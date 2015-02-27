/**
 * ProfileWithHudViewController.m
 * Copyright Miraphonic, Inc 2009. All rights reserved.
 *
 * @author Amit Matani 
 * @created 2/12/09.
 */

#import "ProfileWithHudViewController.h"
#import "Animal.h"
#import "ProfileViewController.h"
#import "HUDViewController.h"
#import "BRAppDelegate.h"
#import "BattleViewController.h"
#import "BRRestClient.h"
#import "BRSession.h"
#import "ProtagonistAnimal.h"
#import "EarnedAchievementContainerController.h"
#import "CommentTableViewContainerController.h"
#import "CommentRemoteCollection.h"
#import "Mega/Mega.h"


@implementation ProfileWithHudViewController

- (id)initWithAnimal:(Animal *)_animal {
	if (self = [super init]) {
		animal = [_animal retain];
		[self doInitialSetup:NO];
	}
	return self;
}

- (id)initWithAnimalId:(NSString *)_animalId {
	if (self = [super init]) {
		animalId = [_animalId retain];
		[self doInitialSetup:YES];
	}
	return self;
}

- (void)doInitialSetup:(BOOL)loadRequired {
	initialLoadRequired = loadRequired;
	hud = [[HUDViewController alloc] init];
}

/**
 * isInitialLoadRequired checks to see if the initial load is allowed by the
 * class.  Subclasses should override this method.
 * @return BOOL - YES if the initial load is allowed, otherwise NO
 */
- (BOOL)isInitialLoadRequired {
    return initialLoadRequired;
}

- (void)performInitialLoadRemoteDataCall {
	[super performInitialLoadRemoteDataCall];
	initialLoadRequired = NO;
	NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:animalId, @"animal_id", nil];
    
    [loadAnimalOperation release];

    loadAnimalOperation = 
        [[[BRRestClient sharedManager] callRemoteMethod:@"animal.loadAnimal" params:params 
                                    nonRetainedDelegate:self] retain];

    [params release];    
}

- (void)remoteMethodDidLoad:(NSString *)method responseCode:(RestResponseCode)responseCode parsedResponse:(NSDictionary *)parsedResponse {
	if (responseCode == RestResponseCodeSuccess) {
		[animal release];
		animal = [[Animal alloc] initWithApiResponse:[parsedResponse objectForKey:@"animal"]];
		[self displayProfileView];
		[containerController showContainedViewController];
	} else {

	}    
}

- (void)remoteMethodDidFail:(NSString *)method {
    
}

- (void)loadView {
	[super loadView];
	
	if (self.containerController != nil) {
		hud.ownerViewController = self.containerController;
	} else {
		hud.ownerViewController = self;
	}

//	self.view.frame = CGRectMake(0, 0, FRAME_WIDTH, FRAME_HEIGHT_WITH_ALL_BARS);
    [self.view addSubview:hud.view];
    
	containerController.initialLoadingIndicator.top += hud.view.height;
	containerController.initialLoadingLabel.top += hud.view.height;
	containerController.specialMessageLabel.top += hud.view.height;
    
	if (!initialLoadRequired) {
		[self displayProfileView];
		[containerController showContainedViewController];
	}
}

- (void)displayProfileView {

	containerController.title = animal.name;
	[profileViewController release];
	profileViewController = [[ProfileViewController alloc] initWithAnimal:animal];
	profileViewController.parentController = self;
	[self.view insertSubview:profileViewController.view belowSubview:hud.view];
	
    CGFloat y = hud.view.frame.origin.y + hud.view.frame.size.height;	
	
	profileViewController.view.frame = CGRectMake(0, y, FRAME_WIDTH, FRAME_HEIGHT_WITH_ALL_BARS - y);
	((UIScrollView *)profileViewController.view).contentSize = CGSizeMake(FRAME_WIDTH, FRAME_HEIGHT_WITH_ALL_BARS + 80);
}


- (void)startBattle {
	if ([[[BRSession sharedManager] protagonistAnimal] hp] <= 0) {
		// TODO put a revive or send to battle master
        [self alertWithTitle:@"Unable to Battle" message:@"You cannot attack when you are in a coma"];         
		return;
	}
	debug_NSLog(@"start battle");
	[[BRAppDelegate sharedManager] showLoadingOverlayWithText:@"Starting Battle"];
	[[BRRestClient sharedManager] battle_startBattle:animal.animalId isBot:@"0" fromView:@"profile" target:self 
									finishedSelector:@selector(finishedStartingBattle:parsedResponse:)
									  failedSelector:@selector(failedStartingBattle)];
}

- (void)finishedStartingBattle:(NSNumber *)responseInt parsedResponse:(NSDictionary *)parsedResponse {
	if ([BRRestClient isResponseSuccessful:responseInt]) {		
		Animal *opponent = [[Animal alloc] initWithApiResponse:[parsedResponse objectForKey:@"opponent_animal"]];
		NSString *battleId = [parsedResponse objectForKey:@"battle_id"];
		BattleViewController *battleViewController = [[BattleViewController alloc] initWithOpponentAnimal:opponent andBattleId:battleId andInitialAction:nil];
		[containerController presentModalViewController:battleViewController animated:YES];
		[battleViewController release];
		[[BRAppDelegate sharedManager] hideLoadingOverlay];
    } else {
        [self failedToStartBattle:[parsedResponse objectForKey:@"response_message"]];
    }
}

- (void)showAchievements {
	EarnedAchievementContainerController *eacc = [[EarnedAchievementContainerController alloc] initWithAnimal:animal];	
	[[containerController navigationController] pushViewController:eacc animated:YES];

	[eacc setViewFrame:CGRectMake(0, 0, FRAME_WIDTH, self.view.frame.size.height)];	    

	[eacc release];
}

- (void)showComments { 
	CommentTableViewContainerController *ctvcc = [[CommentTableViewContainerController alloc] initWithAnimal:animal];
	[[containerController navigationController] pushViewController:ctvcc animated:YES];

	[ctvcc setViewFrame:CGRectMake(0, 0, FRAME_WIDTH, self.view.frame.size.height)];    
	[ctvcc release];
}

- (void)failedStartingBattle {
    [self failedToStartBattle:@"Unknown Error"];
}

- (void)failedToStartBattle:(NSString *)message {
	[[BRAppDelegate sharedManager] hideLoadingOverlay];	        
    [self alertWithTitle:@"Unable to Battle" message:message]; 
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}

- (void)willDisplayFromNavigation {
	[containerController setViewFrame:CGRectMake(0, 0, FRAME_WIDTH, FRAME_HEIGHT_WITH_NO_BARS)];	        
}


- (void)dealloc {
	[animal release];
	[animalId release];
    [hud cleanup];
    [hud release];
    [profileViewController release];
    [loadAnimalOperation cancel];
    [loadAnimalOperation release];
    [super dealloc];
}


@end
