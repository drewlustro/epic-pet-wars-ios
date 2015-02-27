/**
 * AnimalAnimationUIView.m
 * Copyright Miraphonic, Inc 2009. All rights reserved.
 *
 * @author Amit Matani 
 * @created 3/6/09.
 */

#import <UIKit/UIKit.h>


@interface AnimalAnimationUIView : UIView {
    UIView *movingView;
    CGRect bounds, innerBounds;
    float velocity; // px/ms
    CGPoint targetPoint, startingPoint, currentPoint;
    NSThread *movementThread;
}

- (void)setMovingView:(UIView *)_movingView withBoundRect:(CGRect)_bounds;
- (void)moveWithAnimation;
- (void)spin;
- (void)jump;
- (void)jumpFlip;
- (void)walkToTarget;

@end
