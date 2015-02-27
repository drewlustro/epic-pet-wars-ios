/**
 * BorderView.m
 * Copyright Miraphonic, Inc 2009. All rights reserved.
 *
 * The BorderView is used to draw borders around RemoveImageViews
 *
 * @author Drew Lustro
 * @created 1/15/09
 */


#import "BorderView.h"


@implementation BorderView


- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // Initialization code
		
		self.contentMode = UIViewContentModeRedraw;
		self.opaque = NO;
    }
    return self;
}


- (void)drawRect:(CGRect)rect {
		
    // Drawing code
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSetRGBFillColor(context, 1.0, 1.0, 1.0, 0.0);
	
	// draw square rectangle using CoreGraphics
	CGContextSetRGBStrokeColor(context, 0.0, 0.0, 0.0, 0.7);
	CGContextSetLineWidth(context, 2.0);
	CGFloat width = CGRectGetWidth(self.frame);
	CGFloat height = CGRectGetHeight(self.frame);
	// move to origin
	CGContextMoveToPoint(context, 0, 0);
	
	// draw the rectangle
	CGContextAddLineToPoint(context, width, 0);
	CGContextAddLineToPoint(context, width, height);
	CGContextAddLineToPoint(context, 0, height);
	CGContextAddLineToPoint(context, 0, 0);
	
	CGContextStrokePath(context);

}


- (void)dealloc {
    [super dealloc];
}


@end
