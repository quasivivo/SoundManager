//
//  WHLoginParticleScene.m
//  SoundManager
//
//  Created by William Hannah on 1/31/16.
//  Copyright © 2016 William Hannah. All rights reserved.
//

#import "WHLoginParticleScene.h"

@implementation WHLoginParticleScene

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        self.backgroundColor = [SKColor whiteColor];
        NSString *emitterPath = [[NSBundle mainBundle] pathForResource:@"Magic" ofType:@"sks"];
        SKEmitterNode *magic = [NSKeyedUnarchiver unarchiveObjectWithFile:emitterPath];
        magic.position = CGPointMake(CGRectGetMidX(self.frame), self.size.height/2);
        magic.name = @"magic";
        magic.targetNode = self.scene;
        [self addChild:magic];
    }
    return self;
}

@end
