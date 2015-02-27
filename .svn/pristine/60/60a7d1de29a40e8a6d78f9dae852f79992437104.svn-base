/**
 * ItemRemoteCollection.h
 * Copyright Miraphonic, Inc 2009. All rights reserved.
 *
 * @author Amit Matani 
 * @created 3/22/09.
 */


#import <Foundation/Foundation.h>
#import "AbstractRemoteCollectionStore.h"

@class Item;
@interface ItemRemoteCollection : AbstractRemoteCollectionStore {
    NSString *category;
}

@property (nonatomic, copy) NSString *category;

- (id)initWithKey:(NSString *)_category;
- (Item *)getItemMatchingItem:(Item *)item;
- (Item *)getItemWithId:(NSString *)itemId;


@end
