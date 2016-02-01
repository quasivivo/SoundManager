//
//  WHSoundsTableViewController.m
//  SoundManager
//
//  Created by William Hannah on 1/31/16.
//  Copyright © 2016 William Hannah. All rights reserved.
//

#import "WHSoundsTableViewController.h"
#import "WHSoundDetailViewController.h"
#import "WHSingleButtonActionTableViewCell.h"
#import "WHSoundFileManager.h"
#import "WHAuthManager.h"
#import "WHSoundFile.h"

@interface WHSoundsTableViewController ()

@property (nonatomic) BOOL isSearching;
@property (nonatomic) NSMutableArray * filteredSounds;

@property (strong, nonatomic) UISearchController *searchController;

@end

@implementation WHSoundsTableViewController

#pragma mark - View LifeCycle

-(void)viewDidLoad {
    [super viewDidLoad];
    
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchBar.scopeButtonTitles = [NSArray array];
    self.searchController.searchResultsUpdater = self;
    self.searchController.dimsBackgroundDuringPresentation = NO;
    self.tableView.tableHeaderView = self.searchController.searchBar;
    self.definesPresentationContext = YES;
    
    self.searchController.searchBar.delegate = self;
    
    self.navigationController.navigationBar.tintColor = [UIColor darkGrayColor];
}

-(void)viewWillAppear:(BOOL)animated {
    [self.searchController.searchBar sizeToFit];
    self.filteredSounds = [[[WHSoundFileManager sharedManager] sounds] mutableCopy];
    [self searchSounds:self.searchController.searchBar.text];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [WHAuthManager checkNeedsLogin];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.filteredSounds.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 72;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * kSoundTableViewCell = @"soundCell";
    
    WHSingleButtonActionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kSoundTableViewCell forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = (WHSingleButtonActionTableViewCell*)[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kSoundTableViewCell];
    }
    
    UIView *clearSelection = [[UIView alloc] initWithFrame:cell.frame];
    clearSelection.backgroundColor = [UIColor clearColor];
    cell.selectedBackgroundView = clearSelection;
    
    cell.sound = [self.filteredSounds objectAtIndex:indexPath.row];
    
    if (indexPath.row == 1 && [cell.sound.name isEqualToString:@"Ahh Nicely"]) {
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }
    else {
        [cell setAccessoryType:UITableViewCellAccessoryNone];
    }
    
    cell.actionButtonLabel.text = cell.sound.name;
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 1) {
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
        WHSoundDetailViewController *detail = (WHSoundDetailViewController*)[mainStoryboard instantiateViewControllerWithIdentifier:@"soundDetailViewController"];
        
        detail.sound = [self.filteredSounds objectAtIndex:indexPath.row];
        
        [self.navigationController pushViewController:detail animated:YES];
    }
}

#pragma mark - Searchbar filtering

-(void)searchSounds:(NSString *)search {
    if (![search isEqualToString:@""]) {
        search = [search lowercaseString];
        
        self.filteredSounds = [@[] mutableCopy];
        
        for (WHSoundFile * sound in [[WHSoundFileManager sharedManager] sounds]) {
            if ([[sound.name lowercaseString] rangeOfString:search].location != NSNotFound) {
                [self.filteredSounds addObject:sound];
            }
        }
    }
    else {
        [self.tableView reloadData];
    }
}

#pragma mark - UISearchResultsUploading

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    [self searchSounds:searchController.searchBar.text];
    [self.tableView reloadData];
}

#pragma mark - UISearchBarDelegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    self.isSearching = YES;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    self.isSearching = [searchText length] != 0;
    if(self.isSearching) {
        [self searchSounds:searchBar.text];
    }
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    self.isSearching = NO;
    self.filteredSounds = [[[WHSoundFileManager sharedManager] sounds] mutableCopy];
}


#pragma mark - iOS Slide Navigation Controller Delegate

- (BOOL)slideNavigationControllerShouldDisplayLeftMenu
{
    return YES;
}

#pragma mark - Navigation

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showDetailSegue"])
    {
        WHSoundDetailViewController *details = (WHSoundDetailViewController*)segue.destinationViewController;
        
        WHSoundFile * selectedSound = [self.filteredSounds objectAtIndex:[self.tableView indexPathForSelectedRow].row];
        
        details.sound = selectedSound;
    }
}

@end
