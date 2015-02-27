//
//  PostNewAccountViewController.m
//  battleroyale
//
//  Created by Amit Matani on 1/19/09.
//  Copyright 2009 Miraphonic, Inc. All rights reserved.
//

#import "PostNewAccountViewController.h"
#import "BRAppDelegate.h"

@implementation PostNewAccountViewController
@synthesize startPlayingButton;

- (id)init {
    if (self = [super initWithNibName:@"PostNewAccountView" bundle:[NSBundle mainBundle]]) {
        // Custom initialization
    }
    return self;
}

- (void)loadView {
	[super loadView];
	/** LOGO STYLED TOP NAVIGATION BAR **/
	UINavigationBar *navBar = self.navigationController.navigationBar;
	navBar.barStyle = UIBarStyleBlackOpaque;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	[[self navigationController] setNavigationBarHidden:YES];	
    [startPlayingButton addTarget:self action:@selector(startPlayingButtonPressed)
                  forControlEvents:UIControlEventTouchUpInside];
}

- (void)startPlayingButtonPressed {
    [[BRAppDelegate sharedManager] showHomeScreen];
	[[BRAppDelegate sharedManager] registerForRemoteNotifications];
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
    [startPlayingButton release];
    [super dealloc];
}


@end
