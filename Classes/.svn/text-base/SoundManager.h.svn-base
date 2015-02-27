//
//  SoundManager.h
//  battleroyale
//
//  Created by Drew Lustro on 4/30/09.
//  Copyright 2009 Miraphonic, Inc. All rights reserved.
//

#import "Consts.h"
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#include <AudioToolbox/AudioToolbox.h>

@interface SoundManager : NSObject {
	
	CFURLRef	urlBattleLost, urlBattleRun, urlBattleWon,
				urlBuy, urlSell,
				urlClose, urlPopup,
				urlFlyAttack0, urlFlyAttack1, urlFlyAttack2,
				urlHit0, urlHit1, urlHit2, urlHit3, urlHit4,
				urlItemFound,
				urlLevelUp0, urlLevelUp1,
				urlPowerUp, urlPet,
				urlStartup,
				urlSpell, urlSpellHit;
	
	SystemSoundID	battleLost, battleRun, battleWon,
					buy, sell,
					close, popup,
					flyAttack0, flyAttack1, flyAttack2,
					hit0, hit1, hit2, hit3, hit4,
					itemFound,
					levelUp0, levelUp1,
					powerUp, pet,
					startup,
					spell, spellHit;
}

+ (SoundManager *)sharedManager;
- (void)playSoundWithType:(NSString *)type vibrate:(BOOL)vibrate;
- (void)playSoundID:(SystemSoundID)sound;
- (void) vibrate;

@property (readwrite)	CFURLRef urlBattleLost, urlBattleRun, urlBattleWon,
								urlBuy, urlSell,
								urlClose, urlPopup,
								urlFlyAttack0, urlFlyAttack1, urlFlyAttack2,
								urlHit0, urlHit1, urlHit2, urlHit3, urlHit4,
								urlItemFound,
								urlLevelUp0, urlLevelUp1,
								urlPowerUp, urlPet,
								urlStartup,
								urlSpell, urlSpellHit;

@property (readonly)	SystemSoundID	battleLost, battleRun, battleWon,
										buy, sell,
										close, popup,
										flyAttack0, flyAttack1, flyAttack2,
										hit0, hit1, hit2, hit3, hit4,
										itemFound,
										levelUp0, levelUp1,
										powerUp, pet,
										startup,
										spell, spellHit;
										

@end
