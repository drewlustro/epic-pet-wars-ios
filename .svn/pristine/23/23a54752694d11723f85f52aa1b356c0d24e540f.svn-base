/**
 * EarnedAchievementContainerController.m
 * Copyright Miraphonic, Inc 2009. All rights reserved.
 *
 * @author Amit Matani 
 * @created 2/13/09.
 */

#import "EarnedAchievementContainerController.h"
#import "EarnedAchievementRemoteCollection.h"
#import "EarnedAchievementsTableViewController.h"
#import "Animal.h"
#import "Consts.h"

@implementation EarnedAchievementContainerController


// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithAnimal:(Animal *)animal {
	EarnedAchievementRemoteCollection *earc = [[EarnedAchievementRemoteCollection alloc] initWithAnimalId:animal.animalId];
	EarnedAchievementsTableViewController *eatvc = [[EarnedAchievementsTableViewController alloc] initWithDataSource:earc];
	
    if (self = [super initWithRemoteDataController:eatvc]) {
		self.title = @"Achievements";
		[eatvc loadInitialData:NO showLoadingOverlay:YES];		
    }
	
	[earc release];
	[eatvc release];
    return self;
}

// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithAnimalId:(NSString *)animalId {
	EarnedAchievementRemoteCollection *earc = [[EarnedAchievementRemoteCollection alloc] initWithAnimalId:animalId];
	EarnedAchievementsTableViewController *eatvc = [[EarnedAchievementsTableViewController alloc] initWithDataSource:earc];
	
    if (self = [super initWithRemoteDataController:eatvc]) {
		self.title = @"Achievements";
		[eatvc loadInitialData:NO showLoadingOverlay:YES];		
    }
	
	[earc release];
	[eatvc release];
    return self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}


- (void)dealloc {
    [super dealloc];
}


@end
