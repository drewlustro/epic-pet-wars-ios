//
//  BlinkingUILabel.h
//  mega framework
//
//  Created by Amit Matani on 3/3/09.
//  Copyright 2009 Miraphonic, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface BlinkingUILabel : UILabel {
    UIColor *initialColor;
}

- (void)setTextAndBlink:(NSString *)_text;
- (void)blinkWithCallNumber:(NSNumber *)callNumber;
- (void)blinkWithCallNumberHelper:(NSNumber *)callNumber;

@end
