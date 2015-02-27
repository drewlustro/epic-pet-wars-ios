/**
 * HomeViewController.h
 * Copyright Miraphonic, Inc 2009. All rights reserved.
 *
 * The HomeViewController is the controller in charge of handling the home
 * tab of the application. The home tab shows the user's pet as well
 * as some single player actions.
 *
 * @author Amit Matani
 * @created 1/13/09
 */

#import "HomeViewController.h"
#import "HUDViewController.h"
#import "NewsFeedViewController.h"
#import "RDCContainerController.h"
#import "AbstractRemoteCollectionStore.h"
#import "HomeActionViewController.h"
#import "BRAppDelegate.h"
#import "BRSession.h"
#import "BRTabManager.h"
#import "ProtagonistAnimal.h"
#import "Notifier.h"
#import "BattleViewController.h"
#import "UserAnimalsTableContainerViewController.h"
#import <AudioToolbox/AudioServices.h>
#import <AudioToolbox/AudioToolbox.h>
#import "FeedbackViewController.h"

@implementation HomeViewController
@synthesize newsFeedViewController;

- (id)init {
    if (self = [super init]) {
        self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"My Pet" image:[UIImage imageNamed:@"tab_bar_home.png"] tag:0];		
        
        newsFeedViewController = [[NewsFeedViewController alloc] init];
        newsFeedViewController.hideWhenNoObjects = NO;
		newsFeedViewController.homeController = self;
        newsFeedContainer = [[RDCContainerController alloc] initWithRemoteDataController:newsFeedViewController];
		self.title = @"My Pet";
    }
    return self;
}


#pragma mark UIViewController methods
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
    [super loadView];
    
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:@"Switch Pet" style:UIBarButtonItemStylePlain
                                          target:self 
                                          action:@selector(switchAnimalAction)];
    self.navigationItem.leftBarButtonItem = leftButton;
    [leftButton release];
	
	/** LOGO STYLED TOP NAVIGATION BAR **/
	UINavigationBar *navBar = self.navigationController.navigationBar;
	navBar.barStyle = UIBarStyleBlackOpaque;
	UIImageView *largeLogo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"navigation_bar_logo_large.png"]];
	largeLogo.frame = CGRectMake(FRAME_WIDTH / 2 - 120 / 2, 0, TOP_BAR_LOGO_WIDTH, TOP_BAR_LOGO_HEIGHT);
	self.navigationItem.titleView = largeLogo;
	[largeLogo release];

    
    // FOR NOW put this feedback button in for testing
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithTitle:@"Help" style:UIBarButtonItemStylePlain
                                                                  target:self 
                                                                  action:@selector(showFeedbackView)];
    self.navigationItem.rightBarButtonItem= rightBarButton;
    [rightBarButton release];
}

- (void)showFeedbackView {
	[[SoundManager sharedManager] playSoundWithType:@"popup" vibrate:NO];
    FeedbackViewController *fvc = [[FeedbackViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:fvc];
    [self presentModalViewController:nav animated:YES];
    [nav release];
    [fvc release];
}

- (CGFloat)loadViewAndRespondWithY { 
    CGFloat y = [super loadViewAndRespondWithY];
    
    CGFloat height = FRAME_HEIGHT_WITH_ALL_BARS - y;
    CGRect rect = CGRectMake(0, y, FRAME_WIDTH, height);
    [newsFeedContainer setViewFrame:rect];
    [self.view addSubview:newsFeedContainer.view];
	return y;
}

- (void)didReceiveMemoryWarning {
    debug_NSLog(@"memory warning");
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}

/**
 * switchAnimalAction is called when the switch animal button is pressed.
 * It puts up an alert view asking the user if they are sure they want 
 * to switch
 */
- (void)switchAnimalAction {
	[[SoundManager sharedManager] playSoundWithType:@"popup" vibrate:NO];
	UserAnimalsTableContainerViewController *uatcvc = [[UserAnimalsTableContainerViewController alloc] init];
	UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:uatcvc];
	[self presentModalViewController:nav animated:YES];
	[nav release];
	[uatcvc release];
}

#pragma mark alert view
/**
 * The alert view will log a user out if they clicked yes
 */
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
}

- (void)increaseBadgeValue:(NSInteger)increment {
	[[SoundManager sharedManager] playSoundWithType:@"popup" vibrate:YES];
	self.tabBarItem.badgeValue = [NSString stringWithFormat:@"%d", [self.tabBarItem.badgeValue intValue] + increment];
}

#pragma mark TopLevelController methods
- (void)handleSelected {
	self.tabBarItem.badgeValue = nil;
}

- (void)handleLogin {
	[super handleLogin];
    [self performSelector:@selector(loadNewsfeed) withObject:nil afterDelay:0];
    [[newsFeedViewController actionViewController] update];
}

- (void)loadNewsfeed {
    [newsFeedViewController loadInitialData:YES showLoadingOverlay:NO];    
}

- (void)handleLogout {}


- (void)dealloc {
    [newsFeedContainer release];
	[newsFeedViewController release];
    [super dealloc];
}


@end
