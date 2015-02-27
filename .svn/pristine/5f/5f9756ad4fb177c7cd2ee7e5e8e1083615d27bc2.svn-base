//
//  Job.m
//  battleroyale
//
//  Created by Amit Matani on 1/30/09.
//  Copyright 2009 Miraphonic, Inc. All rights reserved.
//

#import "Job.h"
#import "Item.h"

@implementation Job
@synthesize name, details, requiresLevel, requiresEnergy, requiresMoney, requiresPosse, requiresItems, 
            rewardExpFloor, rewardExpCeil, rewardMoneyFloor, rewardMoneyCeil, hasRewardItem, 
			bossBotAnimalId, jobId, requiredItemCounts, 
			requiresTwitter = _requiresTwitter, requiresFacebook = _requiresFacebook;

static NSDictionary *fieldMap;
+ (void)initialize {
    if (self = [Job class]) {
        if (fieldMap == nil) {
            fieldMap = [[NSDictionary alloc] initWithObjectsAndKeys:
                            @"setJobId:", @"id",
                            @"setName:", @"name",
                            @"setDetails:", @"details",
                            @"setRequiresLevelWithString:", @"requires_level",
                            @"setRequiresEnergyWithString:", @"requires_energy",
                            @"setRequiresMoneyWithString:", @"requires_money",
							@"setRequiresPosseWithString:", @"requires_posse",
                            @"setRequiresItemsFromList:", @"requires_items_list_objects",
                            @"setRewardExpFloor:", @"reward_exp_floor",
                            @"setRewardExpCeil:", @"reward_exp_ceil",
                            @"setRewardMoneyFloor:", @"reward_money_floor",
                            @"setRewardMoneyCeil:", @"reward_money_ceil",
                            @"setHasRewardItem:", @"has_reward_item",
                            @"setBossBotAnimalId:", @"boss_bot_animal_id",
                            @"setRequiredItemCounts:", @"requires_items_list",
							@"setRequiresTwitterWithString:", @"requires_twitter",
							@"setRequiresFacebookWithString:", @"requires_facebook",						
                            nil
                        ];
        }
    }
}

+ (NSDictionary *)GetFieldMapHelper {
    return fieldMap;
}

- (BOOL)doesJobHaveRewardItem {	
	if ([hasRewardItem isEqualToString:@"1"]) {
		return YES;
	}
	return NO;
}

- (void)setRequiresLevelWithString:(NSString *)_value {
    self.requiresLevel = [_value intValue];
}

- (void)setRequiresEnergyWithString:(NSString *)_value {
    self.requiresEnergy = [_value intValue];
}

- (void)setRequiresMoneyWithString:(NSString *)_value {
    self.requiresMoney = [_value intValue];
}

- (void)setRequiresPosseWithString:(NSString *)_value {
	self.requiresPosse = [_value intValue];
}

- (void)setRequiresFacebookWithString:(NSString *)_value {
    self.requiresFacebook = [_value isEqualToString:@"1"];
}

- (void)setRequiresTwitterWithString:(NSString *)_value {
    self.requiresTwitter = [_value isEqualToString:@"1"];
}

- (void)setRequiresItemsFromList:(NSDictionary *)list {
    if ((id)list == [NSNull null] || list == nil || ![list isKindOfClass:[NSDictionary class]]) {
        self.requiresItems = nil;
        return;
    }
    
    NSArray *values = [list allValues];
    NSMutableArray *items = [[NSMutableArray alloc] initWithCapacity:[values count]];
    
    for (NSDictionary *itemDict in values) {
        Item *item = [[Item alloc] initWithApiResponse:itemDict];
        [items addObject:item];
        [item release];
    }
    
    self.requiresItems = items;
    [items release];
}

- (void)dealloc {
    [jobId release];
    [name release];
    [details release];
    [rewardExpFloor release];
    [rewardExpCeil release];
    [rewardMoneyFloor release];
    [rewardMoneyCeil release];
    [hasRewardItem release];
    [bossBotAnimalId release];
	[requiresItems release];
    [requiredItemCounts release];
	[super dealloc];
}

@end
