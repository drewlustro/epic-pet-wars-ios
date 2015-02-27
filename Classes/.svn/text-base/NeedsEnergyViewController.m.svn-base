//
//  NeedsEnergyViewController.m
//  battleroyale
//
//  Created by Amit Matani on 3/4/09.
//  Copyright 2009 Miraphonic, Inc. All rights reserved.
//

#import "NeedsEnergyViewController.h"
#import "BRAppDelegate.h"
#import "BRTabManager.h"
#import "BRGlobal.h"
#import "BattleMasterViewController.h"

@implementation NeedsEnergyViewController
@synthesize getMoreEnergy, okButton;

// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)init {
    if (self = [super initWithNibName:@"NeedsEnergyView" bundle:[NSBundle mainBundle]]) {
        self.title = @"Curses!";
    }
    return self;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    [getMoreEnergy addTarget:self action:@selector(showResepectTab) forControlEvents:UIControlEventTouchUpInside];
    [okButton addTarget:self action:@selector(okButtonTapped) forControlEvents:UIControlEventTouchUpInside];
}

- (void)okButtonTapped {		
	[self dismissTopMostModalViewControllerWithAnimationAndSound];
}

- (void)showResepectTab {
	BattleMasterViewController *bmvc = [[BattleMasterViewController alloc] init];
	[self presentModalViewControllerWithNavigationBar:bmvc];
	[bmvc release];
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
    [getMoreEnergy release];
    [okButton release];
    
    [super dealloc];
}


@end
