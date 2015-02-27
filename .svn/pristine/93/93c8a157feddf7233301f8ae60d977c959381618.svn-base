//
//  NeedsMoneyViewController.m
//  battleroyale
//
//  Created by Amit Matani on 3/4/09.
//  Copyright 2009 Miraphonic, Inc. All rights reserved.
//

#import "NeedsMoneyViewController.h"
#import "BRAppDelegate.h"
#import "BRTabManager.h"
#import "BRGlobal.h"
#import "BRSession.h"
#import "ProtagonistAnimal.h"
#import "BattleMasterViewController.h"

@implementation NeedsMoneyViewController
@synthesize respectButton, jobButton, battleButton, okButton, bankBalanceLabel;


// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)init {
    if (self = [super initWithNibName:@"NeedsMoneyView" bundle:[NSBundle mainBundle]]) {
        self.title = @"Curses!";
    }
    return self;
}

- (void)loadView {
	[super loadView];
	/** LOGO STYLED TOP NAVIGATION BAR **/
	UINavigationBar *navBar = self.navigationController.navigationBar;
	navBar.barStyle = UIBarStyleBlackOpaque;	
	UIImageView *topLogo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"navigation_bar_logo.png"]];
	topLogo.frame = CGRectMake(FRAME_WIDTH - TOP_BAR_LOGO_WIDTH, 0, TOP_BAR_LOGO_WIDTH, TOP_BAR_LOGO_HEIGHT);
	[navBar addSubview: topLogo];
	[topLogo release];
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    [respectButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [jobButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [battleButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];    
    [okButton addTarget:self action:@selector(okButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    
    bankBalanceLabel.text = [NSString stringWithFormat:@"¥%d", ([[BRSession sharedManager] protagonistAnimal]).bankFunds];
}

- (void)okButtonTapped {		
    [self dismissTopMostModalViewControllerWithAnimationAndSound];
}

- (void)buttonClicked:(UIButton *)sender {
    int selectedIndex = 0;
    if (sender == respectButton) {
//        selectedIndex = 3;        
		BattleMasterViewController *bmvc = [[BattleMasterViewController alloc] init];
		[self presentModalViewControllerWithNavigationBar:bmvc];
		[bmvc release];
		return;
    } else if (sender == jobButton) {
        selectedIndex = 1;        
    } else if (sender == battleButton) {
        selectedIndex = 2;  
    }
    [[[BRAppDelegate sharedManager] tabManager] tabBarController].selectedIndex = selectedIndex;
    [self dismissTopMostModalViewControllerWithAnimation];
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
    [respectButton release];
    [jobButton release];
    [battleButton release];
    [okButton release];
    [bankBalanceLabel release];
    
    [super dealloc];
}


@end
