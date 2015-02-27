//
//  EquipmentSet.m
//  battleroyale
//
//  Created by Amit Matani on 3/22/09.
//  Copyright 2009 Miraphonic, Inc. All rights reserved.
//

#import "MutableEquipmentSet.h"
#import "ItemRemoteCollection.h"
#import "Item.h"

@implementation MutableEquipmentSet
@synthesize categoryKeys = _categoryKeys, categoryNames = _categoryNames, collections = _collections;

- (void)setup {
	[_collections release];
	_collections = [[NSMutableArray alloc] initWithCapacity:[_categoryKeys count]];
	for (NSString *key in _categoryKeys) {
		id collection = [[_remoteCollectionClass alloc] initWithKey:key];
		[_collections addObject:collection];
		[collection release];
	}
}

- (id)initWithItemRemoteCollectionClass:(Class)remoteCollectionClass {
    if (self = [super init]) {
		_remoteCollectionClass = [remoteCollectionClass retain];
    }
    return self;	
}

- (id)initWithItemRemoteCollectionClass:(Class)remoteCollectionClass categoryKeys:(NSArray *)categoryKeys categoryNames:(NSArray *)categoryNames {
    if (self = [super init]) {
		_categoryKeys = [categoryKeys retain];
		_categoryNames = [categoryNames retain];
		_remoteCollectionClass = [remoteCollectionClass retain];
		[self setup];
    }
    return self;
}

- (Item *)getItemInSetMatchingItem:(Item *)item {
    ItemRemoteCollection *itemRC = [self getRemoteCollectionForCategory:item.categoryKey];
    
    return [itemRC getItemMatchingItem:item];
}

- (Item *)getItemInSetWithId:(NSString *)itemId {
	Item *item = nil;
	for (ItemRemoteCollection *collection in _collections) {
		item = [collection getItemWithId:itemId];
		if (item != nil) {
			break;
		}
	}
	return item;
}

- (ItemRemoteCollection *)getRemoteCollectionForCategory:(NSString *)category {
    NSInteger index = [_categoryKeys indexOfObject:category];
	if (index == NSNotFound) {
		return nil;
	}
	return [_collections objectAtIndex:index];
}

- (void)reset {
	for (ItemRemoteCollection *collection in _collections) {
		[collection resetCollection];
	}
}

- (void)resetWithNewCategoryKeys:(NSArray *)categoryKeys categoryNames:(NSArray *)categoryNames {
	_categoryKeys = [categoryKeys retain];
	_categoryNames = [categoryNames retain];
	[self setup];
}

- (ItemRemoteCollection *)useable {
	return [self getRemoteCollectionForCategory:@"useable"];	
}

- (ItemRemoteCollection *)spell {
	return [self getRemoteCollectionForCategory:@"spell"];
}

- (void)dealloc {
	[_categoryKeys release];
	[_categoryNames release];
	[_collections release];
	[_remoteCollectionClass release];
	
    [super dealloc];
}

@end
