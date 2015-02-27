/**
 * ItemRemoteCollection.m
 * Copyright Miraphonic, Inc 2009. All rights reserved.
 *
 * @author Amit Matani 
 * @created 3/22/09.
 */

#import "ItemRemoteCollection.h"
#import "Item.h"

@implementation ItemRemoteCollection
@synthesize category;

- (id)initWithKey:(NSString *)_category {
    if (self = [super initWithCollectionName:@"items" numObjectsPerLoad:0]) {
        self.category = _category;
    }
    return self;
}

- (void)callRemoteCollectionLoadingMethodWithTarget:(id)target 
		finishedSelector:(SEL)finishedSelector failedSelector:(SEL)failedSelector  {
    
}

- (id)packageObjectForSaving:(id)object {
    Item *item = [[Item alloc] initWithApiResponse:object];
    return item;
}

- (BOOL)insertObject:(id)object atIndex:(NSInteger)index {
    if (completedInitialLoad) {
        return [super insertObject:object atIndex:index];
    }
    return NO;
}

- (Item *)getItemWithId:(NSString *)itemId {
	Item *matchingItem = nil;
    [loadingLock lock];
    
    for (Item *i in loadedObjects) {
        if ([i.itemId isEqualToString:itemId]) {
            matchingItem = i;
            break;
        }
    }
    
    [loadingLock unlock];
    return matchingItem;
}

- (Item *)getItemMatchingItem:(Item *)item {
	return [self getItemWithId:item.itemId];
}

@end
