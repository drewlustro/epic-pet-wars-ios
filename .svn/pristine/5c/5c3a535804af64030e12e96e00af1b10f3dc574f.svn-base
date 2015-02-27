//
//  ProtagonistAnimalItemManager.m
//  battleroyale
//
//  Created by amit on 1/9/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ProtagonistAnimalItemManager.h"
#import "ProtagonistAnimal.h"
#import "ActionResult.h"
#import "Item.h"
#import "BRRestClient.h"
#import "SoundManager.h"
#import "OwnedEquipmentSet.h"
#import "BRSession.h"
#import "ItemRemoteCollection.h"

@implementation ProtagonistAnimalItemManager

@synthesize delegate = _delegate;

- (id)initWithProtagonistAnimal:(ProtagonistAnimal *)animal {
	if (self = [super init]) {
		_animal = animal;
	}
	return self;
}

- (BOOL)isUsingItem {
	return _activeItem && _delayedItemId;
}
- (void)failedAction:(NSString *)message selector:(SEL)selector {
	if ([_delegate respondsToSelector:selector]) {
		[_delegate performSelector:selector withObject:_activeItem withObject:message];
	}
	[_activeItem release];
	_activeItem = nil;
}

- (void)handleResponse:(NSDictionary *)parsedResponse success:(SEL)success{
	ActionResult *actionResult = 
		[[ActionResult alloc] initWithApiResponse:[parsedResponse objectForKey:@"action_result"]];
    [_animal updateWithActionResult:actionResult];
	
	if ([_delegate respondsToSelector:success]) {
		[_delegate performSelector:success withObject:_activeItem withObject:actionResult];
	}
	
	[actionResult release];
	
	[_activeItem release];
	_activeItem = nil;
}

#pragma mark Purchase
- (BOOL)purchaseItem:(Item *)item amount:(NSInteger)amount {
    if ([self isUsingItem]) { return NO; }
	_activeItem = [item retain];
	
    _numItemsPurchasingOrSelling = amount;
	
    [[BRRestClient sharedManager] item_buyItem:_activeItem.itemId amount:amount target:self 
                              finishedSelector:@selector(finishedPurchase:parsedResponse:)
                                failedSelector:@selector(failedPurchase)];
	return YES;
}

- (void)finishedPurchase:(NSNumber *)responseInt parsedResponse:(NSDictionary *)parsedResponse {
    if (![BRRestClient isResponseSuccessful:responseInt]) {
		[self failedAction:[parsedResponse objectForKey:@"response_message"] selector:@selector(failedToPurchaseItem:message:)];
        return;
    }
	
	[self incrementNumOwnedCount:_numItemsPurchasingOrSelling];
	
	[self handleResponse:parsedResponse success:@selector(purchasedItem:result:)];
}


- (void)failedPurchase {
	[self failedAction:@"Unknown Error" selector:@selector(failedToPurchaseItem:message:)];
}

#pragma mark Item Sale
- (BOOL)sellItem:(Item *)item amount:(NSInteger)amount {
    if (_activeItem) { return NO; }
	_activeItem = [item retain];
	
    _numItemsPurchasingOrSelling = amount;
	
    [[BRRestClient sharedManager] item_sellItem:_activeItem.itemId amount:amount target:self 
                              finishedSelector:@selector(finishedSale:parsedResponse:)
                                failedSelector:@selector(failedSale)];
	return YES;
}

- (void)finishedSale:(NSNumber *)responseInt parsedResponse:(NSDictionary *)parsedResponse {
    if (![BRRestClient isResponseSuccessful:responseInt]) {
		[self failedAction:[parsedResponse objectForKey:@"response_message"] selector:@selector(failedToSellItem:message:)];
        return;
    }
	
	[self decrementOwnedCount:_numItemsPurchasingOrSelling];
	
	[self handleResponse:parsedResponse success:@selector(soldItem:result:)];
}


- (void)failedSale {
	[self failedAction:@"Unknown Error" selector:@selector(failedToSellItem:message:)];
}

- (BOOL)callDelayedLoad:(NSString *)itemId categoryKey:(NSString *)categoryKey delayedSelector:(SEL)delayedSelector {
    if ([self isUsingItem]) { return NO; }
    ItemRemoteCollection *rc = [[_animal equipment] getRemoteCollectionForCategory:categoryKey];
	_delayedItemId = [itemId copy];
	_delayedCategoryKey = [categoryKey copy];
	if (rc != nil) {
        [rc loadRemoteCollectionWithTarget:self selector:delayedSelector];
		return YES;
	}
	return NO;	
}

- (Item *)getDelayedItem {
	ItemRemoteCollection *rc = [[_animal equipment] getRemoteCollectionForCategory:_delayedCategoryKey];
	Item *item = [rc getItemWithId:_delayedItemId];
	[_delayedItemId release];
	[_delayedCategoryKey release];
	_delayedItemId = nil;
	_delayedCategoryKey = nil;
	
	return item;
}

#pragma mark Item usage
- (BOOL)useItem:(Item *)item {
    if (item.numOwned <= 0 || [self isUsingItem]) { return NO; }
	_activeItem = [item retain];
	
    [[BRRestClient sharedManager] item_useItem:_activeItem.itemId
										target:self 
							  finishedSelector:@selector(finishedUsing:parsedResponse:) 
								failedSelector:@selector(failedUsing)]; 
	return YES;
}

- (void)delayedUseItem {
	Item *item = [self getDelayedItem];
	if (![self useItem:item]) {
		[self failedAction:@"You do not own this Item" selector:@selector(failedToUseItem:message:)];
	}
}

- (BOOL)useItemWithId:(NSString *)itemId categoryKey:(NSString *)categoryKey {
	return [self callDelayedLoad:itemId categoryKey:categoryKey delayedSelector:@selector(delayedUseItem)];
}

- (void)finishedUsing:(NSNumber *)responseInt parsedResponse:(NSDictionary *)parsedResponse {
    if (![BRRestClient isResponseSuccessful:responseInt]) {
		[self failedAction:[parsedResponse objectForKey:@"response_message"] selector:@selector(failedToUseItem:message:)];
        return;
    }
	
	[self decrementOwnedCount:1];
	
	[self handleResponse:parsedResponse success:@selector(usedItem:result:)];
}

- (void)failedUsing {
	[self failedAction:@"Unknown Error" selector:@selector(failedToUseItem:message:)];
}


#pragma mark Item Equip
- (BOOL)equipItem:(Item *)item slot:(NSInteger)slot {
	if (item.numOwned <= 0 || [self isUsingItem]) { return NO; }
	_activeItem = [item retain];
	_slot = slot;
	
    [[BRRestClient sharedManager] item_equipItem:_activeItem.itemId slot:_slot
										  target:self 
								finishedSelector:@selector(finishedEquiping:parsedResponse:) 
								  failedSelector:@selector(failedEquiping)];
	return YES;
}

- (void)delayedEquipItem {
	Item *item = [self getDelayedItem];
	
	if (![self equipItem:item slot:_delayedEquipSlot]) {
		[self failedAction:@"You do not own this Item" selector:@selector(failedToEquipItem:message:)];
	}
}

- (BOOL)equipItemWithId:(NSString *)itemId categoryKey:(NSString *)categoryKey slot:(NSInteger)slot {
	if ([self callDelayedLoad:itemId categoryKey:categoryKey delayedSelector:@selector(delayedEquipItem)]) {
		_delayedEquipSlot = slot;
		return YES;
	}
	
	return NO;
}

- (void)finishedEquiping:(NSNumber *)responseCode 
		  parsedResponse:(NSDictionary *)parsedResponse {
    if (![BRRestClient isResponseSuccessful:responseCode]) {
		[self failedAction:[parsedResponse objectForKey:@"response_message"] selector:@selector(failedToEquipItem:message:)];
        return;
    }
	
	NSString *slot;
	
	if ([_activeItem.categoryKey isEqualToString:@"accessory"]) {
		NSInteger otherSlot = _slot == 0 ? 1 : 0;
		if (_activeItem.numOwned == 1 && [_animal isEquiped:_activeItem inSlot:otherSlot]) {
			[_animal equipItem:nil inPosition:(otherSlot == 0) ? @"accessory1" : @"accessory2"];
		}
		slot = _slot == 0 ? @"accessory1" : @"accessory2";
	} else {
		slot = _activeItem.categoryKey;
	}
	
	[_animal equipItem:_activeItem inPosition:slot];
    
    ActionResult *actionResult = [[ActionResult alloc] initWithApiResponse:[parsedResponse objectForKey:@"action_result"]];
	[_animal updateWithActionResult:actionResult];
	// TODO use the action result
	if ([_delegate respondsToSelector:@selector(equippedItem:slot:result:)]) {
		[_delegate equippedItem:_activeItem slot:_slot result:actionResult];
	}
	
    [actionResult release];
	[_activeItem release];
	_activeItem = nil;
}

- (void)failedEquiping {
	[self failedAction:@"Unknown Error" selector:@selector(failedToEquipItem:message:)];
}

#pragma mark Item Unequip
- (BOOL)unequipItem:(Item *)item slot:(NSInteger)slot {
	if (item.numOwned <= 0 || [self isUsingItem]) { return NO; }
	_activeItem = [item retain];
	_slot = slot;
	
    [[BRRestClient sharedManager] item_unequipItem:_activeItem.itemId 
											  slot:0 target:self 
								  finishedSelector:@selector(finishedUnequiping:parsedResponse:) 
									failedSelector:@selector(failedUnequiping)];
	return YES;
}

- (void)delayedUnequipItem {
	Item *item = [self getDelayedItem];
	
	if (![self unequipItem:item slot:_delayedEquipSlot]) {
		[self failedAction:@"You do not own this Item" selector:@selector(failedToUnequipItem:message:)];
	}
}

- (BOOL)unequipItemWithId:(NSString *)itemId categoryKey:(NSString *)categoryKey slot:(NSInteger)slot {
	if ([self callDelayedLoad:itemId categoryKey:categoryKey delayedSelector:@selector(delayedUnequipItem)]) {
		_delayedEquipSlot = slot;
		return YES;
	}
	
	return NO;
}

- (void)finishedUnequiping:(NSNumber *)responseCode parsedResponse:(NSDictionary *)parsedResponse {
    if (![BRRestClient isResponseSuccessful:responseCode]) {
		[self failedAction:[parsedResponse objectForKey:@"response_message"] selector:@selector(failedToUnequipItem:message:)];
        return;
    }
	// TODO switch this to slot
	NSString *slot;
	
	if ([_activeItem.categoryKey isEqualToString:@"accessory"]) {
		slot = _slot == 0 ? @"accessory1" : @"accessory2";
	} else {
		slot = _activeItem.categoryKey;
	}
	
	[_animal equipItem:nil inPosition:slot];
	
    ActionResult *actionResult = [[ActionResult alloc] initWithApiResponse:[parsedResponse objectForKey:@"action_result"]];    
	[_animal updateWithActionResult:actionResult];
	// TODO use the action result
	if ([_delegate respondsToSelector:@selector(unequippedItem:slot:result:)]) {
		[_delegate unequippedItem:_activeItem slot:_slot result:actionResult];
	}
	
    [actionResult release];
	[_activeItem release];
	_activeItem = nil;
}

- (void)failedUnequiping {
	[self failedAction:@"Unknown Error" selector:@selector(failedToUnequipItem:message:)];
}


#pragma mark Item count
- (void)incrementNumOwnedCount:(NSInteger)count {
	if (_activeItem == nil) { return; }
	if (_activeItem.numOwned <= 0) {
        [[_animal equipment] addItem:_activeItem];
    }
    _activeItem.numOwned += count;
}

- (void)decrementOwnedCount:(NSInteger)count {
	if (_activeItem == nil) { return; }	
	[_animal.equipment decrementOwnedCountForItem:_activeItem count:count];
    
    if (_activeItem.numOwned == 1 && [_activeItem.categoryKey isEqualToString:@"accessory"] && 
        [_animal numEquiped:_activeItem] > 1) {
        // since the item is equiped in both slots we can just
        // unequip one slot
        [_animal equipItem:nil inPosition:@"accessory2"]; 
    }
    
    if (_activeItem.numOwned == 0) {
        Item *tempItem = [_activeItem copy];
        [_activeItem release];
        _activeItem = tempItem;
        
        NSString *key = nil;
        int numEquiped = [_animal numEquiped:_activeItem];
        if (numEquiped > 0) {
            if ([_activeItem.categoryKey isEqualToString:@"accessory"]) {
                if (numEquiped > 1) {
                    [_animal equipItem:nil inPosition:@"accessory1"];
                    [_animal equipItem:nil inPosition:@"accessory2"];
                } else {
                    key = [_animal isEquiped:_activeItem inSlot:0] ? @"accessory1" : @"accessory2";
                }
            } else {
                key = _activeItem.categoryKey;
            }
        }
        if (key != nil) {
            [_animal equipItem:nil inPosition:key];
        }
    }	
}

- (void)dealloc {
	[_delayedCategoryKey release];
	[_delayedItemId release];
	[_activeItem release];
	[super dealloc];
}

@end
