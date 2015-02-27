//
//  EquipmentSet.h
//  battleroyale
//
//  Created by Amit Matani on 3/22/09.
//  Copyright 2009 Miraphonic, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ItemRemoteCollection, Item;
@interface EquipmentSet : NSObject {
    ItemRemoteCollection *weapons, *armor, *accessories, 
                         *backgrounds, *investments, *useable,
                         *spells;
}

@property (nonatomic, readonly) ItemRemoteCollection *weapons, *armor, *accessories, 
                                                     *backgrounds, *investments, *useable, *spells;

- (id)initWithItemRemoteCollectionClass:(Class)remoteCollectionClass;
- (Item *)getItemInSetMatchingItem:(Item *)item;
- (ItemRemoteCollection *)getRemoteCollectionForCategory:(NSString *)category;
- (void)reset;

@end
