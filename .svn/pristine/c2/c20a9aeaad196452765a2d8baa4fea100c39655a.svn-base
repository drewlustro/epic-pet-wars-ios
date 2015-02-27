/**
 * ActionResult.h
 * Copyright Miraphonic, Inc 2009. All rights reserved.
 *
 * The ActionResult that handles ActionResult object
 *
 * @author Amit Matani
 * @created 1/15/09
 */

#import "ActionResult.h"
#import "Item.h"
#import "Animal.h"
#import "Consts.h"
#import "Utility.h"

@implementation ActionResult
@synthesize failure, reason, money, hp, hpMax, hpMaxBoost, energy, energyMax, energyMaxBoost,
            atk, def, mood, flagWonBattle, flagDied, jobName, 
            opponentName, dealtHp, message, formattedResponse, formattedResponseHeight,
            formattedResponseWidth, exp, expNextLevel, newExp, level,
			energyRefreshSeconds, respectPoints, item, reviveSeconds,
			reviveCost, newChallenger, battleId, petEnergyCost, forageEnergyCost, income,
            fbTemplateItem, posseSize = _posseSize, posseSizeBoost = _posseSizeBoost,
            bankFunds,
            // correcting
            correctHp = _correctHp, correctEnergy = _correctEnergy, correctMoney = _correctMoney,
			fbRequiredExtendedPermission = _fbRequiredExtendedPermission, showPopup = _showPopup,
			atkBoost, defBoost, itemCount = _itemCount, popupHTML = _popupHTML;

static NSDictionary *fieldMap;
+ (void)initialize {
    if (self = [ActionResult class]) {
        if (fieldMap == nil) {
            fieldMap = [[NSDictionary alloc] initWithObjectsAndKeys:
                            @"setFailure:", @"failure",
                            @"setReason:", @"reason",
                            @"setMoney:", @"money",
							@"setRespectPoints:", @"respect_points",
                            @"setHp:", @"hp",
                            @"setHpMax:", @"hp_max",
                            @"setHpMaxBoost:", @"hp_max_boost",                        
                            @"setEnergy:", @"energy",
                            @"setEnergyMax:", @"energy_max",
                            @"setEnergyMaxBoost:", @"energy_max_boost",
							@"setEnergyRefreshSeconds:", @"energy_refresh_seconds", 
                            @"setAtk:", @"atk",
							@"setAtkBoost:", @"atk_boost",
                            @"setDef:", @"def",
							@"setDefBoost:", @"def_boost",
                            @"setMood:", @"mood",
                            @"setLevel:", @"level",
                            @"setExp:", @"exp",
                            @"setNewExp:", @"new_exp",						
                            @"setExpNextLevel:", @"exp_next_level",	
                            @"setFlagWonBattle:", @"flag_won_battle",
                            @"setFlagDied:", @"flag_died",
                            @"setJobName:", @"job_name",
                            @"setOpponentName:", @"opponent_name",
                            @"setDealtHp:", @"dealt_hp",
                            @"setMessage:", @"message",
                            @"setFormattedResponse:", @"formatted_response",
                            @"setFormattedResponseWidth:", @"formatted_response_width",
                            @"setFormattedResponseHeight:", @"formatted_response_height",
							@"setItemWithApiResponse:", @"item",
							@"setItemWithApiResponse:", @"item",
							@"setReviveSeconds:", @"revive_seconds",
							@"setReviveCost:", @"revive_cost",
							@"setNewChallengerWithApiResponse:", @"new_challenger",
							@"setBattleId:", @"battle_id",
							@"setPetEnergyCost:", @"pet_cost",
							@"setForageEnergyCost:", @"forage_cost",
                            @"setIncome:", @"income",
                            @"setBankFunds:", @"bank_funds",
                            @"setFbTemplateItem:", @"fbTemplateItem",
                            @"setFbRequiredExtendedPermission:", @"fb_required_extended_permission",
                            @"setPosseSize:", @"posse_size",
                            @"setPosseSizeBoost:", @"posse_size_boost",
							
							// item
							@"setItemCount:", @"item_count",

                            // correct numbers
                            @"setCorrectHp:", @"correct_hp",
                            @"setCorrectEnergy:", @"correct_energy",
                            @"setCorrectMoney:", @"correct_money",
						
							// popup stuff for the webviews
							@"setShowPopupWithNumber:", @"flag_show_popup",
						
							@"setPopupHTML:", @"popup_html",
                            nil
                    ];
        }
    }
}

- (void)setItemWithApiResponse:(NSDictionary *)_value {
	Item *itemTemp = [[Item alloc] initWithApiResponse:_value];
	self.item = itemTemp;
	[itemTemp release];
}

- (NSInteger)getItemCount {
	// default to 1
	NSInteger count = 1; 
	if (_itemCount != nil) {
		count = [_itemCount intValue];
	}
	return count;
}

- (void)setNewChallengerWithApiResponse:(NSDictionary *)_value {
	Animal *animal = [[Animal alloc] initWithApiResponse:_value];
	self.newChallenger = animal;
	[animal release];
}

- (void)setShowPopupWithNumber:(NSNumber *)_value {
	self.showPopup = _value != nil && [_value isEqualToNumber:[NSDecimalNumber one]];
}

- (void)mergeWithActionResult:(ActionResult *)actionResult {
	NSNumber *temp = [[NSNumber alloc] initWithInt:[self.hp intValue] + [actionResult.hp intValue]];
	self.hp = temp;
	[temp release];	
	
	temp = [[NSNumber alloc] initWithInt:[self.hpMax intValue] + [actionResult.hpMax intValue]];
	self.hpMax = temp;
	[temp release];	
    
	temp = [[NSNumber alloc] initWithInt:[self.hpMaxBoost intValue] + [actionResult.hpMaxBoost intValue]];
	self.hpMaxBoost = temp;
	[temp release];	    

	temp = [[NSNumber alloc] initWithInt:[self.energy intValue] + [actionResult.energy intValue]];
	self.energy = temp;
	[temp release];	

	temp = [[NSNumber alloc] initWithInt:[self.energyMax intValue] + [actionResult.energyMax intValue]];
	self.energyMax = temp;
	[temp release];	
	
	temp = [[NSNumber alloc] initWithInt:[self.energyMaxBoost intValue] + [actionResult.energyMaxBoost intValue]];
	self.energyMaxBoost = temp;
	[temp release];	

	temp = [[NSNumber alloc] initWithInt:[self.atk intValue] + [actionResult.atk intValue]];
	self.atk = temp;
	[temp release];	
	
	temp = [[NSNumber alloc] initWithInt:[self.atkBoost intValue] + [actionResult.atkBoost intValue]];
	self.atkBoost = temp;
	[temp release];	

	temp = [[NSNumber alloc] initWithInt:[self.def intValue] + [actionResult.def intValue]];
	self.def = temp;
	[temp release];	
	
	temp = [[NSNumber alloc] initWithInt:[self.defBoost intValue] + [actionResult.defBoost intValue]];
	self.defBoost = temp;
	[temp release];	

	temp = [[NSNumber alloc] initWithInt:[self.mood intValue] + [actionResult.mood intValue]];
	self.mood = temp;
	[temp release];
    
    temp = [[NSNumber alloc] initWithInt:[self.income intValue] + [actionResult.income intValue]];
    self.income = temp;
    [temp release];
    
    temp = [[NSNumber alloc] initWithInt:[self.bankFunds intValue] + [actionResult.bankFunds intValue]];
    self.bankFunds = temp;
    [temp release];    
    
    temp = [[NSNumber alloc] initWithInt:[self.posseSize intValue] + [actionResult.posseSize intValue]];
    self.posseSize = temp;
    [temp release];
    
    temp = [[NSNumber alloc] initWithInt:[self.posseSizeBoost intValue] + [actionResult.posseSizeBoost intValue]];
    self.posseSizeBoost = temp;
    [temp release];
}

- (void)invert {
	NSNumber *temp = [[NSNumber alloc] initWithInt:-1 * [self.hp intValue]];
	self.hp = temp;
	[temp release];	
	
	temp = [[NSNumber alloc] initWithInt:-1 * [self.hpMax intValue]];
	self.hpMax = temp;
	[temp release];	
    
	temp = [[NSNumber alloc] initWithInt:-1 * [self.hpMaxBoost intValue]];
	self.hpMaxBoost = temp;
	[temp release];
	
	temp = [[NSNumber alloc] initWithInt:-1 * [self.energy intValue]];
	self.energy = temp;
	[temp release];	
	
	temp = [[NSNumber alloc] initWithInt:-1 * [self.energyMax intValue]];
	self.energyMax = temp;
	[temp release];	
	
	temp = [[NSNumber alloc] initWithInt:-1 * [self.energyMaxBoost intValue]];
	self.energyMaxBoost = temp;
	[temp release];	
	
	temp = [[NSNumber alloc] initWithInt:-1 * [self.atk intValue]];
	self.atk = temp;
	[temp release];	
	
	temp = [[NSNumber alloc] initWithInt:-1 * [self.atkBoost intValue]];
	self.atkBoost = temp;
	[temp release];	
	
	temp = [[NSNumber alloc] initWithInt:-1 * [self.def intValue]];
	self.def = temp;
	[temp release];	
	
	temp = [[NSNumber alloc] initWithInt:-1 * [self.defBoost intValue]];
	self.defBoost = temp;
	[temp release];	
	
	temp = [[NSNumber alloc] initWithInt:-1 * [self.mood intValue]];
	self.mood = temp;
	[temp release];	
    
    temp = [[NSNumber alloc] initWithInt:-1 * [self.income intValue]];
    self.income = temp;
    [temp release];
    
    temp = [[NSNumber alloc] initWithInt:-1 * [self.bankFunds intValue]];
    self.bankFunds = temp;
    [temp release];
}

- (BOOL)hasFacebookDialog {
	return (fbTemplateItem != nil || (_fbRequiredExtendedPermission != nil && ![_fbRequiredExtendedPermission isEqualToString:@""]));
}

+ (NSDictionary *)GetFieldMapHelper {
    return fieldMap;
}

- (void)dealloc {    
    debug_NSLog(@"deallocing action result");
    [failure release];
    [reason release];
    [money release];
	[respectPoints release];
    [hp release];
    [hpMax release];
    [hpMaxBoost release];
    [energy release];
    [energyMax release];
	[energyMaxBoost release];
    [atk release];
	[atkBoost release];
    [def release];
	[defBoost release];
	[exp release];
	[newExp release];	
	[expNextLevel release];
    [mood release];
    [level release];
    [flagWonBattle release];
    [flagDied release];
    [jobName release];
    [opponentName release];
    [dealtHp release];
    [message release];
    [formattedResponse release];
    [formattedResponseWidth release];
    [formattedResponseHeight release];        
	[item release];
	[reviveSeconds release];
	[reviveCost release];
	[newChallenger release];
	[battleId release];
    [forageEnergyCost release];
    [petEnergyCost release];
    [income release];
    [energyRefreshSeconds release];
    [_posseSize release];
    [_posseSizeBoost release];
    [bankFunds release];
	[_itemCount release];
    
    // facebook
    [fbTemplateItem release];
    [_fbRequiredExtendedPermission release];
    
    
    // correcting numbers
    [_correctHp release];
    [_correctEnergy release];
    [_correctMoney release];
	
	[_popupHTML release];
    
	[super dealloc];
}

@end
