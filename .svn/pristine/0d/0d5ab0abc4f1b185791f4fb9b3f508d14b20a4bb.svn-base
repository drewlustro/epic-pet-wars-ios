/**
 * BRTabManager.m
 * Copyright Miraphonic, Inc 2009. All rights reserved.
 *
 * The BRTabManager adds Battle Royale specific methods to the TabManager
 *
 * @author Amit Matani
 * @created 1/13/09
 */

#import "BRTabManager.h"
#import "HomeViewController.h"
#import "JobWebViewController.h"
#import "BattleWebViewController.h"
#import "BattleListViewController.h"
#import "BattleMasterViewController.h"
#import "InviteOptionsViewController.h"
#import "BRSession.h"
#import "ProtagonistAnimal.h"

@implementation BRTabManager
@synthesize homeController, jobController, battleListController, 
			battleMasterViewController, inviteOptionsViewController;

/**
 * init instantiates the object, the tabBarController and the
 * associated navigation and view controllers
 * @return BRTabManager instance
 */
- (id)init {
    if (self = [super init]) {
        HomeViewController *hc = [[HomeViewController alloc] init];
        self.homeController = hc;
        [hc release];
        
        JobWebViewController *jc = [[JobWebViewController alloc] init];
        self.jobController = jc;
        [jc release];
		
		BattleWebViewController *blc = [[BattleWebViewController alloc] init];
        self.battleListController = blc;
        [blc release];
		
		BattleMasterViewController *bmvc = [[BattleMasterViewController alloc] init];
        self.battleMasterViewController = bmvc;
        [bmvc release];
		
		InviteOptionsViewController *iovc = [[InviteOptionsViewController alloc] init];
		self.inviteOptionsViewController = iovc;
		[iovc release];
              
        [self setViewControllers:
            [NSArray arrayWithObjects:homeController,
                                      jobController,
									  battleListController,
									  battleMasterViewController,
									  inviteOptionsViewController,
                                      nil]];
    }
    return self;
}

- (void)login {
	[super login];
	ProtagonistAnimal *animal = [[BRSession sharedManager] protagonistAnimal];
	if (animal != nil && animal.hp == 0) {
		[self handleDeath];
	} else if (animal != nil) {
		[self handleRevive];
	}
}

- (void)handleDeath {
	UIViewController <TopLevelController> *controller;
	for (controller in viewControllerList) {
		[controller handleDeath];
	}
}

- (void)handleRevive {
	UIViewController <TopLevelController> *controller;
	for (controller in viewControllerList) {
		[controller handleRevive];
	}
}

- (void)showBattleMaster {
    tabBarController.selectedIndex = 3;
}

- (void)showInvite {
    tabBarController.selectedIndex = 4;
}

- (void)dealloc {
	[battleListController release];
    [homeController release];
    [jobController release];
    [inviteOptionsViewController release];
	[battleListController release];
    [battleMasterViewController release];
    [super dealloc];
}


@end
