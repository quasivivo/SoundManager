//
//  WHSingleButtonActionTableViewCell.m
//  SoundManager
//
//  Created by William Hannah on 1/31/16.
//  Copyright © 2016 William Hannah. All rights reserved.
//

#import "WHSingleButtonActionTableViewCell.h"
#import "WHParticleScene.h"
#import "SoundManager/WHSoundManager.h"

@interface WHSingleButtonActionTableViewCell()
{
    BOOL isAnimating;
}
@end

@implementation WHSingleButtonActionTableViewCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    if (!isAnimating && selected) {
        isAnimating = YES;
        
        SKView * particleView = [[SKView alloc] initWithFrame:self.bounds];
        WHParticleScene * particleScene = [WHParticleScene sceneWithSize:particleView.bounds.size];
        NSURL * imageURL = self.sound.image;
        UIImage * image = [UIImage imageWithContentsOfFile:[imageURL path]];
        
        particleScene.scaleMode = SKSceneScaleModeAspectFill;
        [particleScene loadParticleWithImage:image];
        
        [particleView presentScene:particleScene];
        particleView.tag = 1;
        [self addSubview:particleView];
        [self sendSubviewToBack:particleView];
        [[WHSoundManager sharedManager] playAudioWithURL:self.sound.sound];
    }
    else {
        for (UIView *subView in self.subviews) {
            if (subView.tag == 1) {
                [subView removeFromSuperview];
                isAnimating = NO;
            }
        }
    }
}

@end
