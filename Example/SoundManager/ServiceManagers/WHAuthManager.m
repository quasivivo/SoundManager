//
//  WHAuthManager.m
//  SoundManager
//
//  Created by William Hannah on 1/31/16.
//  Copyright © 2016 William Hannah. All rights reserved.
//

#import "WHAuthManager.h"
#import "WHLoginViewController.h"
#import "iOS-Slide-Menu/SlideNavigationController.h"

static WHAuthManager *sAuthManager = nil;

@interface WHAuthManager()

@property (nonatomic) NSString * currentUser;

@end

@implementation WHAuthManager

+ (WHAuthManager *)sharedManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sAuthManager = [WHAuthManager new];
    });
    return sAuthManager;
}

-(instancetype)init {
    if (self = [super init]) {
        self.currentUser = @"";
    }
    return self;
}

#pragma mark - Authorization Logic

+ (void)loginWithEmail:(NSString *)email password:(NSString *)password completion:(void (^)(BOOL success))completion {
    if ([email isEqualToString:@""] || [password isEqualToString:@""]) {
        completion(NO);
    }
    else {
        [[WHAuthManager sharedManager] setCurrentUser:email];        
        completion(YES);
    }
}

+ (void)logout {
    [[WHAuthManager sharedManager] setCurrentUser:@""];
    [[SlideNavigationController sharedInstance] popToRootViewControllerAnimated:YES];
    [self checkNeedsLogin];
}

+ (NSString *)currentUser
{
    return [[WHAuthManager sharedManager] currentUser];
}

+ (void) checkNeedsLogin {
    if ([[[WHAuthManager sharedManager] currentUser] isEqualToString:@""])
    {
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
        WHLoginViewController *login = (WHLoginViewController*)[mainStoryboard instantiateViewControllerWithIdentifier:@"loginViewController"];
        
        [[[[UIApplication sharedApplication] keyWindow] rootViewController] presentViewController:login animated:YES completion:nil];
    }
}


@end
