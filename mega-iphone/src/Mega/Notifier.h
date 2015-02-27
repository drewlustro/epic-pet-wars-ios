//
//  Notifier.h
//  hon
//
//  Created by Drew Lustro on 11/5/08.
//  Copyright 2008 UC Berkeley. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface Notifier : UIView {
	NSString *message;
	NSMutableArray *seenMessages;
	BOOL isAnimating; // prevents animations from conflicting
	BOOL hasTappedToCancel;
    UIWebView *contentView;
}

@property (nonatomic, copy) NSString *message;
@property (nonatomic, retain) NSMutableArray *seenMessages;
@property (nonatomic, retain) UIWebView *contentView;


- (void)setMessage:(NSString *)newMessage;
- (void)setMessageIfUnseen:(NSString *)newMessage;
- (void)forceHideNotification;
- (void)hideNotificationAfterTimer:(id)anArgument;
- (void)displayNotification;
- (float)getReadableDuration;
- (void)startTimer;
- (void)drawBackgroundWithContext:(CGContextRef)context;
- (void)setMessage:(NSString *)newMessage andShow:(BOOL)show;
- (void)setMessage:(NSString *)newMessage withWidth:(CGFloat)width andHeight:(CGFloat)height;
- (void)setPlainTextMessage:(NSString *)newMessage;

@end
