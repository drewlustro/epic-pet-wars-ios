/**
 * ProtagonistAnimal.m
 * Copyright Miraphonic, Inc 2009. All rights reserved.
 *
 * ProtagonistAnimal adds functionality to the Animal class reserved
 * for the user's animal
 *
 * @author Amit Matani
 * @created 1/14/09
 */

#import <Foundation/Foundation.h>
#import "Animal.h"
#import "FBConnect/FBConnect.h"


@class OwnedEquipmentSet, Job, EarnedAchievementRemoteCollection, PosseAnimalRemoteCollection, ProtagonistAnimalItemManager;
@interface ProtagonistAnimal : Animal <FBSessionDelegate, FBDialogDelegate> {
    NSInteger timeLeftToEnergyRefresh, timeLeftToRevive, timeLeftToHpRefresh, timeLeftToMoneyRefresh;
    OwnedEquipmentSet *equipment;
	CGFloat pollingInterval;
	EarnedAchievementRemoteCollection *earnedAchievements;
	PosseAnimalRemoteCollection *posse;
    NSTimer *reviveTimer;
    BOOL inBattle, hpTimerActive, moneyTimerActive, energyTimerActive;
    NSTimer *centralTimer;
    
    FBSession *fbSession;
	id<FBDialogDelegate> _fBDialogDelegate;
    NSDictionary *pendingTemplateItem;
    NSString *_pendingRequiredExtendedPermission;
	
	NSArray *_topListKeys, *_topListValues, *_storeKeys, *_storeValues, *_myItemKeys, *_myItemValues;
	
	ProtagonistAnimalItemManager *_itemManager;
}

@property (nonatomic, assign) NSInteger timeLeftToEnergyRefresh, timeLeftToRevive, timeLeftToHpRefresh, timeLeftToMoneyRefresh;
@property (nonatomic, readonly) OwnedEquipmentSet *equipment;
@property (nonatomic, readonly) EarnedAchievementRemoteCollection *earnedAchievements;
@property (nonatomic, readonly) PosseAnimalRemoteCollection *posse;
@property (nonatomic, assign) BOOL inBattle;
@property (nonatomic, assign) id<FBDialogDelegate> fBDialogDelegate;
@property (nonatomic, retain) NSDictionary *pendingTemplateItem;
@property (nonatomic, retain) NSArray *storeKeys, *storeValues, *myItemKeys, *myItemValues;
@property (readonly) ProtagonistAnimalItemManager *itemManager;

/**
 * updateRefreshSeconds will update the refresh seconds and start
 * a timer
 */
- (void)updateRefreshSeconds;
- (void)updateSecondsToMoneyRefresh;
- (void)updateSecondsToHpRefresh;
- (void)updateSecondsToEnergyRefresh;
- (void)updateWithActionResult:(ActionResult *)actionResult;

- (void)setSecondsToEnergyRefresh:(NSInteger)refreshSeconds;
- (void)setSecondsToHpRefresh:(NSInteger)refreshSeconds;
- (void)setSecondsToMoneyRefresh:(NSInteger)refreshSeconds;


- (BOOL)doesAnimalNeedMoreEnergy;
- (BOOL)doesAnimalNeedMoreHp;

- (BOOL)isEquiped:(Item *)item inSlot:(NSInteger)slot;

- (int)numEquiped:(Item *)item;

- (void)equipItem:(Item *)item inPosition:(NSString *)position;

- (BOOL)canPerformJob:(Job *)job;

- (void)checkForExternalActions;
- (void)cancelExternalActionChecks;


- (void)handleFailedAutoRevive;
- (void)addAnimalToPosse:(Animal *)animal;

- (void)startCentralTimer;
- (void)centralTimerAction:(NSTimer *)timer;

- (void)checkForExternalActions;

@end
