//
//  UIScrollViewWithInnerScrollView.m
//  mega framework
//
//  Created by Amit Matani on 4/16/09.
//  Copyright 2009 Miraphonic, Inc. All rights reserved.
//

#import "UIScrollViewWithInnerScrollView.h"


@implementation UIScrollViewWithInnerScrollView

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    for (int i = 0; i< [self.subviews count]; i++) {
        CGPoint convertedPoint = [self convertPoint:point toView:[self.subviews objectAtIndex:i]];
        
        UIView *subview = [[self.subviews objectAtIndex:i] hitTest:convertedPoint withEvent:event];
        if ([subview isKindOfClass:[UIScrollView class]]) {
            return (UIScrollView *)subview;
        }
    }
    return self;
}

@end
