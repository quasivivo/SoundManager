//
//  WHCustomAlert+UIViewController.m
//  SoundManager
//
//  Created by William Hannah on 1/31/16.
//  Copyright © 2016 William Hannah. All rights reserved.
//

#import "WHCustomAlert+UIViewController.h"


@implementation UIViewController(WHCustomAlert)

-(void)showAlertWithTitle:(NSString *)title dismissButtonTitle:(NSString *)dismissButtonTitle
{
    UIAlertController* alert = [UIAlertController new];
    
    [alert setTitle:title];
    
    UIAlertAction* action = [UIAlertAction actionWithTitle:dismissButtonTitle style:UIAlertActionStyleDefault handler:nil];
    
    [alert addAction:action];
    
    [self presentViewController:alert animated:YES completion:nil];
}

@end
