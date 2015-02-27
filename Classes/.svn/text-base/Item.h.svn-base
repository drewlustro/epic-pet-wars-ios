/**
 * Item.m
 * Copyright Miraphonic, Inc 2009. All rights reserved.
 *
 * Item is a rest object that handles the item objects
 *
 * @author Amit Matani
 * @created 1/26/09
 */

#import <Foundation/Foundation.h>
#import "AbstractRestRequestedModel.h"

@interface Item : AbstractRestRequestedModel {
    NSString *itemId;
    NSString *name;
    NSString *details;
    NSString *category;
    NSString *categoryKey;    
    NSUInteger cost;
    NSUInteger sellPrice;
	NSString *imageSquare100, *imageSquare75, *imageSquare50, *imageSquare35, *imageSquare25;
	NSString *iphoneBackgroundImage, *iphoneBackgroundBattleImage;
    NSString *requiresLevel;
    NSInteger boostHp;
    NSInteger boostHpMax;
    NSInteger boostEnergy;
    NSInteger boostEnergyMax;
    NSInteger boostAtk;
    NSInteger boostDef;
    NSInteger boostMood;
    NSString *forageProbability;
    NSString *forageable;
    BOOL inShop, isUseableInBattle, isBattleOnly;
    NSUInteger numOwned;
    NSInteger cashFlow;
	
	NSDictionary *_extraProperties;
	NSUInteger _equipped;
}

@property (nonatomic, copy) NSString *itemId;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *details;
@property (nonatomic, copy) NSString *category;
@property (nonatomic, copy) NSString *categoryKey;
@property (nonatomic, assign) NSUInteger cost;
@property (nonatomic, assign) NSUInteger sellPrice;
@property (nonatomic, copy) NSString *iphoneBackgroundImage, *imageSquare100, *imageSquare75, *imageSquare50, *imageSquare35, *imageSquare25, *iphoneBackgroundBattleImage;
@property (nonatomic, copy) NSString *requiresLevel;
@property (nonatomic, assign) NSInteger boostHp;
@property (nonatomic, assign) NSInteger boostHpMax;
@property (nonatomic, assign) NSInteger boostEnergy;
@property (nonatomic, assign) NSInteger boostEnergyMax;
@property (nonatomic, assign) NSInteger boostAtk;
@property (nonatomic, assign) NSInteger boostDef;
@property (nonatomic, assign) NSInteger boostMood;
@property (nonatomic, copy) NSString *forageProbability;
@property (nonatomic, copy) NSString *forageable;
@property (nonatomic, assign) BOOL inShop, isUseableInBattle, isBattleOnly;
@property (nonatomic, assign) NSUInteger numOwned;       
@property (nonatomic, assign) NSInteger cashFlow;
@property (nonatomic, retain) NSDictionary *extraProperties;
@property (nonatomic, assign) NSUInteger equipped;

- (id)copyWithZone:(NSZone *)zone;
- (BOOL)isSameItem:(Item *)item;
- (NSString *)serializeToJavascriptArray;
@end
