/**
 * InitialLoginViewController.m
 * Copyright Miraphonic, Inc 2009. All rights reserved.
 *
 * The InitialLoginViewController manages the InitialLoginView
 * which is splashed on the screen after a user has launched the app.
 * If the session is properly returned it goes to the home screen
 * otherwise it will either ask for an new account or new animal
 *
 * @author Amit Matani
 * @created 2/9/09
 */
#import "InitialLoginViewController.h"
#import "BRRestClient.h"
#import "BRSession.h"
#import "BRAppDelegate.h"
#import "BRTabManager.h"
#import "ProtagonistAnimal.h"
#import "BattleViewController.h"
#import "AnimalTypeSelectionController.h"
#import "RDCContainerController.h"
#import "CreateAccountViewController.h"
#import "AnimalTypeSelectionContainerController.h"
#import "ActionResult.h"
#import "BRStoreKitPaymentManager.h"

@implementation InitialLoginViewController

// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)init {
    if (self = [super initWithNibName:@"InitialLoginView" bundle:[NSBundle mainBundle]]) {
        
    }
    return self;
}


// Implement viewDidLoad to do additional setup after Login the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	[[SoundManager sharedManager] playSoundWithType:@"startup" vibrate:NO];    
	[self getSession];
}

- (void)getSession {
	[[BRRestClient sharedManager] auth_getSessionWithDeviceId:NO target:self 
											 finishedSelector:@selector(handleSuccessfulAuthResponse:parsedResponse:)
											   failedSelector:@selector(handleFailedAuthResponse)];
}

/**
 * handleSuccessfulAuthResponse get is called when the BRRestClient finishes calling the
 * auth_getSession function.  If the responseInt is successful, the user is logged in.
 * Otherwise, show a Incorrect username or password prompt
 */
- (void)handleSuccessfulAuthResponse:(NSNumber *)responseInt parsedResponse:(NSDictionary *)parsedResponse {
	// launch plus if necessary because this is the first thing that our servers report back
	[[BRSession sharedManager] launchPlusPlusWithOAuthKey:[Utility stringIfNotEmpty:[parsedResponse objectForKey:@"pp_oauth_key"]] 
											  oauthSecret:[Utility stringIfNotEmpty:[parsedResponse objectForKey:@"pp_oauth_secret"]]];
	
    if ([BRRestClient isResponseSuccessful:responseInt]) {
		[self handleSuccessfulLogin:parsedResponse];
	} else {
		CreateAccountViewController *chooser = 
			[[CreateAccountViewController alloc] initWithInitalLoginViewController:self];
		[self presentModalViewController:chooser animated:YES];
		[chooser release];
	}
}

- (void)handleFailedAuthResponse {
	// show the error
}

/**
 * handleSuccessfulLogin is called when the attempted login was successful.
 * It will save the sessionData in the BRSession, tell the BRTabManager to
 * alert all theTopLevelControllers that a login has occurred, and then tell the 
 * BRAppDelegate to remove the login screen.
 */
- (void)handleSuccessfulLogin:(NSDictionary *)sessionData {
    BRSession *session = [BRSession sharedManager];
	[session login:@"" password:@"" extraProperties:sessionData];
	if (![session isLoggedIn]) {
		// show the error
	} else {
        // check for a message / action result from the server
        // we also can stop the login from here if the server decides to
        NSString *stopLoginString = [sessionData objectForKey:@"stop_login"];
        NSString *initialMessage = [sessionData objectForKey:@"initial_message"];
        if (initialMessage != (id)[NSNull null] && initialMessage != nil) {
            NSString *initialMessageTitle = [sessionData objectForKey:@"initial_message_title"];
            if (initialMessageTitle == (id)[NSNull null] || initialMessageTitle == nil) {
                initialMessageTitle = @"Alert";
            }
            UIAlertView *initialLoginMessage = 
                [[UIAlertView alloc] initWithTitle:initialMessageTitle
                                           message:initialMessage
                                          delegate:self 
                                 cancelButtonTitle:@"OK" 
                                 otherButtonTitles:nil];
            [initialLoginMessage show];
            [initialLoginMessage release];
            stopLogin = (id)stopLoginString != [NSNull null] && [stopLoginString isEqualToString:@"1"];
            storedSessionData = [sessionData retain];
        } else {
            [self handleSuccessfulLoginHelper:sessionData];
        }
		[[BRStoreKitPaymentManager sharedManager] startCreditingPurchases];
	}
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (!stopLogin) {
        [self handleSuccessfulLoginHelper:storedSessionData];
    }
    [storedSessionData release];
    storedSessionData = nil;
}


- (void)handleSuccessfulLoginHelper:(NSDictionary *)sessionData {
    BRSession *session = [BRSession sharedManager];    
    [[[BRAppDelegate sharedManager] tabManager] login];
    NSString *battleId = [sessionData objectForKey:@"battle_id"];
    if (session.protagonistAnimal == nil) {
        // we have a user without an animal, we need to show the new animal view
        [self showNewAnimalViews];
    } else if (battleId != nil) {
        Animal *opponent = [[Animal alloc] initWithApiResponse:[sessionData objectForKey:@"challenger"]];
        ActionResult *initialBattleActionResult = [[ActionResult alloc] initWithApiResponse:[sessionData objectForKey:@"inital_battle_action_result"]];
        BattleViewController *bvc = [[BattleViewController alloc] initWithOpponentAnimal:opponent andBattleId:battleId andInitialAction:initialBattleActionResult];
        [initialBattleActionResult release];
        [self presentModalViewController:bvc animated:YES];
        [bvc release];	
        [opponent release];
    } else {
        [[self parentViewController] dismissModalViewControllerAnimated:YES];
		[[BRAppDelegate sharedManager] registerForRemoteNotifications];
    }    
}


/**
 * showNewAccountViews will add to the top of the navigation screen the 
 * controllers required to create a new account
 */
- (void)showNewAnimalViews {    
	AnimalTypeSelectionContainerController *container = [[AnimalTypeSelectionContainerController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:container];
    
	UIViewController *currentController = self;
	
	// find the level of the open modal view controller	
	while ([currentController modalViewController] != nil) {
		currentController = [currentController modalViewController];
	}
	
	[currentController presentModalViewController:nav animated:YES];
    
    [container.containedRDC loadInitialData:YES showLoadingOverlay:YES];
    [container setViewFrame:CGRectMake(0, 0, FRAME_WIDTH, FRAME_HEIGHT_WITH_NAVIGATION_BAR)];
    
    [container release];    
    [nav release];
}
/*
- (void)showFacebookLogin {
	//	[self enableLogin:NO];
	if ([self modalViewController] != nil) {
		debug_NSLog(@"has modal");
	}
	FacebookLoginViewController *flvc = [[FacebookLoginViewController alloc] initWithLoginViewController:self];
	
	UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:flvc];
	
	[self presentModalViewController:nav animated:YES];
	
	[flvc release];
	[nav release];
}*/

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}


- (void)dealloc {
	debug_NSLog(@"deallocing initial Login view controller");
    [storedSessionData release];
    [super dealloc];
}

@end
