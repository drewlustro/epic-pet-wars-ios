/**
 * Item.m
 * Copyright Miraphonic, Inc 2009. All rights reserved.
 *
 * Item is a rest object that handles the item objects
 *
 * @author Amit Matani
 * @created 1/26/09
 */
 
#import "Item.h"
#import "Consts.h"

@implementation Item
@synthesize itemId, name, details, category, cost, sellPrice, 
            requiresLevel, boostHp, boostHpMax, boostEnergy, boostEnergyMax, 
            boostAtk, boostDef, boostMood, forageProbability, forageable, inShop, numOwned,
            categoryKey, isUseableInBattle, isBattleOnly, equipped = _equipped,
			// images 
			imageSquare100, imageSquare75, imageSquare50, imageSquare35,
			imageSquare25, iphoneBackgroundImage, cashFlow, extraProperties = _extraProperties,
			iphoneBackgroundBattleImage;

static NSDictionary *fieldMap;

+ (void)initialize {
    if (self = [Item class]) {
        fieldMap = [[NSDictionary alloc] initWithObjectsAndKeys:
                        @"setItemId:", @"id",
                        @"setName:", @"name",
                        @"setDetails:", @"details",
                        @"setCategory:", @"category",
                        @"setCategoryKey:", @"category_key",                        
                        @"setCostWithString:", @"cost",
                        @"setSellPriceWithString:", @"sell_price",                        
						@"setImageSquare100:", @"image_square_100",
						@"setImageSquare75:", @"image_square_75",
						@"setImageSquare50:", @"image_square_50",
						@"setImageSquare35:", @"image_square_35",
						@"setImageSquare25:", @"image_square_25",
                        @"setRequiresLevel:", @"requires_level",
                        @"setBoostHpWithString:", @"boost_hp",
                        @"setBoostHpMaxWithString:", @"boost_hp_max",
                        @"setBoostEnergyWithString:", @"boost_energy",
                        @"setBoostEnergyMaxWithString:", @"boost_energy_max",
                        @"setBoostAtkWithString:", @"boost_atk",
                        @"setBoostDefWithString:", @"boost_def",
                        @"setBoostMoodWithString:", @"boost_mood",
                        @"setForageProbability:", @"forage_probability",
                        @"setForageable:", @"forageable",
                        @"setInShopWithString:", @"in_shop",
                        @"setNumOwnedWithString:", @"num_owned",
						@"setIsUseableInBattleWithString:", @"useable_in_battle",
						@"setIsBattleOnlyWithString:", @"battle_only",
						@"setIphoneBackgroundImage:", @"iphone_background_image",
						@"setIphoneBackgroundBattleImage:", @"iphone_background_battle_image",
                        @"setCashFlowWithString:", @"cash_flow",
						@"setExtraProperties:", @"extra_properties",
                        nil
                    ];
    }
}


+ (NSDictionary *)GetFieldMapHelper {
    return fieldMap;
}

- (id)copyWithZone:(NSZone *)zone {
    Item *copy = [[[self class] allocWithZone:zone] init];
    copy.itemId = self.itemId;
    copy.name = self.name;
    copy.details = self.details;
    copy.category = self.category;
    copy.cost = self.cost;
    copy.sellPrice = self.sellPrice;
	copy.imageSquare100 = self.imageSquare100;
	copy.imageSquare75 = self.imageSquare75;
	copy.imageSquare50 = self.imageSquare50;
	copy.imageSquare35 = self.imageSquare35;
	copy.imageSquare25 = self.imageSquare25;
    copy.requiresLevel = self.requiresLevel;
    copy.boostHp = self.boostHp;
    copy.boostHpMax = self.boostHpMax;
    copy.boostEnergy = self.boostEnergy;
    copy.boostEnergyMax = self.boostEnergyMax;
    copy.boostAtk = self.boostAtk;
    copy.boostDef = self.boostDef;
    copy.boostMood = self.boostMood;
    copy.forageProbability = self.forageProbability;
    copy.forageable = self.forageable;
    copy.inShop = self.inShop;
    copy.numOwned = self.numOwned;
    copy.categoryKey = self.categoryKey;               
	copy.isBattleOnly = self.isBattleOnly;
	copy.isUseableInBattle = self.isUseableInBattle;
	copy.iphoneBackgroundImage = self.iphoneBackgroundImage;
	copy.iphoneBackgroundBattleImage = self.iphoneBackgroundBattleImage;
    copy.cashFlow = self.cashFlow;
    return copy;

}

- (void)setInShopWithString:(NSString *)_value {
    self.inShop = [_value isEqualToString:@"1"];
}

- (void)setCostWithString:(NSString *)_value {
    self.cost = [_value intValue];
}

- (void)setSellPriceWithString:(NSString *)_value {
    self.sellPrice = [_value intValue];
}

- (void)setNumOwnedWithString:(NSString *)_value {
    self.numOwned = [_value intValue];
}

- (void)setBoostDefWithString:(NSString *)_value {
    self.boostDef = [_value intValue];
}

- (void)setBoostAtkWithString:(NSString *)_value {
    self.boostAtk = [_value intValue];
}

- (void)setBoostEnergyMaxWithString:(NSString *)_value {
    self.boostEnergyMax = [_value intValue];
}

- (void)setBoostEnergyWithString:(NSString *)_value {
    self.boostEnergy = [_value intValue];
}

- (void)setBoostHpMaxWithString:(NSString *)_value {
    self.boostHpMax = [_value intValue];
}

- (void)setBoostHpWithString:(NSString *)_value {
    self.boostHp = [_value intValue];
}

- (void)setBoostMoodWithString:(NSString *)_value {
    self.boostMood = [_value intValue];
}

- (void)setIsUseableInBattleWithString:(NSString *)_value {
	self.isUseableInBattle = [_value isEqualToString:@"1"];
}

- (void)setCashFlowWithString:(NSString *)_value {
    self.cashFlow = [_value intValue];
}

- (void)setIsBattleOnlyWithString:(NSString *)_value {
	self.isBattleOnly = [_value isEqualToString:@"1"];
}

- (BOOL)isSameItem:(Item *)item {
    return [itemId isEqualToString:item.itemId];
}

- (NSString *)serializeToJavascriptArray {
	NSString *extraPropertiesString = [[NSString alloc] initWithString:@""];
	for (id key in _extraProperties) {
		if ([key isKindOfClass:[NSString class]]) {
			id prop = [_extraProperties objectForKey:key];
			if ([prop isKindOfClass:[NSString class]]) {
				NSString *temp = [[NSString alloc] initWithFormat:@"\"%@\":\"%@\"", key, prop];
				NSString *propertyString = [[NSString alloc] initWithFormat:@"%@,%@", extraPropertiesString, temp];
				
				[temp release];
				[extraPropertiesString release];
				extraPropertiesString = propertyString;
			}
		}
	}

	NSString *arr = [NSString stringWithFormat:@"{\"id\":%@," 
												"\"name\":\"%@\","
												"\"details\":\"%@\","
												"\"category\":\"%@\","
												"\"category_key\":\"%@\","
												"\"cost\":%d,"
												"\"requires_level\":%@,"
												"\"sell_price\":%d," 
												"\"boost_hp\":%d," 
												"\"boost_hp_max\":%d,"
												"\"boost_energy\":%d,"
												"\"boost_energy_max\":%d,"
												"\"boost_atk\":%d,"
												"\"boost_def\":%d,"
												"\"boost_mood\":%d,"
												"\"in_shop\":%d,"
												"\"num_owned\":%d,"
												"\"useable_in_battle\":%d,"
												"\"battle_only\":%d,"
												"\"cash_flow\":%d,"
												"\"equipped\":%d"
												"%@}", 
												itemId, name, details, category, categoryKey, cost, requiresLevel, sellPrice,
												boostHp, boostHpMax, boostEnergy, boostEnergyMax, boostAtk, boostDef,
												boostMood, (inShop ? 1 : 0), numOwned, (isUseableInBattle ? 1 : 0),
												(isBattleOnly ? 1 : 0), cashFlow, _equipped, extraPropertiesString];
	[extraPropertiesString release];
	return arr;
	/*
	itemId, name, details, category, cost, sellPrice, 
	requiresLevel, boostHp, boostHpMax, boostEnergy, boostEnergyMax, 
	boostAtk, boostDef, boostMood, forageProbability, forageable, inShop, numOwned,
	categoryKey, isUseableInBattle, isBattleOnly, 
	// images 
	imageSquare100, imageSquare75, imageSquare50, imageSquare35,
	imageSquare25, iphoneBackgroundImage, cashFlow;*/
}


- (void)dealloc {
    [itemId release];
    [name release];
    [details release];
    [category release];
	[categoryKey release];
	
	[iphoneBackgroundImage release];
	[iphoneBackgroundBattleImage release];
	[imageSquare100 release];
	[imageSquare75 release];
	[imageSquare50 release];
	[imageSquare35 release];
	[imageSquare25 release];
	
    [requiresLevel release];
    [forageProbability release];
    [forageable release];
	
	[_extraProperties release];
    
	[super dealloc];
}
@end
