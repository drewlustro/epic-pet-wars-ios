/**
 * AnimalTypeRemoteCollection.m
 * Copyright Miraphonic, Inc 2009. All rights reserved.
 *
 * AnimalTypeRemoteCollection is a subclass of AbstractRemoteCollection store.
 * It handles the management of the animal_types collection
 *
 * @author Amit Matani
 * @created 1/15/09
 */


#import "AnimalTypeRemoteCollection.h"
#import "BRRestClient.h"
#import "AnimalType.h"

@implementation AnimalTypeRemoteCollection

- (id)init {
    if (self = [super initWithCollectionName:@"animal_types" numObjectsPerLoad:0]) {
        
    }
    return self;
}

- (void)callRemoteCollectionLoadingMethodWithTarget:(id)target 
		finishedSelector:(SEL)finishedSelector failedSelector:(SEL)failedSelector  {
    [[BRRestClient sharedManager] account_getAvailablePlayerTypes:start limit:numRequestedObjectsPerLoad
								   target:target finishedSelector:finishedSelector
												 failedSelector:failedSelector];
}

- (id)packageObjectForSaving:(id)object {
    AnimalType *animalType = [[AnimalType alloc] initWithApiResponse:object];
    return animalType;
}

@end
