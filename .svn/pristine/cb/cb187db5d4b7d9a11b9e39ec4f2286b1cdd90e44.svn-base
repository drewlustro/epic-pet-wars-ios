/**
 * ShopItemRemoteCollection.m
 * Copyright Miraphonic, Inc 2009. All rights reserved.
 *
 * @author Amit Matani 
 * @created 3/22/09.
 */

#import "ShopItemRemoteCollection.h"
#import "BRRestClient.h"
#import "BRSession.h"
#import "ProtagonistAnimal.h"
#import "OwnedEquipmentSet.h"

@implementation ShopItemRemoteCollection

- (void)callRemoteCollectionLoadingMethodWithTarget:(id)target 
		finishedSelector:(SEL)finishedSelector failedSelector:(SEL)failedSelector  {
    ItemRemoteCollection *rc = [[[[BRSession sharedManager] protagonistAnimal] equipment] getRemoteCollectionForCategory:category];
    if (rc != nil) {
        // todo, since we know we never dealloc this remote collection we do not have to
        // worry about calling cleanup on the remote collection if the shopitemrc is released
        [rc loadRemoteCollectionWithTarget:self selector:@selector(callDelayedLoad)];
    } else {
        [self callDelayedLoad];
    }
}

- (void)callDelayedLoad {
    [[BRRestClient sharedManager] item_getItemsInShopWithCategory:category start:start limit:0 target:self
                                                 finishedSelector:@selector(handleFinishedLoadingCollection:parsedResponse:)
                                                   failedSelector:@selector(handleFailedLoadingCollection)];     
}

- (id)packageObjectForSaving:(id)object {
	Item *item = [super packageObjectForSaving:object];
	
	// we need to double check that we have not seen this object already in the owned set
    ItemRemoteCollection *rc = [[[[BRSession sharedManager] protagonistAnimal] equipment] getRemoteCollectionForCategory:category];
	Item *ownedItem = [rc getItemMatchingItem:item];
	
	if (ownedItem != nil) {
		[ownedItem retain];
		[item release];
		return ownedItem;
	} else {
		return item;
	}
}



@end
