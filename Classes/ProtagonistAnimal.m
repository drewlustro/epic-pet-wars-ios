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

#import <AudioToolbox/AudioToolbox.h>

#import "ProtagonistAnimal.h"
#import "BRRestClient.h"
#import "Item.h"
#import "OwnedEquipmentSet.h"
#import "Job.h"
#import "ActionResult.h"
#import "BRAppDelegate.h"
#import "BRTabManager.h"
#import "EarnedAchievementRemoteCollection.h"
#import "PosseAnimalRemoteCollection.h"
#import "NewsFeedRemoteCollection.h"
#import "HomeViewController.h"
#import "NewsfeedItem.h"
#import "ExternalAction.h"
#import "Consts.h"
#import "NewsFeedViewController.h"
#import "InviteOptionsViewController.h"
#import "BRSession.h"
#import "EquipmentSet.h"
#import "ShopEquipmentSet.h"
#import "ProtagonistAnimalItemManager.h"
#import "BRDialog.h"
#import "FBStreamDialog.h"

@implementation ProtagonistAnimal

@synthesize timeLeftToEnergyRefresh, equipment, timeLeftToRevive, earnedAchievements, posse, inBattle, timeLeftToHpRefresh, 
			timeLeftToMoneyRefresh, fBDialogDelegate = _fBDialogDelegate, pendingTemplateItem,
			storeKeys = _storeKeys, storeValues = _storeValues, myItemKeys = _myItemKeys, myItemValues = _myItemValues,
			itemManager = _itemManager;

- (id)initWithApiResponse:(NSDictionary *)apiResponse {
    if (self = [super initWithApiResponse:apiResponse]) {
		self.storeKeys = [apiResponse objectForKey:@"store_keys"];
		self.storeValues = [apiResponse objectForKey:@"store_values"];
		
		self.myItemKeys = [apiResponse objectForKey:@"my_item_keys"];
		self.myItemValues = [apiResponse objectForKey:@"my_item_values"];
		
        equipment = [[OwnedEquipmentSet alloc] initWithCategoryKeys:_myItemKeys categoryNames:_myItemValues];
		
		earnedAchievements = [[EarnedAchievementRemoteCollection alloc] initWithAnimalId:self.animalId];
		posse = [[PosseAnimalRemoteCollection alloc] init];
		
		[[[BRSession sharedManager] shopItems] resetWithNewCategoryKeys:_storeKeys categoryNames:_storeValues];
		
		_itemManager = [[ProtagonistAnimalItemManager alloc] initWithProtagonistAnimal:self];
		
		pollingInterval = 60;
        [self performSelector:@selector(checkForExternalActions) withObject:nil afterDelay:10];
	}
	return self;
}

#pragma mark HP related functions
- (void)setHp:(NSInteger)_value {
	int oldHp = hp;
	[super setHp:_value];
	if (hp == 0) {
		[[[BRAppDelegate sharedManager] tabManager] handleDeath];
	} else if (oldHp == 0 && hp > 0) {
		[[[BRAppDelegate sharedManager] tabManager] handleRevive];		
	} else if (hpRefreshSeconds > 0) {
        if ([self doesAnimalNeedMoreHp]) {
            if (oldHp == hpMax + hpMaxBoost) {
                [self setSecondsToHpRefresh:hpRefreshSeconds];    
            }
        } else {
            hpTimerActive = NO;
            self.timeLeftToHpRefresh = 0;
        }
    }
}

- (void)startCentralTimer {
    if (![centralTimer isValid]) {
        [centralTimer release];
        centralTimer = [[NSTimer timerWithTimeInterval:1 target:self selector:@selector(centralTimerAction:) userInfo:nil repeats:YES] retain];
        [[NSRunLoop currentRunLoop] addTimer:centralTimer forMode:NSDefaultRunLoopMode];    
    }
}

- (void)centralTimerAction:(NSTimer *)timer {
    if (hpTimerActive) {
        [self updateSecondsToHpRefresh];
    }
    
    if (moneyTimerActive) {
        [self updateSecondsToMoneyRefresh];        
    }
    
    if (energyTimerActive) {
        [self updateSecondsToEnergyRefresh];                
    }
    
    if (!hpTimerActive && !moneyTimerActive && !energyTimerActive) {
        [centralTimer invalidate];
    }
}

- (void)setSecondsToHpRefresh:(NSInteger)refreshSeconds {
    self.timeLeftToHpRefresh = refreshSeconds;
    hpTimerActive = YES;
    [self startCentralTimer];
    
    
    //debug_NSLog(@"refresh hp seconds %d", refreshSeconds);
}

- (void)updateSecondsToHpRefresh {
    //debug_NSLog(@"refresh hp seconds %d", timeLeftToHpRefresh);
    if (inBattle || hp <= 0) {
        
    } else if (timeLeftToHpRefresh <= 0) {
        hpTimerActive = NO;        
        if ([self doesAnimalNeedMoreHp]) {
            [[BRRestClient sharedManager] animal_updateHp:self 
                                             finishedSelector:@selector(handleFinishedHpUpdate:parsedResponse:)
                                               failedSelector:@selector(handleFailedHpUpdate)];
            debug_NSLog(@"sending hp request");
        }
    } else {
        self.timeLeftToHpRefresh -= 1;
    }
}

- (void)handleFinishedHpUpdate:(NSNumber *)responseInt parsedResponse:(NSDictionary *)parsedResponse {
    if ([BRRestClient isResponseSuccessful:responseInt]) {
        ActionResult *actionResult = 
            [[ActionResult alloc] initWithApiResponse:[parsedResponse objectForKey:@"action_result"]];
        [self updateWithActionResult:actionResult];
        [actionResult release];
    }
    if ([self doesAnimalNeedMoreHp]) {
        [self setSecondsToHpRefresh:hpRefreshSeconds];            
    }
}

- (void)handleFailedHpUpdate {
    
}



/**
 * setEnergyRefreshSeconds overrides the refresh setter so
 * we can set a timer up.  We assume energy last refreshed is
 * set first. It really only has to do this on the initial setup 
 */
- (void)setHpRefreshSeconds:(NSInteger)refreshSeconds {
    hpRefreshSeconds = refreshSeconds;
    if ([self doesAnimalNeedMoreHp] && hpRefreshSeconds > 0) {
        [self setSecondsToHpRefresh:[hpInitialSecondsToRefresh intValue]];        
    }    
}


#pragma mark Money Related Functions
- (void)setIncome:(NSInteger)_value {
    income = _value;
    if (income != 0) {
        // check if the timer is already running, if so we do not care
        if (!moneyTimerActive && moneyRefreshSeconds > 0) {
            [self setSecondsToMoneyRefresh:moneyRefreshSeconds];
        }
    } else { // we need to stop the timer if it is running
        moneyTimerActive = NO;        
        self.timeLeftToMoneyRefresh = 0;
    }
}

- (void)setMoneyInitialSecondsToRefresh:(NSString *)_value {
    if (_value != moneyInitialSecondsToRefresh) {
        [moneyInitialSecondsToRefresh release];
        moneyInitialSecondsToRefresh = [_value copy];
        
        int seconds = [moneyInitialSecondsToRefresh intValue];
        if (seconds > 0) {
            [self setSecondsToMoneyRefresh:seconds];
        }
    }
    
}

- (void)setSecondsToMoneyRefresh:(NSInteger)refreshSeconds {
    self.timeLeftToMoneyRefresh = refreshSeconds;
    moneyTimerActive = YES;
    [self startCentralTimer];    
    
    debug_NSLog(@"set money seconds %d", refreshSeconds);
}


- (void)updateSecondsToMoneyRefresh {
    //debug_NSLog(@"refresh money seconds %d", timeLeftToMoneyRefresh);
    if (timeLeftToMoneyRefresh <= 0) {
        [[BRRestClient sharedManager] animal_updateMoney:self 
                                     finishedSelector:@selector(handleFinishedMoneyUpdate:parsedResponse:)
                                       failedSelector:@selector(handleFailedMoneyUpdate)];
        debug_NSLog(@"sending money request");
        moneyTimerActive = NO;
    } else {
        self.timeLeftToMoneyRefresh -= 1;
    }
}

- (void)handleFinishedMoneyUpdate:(NSNumber *)responseInt parsedResponse:(NSDictionary *)parsedResponse {
    if ([BRRestClient isResponseSuccessful:responseInt]) {
        ActionResult *actionResult = 
            [[ActionResult alloc] initWithApiResponse:[parsedResponse objectForKey:@"action_result"]];
        [self updateWithActionResult:actionResult];
        [actionResult release];
    }
    [self setSecondsToMoneyRefresh:moneyRefreshSeconds];
}

- (void)handleFailedMoneyUpdate {
    
}

#pragma mark Energy Related Functions

- (void)setEnergy:(NSInteger)_value {
    int oldEnergy = energy;
	if (_value < 0) {
		energy = 0;
	} else if (_value > energyMax + energyMaxBoost) {
		energy = energyMax + energyMaxBoost;
	} else {
		energy = _value;
	}
    if (energyRefreshSeconds > 0) {
        if ([self doesAnimalNeedMoreEnergy]) {
            if (oldEnergy == energyMax + energyMaxBoost) {
                [self setSecondsToEnergyRefresh:energyRefreshSeconds];    
            }
        } else {
            energyTimerActive = NO;
            self.timeLeftToEnergyRefresh = 0;            
        }
    }
}


/**
 * setEnergyRefreshSeconds overrides the refresh setter so
 * we can set a timer up.  We assume energy last refreshed is
 * set first. It really only has to do this on the initial setup 
 */
- (void)setEnergyRefreshSeconds:(NSInteger)refreshSeconds {
    energyRefreshSeconds = refreshSeconds;
    if ([self doesAnimalNeedMoreEnergy]) {
        [self setSecondsToEnergyRefresh:[energyInitialSecondsToRefresh intValue]];        
    }    
}

- (void)setSecondsToEnergyRefresh:(NSInteger)refreshSeconds {
    self.timeLeftToEnergyRefresh = refreshSeconds;
    energyTimerActive = YES;
    [self startCentralTimer];
    //debug_NSLog(@"refresh seconds %d", refreshSeconds);
}

- (void)updateSecondsToEnergyRefresh {
    //debug_NSLog(@"refresh seconds %d", timeLeftToEnergyRefresh);    
    if (timeLeftToEnergyRefresh <= 0 && [self doesAnimalNeedMoreEnergy]) {
        [[BRRestClient sharedManager] animal_updateEnergy:self 
										 finishedSelector:@selector(handleFinishedEnergyUpdate:parsedResponse:)
                                           failedSelector:@selector(handleFailedEnergyUpdate)];
        energyTimerActive = NO;
    } else {
        self.timeLeftToEnergyRefresh -= 1;
    }
}

- (void)handleFinishedEnergyUpdate:(NSNumber *)responseInt parsedResponse:(NSDictionary *)parsedResponse {
    if ([BRRestClient isResponseSuccessful:responseInt]) {
        ActionResult *actionResult = 
            [[ActionResult alloc] initWithApiResponse:[parsedResponse objectForKey:@"action_result"]];
        [self updateWithActionResult:actionResult];
        [actionResult release];
    }
    if ([self doesAnimalNeedMoreEnergy]) {
        [self setSecondsToEnergyRefresh:energyRefreshSeconds];            
    }
}

- (void)handleFailedEnergyUpdate {
    
}

#pragma mark Revive Functions
- (void)setReviveSeconds:(NSInteger)_value {
	reviveSeconds = _value;
	if (hp == 0) {
		self.timeLeftToRevive = reviveSeconds;
        
        [reviveTimer invalidate];
        [reviveTimer release];
        reviveTimer = [[NSTimer timerWithTimeInterval:1 target:self selector:@selector(decrementReviveSeconds:) userInfo:nil repeats:YES] retain];
        [[NSRunLoop currentRunLoop] addTimer:reviveTimer forMode:NSDefaultRunLoopMode];
	}
}
		
- (void)decrementReviveSeconds:(NSTimer *)timer {
    
    debug_NSLog(@"decrement revive seconds");
	if (hp > 0) { 
        [timer invalidate];
        return; 
    }
	self.timeLeftToRevive -= 1;
	if (timeLeftToRevive <= 0) {
        [[BRRestClient sharedManager] animal_autoRevive:self
									  finishedSelector:@selector(handleFinishedAutoRevive:parsedResponse:)
									  failedSelector:@selector(handleFailedAutoRevive)];
        [timer invalidate];
	}
}

- (void)handleFinishedAutoRevive:(NSNumber *)responseInt parsedResponse:(NSDictionary *)parsedResponse {
    if ([BRRestClient isResponseSuccessful:responseInt]) {
		ActionResult *ar = [[ActionResult alloc] initWithApiResponse:[parsedResponse objectForKey:@"action_result"]];
		[self updateWithActionResult:ar];
		[ar release];
    } else {
		[self handleFailedAutoRevive];
	}
}

- (void)handleFailedAutoRevive {
    
}

- (void)setLevel:(NSInteger)_value {
    int oldLevel = level;
    level = _value;
    
    if (oldLevel > 0 && oldLevel != level) {
        [[[BRSession sharedManager] shopItems] reset];
    }
}


- (void)setInviteCount:(NSInteger)_value {
    inviteCount = _value;
    [[[[BRAppDelegate sharedManager] tabManager] inviteOptionsViewController] updateInviteCount:_value];
}

- (BOOL)isEquiped:(Item *)item inSlot:(NSInteger)slot {
    if ([item.categoryKey isEqualToString:@"accessory"]) {
        if (slot == 0) {
            return [item isSameItem:self.accessory1];
        } else {
            return [item isSameItem:self.accessory2];            
        }
    }
    return [self numEquiped:item] > 0;
}

/**
 * num equiped returns the number of times that the
 * item is equiped.  Usually this is only 1 if the item 
 * is equiped because only accessories can be equiped twice
 */ 
- (int)numEquiped:(Item *)item {
    int num = 0;
    if ([item.categoryKey isEqualToString:@"accessory"]) {
        num = ([item isSameItem:self.accessory1] ? 1 : 0) +
              ([item isSameItem:self.accessory2] ? 1 : 0);
    } else if ([item.categoryKey isEqualToString:@"weapon"]) {
        num = [item isSameItem:self.weapon] ? 1 : 0;
    } else if ([item.categoryKey isEqualToString:@"armor"]) {
        num = [item isSameItem:self.armor] ? 1 : 0;
    } else if ([item.categoryKey isEqualToString:@"background"]) {
        num = [item isSameItem:self.background] ? 1 : 0;
	}
    return num;
}

- (void)equipItem:(Item *)item inPosition:(NSString *)position {
	
	// sound effects
	if (item == nil) {
		[[SoundManager sharedManager] playSoundWithType:@"close" vibrate:NO];
	} else {
		[[SoundManager sharedManager] playSoundWithType:@"pet" vibrate:NO];
	}
	
	Item *oldItem;
    if ([position isEqualToString:@"accessory1"]) {
        oldItem = [accessory1 retain];
        self.accessory1 = item;        
    } else if ([position isEqualToString:@"accessory2"]) {
        oldItem = [accessory2 retain];
        self.accessory2 = item;
    } else if ([position isEqualToString:@"weapon"]) {
        oldItem = [weapon retain];
        self.weapon = item;        
    } else if ([position isEqualToString:@"armor"]) {
        oldItem = [armor retain];
        self.armor = item;
    } else if ([position isEqualToString:@"background"]) {
		oldItem = [background retain];
		self.background = item;
	}

    
    [oldItem release];
}

- (void)setPendingTemplateItem:(NSDictionary *)templateItem {
	[pendingTemplateItem release];
	pendingTemplateItem = [templateItem retain];
	[[BRSession sharedManager] resumeFacebookSession:self];
}

- (void)updateWithActionResult:(ActionResult *)actionResult {
	BOOL alreadyRefreshingHP = [self doesAnimalNeedMoreHp];
	BOOL alreadyRefreshingEnergy = [self doesAnimalNeedMoreEnergy];
    
	[super updateWithActionResult:actionResult];
	if (actionResult.item != nil) {
		Item *userItem = [equipment getItemInSetMatchingItem:actionResult.item];
		if (userItem != nil) {
			userItem.numOwned += [actionResult getItemCount];
		} else {
			[equipment addItem:actionResult.item];
			actionResult.item.numOwned = [actionResult getItemCount];
		}
	}
    if (actionResult.fbTemplateItem != nil || actionResult.fbRequiredExtendedPermission != nil) {
        if (actionResult.fbTemplateItem != nil) {
            [pendingTemplateItem release];
            pendingTemplateItem = [actionResult.fbTemplateItem retain];
        } else {
            [_pendingRequiredExtendedPermission release];
            _pendingRequiredExtendedPermission = [actionResult.fbRequiredExtendedPermission copy];
        }
		[[BRSession sharedManager] resumeFacebookSession:self];
    }
    
    // corrections for data consistency
    if (actionResult.correctHp != nil) {
        self.hp = [actionResult.correctHp intValue];        
    }
    
    if (actionResult.correctEnergy != nil) {
        self.energy = [actionResult.correctEnergy intValue];        
    }
    
    if (actionResult.correctMoney != nil) {
        self.money = [actionResult.correctMoney intValue];        
    }
	
	if (!alreadyRefreshingHP && [self doesAnimalNeedMoreHp]) {
        [self setSecondsToHpRefresh:hpRefreshSeconds];
    }
	
	if (!alreadyRefreshingEnergy && [self doesAnimalNeedMoreEnergy]) {
        [self setSecondsToEnergyRefresh:energyRefreshSeconds];
    }
	
	if (actionResult.popupHTML != nil) {
		BRDialog *dialog = [[BRDialog alloc] initWithHTML:actionResult.popupHTML];
		[dialog show];
		[dialog release];
	}
}

- (void)addAnimalToPosse:(Animal *)animal {
	self.posseSize += 1;
	[self.posse insertObject:animal atIndex:0];
}


/**
 * updateRefreshSeconds will update the refresh seconds and start
 * a timer
 */
- (void)updateRefreshSeconds {
    [self setSecondsToEnergyRefresh:timeLeftToEnergyRefresh - 1];    
}

- (BOOL)doesAnimalNeedMoreEnergy {
    return energy < energyMax + energyMaxBoost;
}

- (BOOL)doesAnimalNeedMoreHp {
    return hp < hpMax + hpMaxBoost;
}

#pragma mark Job helpers
- (BOOL)canPerformJob:(Job *)job {
	// add the items thing in
    return (self.money >= job.requiresMoney && 
		   self.energy >= job.requiresEnergy &&
		   self.level >= job.requiresLevel &&
			self.posseSize >= job.requiresPosse);
}

#pragma mark external action polling 
- (void)cancelExternalActionChecks {
	[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(checkForExternalActions) object:nil];        
}

- (void)checkForExternalActions {
    [self cancelExternalActionChecks];
    debug_NSLog(@"Checking for external action");
	[[BRRestClient sharedManager] animal_getExternalActions:self 
								  finishedSelector:@selector(finishedCheckingForExternalActions:parsedResponse:) 
								  failedSelector:@selector(failedCheckingForExternalActions)];
}

- (void)finishedCheckingForExternalActions:(NSNumber *)responseInt parsedResponse:(NSDictionary *)parsedResponse {
	if ([BRRestClient isResponseSuccessful:responseInt]) {
		NSNumber *newPollingInterval = [parsedResponse objectForKey:@"polling_interval"];
		if (newPollingInterval != nil && (id)newPollingInterval != [NSNull null]) {
			CGFloat temp = [newPollingInterval intValue];
			if (temp > 0) { pollingInterval = temp; }
		}
		ActionResult *actionResult = [[ActionResult alloc] initWithApiResponse:[parsedResponse objectForKey:@"action_result"]];
		
		[self updateWithActionResult:actionResult];
		
		[actionResult release];
		
		NSArray *newsfeedItems = [parsedResponse objectForKey:@"newsfeed_items"];
		if (newsfeedItems != nil && (id)newsfeedItems != [NSNull null] && [newsfeedItems count] > 0) {
			for (NSDictionary *newsfeedDict in newsfeedItems) {
				NewsfeedItem *item = [[NewsfeedItem alloc] initWithApiResponse:newsfeedDict];
				[[[[[BRAppDelegate sharedManager] tabManager] homeController] newsFeedViewController] addNewsFeedItemToTop:item];
				[item release];
			}
			[[[[BRAppDelegate sharedManager] tabManager] homeController] increaseBadgeValue:[newsfeedItems count]];
		}
        
        
        NSArray *externalActions = [parsedResponse objectForKey:@"external_actions"];
        NSString *explanation = nil;
		if (externalActions != nil && (id)externalActions != [NSNull null] && [externalActions count] > 0) {
			for (NSDictionary *externalActionDict in externalActions) {
				ExternalAction *item = [[ExternalAction alloc] initWithApiResponse:externalActionDict];
                if ((item.newsfeedTemplateId == nil || [item.newsfeedTemplateId isEqualToString:@"0"]) && 
                    (item.explanation != nil && ![item.explanation isEqualToString:@""])) {
                    // TODO set a height and width on this
                    if (explanation == nil) {
                        explanation = [item.explanation copy];
                    } else {
                        NSString *temp = explanation;
                        explanation = [[NSString alloc] initWithFormat:@"%@\n<br>%@", explanation, item.explanation];
                        [temp release];
                    }
                }
				[item release];
			}

			if (explanation != nil) {
                [[BRAppDelegate sharedManager] showPlainTextNotification:explanation];     
                [explanation release];
            }
			
			// issue a sound on external actions coming in
			[[SoundManager sharedManager] playSoundWithType:@"pet" vibrate:NO];
		}
	}
	[self performSelector:@selector(checkForExternalActions) withObject:nil afterDelay:pollingInterval];
}

- (void)setInBattle:(BOOL)_inBattle {
    inBattle = _inBattle;
    if (inBattle) {
        [self cancelExternalActionChecks];
    } else {
        [self checkForExternalActions];        
    }
}

- (void)cleanup {
    [super cleanup];
    [reviveTimer invalidate];
    [centralTimer invalidate];
}

- (void)failedCheckingForExternalActions {
	pollingInterval *= 2;
	[self performSelector:@selector(checkForExternalActions) withObject:nil afterDelay:pollingInterval];        

}

#pragma mark FBSession delegates
- (void)session:(FBSession*)_session didLogin:(FBUID)uid {
    FBDialog *dialog = nil;
    
    if (pendingTemplateItem != nil) {
        dialog = [[[FBStreamDialog alloc] init] autorelease];
		// have something in here that replaces the <source_user> with a facebook_user_id
		NSString *fbUserId = [[NSString alloc] initWithFormat:@"%qu", uid];
		
        ((FBStreamDialog *)dialog).attachment = 
			[[pendingTemplateItem objectForKey:@"attachment"] stringByReplacingOccurrencesOfString:@"<source_user>" withString:fbUserId];
        ((FBStreamDialog *)dialog).actionLinks = 
			[[pendingTemplateItem objectForKey:@"actionLinks"] stringByReplacingOccurrencesOfString:@"<source_user>" withString:fbUserId];
        ((FBStreamDialog *)dialog).targetId = 
			[[pendingTemplateItem objectForKey:@"targetId"] stringByReplacingOccurrencesOfString:@"<source_user>" withString:fbUserId];
        ((FBStreamDialog *)dialog).userMessagePrompt = 
			[[pendingTemplateItem objectForKey:@"userMessagePrompt"] stringByReplacingOccurrencesOfString:@"<source_user>" withString:fbUserId];
		
		[fbUserId release];
		 
    } else if (_pendingRequiredExtendedPermission != nil) {
        dialog = [[[FBPermissionDialog alloc] init] autorelease];
        ((FBPermissionDialog *)dialog).permission = _pendingRequiredExtendedPermission;
        
        [_pendingRequiredExtendedPermission release];
        _pendingRequiredExtendedPermission = nil;
    }
	
	if (dialog != nil) {
		dialog.delegate = self;//_fBDialogDelegate;
		[dialog show];
	}
}

- (void)cleanupPendingDialog {
	[pendingTemplateItem release];
	pendingTemplateItem = nil;
}
#pragma mark FBDialogDelegate actions
- (void)dialogDidSucceed:(FBDialog*)dialog {
	if ([_fBDialogDelegate respondsToSelector:@selector(dialogDidSucceed:)]) {
		[_fBDialogDelegate dialogDidSucceed:dialog];
	}
	
	if (pendingTemplateItem != nil) {
		// TODO call the link that tells the server to create the stuff
		[[BRRestClient sharedManager] animal_streamPublishAttempted:[[FBSession session] uid] callback:[pendingTemplateItem objectForKey:@"callback"]];
		[self cleanupPendingDialog];
	}
}

/**
 * Called when the dialog is cancelled and is about to be dismissed.
 */
- (void)dialogDidCancel:(FBDialog*)dialog {
	if ([_fBDialogDelegate respondsToSelector:@selector(dialogDidCancel:)]) {
		[_fBDialogDelegate dialogDidCancel:dialog];
	}
	if (pendingTemplateItem != nil) {
		[self cleanupPendingDialog];
	}
}

/**
 * Called when dialog failed to load due to an error.
 */
- (void)dialog:(FBDialog*)dialog didFailWithError:(NSError*)error {
	if ([_fBDialogDelegate respondsToSelector:@selector(dialog:didFailWithError:)]) {
		[_fBDialogDelegate dialog:dialog didFailWithError:error];
	}
	if (pendingTemplateItem != nil) {
		[self cleanupPendingDialog];
	}
}



- (void)dealloc {    
    debug_NSLog(@"deallocing protag");
    [pendingTemplateItem release];
    [fbSession release];
    [equipment release];
	[earnedAchievements release];
    [centralTimer release];
    [reviveTimer release];
    [posse release];
	[_itemManager release];
    [super dealloc];
}

@end
