//
//  WHSingleButtonActionTableViewCell.h
//  SoundManager
//
//  Created by William Hannah on 1/31/16.
//  Copyright © 2016 William Hannah. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WHSoundFile.h"
@import SpriteKit;

@interface WHSingleButtonActionTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *actionButtonLabel;

@property (nonatomic) WHSoundFile *sound;

@end
