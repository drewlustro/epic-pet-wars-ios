/**
 * AnimalType.h
 * Copyright Miraphonic, Inc 2009. All rights reserved.
 *
 * AnimalType is a rest object that handles the default animal types
 *
 * @author Amit Matani
 * @created 1/14/09
 */

#import <Foundation/Foundation.h>
#import "AbstractRestRequestedModel.h"

@interface AnimalType : AbstractRestRequestedModel {
    NSString *typeId;
    NSString *name;
    NSString *details;
    NSString *image;
    NSString *baseHp;
    NSString *baseEnergy;
    NSString *baseEnergyRefreshSeconds;
	NSString *baseMoneyRefreshSeconds;
	NSString *baseHpRefreshSeconds;
    NSString *baseMood;
    NSString *baseAttack;
    NSString *baseDefense;
    NSString *imageSquare75, *imageSquare150;
    BOOL locked;
    NSString *lockedReason;    
}
@property (nonatomic, copy) NSString *typeId;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *details;
@property (nonatomic, copy) NSString *image;
@property (nonatomic, copy) NSString *baseHp;
@property (nonatomic, copy) NSString *baseEnergy;
@property (nonatomic, copy) NSString *baseEnergyRefreshSeconds, *baseMoneyRefreshSeconds, *baseHpRefreshSeconds;
@property (nonatomic, copy) NSString *baseMood;
@property (nonatomic, copy) NSString *baseAttack;
@property (nonatomic, copy) NSString *baseDefense;
@property (nonatomic, assign) BOOL locked;
@property (nonatomic, copy) NSString *lockedReason;    
@property (nonatomic, copy) NSString *imageSquare75, *imageSquare150;
@end
