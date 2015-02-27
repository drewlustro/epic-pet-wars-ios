/**
 * AnimalTypeSelectionContainerController.m
 * Copyright Miraphonic, Inc 2009. All rights reserved.
 *
 * @author Amit Matani 
 * @created 2/11/09.
 */

#import "AnimalTypeSelectionContainerController.h"
#import "BRSession.h"
#import "ProtagonistAnimal.h"
#import "AnimalTypeSelectionController.h"
#import "BRGlobal.h"

@implementation AnimalTypeSelectionContainerController

- (id)init {
    AnimalTypeSelectionController *atsc = [[AnimalTypeSelectionController alloc] init]; 	
	if (self = [super initWithRemoteDataController:atsc]) {
		self.title = @"Choose Type";
	}
	[atsc release];
	return self;
}
- (void)loadView {
	[super loadView];
	// if we already have a protagonist animal the user should be able to cancel
	// this screen
	if ([[BRSession sharedManager] protagonistAnimal] != nil) {
		UIBarButtonItem *cancelButton = 
		[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
													  target:self 
													  action:@selector(dismissTopMostModalViewControllerWithAnimation)];
		self.navigationItem.leftBarButtonItem = cancelButton;
		[cancelButton release];		
	} else {
		self.navigationItem.leftBarButtonItem = nil;
	}
	
	[self setViewFrame:CGRectMake(0, 0, FRAME_WIDTH, FRAME_HEIGHT_WITH_NAVIGATION_BAR)];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}


- (void)dealloc {
    [super dealloc];
}


@end
