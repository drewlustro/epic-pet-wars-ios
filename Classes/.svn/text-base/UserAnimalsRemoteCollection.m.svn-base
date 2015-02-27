/**
 * UserAnimalsRemoteCollection.m
 * Copyright Miraphonic, Inc 2009. All rights reserved.
 *
 * @author Amit Matani 
 * @created 2/10/09.
 */

#import "UserAnimalsRemoteCollection.h"
#import "Animal.h"
#import "BRRestClient.h"

@implementation UserAnimalsRemoteCollection

- (id)init {
    if (self = [super initWithCollectionName:@"animals" numObjectsPerLoad:10]) {
        
    }
    return self;
}

- (void)callRemoteCollectionLoadingMethodWithTarget:(id)target 
								   finishedSelector:(SEL)finishedSelector 
									 failedSelector:(SEL)failedSelector  {
    [[BRRestClient sharedManager] account_getUserAnimals:start limit:numRequestedObjectsPerLoad 
                                                  target:target
                                        finishedSelector:finishedSelector
										 failedSelector:failedSelector];
}

- (id)packageObjectForSaving:(id)object {
    Animal *animal = [[Animal alloc] initWithApiResponse:object];
    return animal;
}

- (void)callRemoteCollectionRemoveAtIndex:(id)object { 
    NSString *animalId = ((Animal *)object).animalId;
    [[BRRestClient sharedManager] account_deactivateAnimal:animalId target:self 
                                          finishedSelector:@selector(objectRemovedResponse:parsedResponse:)
                                            failedSelector:@selector(objectFailedRemoval)];
}

@end
