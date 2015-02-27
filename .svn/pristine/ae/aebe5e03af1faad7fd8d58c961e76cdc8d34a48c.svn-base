//
//  ItemTableViewContainerController.m
//  battleroyale
//
//  Created by Amit Matani on 3/22/09.
//  Copyright 2009 Miraphonic, Inc. All rights reserved.
//

#import "ItemTableViewContainerController.h"
#import "ItemTableViewController.h"
#import "HUDViewController.h"
#import "HelpWebViewController.h"
#import "BRGlobal.h"


@implementation ItemTableViewContainerController

- (id)initWithItemTableViewController:(ItemTableViewController *)itvc {
    if (self = [super init]) {
        hud = [[HUDViewController alloc] init];
		hud.ownerViewController = self;
        itvc.itemTableContainerController = self;
        itemTableContainer = [[RDCContainerController alloc] initWithRemoteDataController:itvc];
        [self navigationController].delegate = itemTableContainer;
    }
    return self;
}

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
    [super loadView];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:hud.view]; 
    [hud reset];
    
    CGFloat y = hud.view.frame.origin.y + hud.view.frame.size.height;
    debug_NSLog(@"y is %f", y);
    CGFloat height = FRAME_HEIGHT_WITH_NAVIGATION_BAR - y;
    CGRect rect = CGRectMake(0, hud.view.frame.origin.y + hud.view.frame.size.height, 320, height);
    [itemTableContainer setViewFrame:rect];
    [self.view addSubview:itemTableContainer.view];
    [itemTableContainer.containedRDC loadInitialData:NO showLoadingOverlay:NO];
    
    [self addLeftCloseButton];
	
	
	UIBarButtonItem *helpButton = [[UIBarButtonItem alloc] initWithTitle:@"Help"
																   style:UIBarButtonItemStylePlain
																  target:self
																  action:@selector(showItemHelp)];
	self.navigationItem.rightBarButtonItem = helpButton;
	[helpButton release];
	
	/** LOGO STYLED TOP NAVIGATION BAR **/
	UINavigationBar *navBar = self.navigationController.navigationBar;
	navBar.barStyle = UIBarStyleBlackOpaque;
	
}

- (void)showItemHelp {
	[[SoundManager sharedManager] playSoundWithType:@"popup" vibrate:NO];
	HelpWebViewController *hvc = [[HelpWebViewController alloc] initWithTypeString:@"item"];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:hvc];
    [self presentModalViewController:nav animated:YES];
    [nav release];
    [hvc release];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}


- (void)dealloc {
    [hud cleanup];
    [hud release];
    [itemTableContainer release];
    [super dealloc];
}

@end
