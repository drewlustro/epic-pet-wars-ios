//
//  NewMassCommentViewController.m
//  battleroyale
//
//  Created by Amit Matani on 3/10/09.
//  Copyright 2009 Miraphonic, Inc. All rights reserved.
//

#import "NewMassCommentViewController.h"
#import "BRAppDelegate.h"
#import "BRRestClient.h"
#import "BRGlobal.h"
#import "BRSession.h"
#import "ActionResult.h"
#import "ProtagonistAnimal.h"

@implementation NewMassCommentViewController


// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)init {
    if (self = [super initWithNibName:@"NewCommentView" bundle:[NSBundle mainBundle]]) {
		self.title = @"New Bulletin";
		numCharactersUsed = 0;
    }
    return self;
}


- (void)sendComment {
	[[BRAppDelegate sharedManager] showLoadingOverlayWithText:@"Sending"];
	[[BRRestClient sharedManager] comment_sendBulletin:commentText.text
											   target:self 
									 finishedSelector:@selector(finishedSendingComment:parsedResponse:)
									   failedSelector:@selector(failedSendingComment)];
}

- (void)finishedSendingComment:(NSNumber *)responseInt parsedResponse:(NSDictionary *)parsedResponse {
	if ([BRRestClient isResponseSuccessful:responseInt]) {
		
		ActionResult *ar = [[ActionResult alloc] initWithApiResponse:[parsedResponse objectForKey:@"action_result"]];
        [[[BRSession sharedManager] protagonistAnimal] updateWithActionResult:ar];
		NSString *msg = (ar == nil || [ar.message isEqualToString:@""]) ? @"Bulletin was posted!" : ar.message;
		
        [[BRAppDelegate sharedManager] hideLoadingOverlay];
		[self dismissTopMostModalViewControllerWithAnimation];
        [[BRAppDelegate sharedManager] showPlainTextNotification:msg];
        
		[ar release];
	} else {
		[self failedSendingComment];
	}
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}


- (void)dealloc {
    [super dealloc];
}


@end
