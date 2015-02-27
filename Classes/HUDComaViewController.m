/**
 * HUDComaViewController.m
 * Copyright Miraphonic, Inc 2009. All rights reserved.
 *
 * @author Amit Matani 
 * @created 2/4/09.
 */

#import "HUDComaViewController.h"
#import "BRSession.h"
#import "ProtagonistAnimal.h"
#import "ActionResult.h"
#import "BRRestClient.h"
#import "BRAppDelegate.h"
#import "BRTabManager.h"
#import "BattleMasterViewController.h"
#import "HUDViewController.h"

@implementation HUDComaViewController
@synthesize moneyLabel, respectPointsLabel, reviveTimerLabel, hospitalButton, battleMasterButton, 
			hudViewController = _hudViewController;


// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)init {
    if (self = [super initWithNibName:@"HUDComaView" bundle:[NSBundle mainBundle]]) {
        [[[BRSession sharedManager] protagonistAnimal] registerObserverToAllProperties:self];
        [[BRSession sharedManager] registerObserverForProtagonistAnimal:self];
    }
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object
						change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"protagonistAnimal"]) {
        [[[BRSession sharedManager] protagonistAnimal] registerObserverToAllProperties:self];
        [self reset];
        return;
    }
    ProtagonistAnimal *protagonistAnimal = [[BRSession sharedManager] protagonistAnimal]; 
	if ([keyPath isEqualToString:@"money"]) {
		moneyLabel.text = [NSString stringWithFormat:@"¥%d", protagonistAnimal.money];
	}
	if ([keyPath isEqualToString:@"respectPoints"]) {
        respectPointsLabel.text = [NSString stringWithFormat:@"%d", protagonistAnimal.respectPoints];        
	}
	if ([keyPath isEqualToString:@"timeLeftToRevive"]) {
        reviveTimerLabel.text = [NSString stringWithFormat:@"%d:%02d", 
                                    protagonistAnimal.timeLeftToRevive / 60, protagonistAnimal.timeLeftToRevive % 60];        
	}
	if ([keyPath isEqualToString:@"hospitalCost"]) {
		[hospitalButton setTitle:[NSString stringWithFormat:@"Revive For ¥%@", protagonistAnimal.hospitalCost]
						forState:UIControlStateNormal];
	}
	// TODO change to battle master
//	hospitalButton.enabled = protagonistAnimal.money >= [protagonistAnimal.hospitalCost intValue];
}

- (void)reset {
    ProtagonistAnimal *protagonistAnimal = [[BRSession sharedManager] protagonistAnimal]; 	
	reviveTimerLabel.text = [NSString stringWithFormat:@"%d", protagonistAnimal.timeLeftToRevive];        			
	moneyLabel.text = [NSString stringWithFormat:@"¥%d", protagonistAnimal.money];	
	respectPointsLabel.text = [NSString stringWithFormat:@"%d", protagonistAnimal.respectPoints];
	[hospitalButton setTitle:[NSString stringWithFormat:@"Revive For ¥%@", protagonistAnimal.hospitalCost]
					forState:UIControlStateNormal];
//	hospitalButton.enabled = protagonistAnimal.money >= [protagonistAnimal.hospitalCost intValue];	
}

- (void)hospitalButtonClicked {
	[[BRRestClient sharedManager] animal_useHosptial:self 
								  finishedSelector:@selector(finishedUsingHospital:parsedResponse:) 
								  failedSelector:@selector(failedUsingHospital)];
	[[BRAppDelegate sharedManager] showLoadingOverlayWithText:@"Reviving"];
}

- (void)battleMasterButtonClicked {
//    [[[BRAppDelegate sharedManager] tabManager] showBattleMaster]; 
//	BattleMasterViewController *bmvc = [[BattleMasterViewController alloc] init];
//	[self presentModalViewControllerWithNavigationBar:bmvc];
//	[bmvc release];		
	[_hudViewController respectButtonClicked];
}

- (void)finishedUsingHospital:(NSNumber *)responseInt parsedResponse:(NSDictionary *)parsedResponse {
	if ([BRRestClient isResponseSuccessful:responseInt]) {
		ActionResult *ar = [[ActionResult alloc] initWithApiResponse:[parsedResponse objectForKey:@"action_result"]];
		[[[BRSession sharedManager] protagonistAnimal] updateWithActionResult:ar];
		// TODO put an alert up for this shit
		[ar release];
		[[BRAppDelegate sharedManager] hideLoadingOverlay];		
		[[SoundManager sharedManager] playSoundWithType:@"powerup" vibrate:NO];
	} else {
		[self failedUsingHospital];
	}
}

- (void)failedUsingHospital {
	[[BRAppDelegate sharedManager] hideLoadingOverlay];
	// todo put an alert here
}

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	[hospitalButton addTarget:self action:@selector(hospitalButtonClicked) 
					forControlEvents:UIControlEventTouchUpInside];
    [battleMasterButton addTarget:self action:@selector(battleMasterButtonClicked) 
                 forControlEvents:UIControlEventTouchUpInside];
	[self reset];
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}

- (void)cleanup {
    [[[BRSession sharedManager] protagonistAnimal] unregisterObserver:self]; 
    [[BRSession sharedManager] removeObserver:self forKeyPath:@"protagonistAnimal"];    
}

- (void)dealloc {
    [moneyLabel release];
    [respectPointsLabel release];
    [reviveTimerLabel release];
    
    [hospitalButton release];
    [battleMasterButton release];
    
    [super dealloc];
}


@end
