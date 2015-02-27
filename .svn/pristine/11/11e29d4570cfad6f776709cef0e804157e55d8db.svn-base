/**
 * AchievementRemoteCollection.m
 * Copyright Miraphonic, Inc 2009. All rights reserved.
 *
 * @author Amit Matani 
 * @created 2/4/09.
 */

#import "AchievementRemoteCollection.h"
#import "BRRestClient.h"
#import	"Achievement.h"

@implementation AchievementRemoteCollection

- (id)init {
    if (self = [super initWithCollectionName:@"achievements" numObjectsPerLoad:20]) {
        
    }
    return self;
}

- (void)callRemoteCollectionLoadingMethodWithTarget:(id)target 
		finishedSelector:(SEL)finishedSelector failedSelector:(SEL)failedSelector  {
    [[BRRestClient sharedManager] achievement_getAvailableAcievements:start 
								  limit:numRequestedObjectsPerLoad
								  target:self
								  finishedSelector:finishedSelector
								  failedSelector:failedSelector];
}

- (id)packageObjectForSaving:(id)object {
	Achievement *achievement = [[Achievement alloc] initWithApiResponse:object];
    return achievement;
}

@end
