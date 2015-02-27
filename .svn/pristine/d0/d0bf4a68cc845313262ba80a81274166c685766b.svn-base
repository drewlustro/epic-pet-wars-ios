/**
 * Animal.m
 * Copyright Miraphonic, Inc 2009. All rights reserved.
 *
 * Animal is a rest object that handles the animal objects
 *
 * @author Amit Matani
 * @created 1/14/09
 */

#import "Animal.h"
#import "AnimalType.h"
#import "Item.h"
#import "ActionResult.h"
#import "Consts.h"

@implementation Animal
@synthesize animalId, animalTypeId, animalTypeName, userId, created, name, level, posseSize, hp, hpMax, 
            hpMaxBoost, energy, energyMax, energyMaxBoost, energyRefreshSeconds, 
            mood, moodText, atk, atkBoost, def, defBoost, experience, expNextLevel, expTotal, money, weapon, 
            armor, accessory1, accessory2, animalType, respectPoints, reviveSeconds, hospitalCost, friendCode, 
			background, petEnergyCost, forageEnergyCost, achievements, rank, bankFunds, bankDepositPercentage, 
            bankWithdrawalPercentage,
			// image sizes
			image, imageSquare50, imageSquare75, imageSquare100, imageSquare150, wins,
            losses, passiveWins, passiveLosses, ranAwayTimes, inviteCount, energyInitialSecondsToRefresh,
            hpInitialSecondsToRefresh, hpRefreshSeconds, income, moneyRefreshSeconds, moneyInitialSecondsToRefresh,
            isBoss;
static NSDictionary *fieldMap;
static NSArray *properties;

+ (void)initialize {
    if (self = [Animal class]) {
        if (fieldMap == nil) {
            fieldMap = [[NSDictionary alloc] initWithObjectsAndKeys:
                            @"setAnimalId:", @"id",
                            @"setAnimalTypeId:", @"animal_type_id",
                            @"setAnimalTypeName:", @"animal_type_name",
                            @"setUserId:", @"user_id",
                            @"setCreated:", @"created",
                            @"setName:", @"name",
                            @"setLevelWithString:", @"level",
                            @"setPosseSizeWithString:", @"posse_size",                 
                            @"setHpMaxWithString:", @"hp_max",
                            @"setHpMaxBoostWithString:", @"hp_max_boost",
                            @"setHpInitialSecondsToRefresh:", @"hp_initial_seconds_to_refresh",                                                
                            @"setHpWithString:", @"hp",   						
                            @"setHpRefreshSecondsWithString:", @"hp_refresh_seconds",                                            
                            @"setEnergyMaxWithString:", @"energy_max",
                            @"setEnergyMaxBoostWithString:", @"energy_max_boost",
                            @"setEnergyInitialSecondsToRefresh:", @"energy_initial_seconds_to_refresh",                        
                            @"setEnergyWithString:", @"energy",
                            @"setEnergyRefreshSecondsWithString:", @"energy_refresh_seconds",                    
                            @"setMoodWithString:", @"mood",
                            @"setAtkWithString:", @"atk",
                            @"setAtkBoostWithString:", @"atk_boost",
                            @"setDefWithString:", @"def",
                            @"setDefBoostWithString:", @"def_boost",
                            @"setExperienceWithString:", @"exp",
                            @"setExpNextLevelWithString:", @"exp_next_level",
                            @"setExpTotalWithString:", @"exp_total",
                            @"setMoneyWithString:", @"money",
                            @"setBankFundsWithString:", @"bank_funds",                        
                            @"setBankWithdrawalPercentage:", @"bank_withdrawal_percentage",                        
                            @"setBankDepositPercentage:", @"bank_deposit_percentage",                                                
                            @"setMoneyRefreshSecondsWithString:", @"money_refresh_seconds",
                            @"setIncomeWithString:", @"income",
                            @"setMoneyInitialSecondsToRefresh:", @"money_initial_seconds_to_refresh",
                            @"setWeaponWithApiResponse:", @"weapon",
                            @"setArmorWithApiResponse:", @"armor",
                            @"setAccessory1WithApiResponse:", @"accessory_1",
                            @"setAccessory2WithApiResponse:", @"accessory_2",
                            @"setBackgroundWithApiResponse:", @"background",						
                            @"setImage:", @"image",
							@"setImageSquare50:", @"image_square_50",
							@"setImageSquare75:", @"image_square_75",
							@"setImageSquare100:", @"image_square_100",
							@"setImageSquare150:", @"image_square_150",
                            @"setMoodText:", @"mood_string",
                            @"setRespectPointsWithString:", @"respect_points",
							@"setReviveSecondsWithNumber:", @"auto_revive_total_seconds",
							@"setHospitalCost:", @"hospital_cost",
							@"setFriendCode:", @"friend_code",
							@"setPetEnergyCost:", @"pet_energy_cost",
							@"setForageEnergyCost:", @"forage_energy_cost",
                            @"setWins:", @"wins",
                            @"setLosses:", @"losses",
                            @"setPassiveWins:", @"passive_wins",
                            @"setPassiveLosses:", @"passive_losses",
                            @"setRanAwayTimes:", @"run_away_times",
							@"setAchievements:", @"achievements",
							@"setRank:", @"rank",
                            @"setInviteCountWithNumber:", @"invite_count",
                            @"setIsBossWithString:", @"is_boss",
							
                            //@"setAnimalTypeWithAPIResponse:", @"animal_type",                       
                            nil
                        ];
			if (properties == nil) {
				properties = [[NSArray alloc] initWithObjects:
							  @"animalId", @"animalTypeId", @"animalTypeName", @"userId", @"created", 
							  @"name", @"level", @"posseSize", @"hpMax", @"hpMaxBoost", @"hp",  
							  @"energyMax", @"energyMaxBoost", @"energyRefreshSeconds", @"energy", 
							  @"mood", @"atk", @"atkBoost", @"def", @"defBoost", 
							  @"experience", @"expNextLevel", @"expTotal", @"money", @"weapon", @"background",
							  @"armor", @"accessory1", @"accessory2", @"animalType", @"moodText", @"respectPoints", 
							  @"timeLeftToEnergyRefresh", @"timeLeftToHpRefresh", @"timeLeftToRevive", @"hospitalCost", @"friendCode", 
							  @"petEnergyCost", @"forageEnergyCost", @"invite_count", @"achievements", @"rank",
							  // images
							  @"image", @"imageSquare50", @"image_square_75", @"imageSquare100", @"imageSquare150", 
							  @"wins", @"losses", @"passiveWins", @"passiveLosses",
                              @"ranAwayTimes", @"energyInitialSecondsToRefresh", @"hpInitialSecondsToRefresh", 
                              @"income", @"moneyRefreshSeconds", @"moneyInitialSecondsToRefresh",
                              @"timeLeftToMoneyRefresh", @"income", @"bankFunds",
							  nil];
			}			
        }
    }
}

+ (NSDictionary *)GetFieldMapHelper {
    return fieldMap;
}

- (id)initWithApiResponse:(NSDictionary *)apiResponse {
    if (self = [super initWithApiResponse:apiResponse]) {
		observers = [[NSMutableArray alloc] initWithCapacity:10];
	}
	return self;
}
- (void)setAnimalTypeWithAPIResponse:(NSDictionary *)apiResponse {
    AnimalType *typeTemp = [[AnimalType alloc] initWithApiResponse:apiResponse];
    self.animalType = typeTemp;
    [typeTemp release];
}

- (void)setItemWithApiResponse:(NSDictionary *)apiResponse setter:(NSString *)setter {
    if (apiResponse == nil || (id) apiResponse == [NSNull null]) { return; }
    Item *item = [[Item alloc] initWithApiResponse:apiResponse];
    SEL selector = NSSelectorFromString(setter);
    [self performSelector:selector withObject:item];
    [item release];
}

- (void)setArmorWithApiResponse:(NSDictionary *)apiResponse {
    [self setItemWithApiResponse:apiResponse setter:@"setArmor:"];
}

- (void)setWeaponWithApiResponse:(NSDictionary *)apiResponse {
    [self setItemWithApiResponse:apiResponse setter:@"setWeapon:"];
}

- (void)setAccessory1WithApiResponse:(NSDictionary *)apiResponse {
    [self setItemWithApiResponse:apiResponse setter:@"setAccessory1:"];
}

- (void)setAccessory2WithApiResponse:(NSDictionary *)apiResponse {
    [self setItemWithApiResponse:apiResponse setter:@"setAccessory2:"];
}

- (void)setBackgroundWithApiResponse:(NSDictionary *)apiResponse {
    [self setItemWithApiResponse:apiResponse setter:@"setBackground:"];
}

- (void)setEnergyRefreshSecondsWithString:(NSString *)refreshSeconds {
    self.energyRefreshSeconds = [refreshSeconds intValue];
}

- (void)setHpRefreshSecondsWithString:(NSString *)refreshSeconds {
    self.hpRefreshSeconds = [refreshSeconds intValue];
}

- (void)setMoneyRefreshSecondsWithString:(NSString *)refreshSeconds {
    self.moneyRefreshSeconds = [refreshSeconds intValue];
}


- (void)setEnergyWithString:(NSString *)_value {
    energy = [_value intValue];
}

- (void)setEnergyMaxWithString:(NSString *)_value {
    self.energyMax = [_value intValue];
}

- (void)setEnergyMaxBoostWithString:(NSString *)_value {
    self.energyMaxBoost = [_value intValue];
}

- (void)setHpWithString:(NSString *)_value {
    hp = [_value intValue];
}

- (void)setHpMaxWithString:(NSString *)_value {
    self.hpMax = [_value intValue];
}

- (void)setHpMaxBoostWithString:(NSString *)_value {
    self.hpMaxBoost = [_value intValue];
}


- (void)setDefWithString:(NSString *)_value {
    self.def = [_value intValue];
}


- (void)setDefBoostWithString:(NSString *)_value {
    self.defBoost = [_value intValue];
}


- (void)setAtkWithString:(NSString *)_value {
    self.atk = [_value intValue];
}


- (void)setAtkBoostWithString:(NSString *)_value {
    self.atkBoost = [_value intValue];
}

- (void)setMoneyWithString:(NSString *)_value {
    self.money = [_value intValue];
}

- (void)setBankFundsWithString:(NSString *)_value {
    self.bankFunds = [_value longLongValue];
}

- (void)setExperienceWithString:(NSString *)_value {
	self.experience = [_value intValue];
}

- (void)setExpTotalWithString:(NSString *)_value {
	self.expTotal = [_value intValue];
}

- (void)setExpNextLevelWithString:(NSString *)_value {
	self.expNextLevel = [_value intValue];
}

- (void)setLevelWithString:(NSString *)_value {
	self.level = [_value intValue];
}

- (void)setRespectPointsWithString:(NSString *)_value {
	self.respectPoints = [_value intValue];
}

- (void)setReviveSecondsWithNumber:(NSNumber *)_value {
	self.reviveSeconds = [_value intValue];
}

- (void)setPosseSizeWithString:(NSNumber *)_value {
	self.posseSize = [_value intValue];
}

- (void)setInviteCountWithNumber:(NSNumber *)_value {
    self.inviteCount = [_value intValue];
}


- (void)setMoodWithString:(NSNumber *)_value {
	self.mood = [_value intValue];
}

- (void)setIncomeWithString:(NSString *)_value {
    self.income = [_value intValue];
}


- (void)setHp:(NSInteger)_value {
	if (_value < 0) {
		hp = 0;
	} else if (_value > hpMax + hpMaxBoost) {
		hp = hpMax + hpMaxBoost;
	} else {
		hp = _value;
	}
}

- (void)setEnergy:(NSInteger)_value {
	if (_value < 0) {
		energy = 0;
	} else if (_value > energyMax + energyMaxBoost) {
		energy = energyMax + energyMaxBoost;
	} else {
		energy = _value;
	}
}

- (void)setMoney:(unsigned long long)_value {
	money = _value < 0 ? 0 : _value;
}

- (void)setMood:(NSInteger)_value {
    if (_value < 0) {
        mood = 0;
    } else if (_value > 100) {
        mood = 100;
    } else {
        mood = _value;
    }
}

- (void)updateWithActionResult:(ActionResult *)actionResult {
    if (actionResult.money != nil) {
        self.money += [actionResult.money longLongValue];
    }
	if (actionResult.energyMax != nil) {
		self.energyMax += [actionResult.energyMax intValue];
	}
	if (actionResult.energyMaxBoost != nil) {
		self.energyMaxBoost += [actionResult.energyMaxBoost intValue];
	}
    if (actionResult.energy != nil) {
        self.energy += [actionResult.energy intValue];
    }
	if (actionResult.hpMax != nil) {
		self.hpMax += [actionResult.hpMax intValue];
	}
	if (actionResult.hpMaxBoost != nil) {
		self.hpMaxBoost += [actionResult.hpMaxBoost intValue];
	}    
    if (actionResult.hp != nil) {
        self.hp += [actionResult.hp intValue];        
    }
	if (actionResult.newExp != nil) {
		self.experience = [actionResult.newExp intValue];
	} else if (actionResult.exp != nil) {
		self.experience += [actionResult.exp intValue];
	}
	if (actionResult.expNextLevel != nil) {
		self.expNextLevel = [actionResult.expNextLevel intValue];
	}
	if (actionResult.level != nil) {
		self.level = [actionResult.level intValue];
	}
	if (actionResult.atk != nil) {
		self.atk += [actionResult.atk intValue];
	}
	if (actionResult.atkBoost != nil) {
		self.atkBoost += [actionResult.atkBoost intValue];
	}
	if (actionResult.def != nil) {
		self.def += [actionResult.def intValue];
	}
	if (actionResult.defBoost != nil) {
		self.defBoost += [actionResult.defBoost intValue];
	}
	if (actionResult.energyRefreshSeconds != nil) {
		self.energyRefreshSeconds += [actionResult.energyRefreshSeconds intValue];
	}
	if (actionResult.respectPoints != nil) {
		self.respectPoints += [actionResult.respectPoints intValue];
	}
	if (actionResult.reviveSeconds != nil) {
		self.reviveSeconds = [actionResult.reviveSeconds intValue];
	}
	if (actionResult.reviveCost != nil) {
		self.hospitalCost = actionResult.reviveCost;
	}
	if (actionResult.petEnergyCost != nil) {
		self.petEnergyCost = actionResult.petEnergyCost;
	}
	if (actionResult.forageEnergyCost != nil) {
		self.forageEnergyCost = actionResult.forageEnergyCost;
	}
	if (actionResult.mood != nil) {
		self.mood += [actionResult.mood intValue];
	}
    
    if (actionResult.income != nil) {
        self.income += [actionResult.income intValue];
    }
    
    if (actionResult.bankFunds != nil) {
        self.bankFunds += [actionResult.bankFunds longLongValue];
    }    
    
    if (actionResult.posseSize != nil) {
        self.posseSize += [actionResult.posseSize intValue];
    }
    
    if (actionResult.posseSizeBoost != nil) {
        self.posseSize += [actionResult.posseSizeBoost intValue];        
    }
	
}

- (void)setIsBossWithString:(NSString *)_value {
    self.isBoss = [_value isEqualToString:@"1"];
}

/**
 * add observer will add the observer to changes of all properties of the
 * animal class.  This alows the observers to auto update when things change 
 * to the animal
 */
- (void)registerObserverToAllProperties:(NSObject *)observer {
    NSString *property;
    [observers addObject:observer];
    for (property in properties) {
        [self addObserver:observer forKeyPath:property
				  options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld)
				  context:NULL];
    }
    debug_NSLog(@"=============num observers after register: %d ==============", [observers count]);    
}

/**
 * removes observer
 */
- (void)unregisterObserver:(NSObject *)observer {
    NSString *property;
    for (property in properties) {
        [self removeObserver:observer forKeyPath:property];
    }
    [observers removeObject:observer];
    debug_NSLog(@"=============num observers after unregister: %d ==============", [observers count]);
}

- (void)cleanup {
    while ([observers count] > 0) {
        id observer = [observers objectAtIndex:0];
        [self unregisterObserver:observer];
    }
    [NSObject cancelPreviousPerformRequestsWithTarget:self];    
}

- (void)dealloc {
    debug_NSLog(@"deallocing animal");
    [energyInitialSecondsToRefresh release];
    [animalId release];
    [animalTypeId release];
    [animalTypeName release];
    [userId release];
    [created release];
    [name release];
    [weapon release];
    [armor release];
    [accessory1 release];
    [accessory2 release];
    [image release];
	[imageSquare50 release];
    [imageSquare75 release];
	[imageSquare100 release];
	[imageSquare150 release];
    [animalType release];
    [moodText release];
    [observers release];
	[hospitalCost release];
	[friendCode release];
	[petEnergyCost release];
	[forageEnergyCost release];	
    [background release];
    [ranAwayTimes release];
    [passiveWins release];
    [passiveLosses release];
    [wins release];
    [losses release];
	[achievements release];
	[rank release];
    [hpInitialSecondsToRefresh release];
    [moneyInitialSecondsToRefresh release];
    [bankDepositPercentage release];
    [bankWithdrawalPercentage release];
    [super dealloc];
}
@end
