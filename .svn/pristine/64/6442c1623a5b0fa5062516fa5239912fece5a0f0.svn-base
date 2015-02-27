/**
 * OwnedItemRemoteCollection.m
 * Copyright Miraphonic, Inc 2009. All rights reserved.
 *
 * @author Amit Matani 
 * @created 3/22/09.
 */

#import "OwnedItemRemoteCollection.h"
#import "BRRestClient.h"
#import "Item.h"
#import "BRSession.h"
#import "ProtagonistAnimal.h"


@implementation OwnedItemRemoteCollection

- (void)callRemoteCollectionLoadingMethodWithTarget:(id)target 
                                   finishedSelector:(SEL)finishedSelector failedSelector:(SEL)failedSelector  {
    [[BRRestClient sharedManager] item_getItemsForAnimalWithCategory:category start:start limit:numRequestedObjectsPerLoad
                                                           target:target finishedSelector:finishedSelector 
                                                   failedSelector:failedSelector];
}

// this will only work correctly if the equipment has all the objects loaded
- (void)decrementOwnedCountForItem:(Item *)item count:(NSInteger)count {
    [loadingLock lock];
    
    Item *matchingItem = nil;    
    int index = 0;
    
    for (Item *i in loadedObjects) {
        if ([i.itemId isEqualToString:item.itemId]) {
            matchingItem = i;
            break;
        }
        index += 1;
    }
    
    [loadingLock unlock];
    
    if (matchingItem) {
        matchingItem.numOwned -= count;
        if (matchingItem.numOwned <= 0) {
            [self removeObjectAtIndex:index];
        }
    }
}

// you are responsible to release this array
- (NSArray *)getBattleItems {
    NSMutableArray *battleItems = [[NSMutableArray alloc] initWithCapacity:5];
    [loadingLock lock];
	ProtagonistAnimal *animal = [[BRSession sharedManager] protagonistAnimal];
    for (Item *item in loadedObjects) {
        if (item.isUseableInBattle && [item.requiresLevel intValue] <= animal.level) {
            [battleItems addObject:item];
        }
    }
    
    [loadingLock unlock];
    
    return battleItems;
}



@end
