//
//  FeedbackViewController.m
//  battleroyale
//
//  Created by Amit Matani on 3/11/09.
//  Copyright 2009 Miraphonic, Inc. All rights reserved.
//

#import "FeedbackViewController.h"
#import "PostNewAccountViewController.h"
#import "BRRestClient.h"
#import "BRAppDelegate.h"
#import "HelpWebViewController.h"
#import "BRSession.h"
#import "BRGlobal.h"
#import "ActionResult.h"
#import "ProtagonistAnimal.h"

#define MIN_LENGTH 5
#define EMAIL_FIELD 15

@implementation FeedbackViewController
@synthesize feedbackTextView, howToPlayButton, sendFeedBackButton;

/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addLeftCloseButton];
	
    
    [howToPlayButton addTarget:self action:@selector(showHowToPlay) forControlEvents:UIControlEventTouchUpInside];
    [sendFeedBackButton addTarget:self action:@selector(feedbackButtonClicked) forControlEvents:UIControlEventTouchUpInside];    
    sendFeedBackButton.enabled = NO;
    sendFeedBackButton.adjustsImageWhenDisabled = YES;
	sendFeedBackButton.adjustsImageWhenHighlighted = YES;
    feedbackTextView.delegate = self;
}

- (void)showHowToPlay {
    // TODO REPLACE THIS WHEN READY
	[[SoundManager sharedManager] playSoundWithType:@"popup" vibrate:NO];
	HelpWebViewController *hvc = [[HelpWebViewController alloc] initWithTypeString:@"howToPlay"];
	UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:hvc];
	[self presentModalViewController:nav animated:YES];
	[nav release];
	[hvc release];
}

- (void)feedbackButtonClicked {
    if ([[BRSession sharedManager] email] != nil) {
        [self sendFeedbackWithEmail:[[BRSession sharedManager] email]];
    } else {
        
        // THIS IS SUPER UGLY, find a cleaner way
        UIAlertView *noEmailAlert = 
            [[UIAlertView alloc] initWithTitle:@"E-mail Required" 
                                       message:@"Please enter an e-mail address so we can respond to your feedback\n\n\n" 
                                      delegate:self cancelButtonTitle:@"Cancel" 
                             otherButtonTitles:@"Send", nil];
        UITextField *emailField = [[UITextField alloc] initWithFrame:CGRectMake(14, 100, 255, 30)];
        emailField.borderStyle = UITextBorderStyleBezel;
        emailField.textColor = [UIColor blackColor];
        emailField.font = [UIFont systemFontOfSize:16];
        
        emailField.backgroundColor = [UIColor whiteColor];
        emailField.autocorrectionType = UITextAutocorrectionTypeNo;
        
        emailField.keyboardType = UIKeyboardTypeEmailAddress;
        emailField.keyboardAppearance = UIKeyboardAppearanceAlert;
        emailField.delegate = self;
        emailField.tag = EMAIL_FIELD;
        [emailField becomeFirstResponder];
        
        [noEmailAlert addSubview:emailField];
        
        [noEmailAlert show];
        [noEmailAlert release];
        [emailField release];
    }
}

- (void)sendFeedbackWithEmail:(NSString *)email {
    [[BRAppDelegate sharedManager] showLoadingOverlayWithText:@"Sending"];
    [[BRRestClient sharedManager] account_sendFeedback:feedbackTextView.text email:email target:self 
                                      finishedSelector:@selector(sendFeedbackFinished:parsedResponse:)
                                        failedSelector:@selector(sendFeedbackFailed)];
}

- (void)sendFeedbackFinished:(NSNumber *)responseInt parsedResponse:(NSDictionary *)parsedResponse {
    if ([BRRestClient isResponseSuccessful:responseInt]) {
        [[BRAppDelegate sharedManager] hideLoadingOverlay];
		
		ActionResult *ar = [[ActionResult alloc] initWithApiResponse:[parsedResponse objectForKey:@"action_result"]];
        [[[BRSession sharedManager] protagonistAnimal] updateWithActionResult:ar];
		NSString *msg = (ar == nil || [ar.message isEqualToString:@""]) ? @"Thanks for the feedback!" : ar.message;
		
        [[BRAppDelegate sharedManager] showPlainTextNotification:msg];
        
        // if the feedback was successful save the email that was responded if there is one
        NSString *email = [parsedResponse objectForKey:@"email"];
        if (email != nil) {
            [BRSession sharedManager].email = email;
        }
        
		[ar release];
        [self dismissTopMostModalViewControllerWithAnimation];
    } else {
        [self displayFeedbackFailed:[parsedResponse objectForKey:@"response_message"]];
    }
}

- (void)sendFeedbackFailed {
    [self displayFeedbackFailed:@"Unknown Error"];
}

- (void)displayFeedbackFailed:(NSString *)text {
    [[BRAppDelegate sharedManager] hideLoadingOverlay];
    UIAlertView *failedSending = [[UIAlertView alloc] initWithTitle:@"Unable To Send Feedback" 
                                                            message:text delegate:nil 
                                                  cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [failedSending show];
    [failedSending release];
}

- (void)textViewDidChange:(UITextView *)textView {
	sendFeedBackButton.enabled = [textView.text length] >= MIN_LENGTH;     
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}

#pragma mark UIAlertViewDelegate methods
- (void)willPresentAlertView:(UIAlertView *)alertView {
    alertView.frame = CGRectMake(alertView.frame.origin.x, 50, alertView.frame.size.width, alertView.frame.size.height);
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        [feedbackTextView becomeFirstResponder];
    } else {
        UITextField *emailField = (UITextField *)[alertView viewWithTag:EMAIL_FIELD];
        if (emailField) {
            [self sendFeedbackWithEmail:emailField.text];
        }
    }
}

- (void)dealloc {
    [feedbackTextView release];
    [howToPlayButton release];
    [sendFeedBackButton release];
    
    [super dealloc];
}


@end
