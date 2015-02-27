/**
 * EarnedAchievementRemoteCollection.m
 * Copyright Miraphonic, Inc 2009. All rights reserved.
 *
 * @author Amit Matani 
 * @created 2/5/09.
 */

#import "EarnedAchievementRemoteCollection.h"
#import "BRRestClient.h"

@implementation EarnedAchievementRemoteCollection


- (id)initWithAnimalId:(NSString *)_animalId {
	if (self = [super init]) {
		animalId = [_animalId copy];
	}
	return self;
}

- (void)callRemoteCollectionLoadingMethodWithTarget:(id)target 
		finishedSelector:(SEL)finishedSelector failedSelector:(SEL)failedSelector  {
    [[BRRestClient sharedManager] achievement_getEarnedAcievements:animalId
															 start:start 
								  limit:numRequestedObjectsPerLoad
								  target:self
								  finishedSelector:finishedSelector
								  failedSelector:failedSelector];
}

- (void)dealloc {
	[animalId release];
	[super dealloc];
}


@end
