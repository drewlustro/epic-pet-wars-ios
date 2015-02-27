//
//  BlinkingUILabel.m
//  mega framework
//
//  Created by Amit Matani on 3/3/09.
//  Copyright 2009 Miraphonic, Inc. All rights reserved.
//

#import "BlinkingUILabel.h"


@implementation BlinkingUILabel


- (void)setTextAndBlink:(NSString *)_text {
	self.text = _text;
	[self blinkWithCallNumber:[NSNumber numberWithInt:1]];
}

- (void)blinkWithCallNumber:(NSNumber *)callNumber {
    if (initialColor == nil) {
        initialColor = [self.textColor retain];
    }
    [self blinkWithCallNumberHelper:callNumber];
}

- (void)blinkWithCallNumberHelper:(NSNumber *)callNumber {
	[NSObject cancelPreviousPerformRequestsWithTarget:self];
	int callInt = [callNumber intValue];
	if (callInt >= 5) {
        if (initialColor != nil) {
            self.textColor = initialColor;            
            [initialColor release];
            initialColor = nil;
        }
        
		return;
	} else if (callInt == 4) {
		self.textColor = [UIColor redColor];
	} else if (callInt == 3) {
		self.textColor = [UIColor greenColor];		
	} else if (callInt == 2) {
		self.textColor = [UIColor blueColor];		
	} else if (callInt == 1) {
		self.textColor = [UIColor whiteColor];				
	}
	callInt += 1;
	[self performSelector:@selector(blinkWithCallNumber:) 
			   withObject:[NSNumber numberWithInt:callInt]
			   afterDelay:.1];
}

- (void)dealloc {
    [initialColor release];
    [super dealloc];
}

@end
