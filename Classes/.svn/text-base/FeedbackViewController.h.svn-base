//
//  FeedbackViewController.h
//  battleroyale
//
//  Created by Amit Matani on 3/11/09.
//  Copyright 2009 Miraphonic, Inc. All rights reserved.
//

#import "BRGlobal.h"


@interface FeedbackViewController : MegaViewController <UITextViewDelegate, UITextFieldDelegate> {
    IBOutlet UITextView *feedbackTextView;
    IBOutlet UIButton *howToPlayButton, *sendFeedBackButton;
}

@property (nonatomic, retain) UITextView *feedbackTextView;
@property (nonatomic, retain) UIButton *howToPlayButton, *sendFeedBackButton;

- (void)sendFeedbackWithEmail:(NSString *)email;
- (void)displayFeedbackFailed:(NSString *)text;

@end
