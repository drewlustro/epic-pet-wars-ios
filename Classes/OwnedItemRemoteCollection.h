/**
 * OwnedItemRemoteCollection.h
 * Copyright Miraphonic, Inc 2009. All rights reserved.
 *
 * @author Amit Matani 
 * @created 3/22/09.
 */


#import <Foundation/Foundation.h>
#import "ItemRemoteCollection.h"

@interface OwnedItemRemoteCollection : ItemRemoteCollection {
    
}

- (void)decrementOwnedCountForItem:(Item *)item count:(NSInteger)count;
- (NSArray *)getBattleItems;

@end
