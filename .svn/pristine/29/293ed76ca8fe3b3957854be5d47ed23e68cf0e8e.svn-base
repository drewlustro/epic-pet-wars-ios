//
//  ProtagonistAnimalItemManager.h
//  battleroyale
//
//  Created by amit on 1/9/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ProtagonistAnimal, Item, ActionResult;

@protocol ProtagonistAnimalItemManagerDelegate <NSObject>

@optional

- (void)usedItem:(Item *)item result:(ActionResult *)actionResult;
- (void)failedToUseItem:(Item *)item message:(NSString *)message;

- (void)equippedItem:(Item *)item slot:(NSInteger)slot result:(ActionResult *)actionResult;
- (void)failedToEquipItem:(Item *)item message:(NSString *)message;

- (void)unequippedItem:(Item *)item slot:(NSInteger)slot result:(ActionResult *)actionResult;
- (void)failedToUnequipItem:(Item *)item message:(NSString *)message;

- (void)purchasedItem:(Item *)item result:(ActionResult *)actionResult;
- (void)failedToPurchaseItem:(Item *)item message:(NSString *)message;

- (void)soldItem:(Item *)item result:(ActionResult *)actionResult;
- (void)failedToSellItem:(Item *)item message:(NSString *)message;

@end

@interface ProtagonistAnimalItemManager : NSObject {
	ProtagonistAnimal *_animal;
	id<ProtagonistAnimalItemManagerDelegate> _delegate;
	Item *_activeItem;
	NSInteger _numItemsPurchasingOrSelling, _slot;
	NSString *_delayedItemId, *_delayedCategoryKey;
	NSInteger _delayedEquipSlot;
}

@property (nonatomic, assign) id<ProtagonistAnimalItemManagerDelegate> delegate;

- (id)initWithProtagonistAnimal:(ProtagonistAnimal *)animal;

- (BOOL)purchaseItem:(Item *)item amount:(NSInteger)amount;
- (BOOL)sellItem:(Item *)item amount:(NSInteger)amount;

- (BOOL)useItem:(Item *)item;
- (BOOL)useItemWithId:(NSString *)itemId categoryKey:(NSString *)categoryKey;

- (BOOL)equipItem:(Item *)item slot:(NSInteger)slot;
- (BOOL)equipItemWithId:(NSString *)itemId categoryKey:(NSString *)categoryKey slot:(NSInteger)slot;
- (BOOL)unequipItem:(Item *)item slot:(NSInteger)slot;
- (BOOL)unequipItemWithId:(NSString *)itemId categoryKey:(NSString *)categoryKey slot:(NSInteger)slot;

- (void)incrementNumOwnedCount:(NSInteger)count;
- (void)decrementOwnedCount:(NSInteger)count;

@end
