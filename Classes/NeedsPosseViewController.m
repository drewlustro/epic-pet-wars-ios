//
//  NeedsPosseViewController.m
//  battleroyale
//
//  Created by Amit Matani on 3/11/09.
//  Copyright 2009 Miraphonic, Inc. All rights reserved.
//

#import "NeedsPosseViewController.h"
#import "BRAppDelegate.h"
#import "BRTabManager.h"
#import "BRGlobal.h"
#import "GrowPosseViewController.h"
#import "BattleMasterViewController.h"

@implementation NeedsPosseViewController
@synthesize respectButton, inviteButton, okButton;
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)init {
    if (self = [super initWithNibName:@"NeedsPosseView" bundle:[NSBundle mainBundle]]) {
        self.title = @"Requires Larger Posse";
    }
    return self;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    [respectButton addTarget:self action:@selector(showResepectTab) forControlEvents:UIControlEventTouchUpInside];
    [inviteButton addTarget:self action:@selector(showInviteTab) forControlEvents:UIControlEventTouchUpInside];    
    [okButton addTarget:self action:@selector(okButtonTapped) forControlEvents:UIControlEventTouchUpInside];
}

- (void)okButtonTapped {
	[self dismissTopMostModalViewControllerWithAnimation];
}

- (void)showResepectTab {
	BattleMasterViewController *bmvc = [[BattleMasterViewController alloc] init];
	[self presentModalViewControllerWithNavigationBar:bmvc];
	[bmvc release];
}

- (void)showInviteTab {
//	[[[BRAppDelegate sharedManager] tabManager] showInvite];
//    [self dismissTopMostModalViewControllerWithAnimation];
	GrowPosseViewController *gpvc = [[GrowPosseViewController alloc] init];
	gpvc.hideFriendCode = YES;
	gpvc.initialTab = INVITE_HELP;
	[self presentModalViewControllerWithNavigationBar:gpvc];
	[gpvc release];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}


- (void)dealloc {
    [respectButton release];
    [inviteButton release];
    [okButton release];
    
    [super dealloc];
}

@end
