//
//  MutableEquipmentSet.h
//  battleroyale
//
//  Created by Amit Matani on 1/8/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@class ItemRemoteCollection, Item;
@interface MutableEquipmentSet : NSObject {
	NSMutableArray *_collections;
	NSArray *_categoryKeys;
	NSArray *_categoryNames;
	Class _remoteCollectionClass;
}

@property (readonly) NSArray *categoryKeys, *categoryNames, *collections;

- (id)initWithItemRemoteCollectionClass:(Class)remoteCollectionClass;
- (id)initWithItemRemoteCollectionClass:(Class)remoteCollectionClass categoryKeys:(NSArray *)categoryKeys categoryNames:(NSArray *)categoryNames;
- (Item *)getItemInSetMatchingItem:(Item *)item;
- (Item *)getItemInSetWithId:(NSString *)itemId;
- (ItemRemoteCollection *)getRemoteCollectionForCategory:(NSString *)category;
- (void)reset;
- (void)resetWithNewCategoryKeys:(NSArray *)categoryKeys categoryNames:(NSArray *)categoryNames;

- (ItemRemoteCollection *)useable;
- (ItemRemoteCollection *)spell;

@end
