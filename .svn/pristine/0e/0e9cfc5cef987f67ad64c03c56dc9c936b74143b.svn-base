//
//  TwitterFriendInviteViewController.m
//  battleroyale
//
//  Created by Amit Matani on 8/24/09.
//  Copyright 2009 ngmoco:). All rights reserved.
//

#import "TwitterFriendInviteViewController.h"
#import "BRRestClient.h"
#import "BRAppDelegate.h"
#import "BRSession.h"
#import "LoadingUIWebViewWithLocalRequest.h"
#import "ProtagonistAnimal.h"

@implementation TwitterFriendInviteViewController

- (id)init {
	if (self = [super init]) {
		self.title = @"Invite Twitter Friends";
	}
	return self;
}

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
	_webView = [[LoadingUIWebViewWithLocalRequest alloc] initWithFrame:CGRectMake(0, 0, FRAME_WIDTH, FRAME_HEIGHT_WITH_ALL_BARS)];
	_webView.delegate = self;
    _webView.localDelegate = self;
//    webView.shouldOverride = YES;
	_webView.launchExternalLinksInSafari = NO;
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[[BRRestClient sharedManager] getTwitterFriendUrl]]]];
	
	self.view = _webView;
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

#pragma mark LoadingUIWebViewWithLocalRequestDelegate Methods
- (void)webView:(LoadingUIWebViewWithLocalRequest *)webView handleLocalMethod:(NSString *)method params:(NSDictionary *)params {
    if ([method isEqualToString:@"alert"]) {
        NSString *title = [params objectForKey:@"title"];
        NSString *text = [params objectForKey:@"text"];
        
        if (title == nil) {
            title = @"Alert";
        }
        
        if (text == nil) {
            return;
        }
        
        NSString *success = [params objectForKey:@"success"];
        if (success != nil && [success isEqualToString:@"1"]) {
			[[[BRSession sharedManager] protagonistAnimal] checkForExternalActions];
        }
        
        [self alertWithTitle:title message:text delegate:self];
    }
}

- (void)webView:(LoadingUIWebViewWithLocalRequest *)webView willLoadRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
	if (navigationType == UIWebViewNavigationTypeFormSubmitted) {
		_webView.shouldOverride = YES;
	}
}

/*
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
	BOOL result = [super webView:webView shouldStartLoadWithRequest:request navigationType:navigationType];
}*/


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {

	
}

#pragma mark UIWebViewDelegate Methods
- (void)webViewDidStartLoad:(UIWebView *)webView {
	if (_webView.shouldOverride) {
		[[BRAppDelegate sharedManager] showLoadingOverlayWithText:@"Sending"];
	}
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
	if (_webView.shouldOverride) {	
		[[BRAppDelegate sharedManager] hideLoadingOverlay];	
		_webView.shouldOverride = NO;
	}
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
	if (_webView.shouldOverride) {	
		[[BRAppDelegate sharedManager] hideLoadingOverlay];
		_webView.shouldOverride = NO;		
	}
}

- (void)dealloc {
	_webView.delegate = nil;
	[_webView release];
    [super dealloc];
}


@end
