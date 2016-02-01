//
//  WHSoundDetailViewController.m
//  SoundManager
//
//  Created by William Hannah on 1/31/16.
//  Copyright © 2016 William Hannah. All rights reserved.
//

#import "WHSoundDetailViewController.h"
#import "WHSingleButtonActionTableViewCell.h"
#import "SoundManager/WHSoundManager.h"

@interface WHSoundDetailViewController ()
{
    CGPoint startPosition;
    BOOL isDismissing;
}
@property (weak, nonatomic) IBOutlet UIView *simpleShape;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *centerYContraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthConstraint;

@end

@implementation WHSoundDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = self.sound.name;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self beginAnimationCycle];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    isDismissing = YES;
    [self.simpleShape.layer removeAllAnimations];
}

#pragma mark - Animations

- (void)beginAnimationCycle {
    [self morphToCircle];
}

- (void)morphToCircle {
    
    CABasicAnimation *radius = [CABasicAnimation animationWithKeyPath:@"cornerRadius"];
    radius.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    radius.fromValue = [NSNumber numberWithFloat:0.0f];
    radius.toValue = [NSNumber numberWithFloat:64.0f];
    
    CABasicAnimation *color = [CABasicAnimation animationWithKeyPath:@"backgroundColor"];
    color.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    color.fromValue = (id)self.simpleShape.backgroundColor.CGColor;
    color.toValue = (id)[UIColor purpleColor].CGColor;
    
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    [animationGroup setAnimations:[NSArray arrayWithObjects:radius, color, nil]];
    [animationGroup setDuration:3.0];
    [animationGroup setRemovedOnCompletion:NO];
    [animationGroup setFillMode:kCAFillModeForwards];
    animationGroup.delegate = self;
    
    [self.simpleShape.layer addAnimation:animationGroup forKey:@"morph"];
}

- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag {
    if (theAnimation == [self.simpleShape.layer animationForKey:@"morph"]) {
        [self beginBouncing];
    }
}

- (void)beginBouncing {
    float distanceToEdge = (self.view.bounds.size.height/2);
    
    [UIView animateWithDuration:5.0f
            delay:0.5f
            usingSpringWithDamping:0.3f
            initialSpringVelocity:5.0f
            options:UIViewAnimationOptionAllowUserInteraction animations:^{
                [self.centerYContraint setConstant:distanceToEdge-64];
                [self.view layoutIfNeeded];
            }
            completion:^(BOOL finished) {
                if (!isDismissing) {
                    [UIView animateWithDuration:2.0f animations:^{
                        [self.centerYContraint setConstant:128-distanceToEdge];
                        [self.view layoutIfNeeded];
                    } completion:^(BOOL finishedInner) {
                        [[WHSoundManager sharedManager] playAudioWithURL:self.sound.sound];
                        [self beginBouncing];
                    }];
                }
            }];
}

- (IBAction)moveShape:(id)sender {
    CGPoint translatedPoint = [(UIPanGestureRecognizer*)sender translationInView:self.view];
    
    if ([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateBegan) {
        startPosition = CGPointMake([[sender view] center].x,[[sender view] center].y);
    }
    
    translatedPoint = CGPointMake(startPosition.x+translatedPoint.x, startPosition.y+translatedPoint.y);
    
    [[sender view] setCenter:translatedPoint];
    
    if ([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateEnded) {
        CGFloat velocityX = (0.2*[(UIPanGestureRecognizer*)sender velocityInView:self.view].x);
        CGFloat velocityY = (.2*[(UIPanGestureRecognizer*)sender velocityInView:self.view].y);
        
        CGFloat finalX = translatedPoint.x + velocityX;
        CGFloat finalY = translatedPoint.y + velocityY;
        
        CGFloat animationDuration = (ABS(velocityX)*.0002)+.2;
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:animationDuration];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        [UIView setAnimationDelegate:self];
        [[sender view] setCenter:CGPointMake(finalX, finalY)];
        [UIView commitAnimations];
    }
}

@end

