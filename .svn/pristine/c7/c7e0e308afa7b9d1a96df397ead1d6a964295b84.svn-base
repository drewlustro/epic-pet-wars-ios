/**
 * FacebookFriendsContainerViewController.m
 * Copyright Miraphonic, Inc 2009. All rights reserved.
 *
 * @author Amit Matani 
 * @created 2/12/09.
 */

#import "FacebookFriendsContainerViewController.h"
#import "FacebookFriendsTableViewController.h"
#import "Consts.h"
#import "BRSession.h"
#import "FacebookUser.h"
#import "BRAppDelegate.h"
#import "BRRestClient.h"
#import "Animal.h"

@implementation FacebookFriendsContainerViewController

- (id)init {
	FacebookFriendsTableViewController *fftvc = [[FacebookFriendsTableViewController alloc] init];
	if (self = [super initWithRemoteDataController:fftvc]) {
		self.title = @"Your Friends";
	}
	[fftvc release];
	return self;
}

- (void)loadView {
	[super loadView];
	if ([[BRSession sharedManager] isFacebookUser]) {
		[self.containedRDC loadInitialData:NO showLoadingOverlay:NO];
	} else {
        // figure out what to put here
	}
}

- (void)showTableAfterLinking {
	[self dismissModalViewControllerAnimated:YES];
	[self.containedRDC loadInitialData:NO showLoadingOverlay:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}




- (void)dealloc {
	debug_NSLog(@"deallocing facebook friends");
    [super dealloc];
}


@end
