/**
 * PosseAnimalRemoteCollection.m
 * Copyright Miraphonic, Inc 2009. All rights reserved.
 *
 * @author Amit Matani 
 * @created 2/9/09.
 */

#import "PosseAnimalRemoteCollection.h"
#import "Animal.h"
#import "BRRestClient.h"

@implementation PosseAnimalRemoteCollection

- (void)callRemoteCollectionLoadingMethodWithTarget:(id)target 
								   finishedSelector:(SEL)finishedSelector failedSelector:(SEL)failedSelector  {
    [[BRRestClient sharedManager] posse_getPosseAnimals:start limit:numRequestedObjectsPerLoad
												 target:target finishedSelector:finishedSelector
										 failedSelector:failedSelector];
}

- (void)callRemoteCollectionRemoveAtIndex:(id)object { 
    Animal *animal = (Animal *)object;
    [[BRRestClient sharedManager] posse_deleteLink:animal.userId target:self 
                                          finishedSelector:@selector(objectRemovedResponse:parsedResponse:)
                                            failedSelector:@selector(objectFailedRemoval)];
}

@end
