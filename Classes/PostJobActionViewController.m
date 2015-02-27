//
//  PostJobActionViewController.m
//  battleroyale
//
//  Created by Amit Matani on 8/27/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "PostJobActionViewController.h"
#import "InviteContactsViewController.h"
#import "BRSession.h"
#import "TwitterFriendInviteViewController.h"

@implementation PostJobActionViewController

- (id)initWithHTML:(NSString *)html {
	if (self = [super initWithHTML:html]) {
		self.title = @"Bonus";
    }
    return self;
}

#pragma mark LoadingUIWebViewWithLocalRequestDelegate Methods
- (void)webView:(LoadingUIWebViewWithLocalRequest *)webView handleLocalMethod:(NSString *)method params:(NSDictionary *)params {
	[super webView:webView handleLocalMethod:method params:params];
	if ([method isEqualToString:@"showContacts"]) {
		InviteContactsViewController *icvc = [[InviteContactsViewController alloc] init];
		[self presentModalViewControllerWithNavigationBar:icvc];
		[icvc release];
	} else if ([method isEqualToString:@"twitter"]) {
		UIViewController *twitterView;
		if ([[BRSession sharedManager] isTwitterUser]) {
			twitterView = [[TwitterFriendInviteViewController alloc] init];
		} else {
			twitterView = [[TwitterOAuthLinkerViewController alloc] init];
			((TwitterOAuthLinkerViewController *)twitterView).delegate = self;

		}
		[self presentModalViewControllerWithNavigationBar:twitterView];
		[twitterView release];						
	} else if ([method isEqualToString:@"close"]) {
		[self dismissTopMostModalViewControllerWithAnimation];
	}
}

#pragma mark TwitterOAuthLinkerViewControllerDelegate Methods
- (void)didFinishAttemptedLink:(BOOL)wasSuccessful {
	if (wasSuccessful) {
		TwitterFriendInviteViewController *twitterView = [[TwitterFriendInviteViewController alloc] init];		
		[[self modalViewController] presentModalViewControllerWithNavigationBar:twitterView];
		[twitterView release];
	} else {
		[self dismissTopMostModalViewControllerWithAnimation];
	}
}


@end
