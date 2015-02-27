/**
 * BattleResultViewController.m
 * Copyright Miraphonic, Inc 2009. All rights reserved.
 *
 * @author Amit Matani 
 * @created 2/2/09.
 */

#import "BattleResultViewController.h"
#import "BRAppDelegate.h"
#import "BattleViewController.h"
#import "NewCommentViewController.h"
#import "Animal.h"
#import "BRTabManager.h"
#import "BattleMasterViewController.h"

@implementation BattleResultViewController
@synthesize okayButton, battleMasterButton, leaveCommentButton;

- (id)initWithNibName:(NSString *)nibName battleResult:(BattleResult *)result
	 opponent:(Animal *)opponent battleViewController:(BattleViewController *)_battleViewController {
	if (self = [super initWithNibName:nibName bundle:[NSBundle mainBundle]]) {
		battleViewController = _battleViewController;
		opponentAnimal = [opponent retain];
		battleResult = [result retain];
	}
	return self;
}

- (void)viewDidLoad {
	[okayButton addTarget:battleViewController action:@selector(dismissBattleControllers) 
		 forControlEvents:UIControlEventTouchUpInside];
    [battleMasterButton addTarget:self
                           action:@selector(dismissBattleControllersAndShowBattleMaster) 
                 forControlEvents:UIControlEventTouchUpInside];
    [leaveCommentButton addTarget:self action:@selector(leaveComment) 
                 forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}

- (void)dismissBattleControllersAndShowBattleMaster {
//    [battleViewController dismissBattleControllers];
//    [[[BRAppDelegate sharedManager] tabManager] showBattleMaster];
	BattleMasterViewController *bmvc = [[BattleMasterViewController alloc] init];
	[self presentModalViewControllerWithNavigationBar:bmvc];
	[bmvc release];
}

- (void)leaveComment {
    NewCommentViewController *ncvc = [[NewCommentViewController alloc] initWithUserId:opponentAnimal.userId];
	UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:ncvc];
	[self presentModalViewController:nav animated:YES];
	[ncvc release];    
    [nav release];
}


- (void)dealloc {
    [okayButton release];
    [battleMasterButton release];
    [leaveCommentButton release];
	[opponentAnimal release];
	[battleResult release];	
    [super dealloc];
}


@end
