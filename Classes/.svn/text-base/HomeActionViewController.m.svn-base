/**
 * HomeActionViewController.h
 * Copyright Miraphonic, Inc 2009. All rights reserved.
 *
 * HomeActionViewController is a tableHeaderView for the newsfeed table.
 * It is the main view of the home screen.  From it, users can perform 
 * single player actions and use items.
 *
 * @author Amit Matani
 * @created 1/14/09
 */


#import "HomeActionViewController.h"

#import "BattleRoyale.h"
#import "ProtagonistAnimal.h"
#import "AnimalType.h"
#import "Item.h"
#import "ActionResult.h"
#import "LoadingOverlayViewController.h"
#import "HomeViewController.h"
#import "CommentTableViewContainerController.h"
#import "PosseTableViewController.h"
#import "AnimalAnimationUIView.h"
#import "ShopItemTableViewContainerController.h"
#import "OwnedItemTableViewContainerController.h"
#import "SettingsViewController.h"
#import "AchievementTableViewController.h"
#import "GameUpdatesViewController.h"
#import "BankViewController.h"
#import "RemoteImageViewWithFileStore.h"
#import "ProfileWebViewController.h"

#import "BRGlobal.h"

#import "BRDialog.h"

#define BANK_INDEX 0
#define COMMENT_INDEX 1
#define ACHIEVEMENT_INDEX 2
#define POSSE_INDEX 3
#define PROFILE_INDEX 4
#define SETTINGS_INDEX 5
#define UPDATES_INDEX 6

@implementation HomeActionViewController
@synthesize animalImage, backgroundImage, armorImage, weaponImage, accessory1Image,
            accessory2Image, petButton, equipmentButton, shopButton,
            animalAnimationUIView;

// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)init {
    if (self = [super initWithNibName:@"HomeActionView" bundle:[NSBundle mainBundle]]) {
        [[[BRSession sharedManager] protagonistAnimal] registerObserverToAllProperties:self];
        [[BRSession sharedManager] addObserver:self forKeyPath:@"protagonistAnimal"
             options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld)
             context:NULL];
    }
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object
        change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"protagonistAnimal"]) {
        [[[BRSession sharedManager] protagonistAnimal] registerObserverToAllProperties:self];
        return;
    }
    ProtagonistAnimal *animal = [[BRSession sharedManager] protagonistAnimal];    
    if ([keyPath isEqualToString:@"accessory1"]) {
        [self setImage:accessory1Image withItem:animal.accessory1];
    } else if ([keyPath isEqualToString:@"accessory2"]) {
        [self setImage:accessory2Image withItem:animal.accessory2];        
    } else if ([keyPath isEqualToString:@"weapon"]) {
        [self setImage:weaponImage withItem:animal.weapon];
    } else if ([keyPath isEqualToString:@"armor"]) {
        [self setImage:armorImage withItem:animal.armor];
    } else if ([keyPath isEqualToString:@"background"]) {
        [self setImage:backgroundImage withItem:animal.background];		
	} else if ([keyPath isEqualToString:@"petEnergyCost"]) {
		[petButton setTitle:[NSString stringWithFormat:@"Pet (%@ Eng)", animal.petEnergyCost] forState:UIControlStateNormal];
	}
}
/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    
    ScrollableTabBar *tabBar = [[ScrollableTabBar alloc] initWithFrame:CGRectMake(0, 270, FRAME_WIDTH, 40)];
    [tabBar setTabs:[NSArray arrayWithObjects:@"Bank", @"Messages", @"Achievements", @"Posse", @"Profile", @"Settings", @"Game Updates", nil]];
    tabBar.selectedIndex = NSIntegerMax;
    tabBar.delegate = self;
    [self.view addSubview:tabBar];
    [tabBar release];
    
    debug_NSLog(@"view did load");
    BRSession *session = [BRSession sharedManager];
    if ([session isLoggedIn] && session.protagonistAnimal != nil) {
        [self update];
    }
    
	[petButton addTarget:self action:@selector(petButtonClicked) 
	           forControlEvents:UIControlEventTouchUpInside];
   	[equipmentButton addTarget:self action:@selector(equipmentButtonClicked) 
			  forControlEvents:UIControlEventTouchUpInside];
   	[shopButton addTarget:self action:@selector(shopButtonClicked) 
			  forControlEvents:UIControlEventTouchUpInside];
    
    [animalAnimationUIView setMovingView:animalImage withBoundRect:CGRectMake(0, 0, 320, 180)];
}

/**
 * update will update the view with the data in the session
 */
- (void)update {
    if (animalImage == nil) {       
        return;
    }
    BRSession *session = [BRSession sharedManager];    
    ProtagonistAnimal *animal = session.protagonistAnimal;
    [animalImage loadImageWithUrl:animal.image];
    
    [self setImage:accessory1Image withItem:animal.accessory1];
    [self setImage:accessory2Image withItem:animal.accessory2];        
    [self setImage:weaponImage withItem:animal.weapon];
    [self setImage:armorImage withItem:animal.armor];
    [self setImage:backgroundImage withItem:animal.background];
	
	[petButton setTitle:[NSString stringWithFormat:@"Pet (%@ EN)", animal.petEnergyCost] forState:UIControlStateNormal];
	
}

- (void)setImage:(RemoteImageViewWithFileStore *)image withItem:(Item *)item {
    if (item == nil) {
        image.image = nil;
        return;
    }
	NSString *imageUrl;
	if ([item.categoryKey isEqualToString:@"background"]) {
		imageUrl = item.iphoneBackgroundImage;
	} else {
		imageUrl = item.imageSquare50;
	}
    [image loadImageWithUrl:imageUrl];
}

#pragma mark Button Actions

- (void)petButtonClicked {
    [[BRRestClient sharedManager] animal_petAnimal:self 
                                  finishedSelector:@selector(finishedPettingAnimal:parsedResponse:)
                                  failedSelector:@selector(failedPettingAnimal)];
    [[BRAppDelegate sharedManager] showLoadingOverlayWithText:@"Petting"];
	
	// Play Sound
	[[SoundManager sharedManager] playSoundWithType:@"pet" vibrate:NO];
}

- (void)equipmentButtonClicked {
    OwnedItemTableViewContainerController *stvcc = [[OwnedItemTableViewContainerController alloc] init];
    [[[[BRAppDelegate sharedManager] tabManager] homeController] presentModalViewControllerWithNavigationBar:stvcc];
    [stvcc release];
	
	// Play Sound
	[[SoundManager sharedManager] playSoundWithType:@"popup" vibrate:NO];
}

- (void)shopButtonClicked {
    ShopItemTableViewContainerController *stvcc = [[ShopItemTableViewContainerController alloc] init];
    [[[[BRAppDelegate sharedManager] tabManager] homeController] presentModalViewControllerWithNavigationBar:stvcc];
    [stvcc release];
	
	// Play Sound
	[[SoundManager sharedManager] playSoundWithType:@"popup" vibrate:NO];
}

- (void)profileButtonClicked {
    ProfileWebViewController *pwhvc = [[ProfileWebViewController alloc] initWithAnimalId:[[[BRSession sharedManager] protagonistAnimal] animalId] isBot:0];
    [[[[BRAppDelegate sharedManager] tabManager] homeController] presentModalViewControllerWithNavigationBar:pwhvc];
    [pwhvc release];
	
	// Play Sound
	[[SoundManager sharedManager] playSoundWithType:@"popup" vibrate:NO];
}

- (void)achievementButtonClicked {
    AchievementTableViewController *atvc = [[AchievementTableViewController alloc] init];
    [[[[BRAppDelegate sharedManager] tabManager] homeController] presentModalRDTController:atvc];
    [atvc loadInitialData:NO showLoadingOverlay:NO];
    [atvc release]; 
	
	// Play Sound
	[[SoundManager sharedManager] playSoundWithType:@"popup" vibrate:NO];
}

- (void)commentButtonClicked {
	CommentTableViewContainerController *ctvcc = 
		[[CommentTableViewContainerController alloc] initWithUserId:[[[BRSession sharedManager] protagonistAnimal] userId]];
    [[[[BRAppDelegate sharedManager] tabManager] homeController] presentModalRDCContainerController:ctvcc];
	[ctvcc release];
	
	// Play Sound
	[[SoundManager sharedManager] playSoundWithType:@"popup" vibrate:NO];
}

- (void)posseButtonClicked {
	PosseTableViewController *ptvc = [[PosseTableViewController alloc] init];
    [[[[BRAppDelegate sharedManager] tabManager] homeController] presentModalRDTController:ptvc];
    [ptvc loadInitialData:NO showLoadingOverlay:YES];
    [ptvc release];
	
	// Play Sound
	[[SoundManager sharedManager] playSoundWithType:@"popup" vibrate:NO];
}

- (void)settingsButtonClicked {
    SettingsViewController *svc = [[SettingsViewController alloc] init];
    [[[[BRAppDelegate sharedManager] tabManager] homeController] presentModalViewControllerWithNavigationBar:svc];
    [svc release];
	
	// Play Sound
	[[SoundManager sharedManager] playSoundWithType:@"popup" vibrate:NO];
}

- (void)gameUpdatesButtonClicked {
    GameUpdatesViewController *guvc = [[GameUpdatesViewController alloc] init];
    [[[[BRAppDelegate sharedManager] tabManager] homeController] presentModalViewControllerWithNavigationBar:guvc];
    [guvc release];
	
	// Play Sound
	[[SoundManager sharedManager] playSoundWithType:@"popup" vibrate:NO];
}

#pragma mark Petting actions
- (void)finishedPettingAnimal:(NSNumber *)responseInt 
        parsedResponse:(NSDictionary *)parsedResponse {
    [[BRAppDelegate sharedManager] hideLoadingOverlay];            
    if ([BRRestClient isResponseSuccessful:responseInt]) {
        ActionResult *actionResult = [[ActionResult alloc] initWithApiResponse:[parsedResponse objectForKey:@"action_result"]];
        [[[BRSession sharedManager] protagonistAnimal] updateWithActionResult:actionResult];
        
        [[BRAppDelegate sharedManager] showNotification:actionResult.formattedResponse
                  withWidth:[actionResult.formattedResponseWidth floatValue]
                  andHeight:[actionResult.formattedResponseHeight floatValue]];
        
        [actionResult release];
        [animalAnimationUIView jump];
    } else {
        [self alertWithTitle:@"Petting Failed" message:[parsedResponse objectForKey:@"response_message"]];
    }
}

- (void)failedPettingAnimal {
    [[BRAppDelegate sharedManager] hideLoadingOverlay];        
    [self alertWithTitle:@"Petting Failed" message:@"Could not pet animal."];
}

- (void)displayActionFailed:(NSString *)title withMessage:(NSString *)message {
	UIAlertView *failedAction = [[UIAlertView alloc] initWithTitle:title
													 message:message
													 delegate:self 
													 cancelButtonTitle:@"OK" 
													 otherButtonTitles:nil];
	[failedAction show];
	[failedAction release];

}

- (BOOL)scrollableTabBar:(ScrollableTabBar *)scrollableTabBar shouldSelectIndex:(NSInteger)index {
    UIViewController *vc = nil;
    if (index == COMMENT_INDEX) {
        [self commentButtonClicked];
    } else if (index == ACHIEVEMENT_INDEX) {
        [self achievementButtonClicked];
    } else if (index == POSSE_INDEX) {
        [self posseButtonClicked];
    } else if (index == PROFILE_INDEX) {
        [self profileButtonClicked];
    } else if (index == SETTINGS_INDEX) {
        [self settingsButtonClicked];
    } else if (index == UPDATES_INDEX) {
        [self gameUpdatesButtonClicked];
    } else if (index == BANK_INDEX) {
        vc = [[BankViewController alloc] init];    
    }
    if (vc != nil) {
        [[[[BRAppDelegate sharedManager] tabManager] homeController] presentModalViewControllerWithNavigationBar:vc];    
        [vc release];
		// Play Sound
		[[SoundManager sharedManager] playSoundWithType:@"popup" vibrate:NO];
    }
    return NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}

- (void)cleanup {
    [[[BRSession sharedManager] protagonistAnimal] unregisterObserver:self]; 
    [[BRSession sharedManager] removeObserver:self forKeyPath:@"protagonistAnimal"];
}


- (void)dealloc {
    [animalImage release];
    [backgroundImage release];
    [armorImage release];
    [weaponImage release];
    [accessory1Image release];       
    [accessory2Image release];
    [petButton release];
    [equipmentButton release];
    [shopButton release];

    [animalAnimationUIView release];
    
    [super dealloc];
}


@end
