/**
 * FriendCodeViewController.m
 * Copyright Miraphonic, Inc 2009. All rights reserved.
 *
 * @author Amit Matani 
 * @created 2/6/09.
 */

#import "FriendCodeViewController.h"
#import "BRSession.h"
#import "ProtagonistAnimal.h"
#import "BRAppDelegate.h"
#import "BRRestClient.h"
#import "Notifier.h"
#import "GrowPosseViewController.h"
#import "ActionResult.h"

#define FRIEND_CODE_FIELD 100
#define FRIEND_CODE_ALERT_VIEW 1
#define SHARE_CODE_ALERT_VIEW 2

@implementation FriendCodeViewController
@synthesize yourFriendCodeLabel, inviteButton, _shareButton, growPosseViewController = _growPosseViewController;


// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithTabTitles:(NSArray *)titles keys:(NSArray *)keys {
    if (self = [super initWithNibName:@"FriendCodeView" bundle:[NSBundle mainBundle]]) {
        self.title = @"Friend Code";
		_inviteMethodTitles = [titles retain];
		_inviteMethodKeys = [keys retain];
    }
    return self;
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	[inviteButton addTarget:self action:@selector(inviteButtonClicked) 
		   forControlEvents:UIControlEventTouchUpInside];
	[_shareButton addTarget:self action:@selector(shareButtonClicked) 
		   forControlEvents:UIControlEventTouchUpInside];	
	yourFriendCodeLabel.text = [[[BRSession sharedManager] protagonistAnimal] friendCode];
	
    if ([_inviteMethodKeys count] <= 0) {
        _shareButton.hidden = YES;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self inviteButtonClicked];
    return YES;
}

- (void)shareButtonClicked {
	UIAlertView *chooseShareMethod = 
	[[UIAlertView alloc] initWithTitle:@"Share Friend Code" 
							   message:@"Share your friend code by sending an invite using one of the following methods" 
							  delegate:self cancelButtonTitle:@"Cancel" 
					 otherButtonTitles:nil];
	for (NSString *title in _inviteMethodTitles) {
		[chooseShareMethod addButtonWithTitle:title];
	}
	
	_activeAlertView = SHARE_CODE_ALERT_VIEW;
	
	[chooseShareMethod show];
	[chooseShareMethod release];	
	
}

- (void)inviteButtonClicked {
	/// UGLY ASS SHIT, CLEAN THIS
	UIAlertView *enterFriendCodeAlert = 
	[[UIAlertView alloc] initWithTitle:@"Enter Friend Code" 
							   message:@"Enter friend's code to invite them to your Posse\n\n\n" 
							  delegate:self cancelButtonTitle:@"Cancel" 
					 otherButtonTitles:@"Invite", nil];
	UITextField *friendCodeTextField = [[UITextField alloc] initWithFrame:CGRectMake(14, 100, 255, 30)];
	friendCodeTextField.borderStyle = UITextBorderStyleBezel;
	friendCodeTextField.textColor = [UIColor blackColor];
	friendCodeTextField.font = [UIFont systemFontOfSize:16];
	
	friendCodeTextField.backgroundColor = [UIColor whiteColor];
	friendCodeTextField.autocorrectionType = UITextAutocorrectionTypeNo;
	
	friendCodeTextField.keyboardType = UIKeyboardTypeASCIICapable;
	friendCodeTextField.keyboardAppearance = UIKeyboardAppearanceAlert;
	friendCodeTextField.delegate = self;
	friendCodeTextField.tag = FRIEND_CODE_FIELD;
	[friendCodeTextField becomeFirstResponder];
	
	[enterFriendCodeAlert addSubview:friendCodeTextField];
	
	_activeAlertView = FRIEND_CODE_ALERT_VIEW;	
	
	[enterFriendCodeAlert show];
	[enterFriendCodeAlert release];
	[friendCodeTextField release];
}

- (void)finishedInvitingFriend:(NSNumber *)responseInt parsedResponse:(NSDictionary *)parsedResponse {
	if ([BRRestClient isResponseSuccessful:responseInt]) {
		[[BRAppDelegate sharedManager] hideLoadingOverlay];		
		
		ActionResult *ar = [[ActionResult alloc] initWithApiResponse:[parsedResponse objectForKey:@"action_result"]];
        [[[BRSession sharedManager] protagonistAnimal] updateWithActionResult:ar];
		NSString *msg = (ar == nil || [ar.message isEqualToString:@""]) ? @"Sent invite." : ar.message;
		
        [[BRAppDelegate sharedManager] showPlainTextNotification:msg];
		
		[ar release];
	} else {
        [self displayActionFailedWithMessage:[parsedResponse objectForKey:@"response_message"]];
	}
}

- (void)failedInvitingFriend {
    [self displayActionFailedWithMessage:@"Unknown Error"];
}

- (void)displayActionFailedWithMessage:(NSString *)message {
	[[BRAppDelegate sharedManager] hideLoadingOverlay];    
	UIAlertView *failedAction = [[UIAlertView alloc] initWithTitle:@"Unable To Send Invite"
                                                           message:message
                                                          delegate:self 
                                                 cancelButtonTitle:@"OK" 
                                                 otherButtonTitles:nil];
	[failedAction show];
	[failedAction release];
    
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}


- (void)dealloc {
    [inviteButton release];
	[_shareButton release];
    [yourFriendCodeLabel release];
	[_inviteMethodTitles release];
	[_inviteMethodKeys release];
    
    
    [super dealloc];
}

#pragma mark UIAlertViewDelegate methods
// TODO UGLY UGLY UGLY fix
- (void)willPresentAlertView:(UIAlertView *)alertView {
	if (_activeAlertView == FRIEND_CODE_ALERT_VIEW) {
		alertView.frame = CGRectMake(alertView.frame.origin.x, 50, alertView.frame.size.width, alertView.frame.size.height);
	}
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
	if (_activeAlertView == FRIEND_CODE_ALERT_VIEW) {
		if (buttonIndex == 1) {
			UITextField *friendCodeTextField = (UITextField *)[alertView viewWithTag:FRIEND_CODE_FIELD];
			
			if (friendCodeTextField.text == nil || [friendCodeTextField.text isEqualToString:@""]) { return; }
			
			[[BRAppDelegate sharedManager] showLoadingOverlayWithText:@"Inviting"];
			[[BRRestClient sharedManager] posse_inviteUserWithFriendCode:friendCodeTextField.text target:self 
														finishedSelector:@selector(finishedInvitingFriend:parsedResponse:) 
														  failedSelector:@selector(failedInvitingFriend)];		
		}
	} else if (_activeAlertView == SHARE_CODE_ALERT_VIEW) {
		int index = buttonIndex - 1;
		if (index < 0 || index > [_inviteMethodKeys count]) {
			return;
		}
		NSString *key = [_inviteMethodKeys objectAtIndex:index];
		[_growPosseViewController selectTab:key];
	}
}



@end
