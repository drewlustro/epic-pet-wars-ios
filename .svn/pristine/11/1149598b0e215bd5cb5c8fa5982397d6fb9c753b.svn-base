//
//  BRSROfferViewController.m
//  battleroyale
//
//  Created by Amit Matani on 4/14/09.
//  Copyright 2009 Miraphonic, Inc. All rights reserved.
//

#import "BRSROfferViewController.h"
#import "BRSession.h"
#import "BRRestClient.h"
#import "SROffer.h"
#import "BRAppDelegate.h"

#define EMAIL_FIELD 15

@implementation BRSROfferViewController

- (void)displaySendOfferLinkWithEmailFailed:(NSString *)text {
    [[BRAppDelegate sharedManager] hideLoadingOverlay];
    UIAlertView *failedSending = [[UIAlertView alloc] initWithTitle:@"Unable To Send Link" 
                                                            message:text delegate:nil 
                                                  cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [failedSending show];
    [failedSending release];
}

- (void)sendOfferLinkWithEmail:(NSString *)email {
    [[BRRestClient sharedManager] reward_sendOfferLinkWithEmail:email link:offer.url name:offer.name 
                                                       currency:currency target:self 
                                               finishedSelector:@selector(sendOfferLinkWithEmailFinished:parsedResponse:)
                                                 failedSelector:@selector(sendOfferLinkWithEmailFailed)];
    [[BRAppDelegate sharedManager] showLoadingOverlayWithText:@"Sending"];
}


- (void)emailLinkButtonClicked { 
    // make sure that we have an email address for the user
    if ([[BRSession sharedManager] email] != nil) {
        [self sendOfferLinkWithEmail:[[BRSession sharedManager] email]];
    } else {
        // THIS IS SUPER UGLY, find a cleaner way
        UIAlertView *noEmailAlert = 
        [[UIAlertView alloc] initWithTitle:@"E-mail Required" 
                                   message:@"Please enter an e-mail address so we can send the link\n\n\n" 
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

- (void)sendOfferLinkWithEmailFinished:(NSNumber *)responseInt parsedResponse:(NSDictionary *)parsedResponse {
    if ([BRRestClient isResponseSuccessful:responseInt]) {
        [[BRAppDelegate sharedManager] hideLoadingOverlay];
        [[BRAppDelegate sharedManager] showPlainTextNotification:[parsedResponse objectForKey:@"response_message"]];
        
        // if the feedback was successful save the email that was responded if there is one
        NSString *email = [parsedResponse objectForKey:@"email"];
        if (email != nil) {
            [BRSession sharedManager].email = email;
        }
        
    } else {
        [self displaySendOfferLinkWithEmailFailed:[parsedResponse objectForKey:@"response_message"]];
    }
}

- (void)sendOfferLinkWithEmailFailed {
    [self displaySendOfferLinkWithEmailFailed:@"Unknown Error"];
}

#pragma mark UIAlertViewDelegate methods
- (void)willPresentAlertView:(UIAlertView *)alertView {
    alertView.frame = CGRectMake(alertView.frame.origin.x, 50, alertView.frame.size.width, alertView.frame.size.height);
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        UITextField *emailField = (UITextField *)[alertView viewWithTag:EMAIL_FIELD];
        if (emailField) {
            [self sendOfferLinkWithEmail:emailField.text];
        }
    }
}


@end
