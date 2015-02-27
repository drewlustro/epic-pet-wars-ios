//
//  EquipmentSet.m
//  battleroyale
//
//  Created by Amit Matani on 3/22/09.
//  Copyright 2009 Miraphonic, Inc. All rights reserved.
//

#import "EquipmentSet.h"
#import "ItemRemoteCollection.h"
#import "Item.h"

@implementation EquipmentSet
@synthesize weapons, armor, accessories, backgrounds, investments, useable, spells;

- (id)initWithItemRemoteCollectionClass:(Class)remoteCollectionClass {
    if (self = [super init]) {
        useable = [[remoteCollectionClass alloc] initWithKey:@"useable"];
        spells = [[remoteCollectionClass alloc] initWithKey:@"spell"];
        weapons = [[remoteCollectionClass alloc] initWithKey:@"weapon"];
        armor = [[remoteCollectionClass alloc] initWithKey:@"armor"];
        accessories = [[remoteCollectionClass alloc] initWithKey:@"accessory"];
        backgrounds = [[remoteCollectionClass alloc] initWithKey:@"background"];
        investments = [[remoteCollectionClass alloc] initWithKey:@"investment"];        
    }
    return self;
}

- (Item *)getItemInSetMatchingItem:(Item *)item {
    ItemRemoteCollection *itemRC = [self getRemoteCollectionForCategory:item.categoryKey];
    
    return [itemRC getItemMatchingItem:item];
}
        
- (ItemRemoteCollection *)getRemoteCollectionForCategory:(NSString *)category {
    ItemRemoteCollection *itemRC;
    
    if ([category isEqualToString:@"weapon"]) {
        itemRC = weapons;
    } else if ([category isEqualToString:@"armor"]) {
        itemRC = armor;
    } else if ([category isEqualToString:@"useable"]) {
        itemRC = useable;
    } else if ([category isEqualToString:@"spell"]) {
        itemRC = spells;
    } else if ([category isEqualToString:@"accessory"]) {
        itemRC = accessories;
    } else if ([category isEqualToString:@"investment"]) {
        itemRC = investments;
    } else if ([category isEqualToString:@"background"]) {
        itemRC = backgrounds;
    }
    
    return itemRC;
}

- (void)reset {
    [weapons resetCollection];
    [armor resetCollection];
    [accessories resetCollection];
    [backgrounds resetCollection];
    [investments resetCollection];
    [useable resetCollection];
    [spells resetCollection];
}

- (void)dealloc {
    [useable release];    
    [weapons release];
    [armor release];
    [accessories release];
    [backgrounds release];
    [investments release];
    [spells release];
    
    [super dealloc];
}

@end
