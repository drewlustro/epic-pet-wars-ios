//
//  ResizeableViewWithAnchoredBottom.m
//  battleroyale
//
//  Created by Amit Matani on 8/27/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "ResizeableViewWithAnchoredBottom.h"
#import "BRGlobal.h"

@implementation ResizeableViewWithAnchoredBottom
@synthesize resizeableView = _resizeableView, anchoredView = _anchoredView;


- (void)layoutSubviews {
#define PADDING 10
	CGFloat height = self.frame.size.height - _anchoredView.frame.size.height - 2 * PADDING;
	_resizeableView.frame = CGRectMake(0, 0, FRAME_WIDTH, height);
	_anchoredView.frame = CGRectMake(_anchoredView.frame.origin.x, PADDING + height, _anchoredView.frame.size.width, _anchoredView.frame.size.height);
	
	[self addSubview:_resizeableView]; 
	[self addSubview:_anchoredView];
}

- (void)dealloc {
	[_resizeableView release];
	[_anchoredView release];
    [super dealloc];
}


@end
