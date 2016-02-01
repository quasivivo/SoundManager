//
//  WHSoundDetailViewController.h
//  SoundManager
//
//  Created by William Hannah on 1/31/16.
//  Copyright © 2016 William Hannah. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iOS-Slide-Menu/SlideNavigationController.h"
#import "WHSoundFile.h"

@interface WHSoundDetailViewController : UIViewController <SlideNavigationControllerDelegate>

@property (nonatomic) WHSoundFile *sound;

@end
