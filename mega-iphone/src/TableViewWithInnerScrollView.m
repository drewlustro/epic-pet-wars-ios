//
//  TableViewWithInnerScrollView.m
//  mega framework
//
//  Created by Amit Matani on 3/22/09.
//  Copyright 2009 Miraphonic, Inc. All rights reserved.
//

#import "TableViewWithInnerScrollView.h"


@implementation TableViewWithInnerScrollView


- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    for (int i = 0; i< [self.subviews count]; i++) {
        CGPoint convertedPoint = [self convertPoint:point toView:[self.subviews objectAtIndex:i]];
        
        UIView *subview = [[self.subviews objectAtIndex:i] hitTest:convertedPoint withEvent:event];
        if ([subview isKindOfClass:[UIScrollView class]]) {
            return (UIScrollView *)subview;
        }
    }
    return [super hitTest:point withEvent:event];
}

@end
