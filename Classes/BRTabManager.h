/**
 * BRTabManager.h
 * Copyright Miraphonic, Inc 2009. All rights reserved.
 *
 * The BRTabManager adds Battle Royale specific methods to the TabManager
 *
 * @author Amit Matani
 * @created 1/13/09
 */

#import "BRGlobal.h"

@class HomeViewController, 
	   BattleMasterViewController, InviteOptionsViewController, JobWebViewController, BattleWebViewController;

@interface BRTabManager : TabManager {
    HomeViewController *homeController;
    JobWebViewController *jobController;
	BattleWebViewController *battleListController;
	BattleMasterViewController *battleMasterViewController;
	InviteOptionsViewController *inviteOptionsViewController;
}

@property (nonatomic, retain) HomeViewController *homeController;
@property (nonatomic, retain) JobWebViewController *jobController;
@property (nonatomic, retain) BattleWebViewController *battleListController;
@property (nonatomic, retain) BattleMasterViewController *battleMasterViewController;
@property (nonatomic, retain) InviteOptionsViewController *inviteOptionsViewController;

- (void)handleDeath;
- (void)handleRevive;
- (void)showBattleMaster;
- (void)showInvite;

@end
