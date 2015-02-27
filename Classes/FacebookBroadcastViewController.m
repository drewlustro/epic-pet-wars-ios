//
//  FacebookBroadcastViewController.m
//  battleroyale
//
//  Created by Amit Matani on 8/27/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "FacebookBroadcastViewController.h"
#import "BRSession.h"
#import "BRAppDelegate.h"
#import "ActionResult.h"
#import "BRRestClient.h"
#import "ProtagonistAnimal.h"

@implementation FacebookBroadcastViewController


 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithHTML:(NSString *)html {
	if (self = [super init]) {
		_viewHTML = [html copy];
    }
    return self;
}


// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
	LoadingUIWebViewWithLocalRequest *view = [[LoadingUIWebViewWithLocalRequest alloc] initWithFrame:CGRectMake(0, 0, FRAME_WIDTH, FRAME_HEIGHT_WITH_NO_BARS)];
	NSString *path = [[NSBundle mainBundle] bundlePath];
	NSURL *baseURL = [NSURL fileURLWithPath:path];
	view.localDelegate = self;
	[view loadHTMLString:_viewHTML baseURL:baseURL];
	
	self.view = view;
	
	[view release];
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
	((UIWebView *)self.view).delegate = nil;
	((LoadingUIWebViewWithLocalRequest *)self.view).localDelegate = nil;
	
	[[BRSession sharedManager] protagonistAnimal].fBDialogDelegate = nil;	
	[_viewHTML release];
    [super dealloc];
}

#pragma mark RestResponseDelegate
- (void)remoteMethodDidLoad:(NSString *)method responseCode:(RestResponseCode)responseCode parsedResponse:(NSDictionary *)parsedResponse {
	[[BRAppDelegate sharedManager] hideLoadingOverlay];
	if (responseCode == RestResponseCodeSuccess) {
		ActionResult *actionResult = [[ActionResult alloc] initWithApiResponse:[parsedResponse objectForKey:@"action_result"]];
		
		if ([actionResult hasFacebookDialog]) {
			[[BRSession sharedManager] protagonistAnimal].fBDialogDelegate = self;
		}
		
		[[[BRSession sharedManager] protagonistAnimal] updateWithActionResult:actionResult];			
		[[BRAppDelegate sharedManager] showNotification:actionResult.formattedResponse 
											  withWidth:[actionResult.formattedResponseWidth floatValue]
											  andHeight:[actionResult.formattedResponseHeight floatValue]];				
		[actionResult release];
	} else {
		[self alertWithTitle:@"Error" message:[parsedResponse objectForKey:@"response_message"]];
	}
}

- (void)remoteMethodDidFail:(NSString *)method {
    if ([method isEqualToString:@"posse.getFacebookBroadcastAction"]) {    
        [[BRAppDelegate sharedManager] hideLoadingOverlay];    
    }
}


#pragma mark LoadingUIWebViewWithLocalRequestDelegate Methods
- (void)webView:(LoadingUIWebViewWithLocalRequest *)webView handleLocalMethod:(NSString *)method params:(NSDictionary *)params {
	if ([method isEqualToString:@"broadcast"]) {
		// get the details from the server on what to broadcast
        [[BRAppDelegate sharedManager] showLoadingOverlayWithText:@"Loading"];        
        [[BRRestClient sharedManager] posse_getFacebookBroadcastAction:self];
	}
}

#pragma mark FBDialogDelegate Methods
- (void)dialogDidSucceed:(FBDialog*)dialog {
    [[BRAppDelegate sharedManager] showLoadingOverlayWithText:@"Loading"];        
    [[BRRestClient sharedManager] posse_getFacebookBroadcastAction:self];
	[[BRSession sharedManager] protagonistAnimal].fBDialogDelegate = nil;			
}

- (void)dialogDidCancel:(FBDialog*)dialog {
	[[BRSession sharedManager] protagonistAnimal].fBDialogDelegate = nil;			
}



@end
