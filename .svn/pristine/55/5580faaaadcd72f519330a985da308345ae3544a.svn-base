/**
 * ActionResult.h
 * Copyright Miraphonic, Inc 2009. All rights reserved.
 *
 * The ActionResult that handles ActionResult object
 *
 * @author Amit Matani
 * @created 1/15/09
 */

#import <Foundation/Foundation.h>
#import "AbstractRestRequestedModel.h"

@class Item, Animal;
@interface ActionResult : AbstractRestRequestedModel {
    NSString *reason, *failure;
    NSNumber *money;
	NSNumber *respectPoints;
    NSNumber *hp;
    NSNumber *hpMax, *hpMaxBoost;
    NSNumber *energy;
    NSNumber *energyMax, *energyMaxBoost;
    NSNumber *atk, *atkBoost;
    NSNumber *def, *defBoost;
    NSNumber *mood;
	NSNumber *exp;
	NSNumber *newExp;	
	NSNumber *expNextLevel;	
    NSNumber *level;
    NSNumber *flagWonBattle;
    NSNumber *flagDied;
    NSNumber *jobName;
    NSNumber *opponentName;
    NSNumber *dealtHp;
    NSString *message;
    NSString *formattedResponse;
    NSNumber *formattedResponseWidth;
    NSNumber *formattedResponseHeight;        
	NSNumber *energyRefreshSeconds;
	NSNumber *reviveSeconds;
	NSNumber *reviveCost;
	NSString *battleId;
    NSNumber *income;
    NSNumber *bankFunds;
	NSString *petEnergyCost, *forageEnergyCost;
    
	NSDictionary *fbTemplateItem;
    NSString *_fbRequiredExtendedPermission; // the string of the extended permission required
    
    NSNumber *_posseSize;
    NSNumber *_posseSizeBoost;    
    
    // correction fields to get rid of data consistancy issues
    NSNumber *_correctHp, *_correctEnergy, *_correctMoney;
    NSNumber *_itemCount;
	
	NSString *_popupHTML;
	
	Item *item;
	Animal *newChallenger;
	
	BOOL _showPopup;
}


@property (nonatomic, copy) NSString *reason, *failure;
@property (nonatomic, retain) NSNumber *money;
@property (nonatomic, retain) NSNumber *respectPoints;
@property (nonatomic, retain) NSNumber *hp;
@property (nonatomic, retain) NSNumber *hpMax, *hpMaxBoost;
@property (nonatomic, retain) NSNumber *energy;
@property (nonatomic, retain) NSNumber *energyMax, *energyMaxBoost;
@property (nonatomic, retain) NSNumber *atk, *atkBoost;
@property (nonatomic, retain) NSNumber *def, *defBoost;
@property (nonatomic, retain) NSNumber *mood;
@property (nonatomic, retain) NSNumber *exp;
@property (nonatomic, retain) NSNumber *newExp;	
@property (nonatomic, retain) NSNumber *expNextLevel;
@property (nonatomic, retain) NSNumber *level;
@property (nonatomic, retain) NSNumber *flagWonBattle;
@property (nonatomic, retain) NSNumber *flagDied;
@property (nonatomic, retain) NSNumber *jobName;
@property (nonatomic, retain) NSNumber *opponentName;
@property (nonatomic, retain) NSNumber *dealtHp;
@property (nonatomic, retain) NSNumber *energyRefreshSeconds;
@property (nonatomic, retain) NSNumber *reviveSeconds;
@property (nonatomic, retain) NSNumber *income, *bankFunds;
@property (nonatomic, copy) NSString *message;
@property (nonatomic, copy) NSString *formattedResponse;
@property (nonatomic, retain) NSNumber *formattedResponseWidth;
@property (nonatomic, retain) NSNumber *formattedResponseHeight;
@property (nonatomic, retain) NSNumber *reviveCost;
@property (nonatomic, copy) NSString *battleId;
@property (nonatomic, copy) NSString *petEnergyCost, *forageEnergyCost;
@property (nonatomic, retain) Animal *newChallenger;
@property (nonatomic, retain) Item *item;
@property (nonatomic, retain) NSDictionary *fbTemplateItem;
@property (nonatomic, retain) NSNumber *posseSize;
@property (nonatomic, retain) NSNumber *posseSizeBoost;
@property (nonatomic, retain) NSNumber *correctHp, *correctEnergy, *correctMoney;
@property (nonatomic, retain) NSNumber *itemCount;
@property (nonatomic, copy) NSString *popupHTML;

@property (nonatomic, copy) NSString *fbRequiredExtendedPermission;
@property (assign) BOOL showPopup;

- (void)mergeWithActionResult:(ActionResult *)actionResult;
- (void)invert;
- (BOOL)hasFacebookDialog;
- (NSInteger)getItemCount;

@end
