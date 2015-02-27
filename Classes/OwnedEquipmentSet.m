//
//  OwnedEquipmentSet.m
//  battleroyale
//
//  Created by Amit Matani on 3/22/09.
//  Copyright 2009 Miraphonic, Inc. All rights reserved.
//

#import "OwnedEquipmentSet.h"
#import "OwnedItemRemoteCollection.h"
#import "Item.h"
#import "ItemRemoteCollection.h"
#import "BRSession.h"

@implementation OwnedEquipmentSet

- (id)initWithCategoryKeys:(NSArray *)categoryKeys categoryNames:(NSArray *)categoryNames {
    if (self = [super initWithItemRemoteCollectionClass:[OwnedItemRemoteCollection class] categoryKeys:categoryKeys categoryNames:categoryNames]) {
        
    }
    return self;
}

- (void)loadAllCollections {
	for (ItemRemoteCollection *collection in _collections) {
		[collection loadRemoteCollectionWithTarget:nil selector:nil];
	}
}

- (void)addItem:(Item *)item {
    ItemRemoteCollection *itemRC = [self getRemoteCollectionForCategory:item.categoryKey];
    [itemRC insertObject:item atIndex:0];
}

- (void)decrementOwnedCountForItem:(Item *)item count:(NSInteger)count {
    [(OwnedItemRemoteCollection *)[self getRemoteCollectionForCategory:item.categoryKey] decrementOwnedCountForItem:item count:count];
}

- (void)loadBattleItemsWithTarget:(id)target selector:(SEL)finishedSelector {
 	[[self getRemoteCollectionForCategory:@"useable"] loadRemoteCollectionWithTarget:target selector:finishedSelector];
}

- (void)cancelBattleItemsLoadOnTarget:(id)target {
    [[self getRemoteCollectionForCategory:@"useable"] cancelDelayedActionOnTarget:target];
}

- (NSArray *)getLoadedBattleItems {
    return [(OwnedItemRemoteCollection *)[self getRemoteCollectionForCategory:@"useable"] getBattleItems];
}

@end
