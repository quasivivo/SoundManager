//
//  WHMenuTableViewController.m
//  SoundManager
//
//  Created by William Hannah on 1/31/16.
//  Copyright © 2016 William Hannah. All rights reserved.
//

#import "WHMenuTableViewController.h"
#import "WHAuthManager.h"
#import "WHSingleButtonActionTableViewCell.h"

@interface WHMenuTableViewController ()

@property (nonatomic) NSOrderedSet * menuOptions;

@end

@implementation WHMenuTableViewController

#pragma mark - View Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSDictionary * logout = @{
                              @"title": NSLocalizedString(@"Logout", @"Slide menu logout button label"),
                              @"action": ^(void){ [WHAuthManager logout]; }
                              };
    
    self.menuOptions = [[NSOrderedSet alloc] initWithObject:logout];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WHSingleButtonActionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"singleButtonActionCell" forIndexPath:indexPath];
    
    NSDictionary * menuItem = [self menuOptionForIndexPath:indexPath];
    
    [cell.actionButtonLabel setText:[menuItem objectForKey:@"title"]];
    
    return cell;
}

#pragma mark - Table view delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary * menuItem = [self menuOptionForIndexPath:indexPath];
    void (^ actionBlock)() = [menuItem valueForKey:@"action"];
    
    switch (indexPath.section)
    {
        case 0:
        {
            switch (indexPath.row) {
                case 0:
                    actionBlock();
                    break;
                    
                default:
                    break;
            }
        }
    }
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark - Helpers

-(NSDictionary *)menuOptionForIndexPath:(NSIndexPath *)indexPath {
#warning This will not yet support multiple sections
    return [self.menuOptions objectAtIndex:indexPath.row];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
