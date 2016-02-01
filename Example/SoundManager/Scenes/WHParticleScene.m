//
//  WHParticleScene.m
//  SoundManager
//
//  Created by William Hannah on 1/31/16.
//  Copyright © 2016 William Hannah. All rights reserved.
//

#import "WHParticleScene.h"

@implementation WHParticleScene

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        self.backgroundColor = [SKColor whiteColor];
        NSString *emitterPath = [[NSBundle mainBundle] pathForResource:@"FireFlies" ofType:@"sks"];
        SKEmitterNode *fireflies = [NSKeyedUnarchiver unarchiveObjectWithFile:emitterPath];
        fireflies.position = CGPointMake(CGRectGetMidX(self.frame), self.size.height/2);
        fireflies.name = @"fireflies";
        fireflies.targetNode = self.scene;
        [self addChild:fireflies];
    }
    return self;
}

- (void)loadParticleWithImage:(UIImage *)image {
    
    if ([[[self children] objectAtIndex:0] isKindOfClass:[SKEmitterNode class]]) {
        SKEmitterNode *fireflies = (SKEmitterNode *)[[self children] objectAtIndex:0];
        [fireflies setParticleTexture:[SKTexture textureWithImage:image]];
    }
}

@end
