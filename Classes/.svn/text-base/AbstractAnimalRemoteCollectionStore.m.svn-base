/**
 * AbstractAnimalRemoteCollectionStore.m
 * Copyright Miraphonic, Inc 2009. All rights reserved.
 *
 * @author Amit Matani 
 * @created 3/10/09.
 */

#import "AbstractAnimalRemoteCollectionStore.h"
#import "Animal.h"

@implementation AbstractAnimalRemoteCollectionStore

- (id)init {
    if (self = [super initWithCollectionName:@"animals" numObjectsPerLoad:10]) {
        
    }
    return self;
}

- (id)packageObjectForSaving:(id)object {
    Animal *animal = [[Animal alloc] initWithApiResponse:object];
    return animal;
}


@end
