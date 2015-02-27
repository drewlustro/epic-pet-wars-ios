//
//  SoundManager.m
//  battleroyale
//
//  Created by Drew Lustro on 4/30/09.
//  Copyright 2009 Miraphonic, Inc. All rights reserved.
//


#import "SoundManager.h"
#import "BRSession.h"


@implementation SoundManager

@synthesize battleLost, battleRun, battleWon,
			buy, sell,
			close, popup,
			flyAttack0, flyAttack1, flyAttack2,
			hit0, hit1, hit2, hit3, hit4,
			itemFound,
			levelUp0, levelUp1,
			powerUp, pet,
			startup,
			spell, spellHit;

@synthesize urlBattleLost, urlBattleRun, urlBattleWon,
			urlBuy, urlSell,
			urlClose, urlPopup,
			urlFlyAttack0, urlFlyAttack1, urlFlyAttack2,
			urlHit0, urlHit1, urlHit2, urlHit3, urlHit4,
			urlItemFound,
			urlLevelUp0, urlLevelUp1,
			urlPowerUp, urlPet,
			urlStartup,
			urlSpell, urlSpellHit;


static SoundManager *sharedSoundManager = nil;

- (id)init {
    if (self = [super init]) {
		
		// Play Sound Example:
		// [[SoundManager sharedManager] playSoundWithType:@"popup" vibrate:NO];
		
		CFBundleRef mainBundle; 
		mainBundle = CFBundleGetMainBundle();
		
		// general UI
		urlPet = CFBundleCopyResourceURL(mainBundle, CFSTR("pet"), CFSTR("wav"), NULL);
		AudioServicesCreateSystemSoundID(urlPet, &pet);
		
		urlBuy = CFBundleCopyResourceURL(mainBundle, CFSTR("buy"), CFSTR("wav"), NULL);
		AudioServicesCreateSystemSoundID(urlBuy, &buy);
		
		urlSell = CFBundleCopyResourceURL(mainBundle, CFSTR("sell"), CFSTR("wav"), NULL);
		AudioServicesCreateSystemSoundID(urlSell, &sell);
		
		urlClose = CFBundleCopyResourceURL(mainBundle, CFSTR("close"), CFSTR("wav"), NULL);
		AudioServicesCreateSystemSoundID(urlClose, &close);
		
		urlPopup = CFBundleCopyResourceURL(mainBundle, CFSTR("popup"), CFSTR("wav"), NULL);
		AudioServicesCreateSystemSoundID(urlPopup, &popup);
		
		urlItemFound = CFBundleCopyResourceURL(mainBundle, CFSTR("itemfound"), CFSTR("wav"), NULL);
		AudioServicesCreateSystemSoundID(urlItemFound, &itemFound);
		
		urlPowerUp = CFBundleCopyResourceURL(mainBundle, CFSTR("powerup"), CFSTR("wav"), NULL);
		AudioServicesCreateSystemSoundID(urlPowerUp, &powerUp);
		
		urlStartup = CFBundleCopyResourceURL(mainBundle, CFSTR("startup"), CFSTR("wav"), NULL);
		AudioServicesCreateSystemSoundID(urlStartup, &startup);
		
		
		
		// battle results
		urlBattleLost = CFBundleCopyResourceURL(mainBundle, CFSTR("battlelost"), CFSTR("wav"), NULL);
		AudioServicesCreateSystemSoundID(urlBattleLost, &battleLost);
		
		urlBattleWon = CFBundleCopyResourceURL(mainBundle, CFSTR("battlewon"), CFSTR("wav"), NULL);
		AudioServicesCreateSystemSoundID(urlBattleWon, &battleWon);
		
		urlBattleRun = CFBundleCopyResourceURL(mainBundle, CFSTR("battlerun"), CFSTR("wav"), NULL);
		AudioServicesCreateSystemSoundID(urlBattleRun, &battleRun);
		
		// battling collections
		urlHit0 = CFBundleCopyResourceURL(mainBundle, CFSTR("hit0"), CFSTR("wav"), NULL);
		AudioServicesCreateSystemSoundID(urlHit0, &hit0);
		urlHit1 = CFBundleCopyResourceURL(mainBundle, CFSTR("hit1"), CFSTR("wav"), NULL);
		AudioServicesCreateSystemSoundID(urlHit1, &hit1);
		urlHit2 = CFBundleCopyResourceURL(mainBundle, CFSTR("hit2"), CFSTR("wav"), NULL);
		AudioServicesCreateSystemSoundID(urlHit2, &hit2);
		urlHit3 = CFBundleCopyResourceURL(mainBundle, CFSTR("hit3"), CFSTR("wav"), NULL);
		AudioServicesCreateSystemSoundID(urlHit3, &hit3);
		urlHit4 = CFBundleCopyResourceURL(mainBundle, CFSTR("hit4"), CFSTR("wav"), NULL);
		AudioServicesCreateSystemSoundID(urlHit4, &hit4);
		
		urlFlyAttack0 = CFBundleCopyResourceURL(mainBundle, CFSTR("flyattack0"), CFSTR("wav"), NULL);
		AudioServicesCreateSystemSoundID(urlFlyAttack0, &flyAttack0);
		urlFlyAttack1 = CFBundleCopyResourceURL(mainBundle, CFSTR("flyattack1"), CFSTR("wav"), NULL);
		AudioServicesCreateSystemSoundID(urlFlyAttack1, &flyAttack1);
		urlFlyAttack2 = CFBundleCopyResourceURL(mainBundle, CFSTR("flyattack2"), CFSTR("wav"), NULL);
		AudioServicesCreateSystemSoundID(urlFlyAttack2, &flyAttack2);
		
		// spell usages
		urlSpell = CFBundleCopyResourceURL(mainBundle, CFSTR("spell"), CFSTR("wav"), NULL);
		AudioServicesCreateSystemSoundID(urlSpell, &spell);
		
		// spell hits
		urlSpellHit = CFBundleCopyResourceURL(mainBundle, CFSTR("spellhit"), CFSTR("wav"), NULL);
		AudioServicesCreateSystemSoundID(urlSpellHit, &spellHit);
		
		// levelup collection
		urlLevelUp0 = CFBundleCopyResourceURL(mainBundle, CFSTR("levelup0"), CFSTR("wav"), NULL);
		AudioServicesCreateSystemSoundID(urlLevelUp0, &levelUp0);
		urlLevelUp1 = CFBundleCopyResourceURL(mainBundle, CFSTR("levelup1"), CFSTR("wav"), NULL);
		AudioServicesCreateSystemSoundID(urlLevelUp1, &levelUp1);
		
	
    }
    return self;
}

+ (SoundManager *)sharedManager {
    @synchronized(self) {
        if (sharedSoundManager == nil) {
            [[self alloc] init]; // assignment not done here
        }
    }
    return sharedSoundManager;
}

+ (id)allocWithZone:(NSZone *)zone {
    @synchronized(self) {
        if (sharedSoundManager == nil) {
            sharedSoundManager = [super allocWithZone:zone];
            return sharedSoundManager;  // assignment and return on first allocation
        }
    }
    return nil; //on subsequent allocation attempts return nil
}

- (void)playSoundWithType:(NSString *)type vibrate:(BOOL)vibrate {		

	int random, count;
	SystemSoundID sound;
	
	if ([type isEqualToString:@"hit"]) {
		srand(time(NULL));
		count = 5;
		random = rand() % count;
		switch (random) {
			case 0:
				sound = self.hit0;
				break;
			case 1:
				sound = self.hit1;
				break;
			case 2:
				sound = self.hit2;
				break;
			case 3:
				sound = self.hit3;
				break;
			case 4:
				sound = self.hit4;
				break;
		}
			
	} else if ([type isEqualToString:@"flyattack"]) {
		srand(time(NULL));
		count = 3;
		random = rand() % count;
		
		switch (random) {
			case 0:
				sound = self.flyAttack0;
				break;
			case 1:
				sound = self.flyAttack1;
				break;
			case 2:
				sound = self.flyAttack2;
				break;
		}
		
	} else if ([type isEqualToString:@"levelup"]) {
		srand(time(NULL));
		count = 2;
		random = rand() % count;
		
		switch (random) {
			case 0:
				sound = self.levelUp0;
				break;
			case 1:
				sound = self.levelUp1;
				break;
		}
		
	} else if ([type isEqualToString:@"spell"]) {
		sound = self.spell;
	} else if ([type isEqualToString:@"spellhit"]) {
		sound = self.spellHit;
	} else if ([type isEqualToString:@"battlelost"]) {
		sound = self.battleLost;
	} else if ([type isEqualToString:@"battlerun"]) {
		sound = self.battleRun;
	} else if ([type isEqualToString:@"battlewon"]) {
		sound = self.battleWon;
	} else if ([type isEqualToString:@"buy"]) {
		sound = self.buy;
	} else if ([type isEqualToString:@"sell"]) {
		sound = self.sell;
	} else if ([type isEqualToString:@"close"]) {
		sound = self.close;
	} else if ([type isEqualToString:@"popup"]) {
		sound = self.popup;
	} else if ([type isEqualToString:@"pet"]) {
		sound = self.pet;
	} else if ([type isEqualToString:@"itemfound"]) {
		sound = self.itemFound;
	} else if ([type isEqualToString:@"startup"]) {
		sound = self.startup;
	} else if ([type isEqualToString:@"powerup"]) {
		sound = self.powerUp;
	}
	
	// play sound / vibrate
	[self playSoundID:sound];
		
	if (vibrate) {
		[self vibrate];
	}
}

- (void)playSoundID:(SystemSoundID)sound {
    if ([BRSession sharedManager].canPlaySounds) {
        AudioServicesPlaySystemSound(sound);
    }
}

- (void)vibrate {
    if ([BRSession sharedManager].canPlayVibration) {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    }
}

- (void)dealloc {
	
	// kill all SystemSoundID's
	AudioServicesDisposeSystemSoundID(battleLost);
	AudioServicesDisposeSystemSoundID(battleWon);
	AudioServicesDisposeSystemSoundID(battleRun);
	AudioServicesDisposeSystemSoundID(buy);
	AudioServicesDisposeSystemSoundID(sell);
	AudioServicesDisposeSystemSoundID(close);
	AudioServicesDisposeSystemSoundID(popup);
	AudioServicesDisposeSystemSoundID(pet);
	AudioServicesDisposeSystemSoundID(itemFound);
	AudioServicesDisposeSystemSoundID(startup);
	AudioServicesDisposeSystemSoundID(powerUp);
	AudioServicesDisposeSystemSoundID(hit0);
	AudioServicesDisposeSystemSoundID(hit1);
	AudioServicesDisposeSystemSoundID(hit2);
	AudioServicesDisposeSystemSoundID(hit3);
	AudioServicesDisposeSystemSoundID(hit4);
	AudioServicesDisposeSystemSoundID(flyAttack0);
	AudioServicesDisposeSystemSoundID(flyAttack1);
	AudioServicesDisposeSystemSoundID(flyAttack2);
	AudioServicesDisposeSystemSoundID(levelUp0);
	AudioServicesDisposeSystemSoundID(levelUp1);	
	AudioServicesDisposeSystemSoundID(spell);
	AudioServicesDisposeSystemSoundID(spellHit);
	
	// kill all urlRef's
	CFRelease(urlBattleLost);
	CFRelease(urlBattleWon);
	CFRelease(urlBattleRun);
	CFRelease(urlBuy);
	CFRelease(urlSell);
	CFRelease(urlClose);
	CFRelease(urlPopup);
	CFRelease(urlPet);
	CFRelease(urlItemFound);
	CFRelease(urlStartup);
	CFRelease(urlPowerUp);
	CFRelease(urlHit0);
	CFRelease(urlHit1);
	CFRelease(urlHit2);
	CFRelease(urlHit3);
	CFRelease(urlHit4);
	CFRelease(urlFlyAttack0);
	CFRelease(urlFlyAttack1);
	CFRelease(urlFlyAttack2);
	CFRelease(urlLevelUp0);
	CFRelease(urlLevelUp1);
	CFRelease(urlSpell);

	CFRelease(urlSpellHit);

    
    [super dealloc];

}

@end
