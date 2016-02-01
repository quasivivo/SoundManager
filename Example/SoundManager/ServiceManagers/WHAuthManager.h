//
//  WHAuthManager.h
//  SoundManager
//
//  Created by William Hannah on 1/31/16.
//  Copyright © 2016 William Hannah. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WHAuthManager : NSObject

+ (void)loginWithEmail:(NSString *)email password:(NSString *)password completion:(void (^)(BOOL success))completion;
+ (void)logout;
+ (NSString *)currentUser;
+ (void)checkNeedsLogin;

@end
