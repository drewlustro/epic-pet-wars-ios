//
//  TwitterOAuthLinkerViewController.m
//  battleroyale
//
//  Created by Amit Matani on 8/22/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "TwitterOAuthLinkerViewController.h"
#import "BRRestClient.h"
#import "BRAppDelegate.h"
#import "LoadingUIWebViewWithLocalRequest.h"
#import "BRSession.h"

@implementation TwitterOAuthLinkerViewController

@synthesize delegate = _delegate;

- (id)init {
	if (self = [super init]) {
		self.title = @"Link To Twitter";
	}
	return self;
}

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
	LoadingUIWebViewWithLocalRequest *webView = [[LoadingUIWebViewWithLocalRequest alloc] init];
	webView.delegate = self;
    webView.localDelegate = self;
    webView.shouldOverride = YES;
	webView.scalesPageToFit = YES;
	webView.launchExternalLinksInSafari = NO;
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[[BRRestClient sharedManager] getTwitterLinkUrl]]]];
	
	self.view = webView;
}


/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

#pragma mark UIWebViewDelegate Methods
- (void)webViewDidStartLoad:(UIWebView *)webView {
	[[BRAppDelegate sharedManager] showLoadingOverlayWithText:@"Loading"];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
	[[BRAppDelegate sharedManager] hideLoadingOverlay];	
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
	[[BRAppDelegate sharedManager] hideLoadingOverlay];
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
        NSString *twitterUserId= [params objectForKey:@"twitter_user_id"];		
        if (success != nil && [success isEqualToString:@"1"]) {
            _success = YES;
			[[BRSession sharedManager] setTwitterUserId:twitterUserId];
        }
        
        [self alertWithTitle:title message:text delegate:self];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
//    [self dismissTopMostModalViewControllerWithAnimation];
    [_delegate didFinishAttemptedLink:_success];
        
}

- (void)dealloc {
	((UIWebView *)self.view).delegate = nil;
	((LoadingUIWebViewWithLocalRequest *)self.view).localDelegate = nil;
    [super dealloc];
}


@end
