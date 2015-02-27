/**
 * RewardRemoteCollection.m
 * Copyright Miraphonic, Inc 2009. All rights reserved.
 *
 * @author Amit Matani 
 * @created 2/3/09.
 */

#import "RewardRemoteCollection.h"
#import "BRRestClient.h"
#import "RewardOffer.h"

@implementation RewardRemoteCollection

- (id)init {
    if (self = [super initWithCollectionName:@"rewards" numObjectsPerLoad:0]) {
        
    }
    return self;
}

- (void)callRemoteCollectionLoadingMethodWithTarget:(id)target 
		finishedSelector:(SEL)finishedSelector failedSelector:(SEL)failedSelector  {
    [[BRRestClient sharedManager] reward_getOffersForToday:target finishedSelector:finishedSelector
								  failedSelector:failedSelector];
}

- (id)packageObjectForSaving:(id)object {
    RewardOffer *rewardOffer = [[RewardOffer alloc] initWithApiResponse:object];
    return rewardOffer;
}
@end
