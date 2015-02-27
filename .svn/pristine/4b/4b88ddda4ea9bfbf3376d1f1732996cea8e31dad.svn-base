//
//  BRDialog.m
//  battleroyale
//
//  Created by amit on 1/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "BRDialog.h"
#import "BRDialogWebViewController.h"
#import "BRAppDelegate.h"


///////////////////////////////////////////////////////////////////////////////////////////////////
// global

static NSString* kDefaultTitle = @"Epic Pet Wars";

static CGFloat kBorderGray[4] = {0.3, 0.3, 0.3, 0.8};
static CGFloat kBorderBlack[4] = {0.1, 0.1, 0.1, 1};

static CGFloat kTransitionDuration = 0.3;

static CGFloat kTitleMarginX = 8;
static CGFloat kTitleMarginY = 4;
static CGFloat kPadding = 10;
static CGFloat kBorderWidth = 10;

@implementation BRDialog
@synthesize delegate = _delegate;

///////////////////////////////////////////////////////////////////////////////////////////////////
// private

- (void)addRoundedRectToPath:(CGContextRef)context rect:(CGRect)rect radius:(float)radius {
	CGContextBeginPath(context);
	CGContextSaveGState(context);
	
	if (radius == 0) {
		CGContextTranslateCTM(context, CGRectGetMinX(rect), CGRectGetMinY(rect));
		CGContextAddRect(context, rect);
	} else {
		rect = CGRectOffset(CGRectInset(rect, 0.5, 0.5), 0.5, 0.5);
		CGContextTranslateCTM(context, CGRectGetMinX(rect)-0.5, CGRectGetMinY(rect)-0.5);
		CGContextScaleCTM(context, radius, radius);
		float fw = CGRectGetWidth(rect) / radius;
		float fh = CGRectGetHeight(rect) / radius;
		
		CGContextMoveToPoint(context, fw, fh/2);
		CGContextAddArcToPoint(context, fw, fh, fw/2, fh, 1);
		CGContextAddArcToPoint(context, 0, fh, 0, fh/2, 1);
		CGContextAddArcToPoint(context, 0, 0, fw/2, 0, 1);
		CGContextAddArcToPoint(context, fw, 0, fw, fh/2, 1);
	}
	
	CGContextClosePath(context);
	CGContextRestoreGState(context);
}

- (void)drawRect:(CGRect)rect fill:(const CGFloat*)fillColors radius:(CGFloat)radius {
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
	
	if (fillColors) {
		CGContextSaveGState(context);
		CGContextSetFillColor(context, fillColors);
		if (radius) {
			[self addRoundedRectToPath:context rect:rect radius:radius];
			CGContextFillPath(context);
		} else {
			CGContextFillRect(context, rect);
		}
		CGContextRestoreGState(context);
	}
	
	CGColorSpaceRelease(space);
}

- (void)strokeLines:(CGRect)rect stroke:(const CGFloat*)strokeColor {
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
	
	CGContextSaveGState(context);
	CGContextSetStrokeColorSpace(context, space);
	CGContextSetStrokeColor(context, strokeColor);
	CGContextSetLineWidth(context, 1.0);
    
	{
		CGPoint points[] = {rect.origin.x+0.5, rect.origin.y-0.5,
		rect.origin.x+rect.size.width, rect.origin.y-0.5};
		CGContextStrokeLineSegments(context, points, 2);
	}
	{
		CGPoint points[] = {rect.origin.x+0.5, rect.origin.y+rect.size.height-0.5,
		rect.origin.x+rect.size.width-0.5, rect.origin.y+rect.size.height-0.5};
		CGContextStrokeLineSegments(context, points, 2);
	}
	{
		CGPoint points[] = {rect.origin.x+rect.size.width-0.5, rect.origin.y,
		rect.origin.x+rect.size.width-0.5, rect.origin.y+rect.size.height};
		CGContextStrokeLineSegments(context, points, 2);
	}
	{
		CGPoint points[] = {rect.origin.x+0.5, rect.origin.y,
		rect.origin.x+0.5, rect.origin.y+rect.size.height};
		CGContextStrokeLineSegments(context, points, 2);
	}
	
	CGContextRestoreGState(context);
	
	CGColorSpaceRelease(space);
}

- (BOOL)shouldRotateToOrientation:(UIDeviceOrientation)orientation {
	if (orientation == _orientation) {
		return NO;
	} else {
		return orientation == UIDeviceOrientationLandscapeLeft
		|| orientation == UIDeviceOrientationLandscapeRight
		|| orientation == UIDeviceOrientationPortrait
		|| orientation == UIDeviceOrientationPortraitUpsideDown;
	}
}

- (CGAffineTransform)transformForOrientation {
	UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
	if (orientation == UIInterfaceOrientationLandscapeLeft) {
		return CGAffineTransformMakeRotation(M_PI*1.5);
	} else if (orientation == UIInterfaceOrientationLandscapeRight) {
		return CGAffineTransformMakeRotation(M_PI/2);
	} else if (orientation == UIInterfaceOrientationPortraitUpsideDown) {
		return CGAffineTransformMakeRotation(-M_PI);
	} else {
		return CGAffineTransformIdentity;
	}
}

- (void)sizeToFitOrientation:(BOOL)transform {
	if (transform) {
		self.transform = CGAffineTransformIdentity;
	}
	
	CGRect frame = [UIScreen mainScreen].applicationFrame;
	CGPoint center = CGPointMake(
								 frame.origin.x + ceil(frame.size.width/2),
								 frame.origin.y + ceil(frame.size.height/2));
	
	CGFloat width = frame.size.width - kPadding * 2;
	CGFloat height = frame.size.height - kPadding * 2;
	
	_orientation = [UIApplication sharedApplication].statusBarOrientation;
	if (UIInterfaceOrientationIsLandscape(_orientation)) {
		self.frame = CGRectMake(kPadding, kPadding, height, width);
	} else {
		self.frame = CGRectMake(kPadding, kPadding, width, height);
	}
	self.center = center;
	
	if (transform) {
		self.transform = [self transformForOrientation];
	}
}

- (void)bounce1AnimationStopped {
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:kTransitionDuration/2];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(bounce2AnimationStopped)];
	self.transform = CGAffineTransformScale([self transformForOrientation], 0.9, 0.9);
	[UIView commitAnimations];
}

- (void)bounce2AnimationStopped {
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:kTransitionDuration/2];
	self.transform = [self transformForOrientation];
	[UIView commitAnimations];
}

- (void)postDismissCleanup {
	[self removeFromSuperview];
}

- (void)dismiss:(BOOL)animated {
	
	if ([_delegate respondsToSelector:@selector(dialogDidDismiss:)]) {
	 [_delegate dialogDidDismiss:self];
	}
	
	[self dialogWillDisappear];
	
	//	[_loadingURL release];
	//	_loadingURL = nil;
	
	if (animated) {
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:kTransitionDuration];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(postDismissCleanup)];
		self.alpha = 0;
		[UIView commitAnimations];
	} else {
		[self postDismissCleanup];
	}
}

- (void)cancel {
	[self dismiss:YES];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// NSObject

- (id)initWithHTML:(NSString *)html {
	if (self = [self init]) {
		_html = [html copy];
	}
	return self;
}


- (id)initWithRequest:(NSURLRequest *)request {
	if (self = [self init]) {
		_request = [request retain];
	}
	return self;
}

- (id)init {
	if (self = [super initWithFrame:CGRectZero]) {
		//		_delegate = nil;
		//		_session = [session retain];
		//		_loadingURL = nil;
		_orientation = UIDeviceOrientationUnknown;
		_showingKeyboard = NO;
		
		self.backgroundColor = [UIColor clearColor];
		self.autoresizesSubviews = YES;
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		self.contentMode = UIViewContentModeRedraw;
		
		UIImage* closeImage = [UIImage imageNamed:@"close.png"];
				
		UIColor* color = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
		_closeButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
		[_closeButton setImage:closeImage forState:UIControlStateNormal];
		[_closeButton setTitleColor:color forState:UIControlStateNormal];
		[_closeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
		[_closeButton addTarget:self action:@selector(cancel)
			   forControlEvents:UIControlEventTouchUpInside];
		_closeButton.font = [UIFont boldSystemFontOfSize:12];
		_closeButton.showsTouchWhenHighlighted = YES;
		_closeButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin
		| UIViewAutoresizingFlexibleBottomMargin;
		[self addSubview:_closeButton];
		
		_titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		_titleLabel.text = kDefaultTitle;
		_titleLabel.backgroundColor = [UIColor clearColor];
		_titleLabel.textColor = [UIColor whiteColor];
		_titleLabel.font = [UIFont boldSystemFontOfSize:14];
		_titleLabel.autoresizingMask = UIViewAutoresizingFlexibleRightMargin
		| UIViewAutoresizingFlexibleBottomMargin;
		[self addSubview:_titleLabel];
        
		_webViewController = [[BRDialogWebViewController alloc] initWithDialog:self];
		//		_webView.delegate = self;
		_webViewController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		[self addSubview:_webViewController.view];
	}
	return self;
}

- (void)dealloc {
	[_html release];
	[_request release];
//	_webView.delegate = nil;
	[_webViewController	release];
	[_titleLabel release];
	[_closeButton release];
	//	[_loadingURL release];
	//	[_session release];
	[super dealloc];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// UIView

- (void)drawRect:(CGRect)rect {
	CGRect grayRect = CGRectOffset(rect, -0.5, -0.5);
	[self drawRect:grayRect fill:kBorderGray radius:10];
	
	CGRect headerRect = CGRectMake(
								   ceil(rect.origin.x + kBorderWidth), ceil(rect.origin.y + kBorderWidth),
								   rect.size.width - kBorderWidth*2, _titleLabel.frame.size.height);
	[self drawRect:headerRect fill:kBorderBlack radius:0];
	[self strokeLines:headerRect stroke:kBorderBlack];
	
	CGRect webRect = CGRectMake(
								ceil(rect.origin.x + kBorderWidth), headerRect.origin.y + headerRect.size.height,
								rect.size.width - kBorderWidth*2, _webViewController.view.frame.size.height+1);
	[self strokeLines:webRect stroke:kBorderBlack];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
// UIDeviceOrientationDidChangeNotification

- (void)deviceOrientationDidChange:(void*)object {
	UIDeviceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
	if (!_showingKeyboard && [self shouldRotateToOrientation:orientation]) {
		//		[self updateWebOrientation];
		
		CGFloat duration = [UIApplication sharedApplication].statusBarOrientationAnimationDuration;
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:duration];
		[self sizeToFitOrientation:YES];
		[UIView commitAnimations];
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// UIKeyboardNotifications

- (void)keyboardWillShow:(NSNotification*)notification {
	UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
	if (UIInterfaceOrientationIsLandscape(orientation)) {
		_webViewController.view.frame = CGRectInset(_webViewController.view.frame,
									 -(kPadding + kBorderWidth),
									 -(kPadding + kBorderWidth) - _titleLabel.frame.size.height);
	}
	
	_showingKeyboard = YES;
}

- (void)keyboardWillHide:(NSNotification*)notification {
	UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
	if (UIInterfaceOrientationIsLandscape(orientation)) {
		_webViewController.view.frame = CGRectInset(_webViewController.view.frame,
									 kPadding + kBorderWidth,
									 kPadding + kBorderWidth + _titleLabel.frame.size.height);
	}
	
	_showingKeyboard = NO;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// public

- (NSString*)title {
	return _titleLabel.text;
}

- (void)setTitle:(NSString*)title {
	_titleLabel.text = title;
}

- (void)show {
	[self load];
	[self sizeToFitOrientation:NO];
	
	CGFloat innerWidth = self.frame.size.width - (kBorderWidth+1)*2;  
	[_titleLabel sizeToFit];
	[_closeButton sizeToFit];
	
	_titleLabel.frame = CGRectMake(
								   kBorderWidth + kTitleMarginX,
								   kBorderWidth,
								   innerWidth - (_titleLabel.frame.size.height + kTitleMarginX*2),
								   _titleLabel.frame.size.height + kTitleMarginY*2);
	
	
	_closeButton.frame = CGRectMake(
									self.frame.size.width - (_titleLabel.frame.size.height + kBorderWidth),
									kBorderWidth,
									_titleLabel.frame.size.height,
									_titleLabel.frame.size.height);
	
	_webViewController.view.frame = CGRectMake(
								kBorderWidth+1,
								kBorderWidth + _titleLabel.frame.size.height,
								innerWidth,
								self.frame.size.height - (_titleLabel.frame.size.height + 1 + kBorderWidth*2));
	
	
	UIWindow* window = [UIApplication sharedApplication].keyWindow;
	if (!window) {
		window = [[UIApplication sharedApplication].windows objectAtIndex:0];
	}
	[window addSubview:self];
	
	[self dialogWillAppear];
    
	self.transform = CGAffineTransformScale([self transformForOrientation], 0.001, 0.001);
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:kTransitionDuration/1.5];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(bounce1AnimationStopped)];
	self.transform = CGAffineTransformScale([self transformForOrientation], 1.1, 1.1);
	[UIView commitAnimations];
	
	//	[self addObservers];
}

- (void)load {
	if (_html != nil) {
		NSString *path = [[NSBundle mainBundle] bundlePath];
		NSURL *baseURL = [NSURL fileURLWithPath:path]; 	
		[(UIWebView *)_webViewController.view loadHTMLString:_html baseURL:baseURL];	
	} else if (_request != nil) {
		[(UIWebView *)_webViewController.view loadRequest:_request];
	}
}


- (void)dialogWillAppear {
}

- (void)dialogWillDisappear {
}

@end

