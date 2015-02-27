//
//  BattleWebViewController.m
//  battleroyale
//
//  Created by Amit Matani on 12/22/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "BattleWebViewController.h"
#import "BRSession.h"

#import "TopAnimalsTableViewController.h"
#import "TopAnimalsWebViewController.h"
#import "OwnedItemTableViewContainerController.h"

@implementation BattleWebViewController
- (id)init {
    if (self = [super init]) {
		self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Battle" image:[UIImage imageNamed:@"tab_bar_battle.png"] tag:2];
		self.title = @"Battle";
    }
    return self;
}

- (void)reloadRequest {
	[super reloadRequest];
	[_webViewController loadDataWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[[BRSession sharedManager] getBattleUrl]]]];
}

// Implement loadView to create a view hierarchy programmatically, without using a nib.

- (CGFloat)loadViewAndRespondWithY {
    CGFloat y = [super loadViewAndRespondWithY];
	
    // button to show the top players
    UIBarButtonItem *topPlayers = [[UIBarButtonItem alloc] initWithTitle:@"Leaderboards" 
                                                                   style:UIBarButtonItemStyleDone 
                                                                  target:self 
                                                                  action:@selector(showTopPlayers)];
    self.navigationItem.rightBarButtonItem = topPlayers;
    [topPlayers release];	
	
	UIBarButtonItem *myItems = [[UIBarButtonItem alloc] initWithTitle:@"My Items" 
																style:UIBarButtonItemStylePlain 
															   target:self 
															   action:@selector(equipmentButtonClicked)];
	
    self.navigationItem.leftBarButtonItem = myItems;
    [myItems release];
	
    return y;
}

- (void)showTopPlayers {
	[[SoundManager sharedManager] playSoundWithType:@"popup" vibrate:NO];
	TopAnimalsWebViewController *tawvc = [[TopAnimalsWebViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:tawvc];
    [tawvc addLeftCloseButton];
	[self presentModalViewController:nav animated:YES];
	[tawvc release];
	[nav release];
/*
    TopAnimalsTableViewController *tatvc = [[TopAnimalsTableViewController alloc] init];
    RDCContainerController *container = [[RDCContainerController alloc] initWithRemoteDataController:tatvc];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:container];
    
    [container setViewFrame:CGRectMake(0, 0, FRAME_WIDTH, FRAME_HEIGHT_WITH_NAVIGATION_BAR)];
    
    [container addLeftCloseButton];
    
    [tatvc loadInitialData:NO showLoadingOverlay:NO];
    [self presentModalViewController:nav animated:YES];
    [nav release];
    [container release];
    [tatvc release];*/
}

- (void)equipmentButtonClicked {
	[[SoundManager sharedManager] playSoundWithType:@"popup" vibrate:NO];
    OwnedItemTableViewContainerController *stvcc = [[OwnedItemTableViewContainerController alloc] init];
    
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:stvcc];
    [stvcc release];
    
    [self presentModalViewController:nc animated:YES];
    [nc release];
}

- (void)dealloc {
    [super dealloc];
}

@end
