/**
 * AnimalAnimationUIView.m
 * Copyright Miraphonic, Inc 2009. All rights reserved.
 *
 * @author Amit Matani 
 * @created 3/6/09.
 */

#import "AnimalAnimationUIView.h"
#import "BRAppDelegate.h"
#import "BRTabManager.h"
#import <QuartzCore/CAAnimation.h>
#import <QuartzCore/CAMediaTimingFunction.h>
#import <math.h>
#include <stdlib.h>
#import "Consts.h"

@implementation AnimalAnimationUIView


- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
	if ([self pointInside:point withEvent:event]) {
        UITouch *firstTouch = (UITouch *) [[event allTouches] anyObject];
        if (firstTouch != nil) {
            targetPoint = [firstTouch locationInView:self];
        }
        
		debug_NSLog(@"hit this");
        return [super hitTest:point withEvent:event];
	} else {
		return nil;
	}
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    debug_NSLog(@"ended");
}

- (void)setMovingView:(UIView *)_movingView withBoundRect:(CGRect)_bounds {
    movingView = _movingView;
    bounds = _bounds;
    velocity = 100;
    startingPoint = movingView.center;
    targetPoint = startingPoint;
    
    innerBounds = CGRectMake(movingView.frame.size.width / 2, movingView.frame.size.height / 2,
                             bounds.size.width - movingView.frame.size.width ,
                             bounds.size.height - movingView.frame.size.height);
    currentPoint = movingView.center;
    targetPoint = currentPoint;
    
    [movementThread release];
    movementThread = [[NSThread alloc] initWithTarget:self selector:@selector(moveWithAnimation) object:nil];
    
    [movementThread start];
}

- (void)moveWithAnimation {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];    
    while (YES) {
        NSAutoreleasePool *loopPool = [[NSAutoreleasePool alloc] init];         
        [movingView.layer removeAllAnimations];
        float sleepDuration = .3;
        
        // make sure that the current tab is selected 
        if ([[[[BRAppDelegate sharedManager] tabManager] tabBarController] selectedIndex] != 0) {
            sleepDuration = 2;
        } else {
            if (!CGPointEqualToPoint(targetPoint, currentPoint)) {    
                sleepDuration = .3;
                [self performSelectorOnMainThread:@selector(walkToTarget) withObject:nil waitUntilDone:NO];
            } else if (rand() % 10 == 0) {
                int randInt = rand() % 2;
                if (randInt == 0) {
                    [self performSelectorOnMainThread:@selector(jump) withObject:nil waitUntilDone:NO];
                } else {
                    [self performSelectorOnMainThread:@selector(jumpFlip) withObject:nil waitUntilDone:NO];                
                }
                sleepDuration = 1;
            } else if (CGPointEqualToPoint(targetPoint, currentPoint) && 
                       !CGPointEqualToPoint(targetPoint, startingPoint)) {
                targetPoint = startingPoint;
                sleepDuration = .3;
            }
        }
        [NSThread sleepForTimeInterval:sleepDuration];
        [loopPool release];        
    }
    [pool release];    
}

- (void)spin {
    CABasicAnimation* spinAnimation = [CABasicAnimation
                                       animationWithKeyPath:@"transform.rotation"];
    spinAnimation.toValue = [NSNumber numberWithFloat:2*M_PI];
    [movingView.layer addAnimation:spinAnimation forKey:@"spinAnimation"];
}

- (void)jump {
    CAKeyframeAnimation * animation;
    animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    animation.duration = 1;
    
    // Create arrays for values and associated timings.    
    NSMutableArray *values = [[NSMutableArray alloc] initWithCapacity:7];
    NSMutableArray *timings = [[NSMutableArray alloc] initWithCapacity:6];
    
    NSValue *bounceUp = [NSValue valueWithCGPoint:CGPointMake(currentPoint.x, currentPoint.y - 15)];
    NSValue *rest = [NSValue valueWithCGPoint:CGPointMake(currentPoint.x, currentPoint.y)];
    
    id easeIn = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    id easeOut = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    int i = 0;
    [values addObject:rest];
    while (i < 3) {
        // Bounce up
        [values addObject:bounceUp];
        [timings addObject:easeOut];
        // Return to rest
        [values addObject:rest];
        [timings addObject:easeIn];
        
        i += 1;
    }
    animation.values = values;
    animation.timingFunctions = timings;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeBoth;
    
    [values release];
    [timings release];
    
    [movingView.layer addAnimation:animation forKey:@"animation"];
}

- (void)jumpFlip {
    CAKeyframeAnimation *jumpAnimation;
    jumpAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    jumpAnimation.duration = .5;
    
    // Create arrays for values and associated timings.
    NSMutableArray *values = [NSMutableArray array];
    NSMutableArray *timings = [NSMutableArray array];
    float bounceHeight = -30;
    [values addObject:[NSValue valueWithCGPoint:CGPointMake(currentPoint.x, currentPoint.y)]];    
    
    // Bounce up
    float bounceTop = currentPoint.y + bounceHeight;
    [values addObject:[NSValue valueWithCGPoint:CGPointMake(currentPoint.x, bounceTop)]];
    [timings addObject:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
    // Return to rest
    [values addObject:[NSValue valueWithCGPoint:CGPointMake(currentPoint.x, currentPoint.y)]];
    [timings addObject:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
        
    jumpAnimation.values = values;
    jumpAnimation.timingFunctions = timings;
    
    CABasicAnimation* spinAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    spinAnimation.toValue = [NSNumber numberWithFloat:2*M_PI];
    spinAnimation.duration = .5;
    
    CAAnimationGroup *theGroup = [CAAnimationGroup animation];
	theGroup.animations = [NSArray arrayWithObjects:jumpAnimation, spinAnimation, nil];
    theGroup.duration = .5;
    
    theGroup.removedOnCompletion = NO;
    theGroup.fillMode = kCAFillModeBoth;
    
    [movingView.layer addAnimation:theGroup forKey:@"jumpFlip"];
    
}

- (void)dance {
    
}

- (void)walkToTarget { // walk by step
    CAKeyframeAnimation* waddleAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation"];
    NSMutableArray *values = [NSMutableArray array];
    NSMutableArray *timings = [NSMutableArray array];
    [values addObject:[NSNumber numberWithFloat:0]];
    
#define WADDLE_FRACTION .0625
#define WADDLE_TIME .3
    // rotate counter-clockwise
    [values addObject:[NSNumber numberWithFloat:-WADDLE_FRACTION * M_PI]];
    [timings addObject:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
    // return to center
    [values addObject:[NSNumber numberWithFloat:0]];
    [timings addObject:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];        
    // rotate clockwise
    [values addObject:[NSNumber numberWithFloat:WADDLE_FRACTION * M_PI]];
    [timings addObject:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
    // return to center
    [values addObject:[NSNumber numberWithFloat:0]];
    [timings addObject:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
    
    waddleAnimation.values = values;
    waddleAnimation.timingFunctions = timings;
    waddleAnimation.duration = WADDLE_TIME;
    waddleAnimation.removedOnCompletion = NO;
    waddleAnimation.fillMode = kCAFillModeBoth; 
    
    // move animation
    CAKeyframeAnimation* moveAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
	CGMutablePathRef thePath = CGPathCreateMutable();
	CGPathMoveToPoint(thePath, NULL, currentPoint.x, currentPoint.y);
    
    float dx = targetPoint.x - currentPoint.x, dy = targetPoint.y - currentPoint.y;
    float totalDistance = sqrt(dx*dx + dy*dy);  
    float distanceCanCover = velocity * WADDLE_TIME;
    float distance;
    
    if (totalDistance <= distanceCanCover) {
        currentPoint = targetPoint;
        distance = totalDistance;
    } else {
        float x = fabs(currentPoint.x - targetPoint.x);
        float y = fabs(currentPoint.y - targetPoint.y);
        float newX = cos(atan(y/x)) * distanceCanCover;
        float newY = sin(atan(y/x)) * distanceCanCover;
        
        if (targetPoint.x >= currentPoint.x) {
            currentPoint.x += newX;
            currentPoint.y += targetPoint.y >= currentPoint.y ? newY : -newY;
        } else {
            currentPoint.x -= newX;
            currentPoint.y += targetPoint.y >= currentPoint.y ? newY : -newY;
        }
        distance = distanceCanCover;
    }
    
	CGPathAddLineToPoint(thePath, NULL, currentPoint.x, currentPoint.y);
    
    moveAnimation.path = thePath;
    CGPathRelease(thePath);    
    moveAnimation.duration = distance / velocity;
    moveAnimation.removedOnCompletion = NO;
    moveAnimation.fillMode = kCAFillModeBoth;
    
    CAAnimationGroup *theGroup = [CAAnimationGroup animation];
	theGroup.animations = [NSArray arrayWithObjects:moveAnimation, waddleAnimation, nil];
    theGroup.duration = WADDLE_TIME;
    theGroup.removedOnCompletion = NO;
    theGroup.fillMode = kCAFillModeBoth;
    [movingView.layer addAnimation:theGroup forKey:@"moving"];
}

- (void)dealloc {
    [movementThread release];
    [super dealloc];
}


@end
