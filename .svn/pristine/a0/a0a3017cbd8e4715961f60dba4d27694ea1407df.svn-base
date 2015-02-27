/**
 * AnimalType.m
 * Copyright Miraphonic, Inc 2009. All rights reserved.
 *
 * AnimalType is a rest object that handles the default animal types
 *
 * @author Amit Matani
 * @created 1/14/09
 */

#import "AnimalType.h"


@implementation AnimalType
@synthesize typeId, name, details, image, baseHp, baseEnergy,
            baseEnergyRefreshSeconds, baseMoneyRefreshSeconds, baseHpRefreshSeconds,
			baseMood, baseAttack, baseDefense, locked, lockedReason, 
			imageSquare75, imageSquare150;

static NSDictionary *fieldMap;

+ (void)initialize {
    if (self = [AnimalType class]) {	
		fieldMap = [[NSDictionary alloc] initWithObjectsAndKeys:
						@"setTypeId:", @"id",
						@"setName:", @"name",
						@"setDetails:", @"details",
						@"setImage:", @"image",
						@"setBaseHp:", @"base_hp",
						@"setBaseEnergy:", @"base_energy",
						@"setBaseEnergyRefreshSeconds:", @"base_energy_refresh_seconds",
						@"setBaseMoneyRefreshSeconds:", @"base_money_refresh_seconds",
						@"setBaseHpRefreshSeconds:", @"base_hp_refresh_seconds",
						@"setBaseMood:", @"base_mood",
						@"setBaseAttack:", @"base_atk",
						@"setBaseDefense:", @"base_def",
                        @"setLockedWithString:", @"locked",
                        @"setLockedReason:", @"locked_reason",
                        @"setImageSquare150:", @"image_square_150",                                        
                        @"setImageSquare75:", @"image_square_75",                    
						nil
					];
	}
}

- (void)setLockedWithString:(NSString *)_value {
    self.locked = [_value isEqualToString:@"1"];
}

+ (NSDictionary *)GetFieldMapHelper {
    return fieldMap;
}

- (void)dealloc {
    [typeId release];
    [name release];
    [details release];
    [image release];
    [imageSquare75 release];
	[imageSquare150 release];
    [baseHp release];
    [baseEnergy release];
    [baseEnergyRefreshSeconds release];
	[baseMoneyRefreshSeconds release];
	[baseHpRefreshSeconds release];
    [baseMood release];
    [baseAttack release];
    [baseDefense release];
    [lockedReason release];
    [super dealloc];
}
@end
