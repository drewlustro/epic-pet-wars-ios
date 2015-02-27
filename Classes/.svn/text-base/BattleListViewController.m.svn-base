/**
 * BattleListViewController.m
 * Copyright Miraphonic, Inc 2009. All rights reserved.
 *
 * @author Amit Matani 
 * @created 2/1/09.
 */

#import "BattleListViewController.h"
#import "ChallengerTableViewController.h"
#import "RDCContainerController.h"
#import "Consts.h"
#import "Challenger.h"
#import "BattleViewController.h"
#import "BRAppDelegate.h"
#import "BRRestClient.h"
#import "Animal.h"
#import "ProtagonistAnimal.h"
#import "BRTabManager.h"
#import "BRSession.h"
#import "TopAnimalsTableViewController.h"
#import "OwnedItemTableViewContainerController.h"


@implementation BattleListViewController
@synthesize challengerTableContainer;

- (id)init {
	if (self = [super init]) {
		self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Battle" image:[UIImage imageNamed:@"tab_bar_battle.png"] tag:2];
		ChallengerTableViewController *ctvc = [[ChallengerTableViewController alloc] init];
		ctvc.battleListViewController = self;
        challengerTableContainer = [[RDCContainerController alloc] initWithRemoteDataController:ctvc];
        [ctvc release];
		[[[BRSession sharedManager] protagonistAnimal] registerObserverToAllProperties:self];
        [[BRSession sharedManager] registerObserverForProtagonistAnimal:self];	
		self.title = @"Battle";
	}
	return self;
}

- (CGFloat)loadViewAndRespondWithY { 
    CGFloat y = [super loadViewAndRespondWithY];
    
    CGFloat height = FRAME_HEIGHT_WITH_ALL_BARS - y;
    debug_NSLog(@"y is fro load %f", height);    
    CGRect rect = CGRectMake(0, y, FRAME_WIDTH, height);
    [self.view addSubview:challengerTableContainer.view];      
    [challengerTableContainer setViewFrame:rect];    
	
	/** LOGO STYLED TOP NAVIGATION BAR **/
	UINavigationBar *navBar = self.navigationController.navigationBar;
	navBar.barStyle = UIBarStyleBlackOpaque;
    
    // button to show the top players
    UIBarButtonItem *topPlayers = [[UIBarButtonItem alloc] initWithTitle:@"Top Players" 
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
	
    TopAnimalsTableViewController *tatvc = [[TopAnimalsTableViewController alloc] init];
    RDCContainerController *container = [[RDCContainerController alloc] initWithRemoteDataController:tatvc];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:container];
    
    [container setViewFrame:CGRectMake(0, 0, FRAME_WIDTH, FRAME_HEIGHT_WITH_NAVIGATION_BAR)];
    
    [container addLeftCloseButton];
    
    [tatvc loadInitialData:NO showLoadingOverlay:NO];
    [self presentModalViewController:nav animated:YES];
    [nav release];
    [container release];
    [tatvc release];
}

- (void)equipmentButtonClicked {
	[[SoundManager sharedManager] playSoundWithType:@"popup" vibrate:NO];
    OwnedItemTableViewContainerController *stvcc = [[OwnedItemTableViewContainerController alloc] init];
    
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:stvcc];
    [stvcc release];
    
    [self presentModalViewController:nc animated:YES];
    [nc release];
}

- (void)handleSelected {
    [challengerTableContainer.containedRDC loadInitialData:newLogin showLoadingOverlay:YES];
    newLogin = NO;
}
- (void)handleLogin {
	[super handleLogin];
    newLogin = true;
}

- (void)handleLogout {}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}

- (void)startBattleWithChallenger:(Challenger *)challenger {
	debug_NSLog(@"start battle");
	[[BRAppDelegate sharedManager] showLoadingOverlayWithText:@"Starting Battle"];
	[[BRRestClient sharedManager] battle_startBattle:challenger.animalId isBot:challenger.isBot fromView:@"battleList"
                                target:self finishedSelector:@selector(finishedStartingBattle:parsedResponse:)
								  failedSelector:@selector(failedStartingBattle)];
}

- (void)finishedStartingBattle:(NSNumber *)responseInt parsedResponse:(NSDictionary *)parsedResponse {
	if ([BRRestClient isResponseSuccessful:responseInt]) {		
		Animal *opponent = [[Animal alloc] initWithApiResponse:[parsedResponse objectForKey:@"opponent_animal"]];
		NSString *battleId = [parsedResponse objectForKey:@"battle_id"];
		BattleViewController *battleViewController = [[BattleViewController alloc] initWithOpponentAnimal:opponent andBattleId:battleId andInitialAction:nil];
		[self presentModalViewController:battleViewController animated:YES];
		[battleViewController release];
        [opponent release];
		[[BRAppDelegate sharedManager] hideLoadingOverlay];		
	} else {
        [self failedToStartBattle:[parsedResponse objectForKey:@"response_message"]];
	}
}

- (void)failedStartingBattle {
    [self failedToStartBattle:@"Unknown Error"];
}

- (void)failedToStartBattle:(NSString *)message {
	[[BRAppDelegate sharedManager] hideLoadingOverlay];	        
    UIAlertView *failedBattleStart = 
    [[UIAlertView alloc] initWithTitle:@"Unable to Battle"
                               message:message
                              delegate:self 
                     cancelButtonTitle:@"OK" 
                     otherButtonTitles:nil];
    [failedBattleStart show];
    [failedBattleStart release];    
}



- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object
		change:(NSDictionary *)change context:(void *)context {       
    if ([keyPath isEqualToString:@"protagonistAnimal"]) {
        [[[BRSession sharedManager] protagonistAnimal] registerObserverToAllProperties:self];
        return;
    }    
    if ([keyPath isEqualToString:@"level"]) {
		newLogin = YES;
		if ([[[BRAppDelegate sharedManager] tabManager] getSelectedViewController] == 
			[self navigationController]) {
			[self handleSelected];
		}
	}
}


- (void)dealloc {
    [super dealloc];
}


@end
