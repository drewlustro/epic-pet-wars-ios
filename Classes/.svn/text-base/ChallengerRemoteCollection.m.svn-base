/**
 * ChallengerRemoteCollection.m
 * Copyright Miraphonic, Inc 2009. All rights reserved.
 *
 * @author Amit Matani 
 * @created 2/1/09.
 */

#import "ChallengerRemoteCollection.h"
#import "Challenger.h"
#import "BRRestClient.h"

@implementation ChallengerRemoteCollection

- (id)init {
    if (self = [super initWithCollectionName:@"challengers" numObjectsPerLoad:10]) {
        
    }
    return self;
}

- (void)callRemoteCollectionLoadingMethodWithTarget:(id)target 
								   finishedSelector:(SEL)finishedSelector failedSelector:(SEL)failedSelector  {
    [[BRRestClient sharedManager] battle_getAvailableChallengers:target 
								  finishedSelector:finishedSelector
								  failedSelector:failedSelector];
}

- (id)packageObjectForSaving:(id)object {
	Challenger *challenger = [[Challenger alloc] initWithApiResponse:object];
    return challenger;
}


@end
