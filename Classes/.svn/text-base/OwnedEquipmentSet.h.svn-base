//
//  OwnedEquipmentSet.h
//  battleroyale
//
//  Created by Amit Matani on 3/22/09.
//  Copyright 2009 Miraphonic, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MutableEquipmentSet.h"

@interface OwnedEquipmentSet : MutableEquipmentSet {

}

- (id)initWithCategoryKeys:(NSArray *)categoryKeys categoryNames:(NSArray *)categoryNames;
- (void)decrementOwnedCountForItem:(Item *)item count:(NSInteger)count;
- (void)addItem:(Item *)item;
- (void)loadBattleItemsWithTarget:(id)target selector:(SEL)finishedSelector;
- (NSArray *)getLoadedBattleItems;
- (void)loadBattleItemsWithTarget:(id)target selector:(SEL)finishedSelector;
- (void)cancelBattleItemsLoadOnTarget:(id)target;
- (void)loadAllCollections;

@end
