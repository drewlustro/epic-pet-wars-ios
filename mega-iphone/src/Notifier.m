//
//  Notifier.m
//  miraphonic
//
//  Created by Drew Lustro on 11/5/08.
//  Copyright 2008 Miraphonic. All rights reserved.
//

#import "Notifier.h"
#import "Consts.h"

#define	NOTIFIER_Y_OFFSET 210.0
#define CONTENT_WIDTH 280.0
#define NOTIFICATION_FONT_SIZE 14
#define PADDING 10.0
#define SINGLE_LINE_HEIGHT 35.0

@implementation Notifier

@synthesize seenMessages, message, contentView;


- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // Initialization code
		
		message = nil;
		isAnimating = NO;
		hasTappedToCancel = NO;
		self.backgroundColor = [UIColor clearColor];
		
		NSMutableArray *seenMessagesTemp = [[NSMutableArray alloc] initWithCapacity:0];
		self.seenMessages = seenMessagesTemp;
		[seenMessagesTemp release];
		
        UIWebView *webView = [[UIWebView alloc] initWithFrame:self.frame];
        self.contentView = webView;
        [webView release];
        contentView.backgroundColor = [UIColor clearColor];
        contentView.opaque = NO;
        [self addSubview:contentView];
        
        self.hidden = YES;
    }
    return self;
}

- (id)init {
    self = [self initWithFrame:CGRectMake(20, NOTIFIER_Y_OFFSET, CONTENT_WIDTH, 140)];
    return self;
}

- (NSString *)message {
	return message;
}

- (void)setMessageIfUnseen:(NSString *)newMessage {
	if (newMessage != nil) {
		NSString *currentString;
		for(currentString in seenMessages) {
			if([currentString isEqualToString:newMessage]) {
				return;
			}
		}
		
		[seenMessages addObject:newMessage];
	}
	
	[self setMessage:newMessage];
	
}

- (void)setPlainTextMessage:(NSString *)newMessage {
#define PLAIN_TEXT_WIDTH 200
    struct CGSize size =
        [newMessage sizeWithFont:[UIFont fontWithName:@"Helvetica-Oblique" size:NOTIFICATION_FONT_SIZE]
         constrainedToSize:CGSizeMake(PLAIN_TEXT_WIDTH - 40, 4000)
                   lineBreakMode:UILineBreakModeWordWrap];
	CGFloat height = size.height + 30;
	[self setMessage:newMessage withWidth:PLAIN_TEXT_WIDTH andHeight:height];
}

- (void)setMessage:(NSString *)newMessage withWidth:(CGFloat)width andHeight:(CGFloat)height {
    CGRect mainFrame = [[UIScreen mainScreen] applicationFrame];
    CGFloat y = (mainFrame.size.height - 40 - height) / 2;
    CGFloat x = (mainFrame.size.width - width) / 2;
    self.frame = CGRectMake(x, y, width, height);
	[self setMessage:newMessage andShow:YES];
}

- (void)setMessage:(NSString *)newMessage andShow:(BOOL)show {
    [message release];
    message = [newMessage copy];
    
    if (message != nil) {
        NSString *htmlString = [[NSString alloc] initWithFormat:@"<html><body style=\"background-color:transparent;padding:0px;margin:15px;text-align:center;color:white;font-size:%dpx;font-family:helvetica\">%@</body></html>",
                                                                NOTIFICATION_FONT_SIZE,
                                                                message];
        NSURL *baseURL = [[NSURL alloc] initWithString:@""];
        [contentView loadHTMLString:htmlString baseURL:baseURL];
        [baseURL release];
        [htmlString release];
    }
    
    [self setNeedsDisplay];    
	
	if(show) {
		[self displayNotification];
	}
	
}

- (void)displayNotification {
	
	hasTappedToCancel = NO;
	if(message == nil || isAnimating) { return; }
	
	isAnimating = YES;
	self.hidden = YES;	
	self.alpha = 0.0;
	self.hidden = NO;
	
	[UIView beginAnimations:@"NotifierShow"	context:nil];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
	[UIView setAnimationDuration:0.25];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
	self.alpha = 1.0;
	[UIView commitAnimations];
}

- (void)hideNotification {
    
	if(isAnimating || hasTappedToCancel) { return; }
	isAnimating = YES;
	
	[UIView beginAnimations:@"NotifierHide"	context:nil];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
	[UIView setAnimationDuration:0.25];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
	self.alpha = 0.0;
	[UIView commitAnimations];

}

- (void)forceHideNotification {
	[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideNotificationAfterTimer:) object:nil];
	hasTappedToCancel = YES;
	isAnimating = NO;
	self.hidden = YES;
	self.alpha = 0.0;
    NSURL *baseURL = [[NSURL alloc] initWithString:@""];
    [contentView loadHTMLString:nil baseURL:baseURL];
    [baseURL release];
}

- (void)hideNotificationAfterTimer:(id)anArgument {
	[self hideNotification];
}

- (float)getReadableDuration {
	
	return fmax(1.5, ceil([message length] / 18) * 1.2);
	
}

- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
	//NSLog(@"Animation did stop %@ finishied? %d", animationID, [finished intValue]);
	isAnimating = NO;
	
	if(hasTappedToCancel) { return; }
	
	if([animationID isEqualToString:@"NotifierHide"]) {
			
			self.hidden = YES;
			self.alpha = 0.0;
        NSURL *baseURL = [[NSURL alloc] initWithString:@""];
        [contentView loadHTMLString:nil baseURL:baseURL];        
        [baseURL release];
        return;
	}	

	if(self.hidden == NO && self.alpha > 0.0) {
		[self startTimer];
	}
}

- (void)startTimer {
	[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideNotificationAfterTimer:) object:nil];
	[self performSelector:@selector(hideNotificationAfterTimer:) withObject:nil afterDelay:[self getReadableDuration]];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	[self forceHideNotification];
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
	if ([self pointInside:point withEvent:event] && self.hidden == NO) {
		return self;
	} else if (self.hidden == YES) {  
        return [super hitTest:point withEvent:event];
	} else {
	    return nil;
	}	
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
	// never draw the notification if there is no msg display
	if(message == nil) { return; }
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	[self drawBackgroundWithContext:context];
}

- (void)layoutSubviews {
    [super layoutSubviews];
	CGRect newFrame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    contentView.frame = newFrame;
}

- (void)drawBackgroundWithContext:(CGContextRef)context {
	
	CGFloat rectBorderWidth = 5.0;
	
	CGContextSetRGBStrokeColor(context, 0.0, 0.0, 0.0, 0.5);
	CGContextSetLineWidth(context, rectBorderWidth);
	
	CGRect roundedRect = CGRectMake(rectBorderWidth,rectBorderWidth, self.frame.size.width - (rectBorderWidth * 2), self.frame.size.height - (rectBorderWidth * 2));
	CGFloat roundedRectRadius = 5;
	CGContextSetRGBFillColor(context, 0.0, 0.0, 0.0, 0.95);
	
	CGFloat minx = CGRectGetMinX(roundedRect), midx = CGRectGetMidX(roundedRect), maxx = CGRectGetMaxX(roundedRect);
	CGFloat miny = CGRectGetMinY(roundedRect), midy = CGRectGetMidY(roundedRect), maxy = CGRectGetMaxY(roundedRect);
	
	// Start at 1
	CGContextMoveToPoint(context, minx, midy);
	// Add an arc through 2 to 3
	CGContextAddArcToPoint(context, minx, miny, midx, miny, roundedRectRadius);
	// Add an arc through 4 to 5
	CGContextAddArcToPoint(context, maxx, miny, maxx, midy, roundedRectRadius);
	// Add an arc through 6 to 7
	CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, roundedRectRadius);
	// Add an arc through 8 to 9
	CGContextAddArcToPoint(context, minx, maxy, minx, midy, roundedRectRadius);
	// Close the path
	CGContextClosePath(context);
	// Fill & stroke the path
	CGContextDrawPath(context, kCGPathFillStroke);
	
}

/**
  * This section of methods from retain to autorelease
  * maintain that there is only one notifier object
  */
- (id)retain {
    return self;
}

- (unsigned)retainCount {
    return UINT_MAX;  //denotes an object that cannot be released
}

- (void)release {
    //do nothing
}

- (id)autorelease {   
    return self;
}


- (void)dealloc {
	[message release];
	[seenMessages release];
	contentView.delegate = nil;
    [contentView release];
    [super dealloc];	
}


@end
