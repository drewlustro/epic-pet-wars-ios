/**
 * UserAnimalsTableContainerViewController.m
 * Copyright Miraphonic, Inc 2009. All rights reserved.
 *
 * @author Amit Matani 
 * @created 2/10/09.
 */
 
#import "UserAnimalsTableContainerViewController.h"
#import "UserAnimalsTableViewController.h"
#import "BRSession.h"
#import "ProtagonistAnimal.h"
#import "Animal.h"
#import "BRRestClient.h"
#import "BRAppDelegate.h"
#import "BRTabManager.h"
#import "AnimalTypeSelectionContainerController.h"
#import "BRGlobal.h"

@implementation UserAnimalsTableContainerViewController


- (id)init {
	UserAnimalsTableViewController *uatvc = [[UserAnimalsTableViewController alloc] init];
	if (self = [super initWithRemoteDataController:uatvc]) {
		self.title = @"Your Pets";
		[uatvc loadInitialData:YES showLoadingOverlay:YES];		
	}
	[uatvc release];	
	return self;
}

- (void)loadView {
	[super loadView];
    
    [self setButtonState];
	
	/** LOGO STYLED TOP NAVIGATION BAR **/
	UINavigationBar *navBar = self.navigationController.navigationBar;
	navBar.barStyle = UIBarStyleBlackOpaque;
	
	[self setViewFrame:CGRectMake(0, 0, FRAME_WIDTH, FRAME_HEIGHT_WITH_NAVIGATION_BAR)];
}

- (void)newPet {
	[[SoundManager sharedManager] playSoundWithType:@"popup" vibrate:NO];
    AnimalTypeSelectionContainerController *atscc = [[AnimalTypeSelectionContainerController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:atscc];
    [atscc.containedRDC loadInitialData:NO showLoadingOverlay:YES];
    [atscc release];
    [self presentModalViewController:nav animated:YES];
    [nav release];     
}

- (void)editPets {
    UITableView *tableView = ((AbstractRemoteDataTableController *)containedRDC).myTableView;
    tableView.editing = YES;
    [self setButtonState];
}

- (void)doneEditing {
    ((AbstractRemoteDataTableController *)containedRDC).myTableView.editing = NO;
    [self setButtonState];
}

- (void)setButtonState {
    UIBarButtonItem *rightButton;
    UIBarButtonItem *leftButton;    
    if (((AbstractRemoteDataTableController *)containedRDC).myTableView.editing) {
        rightButton = [[UIBarButtonItem alloc] initWithTitle:@"New Pet" style:UIBarButtonItemStyleBordered
                                                      target:self 
                                                      action:@selector(newPet)];
        leftButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone
                                                      target:self 
                                                      action:@selector(doneEditing)];        
    } else {
        rightButton = [[UIBarButtonItem alloc] initWithTitle:@"Edit Pets" style:UIBarButtonItemStyleBordered
                                        target:self 
                                        action:@selector(editPets)];
        
        leftButton = [[UIBarButtonItem alloc] initWithTitle:@"Close" style:UIBarButtonItemStyleBordered
                                                      target:self 
                                                      action:@selector(dismissTopMostModalViewControllerWithAnimationAndSound)];
    }
    
    self.navigationItem.leftBarButtonItem = leftButton;
    self.navigationItem.rightBarButtonItem = rightButton;    
}

- (void)switchToAnimal:(Animal *)animal {
	[[SoundManager sharedManager] playSoundWithType:@"pet" vibrate:NO];
	ProtagonistAnimal *protag = [[BRSession sharedManager] protagonistAnimal];
	if ([animal.animalId isEqualToString:protag.animalId]) { // same animal, just dismiss
		[self dismissTopMostModalViewControllerWithAnimation];
	} else {
		[[BRAppDelegate sharedManager] showLoadingOverlayWithText:@"Switching"];
		[[BRRestClient sharedManager] account_switchToAnimal:animal.animalId 
													  target:self 
											finishedSelector:@selector(finishedSwitching:parsedResponse:) 
											  failedSelector:@selector(failedSwitching)];
	}
}


- (void)finishedSwitching:(NSNumber *)responseInt parsedResponse:(NSDictionary *)parsedResponse {
	if ([BRRestClient isResponseSuccessful:responseInt]) {
		ProtagonistAnimal *protagonistAnimal = 
			[[ProtagonistAnimal alloc] initWithApiResponse:[parsedResponse objectForKey:@"animal"]];
		
		[[BRSession sharedManager] setProtagonistAnimal:protagonistAnimal];
		
		[protagonistAnimal release];
		
		[[[BRAppDelegate sharedManager] tabManager] login];
		
		[[BRAppDelegate sharedManager] hideLoadingOverlay];
		[[SoundManager sharedManager] playSoundWithType:@"close" vibrate:NO];
		[self dismissTopMostModalViewControllerWithAnimation];
	} else {
		[self failedSwitching];
	}
}

- (void)failedSwitching {
	[[BRAppDelegate sharedManager] hideLoadingOverlay];	
	// put something here
}

- (void)dealloc {
    [super dealloc];
}


@end
