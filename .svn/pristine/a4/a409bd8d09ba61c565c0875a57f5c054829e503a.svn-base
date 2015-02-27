/**
 * NewCommentViewController.m
 * Copyright Miraphonic, Inc 2009. All rights reserved.
 *
 * @author Amit Matani 
 * @created 2/13/09.
 */

#import "NewCommentViewController.h"
#import "BRAppDelegate.h"
#import "BRRestClient.h"
#import "Post.h"
#import "CommentTableViewController.h"
#import "AbstractRemoteCollectionStore.h"
#import "BRGlobal.h"
#import "ActionResult.h"
#import "BRSession.h"
#import "ProtagonistAnimal.h"

#define MAX_LENGTH 255
#define MIN_LENGTH 1

@implementation NewCommentViewController
@synthesize commentTableViewController, commentText, charactersLeft;

- (id)initWithUserId:(NSString *)_userId {
	if (self = [super init]) {
		self.title = @"New Comment";
		userId = [_userId copy];
		numCharactersUsed = 0;
	}
	return self;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    UINavigationBar *navBar = self.navigationController.navigationBar;
	navBar.barStyle = UIBarStyleBlackOpaque;	
    
	commentText.autocorrectionType = UITextAutocorrectionTypeNo;
	[commentText becomeFirstResponder];
	
	UIBarButtonItem *cancelButton = 
	[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
												  target:self 
												  action:@selector(dismissTopMostModalViewControllerWithAnimation)];
    self.navigationItem.leftBarButtonItem = cancelButton;
    [cancelButton release];
	
	UIBarButtonItem *newButton = 
	[[UIBarButtonItem alloc] initWithTitle:@"Send" style:UIBarButtonItemStyleDone
									target:self 
									action:@selector(sendComment)];
	newButton.enabled = NO;
    self.navigationItem.rightBarButtonItem = newButton;
    [newButton release];
}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
	if (numCharactersUsed >= MAX_LENGTH && text && [text length] > 0) {
		return NO;
	}
	return YES;
}

- (void)textViewDidChange:(UITextView *)textView {
	numCharactersUsed = [textView.text length];
	charactersLeft.text = [NSString stringWithFormat:@"%d", MAX_LENGTH - numCharactersUsed];
	
	self.navigationItem.rightBarButtonItem.enabled = numCharactersUsed >= MIN_LENGTH; 
}

- (void)sendComment {
	[[BRAppDelegate sharedManager] showLoadingOverlayWithText:@"Sending"];
	[[BRRestClient sharedManager] comment_sendComment:userId comment:commentText.text
											   target:self 
									 finishedSelector:@selector(finishedSendingComment:parsedResponse:)
									   failedSelector:@selector(failedSendingComment)];
}

- (void)finishedSendingComment:(NSNumber *)responseInt parsedResponse:(NSDictionary *)parsedResponse {
	[[BRAppDelegate sharedManager] hideLoadingOverlay];	    
	if ([BRRestClient isResponseSuccessful:responseInt]) {
		Post *comment = [[Post alloc] initWithApiResponse:[parsedResponse objectForKey:@"comment"]];
		
		ActionResult *ar = [[ActionResult alloc] initWithApiResponse:[parsedResponse objectForKey:@"action_result"]];
        [[[BRSession sharedManager] protagonistAnimal] updateWithActionResult:ar];
		NSString *msg = (ar == nil || [ar.message isEqualToString:@""]) ? @"Comment was sent!" : ar.message;
		
		[commentTableViewController.dataSource insertObject:comment atIndex:0];
		[commentTableViewController softReload];
		
		[[SoundManager sharedManager] playSoundWithType:@"pet" vibrate:NO];
		[self dismissTopMostModalViewControllerWithAnimation];
        [[BRAppDelegate sharedManager] showPlainTextNotification:msg];        
		
		[ar release];
		[comment release];
	} else {
        [self alertWithTitle:@"Could not send Message" message:[parsedResponse objectForKey:@"response_message"]];        
	}
}

- (void)failedSendingComment {
	[[BRAppDelegate sharedManager] hideLoadingOverlay];	
    [self alertWithTitle:@"Could not send Message" message:@"Unknown Error"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}


- (void)dealloc {
	[userId release];
    [commentText release];
    [charactersLeft release];
    [super dealloc];
}


@end
