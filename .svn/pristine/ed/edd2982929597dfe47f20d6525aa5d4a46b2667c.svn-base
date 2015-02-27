//
//  JobViewController.m
//  battleroyale
//
//  Created by Amit Matani on 1/30/09.
//  Copyright 2009 Miraphonic, Inc. All rights reserved.
//

#import "JobViewController.h"
#import "Consts.h"
#import "JobTableViewController.h"
#import "RDCContainerController.h"
#import "Job.h"
#import "BRAppDelegate.h"
#import "BRSession.h"
#import "BRRestClient.h"
#import "ActionResult.h"
#import "BRTabManager.h"
#import "ProtagonistAnimal.h"
#import "Notifier.h"
#import "BattleViewController.h"
#import "NeedsEnergyViewController.h"
#import "NeedsMoneyViewController.h"
#import "Item.h"
#import "LeveledUpViewController.h"
#import "NeedsPosseViewController.h"
#import "OwnedItemTableViewContainerController.h"
#import "ItemReceivedViewController.h"
#import "PostJobActionViewController.h"
#import "TwitterOAuthLinkerViewController.h"

@implementation JobViewController
@synthesize jobsTableContainer;

- (id)init {
    if (self = [super init]) {
        self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Train" image:[UIImage imageNamed:@"tab_bar_jobs.png"] tag:1];
        JobTableViewController *jtvc = [[JobTableViewController alloc] init];
        jtvc.jobViewController = self;   
        jobsTableContainer = [[RDCContainerController alloc] initWithRemoteDataController:jtvc];
        [jtvc release];
		[[[BRSession sharedManager] protagonistAnimal] registerObserverToAllProperties:self];		
        [[BRSession sharedManager] registerObserverForProtagonistAnimal:self];
		self.title = @"Train";
    }
    return self;
}

// Implement loadView to create a view hierarchy programmatically, without using a nib.

- (CGFloat)loadViewAndRespondWithY { 
	self.view.backgroundColor = [UIColor blackColor];
    CGFloat y = [super loadViewAndRespondWithY];
    
    CGFloat height = FRAME_HEIGHT_WITH_ALL_BARS - y;
    debug_NSLog(@"y is fro load %f", height);    
    CGRect rect = CGRectMake(0, y, FRAME_WIDTH, height);

    [self.view addSubview:jobsTableContainer.view];      
    [jobsTableContainer setViewFrame:rect];
	
	UIBarButtonItem *myItems = [[UIBarButtonItem alloc] initWithTitle:@"My Items" 
																style:UIBarButtonItemStylePlain 
															   target:self 
															   action:@selector(equipmentButtonClicked)];
    self.navigationItem.leftBarButtonItem = myItems;
    [myItems release];
	
    return y;
}

- (void)equipmentButtonClicked {
	[[SoundManager sharedManager] playSoundWithType:@"popup" vibrate:NO];
    OwnedItemTableViewContainerController *stvcc = [[OwnedItemTableViewContainerController alloc] init];
    
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:stvcc];
    [stvcc release];
    
    [self presentModalViewController:nc animated:YES];
    [nc release];
}

- (void)attemptToDoJob:(Job *)job {

    ProtagonistAnimal *animal = [[BRSession sharedManager] protagonistAnimal];
    // locally check that we can do this action
    UIViewController *viewController = nil;
	if (job.requiresTwitter && ![[BRSession sharedManager] isTwitterUser]) {
		_chosenAlertView = ChosenAlertViewTwitterConnect;		
		[self alertWithTitle:@"Requires Twitter" message:@"You must link your account to Twitter to complete this job" 
					delegate:self cancelButtonTitle:@"Cancel" otherButtonTitle:@"Connect"];
		return;
	} else if (job.requiresFacebook && ![[BRSession sharedManager] isFacebookUser]) {
		_chosenAlertView = ChosenAlertViewFacebookConnect;		
		[self alertWithTitle:@"Requires Facebook" message:@"You must link your account to Facebook to complete this job" 
					delegate:self cancelButtonTitle:@"Cancel" otherButtonTitle:@"Connect"];		
		return;		
	} else if (animal.energy < job.requiresEnergy) {
        viewController = [[NeedsEnergyViewController alloc] init];
    } else if (animal.money < job.requiresMoney) {
        viewController = [[NeedsMoneyViewController alloc] init];    
    } else if (animal.posseSize < job.requiresPosse) {
        viewController = [[NeedsPosseViewController alloc] init];
    } /*else if ([job.requiresItems count] > 0 && [[animal equipment] hasDataLoaded]) {
        // check to see if the user has the needed items if equipment has already
        // loaded, otherwise let us get the response from the server
        for (Item *item in job.requiresItems) {
            Item *ownedItem = [[animal equipment] getItemInCollectionMatchingItem:item];
            int numNeeded = [[job.requiredItemCounts objectForKey:item.itemId] intValue];            
            if (ownedItem == nil || ownedItem.numOwned < numNeeded) {
                UIAlertView *requiresItems =
                    [[UIAlertView alloc] initWithTitle:@"Cannot Complete Job" 
                                               message:[NSString stringWithFormat:@"You need %d %@ to complete this job.", numNeeded, item.name]
                                              delegate:self 
                                     cancelButtonTitle:@"OK" 
                                     otherButtonTitles:@"Shop", nil];
                [requiresItems show];
                [requiresItems release];
                return;
            }
        }
    }*/
    
    if (viewController != nil) {
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];        
        [self presentModalViewController:navigationController animated:YES];
        [viewController release];
        [navigationController release];        
        return;
    }
    

    [[BRAppDelegate sharedManager] showLoadingOverlayWithText:@"Doing Job"];
    [[BRRestClient sharedManager] job_doJob:job.jobId target:self
            finishedSelector:@selector(finishedDoingJob:parsedResponse:) 
            failedSelector:@selector(failedDoingJob)];        
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
		if (_chosenAlertView == ChosenAlertViewTwitterConnect) {
			TwitterOAuthLinkerViewController *twitterLinker = [[TwitterOAuthLinkerViewController alloc] init];
			twitterLinker.delegate = self;
			[self presentModalViewControllerWithNavigationBar:twitterLinker];
			[twitterLinker release];
		} else if (_chosenAlertView == ChosenAlertViewFacebookConnect) {
			// TODO this is a hack, find a more elegant solution
			[[BRSession sharedManager] performSelector:@selector(resumeFacebookSession:) withObject:nil afterDelay:1.0];
//			[[BRSession sharedManager] resumeFacebookSession:nil];
		} else {
			[self equipmentButtonClicked];
		}
		_chosenAlertView = ChosenAlertViewNone;
    }
}

/**
 * 
 */

- (void)finishedDoingJob:(NSNumber *)responseCode 
        parsedResponse:(NSDictionary *)parsedResponse {
    if ([BRRestClient isResponseSuccessful:responseCode]) {
        [[BRAppDelegate sharedManager] hideLoadingOverlay];
        debug_NSLog(@"action resul succes");
        ActionResult *actionResult = 
            [[ActionResult alloc] initWithApiResponse:[parsedResponse objectForKey:@"action_result"]];
		ProtagonistAnimal *animal = [[BRSession sharedManager] protagonistAnimal];
		
        [animal updateWithActionResult:actionResult];
        
		if (actionResult.battleId == nil) {
			NSString *postJobHTML = [parsedResponse objectForKey:@"postJobHTML"];
		
			if ([Utility stringIfNotEmpty:postJobHTML]) {
				[[SoundManager sharedManager] playSoundWithType:@"pet" vibrate:NO];
				PostJobActionViewController *pjavc = [[PostJobActionViewController alloc] initWithHTML:postJobHTML];
				[self presentModalViewControllerWithNavigationBar:pjavc];
				[pjavc release];
			} else {
				[[BRAppDelegate sharedManager] showNotification:actionResult.formattedResponse 
													  withWidth:[actionResult.formattedResponseWidth floatValue]
													  andHeight:[actionResult.formattedResponseHeight floatValue]];
				if ([actionResult.level intValue] > 0) {
					// the user leveled up due to the job
					LeveledUpViewController *luvc = [[LeveledUpViewController alloc] initWithActionResult:actionResult];
					[self presentModalViewController:luvc animated:YES];
					[luvc release];
				} else if (actionResult.item) {
					ItemReceivedViewController *irvc = [[ItemReceivedViewController alloc] initWithItem:actionResult.item];
					[self presentModalViewController:irvc animated:YES];
					[irvc release];
				} else {
					// make noise only if no battle, no popup, and no item received
					[[SoundManager sharedManager] playSoundWithType:@"pet" vibrate:NO];
				}
			}
		} else {
			BattleViewController *battleViewController = 
            [[BattleViewController alloc] initWithOpponentAnimal:actionResult.newChallenger andBattleId:actionResult.battleId andInitialAction:nil];
			[self presentModalViewController:battleViewController animated:YES];
			[battleViewController release];			
		}
        
        [actionResult release];
        
        
    } else {
        [self failedDoingJobWithMessage:[parsedResponse objectForKey:@"response_message"]];
    }     
}

- (void)failedDoingJob {
    [self failedDoingJobWithMessage:@"Unknown Error"];
}

- (void)failedDoingJobWithMessage:(NSString *)message {
	[[BRAppDelegate sharedManager] hideLoadingOverlay];	        
    UIAlertView *failedToDoJob = 
    [[UIAlertView alloc] initWithTitle:@"Unable to do Job"
                               message:message
                              delegate:self 
                     cancelButtonTitle:@"OK" 
                     otherButtonTitles:nil];
    [failedToDoJob show];
    [failedToDoJob release];    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
}

#pragma mark TopLevelController methods
- (void)handleSelected {
    [jobsTableContainer.containedRDC loadInitialData:newLogin showLoadingOverlay:YES];
    newLogin = NO;
}
- (void)handleLogin {
	[super handleLogin];
    newLogin = YES;
}

- (void)handleLogout {}

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

#pragma mark TwitterOAuthLinkerDelegate
- (void)didFinishAttemptedLink:(BOOL)wasSuccessful {
	[self dismissTopMostModalViewControllerWithAnimation];	
}

- (void)dealloc {
    [jobsTableContainer release];
    [super dealloc];
}


@end
