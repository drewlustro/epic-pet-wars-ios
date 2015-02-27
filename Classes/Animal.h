/**
 * Animal.h
 * Copyright Miraphonic, Inc 2009. All rights reserved.
 *
 * Animal is a rest object that handles the animal objects
 *
 * @author Amit Matani
 * @created 1/14/09
 */

#import <Foundation/Foundation.h>
#import "AbstractRestRequestedModel.h"

@class AnimalType, Item, ActionResult;
@interface Animal : AbstractRestRequestedModel {
    NSString *animalId;
    NSString *animalTypeId;
    NSString *animalTypeName;    
    NSString *userId;
    NSString *created;
    NSString *name;
    NSInteger level;
    NSInteger posseSize;
    NSInteger hp;
    NSInteger hpMax;
    NSInteger hpMaxBoost;
    NSInteger energy;
    NSInteger energyMax;
    NSInteger energyMaxBoost;
    NSInteger energyRefreshSeconds;
    NSInteger mood;
    NSString *moodText;
    NSInteger atk;
    NSInteger atkBoost;
    NSInteger def;
    NSInteger defBoost;
    NSUInteger experience;
    NSUInteger expNextLevel;
    NSUInteger expTotal;
    unsigned long long money, bankFunds;
    NSString *image;
	NSString *imageSquare50, *imageSquare75, *imageSquare100, *imageSquare150;
    NSInteger respectPoints;
	NSInteger reviveSeconds;
	NSNumber *hospitalCost;
	NSString *friendCode;
	NSString *petEnergyCost, *forageEnergyCost;
    NSString *wins, *losses, *passiveWins, *passiveLosses, *ranAwayTimes, *achievements, *energyInitialSecondsToRefresh, *rank;
    NSInteger hpRefreshSeconds;
    NSString *hpInitialSecondsToRefresh;
    
    NSString *moneyInitialSecondsToRefresh;
    NSInteger income, moneyRefreshSeconds;
    
    NSString *bankDepositPercentage, *bankWithdrawalPercentage;
    AnimalType *animalType;
    Item *weapon;    
    Item *armor;
    Item *accessory1;
    Item *accessory2;   
	Item *background;
    // add the items here as well
	
	NSMutableArray *observers;
    NSInteger inviteCount;
    
    BOOL isBoss;
}

@property (nonatomic, copy) NSString *animalId;
@property (nonatomic, copy) NSString *animalTypeId;
@property (nonatomic, copy) NSString *animalTypeName;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *created;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) NSInteger level;
@property (nonatomic, assign) NSInteger posseSize;
@property (nonatomic, assign) NSInteger hp;
@property (nonatomic, assign) NSInteger hpMax;
@property (nonatomic, assign) NSInteger hpMaxBoost;
@property (nonatomic, assign) NSInteger energy;
@property (nonatomic, assign) NSInteger energyMax;
@property (nonatomic, assign) NSInteger energyMaxBoost;
@property (nonatomic, assign) NSInteger energyRefreshSeconds, hpRefreshSeconds;
@property (nonatomic, assign) NSInteger mood;
@property (nonatomic, copy) NSString *moodText;
@property (nonatomic, assign) NSInteger atk;
@property (nonatomic, assign) NSInteger atkBoost;
@property (nonatomic, assign) NSInteger def;
@property (nonatomic, assign) NSInteger defBoost;
@property (nonatomic, assign) NSUInteger experience;
@property (nonatomic, assign) NSUInteger expNextLevel;
@property (nonatomic, assign) NSUInteger expTotal;
@property (nonatomic, assign) unsigned long long money, bankFunds;
@property (nonatomic, copy) NSString *image; 
@property (nonatomic, copy) NSString *imageSquare50, *imageSquare75, *imageSquare100, *imageSquare150;
@property (nonatomic, assign) NSInteger respectPoints;
@property (nonatomic, assign) NSInteger reviveSeconds;
@property (nonatomic, retain) NSNumber *hospitalCost;
@property (nonatomic, copy) NSString *friendCode;
@property (nonatomic, copy) NSString *petEnergyCost;
@property (nonatomic, copy) NSString *forageEnergyCost, *energyInitialSecondsToRefresh, *hpInitialSecondsToRefresh;
@property (nonatomic, copy) NSString *wins, *losses, *passiveWins, *passiveLosses, *ranAwayTimes, *achievements, *rank;
@property (nonatomic, assign) NSInteger inviteCount;

@property (nonatomic, assign) NSInteger income, moneyRefreshSeconds;
@property (nonatomic, copy) NSString *moneyInitialSecondsToRefresh;
@property (nonatomic, copy) NSString *bankDepositPercentage, *bankWithdrawalPercentage;


@property (nonatomic, retain) AnimalType *animalType;
@property (nonatomic, retain) Item *weapon;    
@property (nonatomic, retain) Item *armor;
@property (nonatomic, retain) Item *accessory1;
@property (nonatomic, retain) Item *accessory2;
@property (nonatomic, retain) Item *background;

@property (nonatomic, assign) BOOL isBoss;

- (void)setAnimalTypeWithAPIResponse:(NSDictionary *)apiResponse;
- (void)updateWithActionResult:(ActionResult *)actionResult;
- (void)registerObserverToAllProperties:(NSObject *)observer;

/**
 * removes observer
 */
- (void)unregisterObserver:(NSObject *)observer;
- (void)cleanup;

@end
