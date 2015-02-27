/**
 * ProfileViewController.m
 * Copyright Miraphonic, Inc 2009. All rights reserved.
 *
 * @author Amit Matani 
 * @created 2/12/09.
 */

#import "ProfileViewController.h"
#import "BRAppDelegate.h"
#import "RemoteImageViewWithFileStore.h"
#import "Animal.h"
#import "Item.h"
#import "ProfileWithHudViewController.h"
#import "BRSession.h"
#import "ProtagonistAnimal.h"

@implementation ProfileViewController
@synthesize parentController, animalImage, armorImage, weaponImage, accessory1Image, 
            accessory2Image, backgroundView, attackButton, commentButton, achievementButton, 
            posseSize, wins, losses, ranAway, passiveWins, passiveLosses, level, achievements, rank;

- (id)initWithAnimal:(Animal *)_animal {
	if (self = [super initWithNibName:@"ProfileView" bundle:[NSBundle mainBundle]]) {
		animal = [_animal retain];
    }
    return self;
}

- (void)viewDidLoad {
	[animalImage loadImageWithUrl:animal.imageSquare150];
	[weaponImage loadImageWithUrl:animal.weapon.imageSquare75];
	[armorImage loadImageWithUrl:animal.armor.imageSquare75];
	[accessory1Image loadImageWithUrl:animal.accessory1.imageSquare75];
	[accessory2Image loadImageWithUrl:animal.accessory2.imageSquare75];
    
    if (animal.background) {
        [backgroundView loadImageWithUrl:animal.background.iphoneBackgroundImage];
    }
	
	[attackButton addTarget:self action:@selector(attackButtonClicked) forControlEvents:UIControlEventTouchUpInside];
	attackButton.enabled = ![[[BRSession sharedManager] protagonistAnimal].animalId isEqualToString:animal.animalId];
	
	[achievementButton addTarget:self action:@selector(achievementButtonClicked) forControlEvents:UIControlEventTouchUpInside];	
	[commentButton addTarget:self action:@selector(commentButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    posseSize.text = [NSString stringWithFormat:@"%d", animal.posseSize];
    wins.text = animal.wins;
    losses.text = animal.losses;
    ranAway.text = animal.ranAwayTimes;
    passiveWins.text = animal.passiveWins;
    passiveLosses.text = animal.passiveLosses;
	rank.text = animal.rank;
	achievements.text = animal.achievements;
    level.text = [NSString stringWithFormat:@"%d", animal.level];
}

- (void)attackButtonClicked {
	[parentController startBattle];
}

- (void)achievementButtonClicked {
	[[SoundManager sharedManager] playSoundWithType:@"popup" vibrate:NO];	
	[parentController showAchievements];
}

- (void)commentButtonClicked {
	[[SoundManager sharedManager] playSoundWithType:@"popup" vibrate:NO];	
	[parentController showComments];	
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}


- (void)dealloc {
    debug_NSLog(@"deallocing the profile");
    [animalImage release];
    [armorImage release];
    [weaponImage release];
    [accessory1Image release];
    [accessory2Image release];
    [backgroundView release];
    [attackButton release];
    [commentButton release];
    [achievementButton release];
    [posseSize release];
    [wins release];
    [losses release];
    [ranAway release];
    [passiveWins release];
    [passiveLosses release];
    [level release];
	[achievements release];
	[rank release];
    
	[animal release];
    [super dealloc];
}


@end
