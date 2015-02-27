/**
 * BattleViewController.m
 * Copyright Miraphonic, Inc 2009. All rights reserved.
 *
 * @author Amit Matani 
 * @created 2/2/09.
 */

#import "BattleViewController.h"
#import "BRAppDelegate.h"
#import "BRSession.h"
#import "ProtagonistAnimal.h"
#import "RemoteImageViewWithFileStore.h"
#import "Item.h"
#import "Animal.h"
#import "BRRestClient.h"
#import "BattleResult.h"
#import "BattleLostViewController.h"
#import "BattleWonViewController.h"
#import "BattleRanViewController.h"
#import "RDCContainerController.h"
#import "BattleItemTableViewContainerViewController.h"
#import "ActionResult.h"
#import "BRTabManager.h"
#import "PDColoredProgressView.h"
#import <QuartzCore/CAAnimation.h>
#import <QuartzCore/CAMediaTimingFunction.h>
#import "Consts.h"
#import "BattleListViewController.h"
#import "AbstractRemoteDataController.h"
#import "OwnedEquipmentSet.h"
#import "JobWebViewController.h"
#import "InitialLoginViewController.h"

#import "BRDialog.h"

#define NOTIFICATION_FONT_SIZE 16
#define RED_BOOM 0
#define YELLOW_BOOM 1
#define PURPLE_BOOM 2


@implementation BattleViewController
@synthesize opponentAnimalImage, opponentWeaponImage, opponentArmorImage, opponentAccessory1Image, opponentAccessory2Image, opponentNameLabel, opponentHealthLabel, opponentHealthProgressView,     
animalImage, weaponImage, armorImage, accessory1Image, accessory2Image, nameLabel, loadingLabel, healthProgressView, loadingActivityIndicator,     
attackButton, itemButton, historyView, healthLabel, runButton, useItemCategoryIndex, backgroundImage;

- (id)initWithOpponentAnimal:(Animal *)opponent andBattleId:(NSString *)battle andInitialAction:(ActionResult *)actionResult {
	if (self = [super initWithNibName:@"BattleView" bundle:[NSBundle mainBundle]]) {
		opponentAnimal = [opponent retain];
		battleId = [battle copy];
        ProtagonistAnimal *protagonist = [[BRSession sharedManager] protagonistAnimal];
		[protagonist registerObserverToAllProperties:self];
        protagonist.inBattle = YES;
		[opponentAnimal registerObserverToAllProperties:self];
		battleText = @"";
		itemActionResult = [[ActionResult alloc] init];
        redColorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, FRAME_WIDTH, FRAME_HEIGHT_WITH_NO_BARS)];
        currentBattleResult = nil;
        
        if (actionResult != nil) {
            [[[BRSession sharedManager] protagonistAnimal] updateWithActionResult:actionResult];
            [itemActionResult mergeWithActionResult:actionResult];
        }
		
		useItemCategoryIndex = 0;
	}
	return self;
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	ProtagonistAnimal *protagonist = [[BRSession sharedManager] protagonistAnimal];
	
	[animalImage loadImageWithUrl:protagonist.imageSquare100];
    [weaponImage loadImageWithUrl:protagonist.weapon.imageSquare35];
	[armorImage loadImageWithUrl:protagonist.armor.imageSquare35];
	[accessory1Image loadImageWithUrl:protagonist.accessory1.imageSquare35];
    [accessory2Image loadImageWithUrl:protagonist.accessory2.imageSquare35];
	
	nameLabel.text = protagonist.name;
	[self configureProtagonistHpDisplay:NO];
	
	
	[opponentAnimalImage loadImageWithUrl:opponentAnimal.imageSquare100];
	[opponentWeaponImage loadImageWithUrl:opponentAnimal.weapon.imageSquare35];
	[opponentArmorImage loadImageWithUrl:opponentAnimal.armor.imageSquare35];
	[opponentAccessory1Image loadImageWithUrl:opponentAnimal.accessory1.imageSquare35];
	[opponentAccessory2Image loadImageWithUrl:opponentAnimal.accessory2.imageSquare35];
    [backgroundImage loadImageWithUrl:opponentAnimal.background.iphoneBackgroundBattleImage];
	
	opponentNameLabel.text = opponentAnimal.name;
	[self configureOpponentHpDisplay:NO];
	
	[attackButton addTarget:self action:@selector(attackButtonClicked) 
		  forControlEvents:UIControlEventTouchUpInside];
	
	[runButton addTarget:self action:@selector(runAwayButtonClicked) 
		   forControlEvents:UIControlEventTouchUpInside];
	
	[itemButton addTarget:self action:@selector(itemButtonClicked) 
		 forControlEvents:UIControlEventTouchUpInside];
    
    itemUsedImageView = [[RemoteImageViewWithFileStore alloc] initWithFrame:CGRectMake(-100, -100, 0, 0)];
    itemUsedImageView.contentMode = UIViewContentModeCenter;
    
    [self.view addSubview:itemUsedImageView];
    itemUsedImageView.center = CGPointMake(-100, -100);
    
    // boom
    [redBoomView release];
    [yellowBoomView release];
    [purpleBoomView release];    
    
	redBoomView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"boom.png"]];    
	yellowBoomView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"boom_yellow.png"]];    
	purpleBoomView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"boom_purple.png"]];        
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object
						change:(NSDictionary *)change context:(void *)context {
	ProtagonistAnimal *protagonist = [[BRSession sharedManager] protagonistAnimal];
	if (object == protagonist) {
		if ([keyPath isEqualToString:@"hp"] || [keyPath isEqualToString:@"hpMax"] || [keyPath isEqualToString:@"hpMaxBoost"]) {
			[self configureProtagonistHpDisplay:YES];
		}
	} else if (object == opponentAnimal) {
		if ([keyPath isEqualToString:@"hp"] || [keyPath isEqualToString:@"hpMax"] || [keyPath isEqualToString:@"hpMaxBoost"]) {
			[self configureOpponentHpDisplay:YES];
		}
	}
}

- (void)configureProtagonistHpDisplay:(BOOL)animate {
	ProtagonistAnimal *protagonist = [[BRSession sharedManager] protagonistAnimal];
    NSString *temp = [[NSString alloc] initWithFormat:@"%d/%d", protagonist.hp, protagonist.hpMax + protagonist.hpMaxBoost];
	healthLabel.text = temp;
    [temp release];
    float progress = protagonist.hp / (1.0 * protagonist.hpMax + protagonist.hpMaxBoost);
    if (animate) {
        [healthProgressView animateProgressTo:progress];
    } else {
        healthProgressView.progress = progress;
    }

    UIColor *tintColor;
    if (progress > 0.75) {
        tintColor = [UIColor greenColor];
    } else if (progress > .25) {
        tintColor = [UIColor yellowColor];            
    } else {
        tintColor = [UIColor redColor];            
    }
    [healthProgressView setTintColor:tintColor];
}

- (void)configureOpponentHpDisplay:(BOOL)animate {
    NSString *temp = [[NSString alloc] initWithFormat:@"%d/%d", opponentAnimal.hp, opponentAnimal.hpMax + opponentAnimal.hpMaxBoost];
	opponentHealthLabel.text = temp;
    [temp release];
    float progress = opponentAnimal.hp / (1.0 * opponentAnimal.hpMax + opponentAnimal.hpMaxBoost);
    if (animate) {
        [opponentHealthProgressView animateProgressTo:progress];	
    } else {
        opponentHealthProgressView.progress = progress;
    }
    
    UIColor *tintColor;
    if (progress > 0.75) {
        tintColor = [UIColor greenColor];
    } else if (progress > .25) {
        tintColor = [UIColor yellowColor];            
    } else {
        tintColor = [UIColor redColor];            
    }
    [opponentHealthProgressView setTintColor:tintColor];
}

- (void)hideButtonsWithText:(NSString *)text {
    attackButton.hidden = YES;
    runButton.hidden = YES;
    itemButton.hidden = YES;
    loadingLabel.hidden = NO;
    loadingLabel.text = text;
    loadingActivityIndicator.hidden = NO;
    [loadingActivityIndicator startAnimating];
}

- (void)showButtons {
    attackButton.hidden = NO;
    runButton.hidden = NO;
    itemButton.hidden = NO;
    loadingLabel.hidden = YES;
    loadingActivityIndicator.hidden = YES;
    [loadingActivityIndicator stopAnimating];    
}

- (void)attackButtonClicked {
    
    [self hideButtonsWithText:@"Attacking"];
	[[BRRestClient sharedManager] battle_attack:battleId target:self 
								  finishedSelector:@selector(finishedMove:parsedResponse:) 
								  failedSelector:@selector(failedMove)];
}

- (void)runAwayButtonClicked {
    [self hideButtonsWithText:@"Running"];
	[[BRRestClient sharedManager] battle_run:battleId target:self 
							   finishedSelector:@selector(finishedMove:parsedResponse:) 
								 failedSelector:@selector(failedMove)];
}

- (void)itemButtonClicked {
	[[SoundManager sharedManager] playSoundWithType:@"popup" vibrate:NO];
	BattleItemTableViewContainerViewController *container = [[BattleItemTableViewContainerViewController alloc] initWithIndexSelected:useItemCategoryIndex];
	container.battleViewController = self;
	UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:container];
	[self presentModalViewController:nav animated:YES];
    [nav release];
	[container release];
}

- (void)setBattleText:(NSString *)_value {
	NSString *newText = [[NSString alloc] initWithFormat:@"%@%@", _value, battleText];
	[battleText release];
	battleText = newText;
	
	NSString *htmlString = [[NSString alloc] initWithFormat:@"<html><body style=\"background-color:transparent;padding:0px;margin:0px 10px;text-align:left;color:black;font-size:%d;font-family:helvetica\">%@</body></html>",
							NOTIFICATION_FONT_SIZE,
							battleText];

	NSURL *baseURL = [[NSURL alloc] initWithString:@""];
	[historyView loadHTMLString:htmlString baseURL:baseURL];
	[baseURL release];
	[htmlString release];
}

- (void)animateOpponentMove {
    if (currentBattleResult.opponentItemActionResult != nil) {
        [opponentUsingItem release];
        opponentUsingItem = [currentBattleResult.opponentItemActionResult.item retain];
        currentBattleResult.opponentItemActionResult.item = nil;
        [self animateItemUsed:NO];
    } else if (currentBattleResult.playerSpellActionResult.item != nil) {
        [currentlyAttackedBySpell release];
        currentlyAttackedBySpell = [currentBattleResult.playerSpellActionResult.item retain];
        currentBattleResult.playerSpellActionResult.item = nil;
        [self animateSpellUsed:YES]; 
    } else {
        [self animateOpponentAttack];
    }
}

- (void)animatePlayerMove {
    if (currentBattleResult.playerItemActionResult.item != nil) {
        currentBattleResult.playerItemActionResult.item = nil;
        [self animateItemUsed:YES];
    } else if (currentBattleResult.opponentSpellActionResult.item != nil) {
        [opponentAttackedBySpell release];
        opponentAttackedBySpell = [currentBattleResult.opponentSpellActionResult.item retain];
        currentBattleResult.opponentSpellActionResult.item = nil;
        [self animateSpellUsed:NO];
    } else {
        [self animatePlayerAttack];
    }
}

- (void)finishedMove:(NSNumber *)responseInt parsedResponse:(NSDictionary *)parsedResponse {
	if ([BRRestClient isResponseSuccessful:responseInt]) {
		
		BattleResult *battleResult = [[BattleResult alloc] initWithApiResponse:parsedResponse];
        [currentBattleResult release];
        currentBattleResult = [battleResult retain];
		ProtagonistAnimal *protagonist = [[BRSession sharedManager] protagonistAnimal];
		
        if ([battleResult didPlayerGoFirst]) {
            if ([battleResult didPlayerFailRunning]) {
                [self runAwayFailedAnimation];
            } else if ([battleResult didPlayerRunAwaySuccessfully]) {
                [self runAwayAnimation];                
            } else {
                [self animatePlayerMove];
            }
        } else {
            [self animateOpponentMove];
        }
        
		[battleResult release];
		
		if (currentlyUsingItem != nil) {
            if (battleResult.playerItemActionResult != nil || battleResult.opponentSpellActionResult != nil) {
                [[protagonist equipment] decrementOwnedCountForItem:currentlyUsingItem count:1];
            }
			[currentlyUsingItem release];
			currentlyUsingItem = nil;
		}

	} else {
		[self failedMove];
	}	
}

- (void)attackAnimationFinished:(BOOL)isPlayer {
    if ([[BRSession sharedManager] protagonistAnimal].hp <= 0 ||
        opponentAnimal.hp <= 0) {
        // do a special case check to see if the action result needs to be applied to
        // the player because the opponent died before making its attack
        if (opponentAnimal.hp <= 0 && [currentBattleResult didPlayerGoFirst]) {
            ProtagonistAnimal *protagonist = [[BRSession sharedManager] protagonistAnimal];        
            [protagonist updateWithActionResult:currentBattleResult.playerActionResult];            
        }
        
        [self postAnimations];
        return;
    }
    
    if ([currentBattleResult didPlayerGoFirst]) {
        if (isPlayer) {
            [self animateOpponentMove];
        } else {
			[self postAnimations];
        }
    } else {
        if (!isPlayer) {
            [self animatePlayerMove];
        } else {
			[self postAnimations];
        }
    }
}

- (void)postAnimations {
	if (currentBattleResult.flagPlayerWon || currentBattleResult.flagChallengerWon || [currentBattleResult didPlayerRunAwaySuccessfully]) {
		if (currentBattleResult.postBattleHTML) {
			BRDialog *dialog = [[BRDialog alloc] initWithHTML:currentBattleResult.postBattleHTML];
			UIViewController *container;
			if ([[self parentViewController] isKindOfClass:[InitialLoginViewController class]]) {
				container = [[self parentViewController] parentViewController];
			} else {
				container = [self parentViewController];
			}
			[dialog show];
			[dialog release];
		}
		
        // remove the ephermal buffs from items
        NSNumber *temp = [[NSNumber alloc] initWithInt:0];
        itemActionResult.hp = temp;
		
        [itemActionResult invert];
		
        [[[BRSession sharedManager] protagonistAnimal] updateWithActionResult:itemActionResult];
        [temp release];
		
		[self dismissBattleControllers];
	} else {
        [self setBattleText:currentBattleResult.formattedResponse];
        [self showButtons];
	}
}

- (void)failedMove {
	[currentlyUsingItem release];
	currentlyUsingItem = nil;	
    [self showButtons];
}

- (void)dismissBattleControllers {
    ProtagonistAnimal *protagonist = [[BRSession sharedManager] protagonistAnimal];
	[protagonist unregisterObserver:self];
    protagonist.inBattle = NO;
    
	[opponentAnimal unregisterObserver:self];
	
	if ([[self parentViewController] isKindOfClass:[InitialLoginViewController class]]) {
		[[[self parentViewController] parentViewController] dismissModalViewControllerAnimated:YES];
	} else {
		[[self parentViewController] dismissModalViewControllerAnimated:YES];
	}
	
	
//	[[BRAppDelegate sharedManager] showHomeScreen];
//	[[[[[[BRAppDelegate sharedManager] tabManager] battleListController] challengerTableContainer] containedRDC] loadInitialData:YES showLoadingOverlay:YES];
	[[[[BRAppDelegate sharedManager] tabManager] battleListController] reloadData];
    
    // if the player beat a boss reset the job view
    if (opponentAnimal.isBoss && currentBattleResult.flagPlayerWon) {
//        [[[[[[BRAppDelegate sharedManager] tabManager] jobController] jobsTableContainer] containedRDC] loadInitialData:YES showLoadingOverlay:YES];
        [[[[BRAppDelegate sharedManager] tabManager] jobController] postBossReloadData];
    }
	
	[[SoundManager sharedManager] playSoundWithType:@"close" vibrate:NO];
}

- (void)useItemInBattle:(Item *)item {
	[currentlyUsingItem release]; 
	currentlyUsingItem = [item retain];
    [self hideButtonsWithText:@"Using Item"];
	[[BRRestClient sharedManager] battle_useItem:battleId itemId:item.itemId target:self
								finishedSelector:@selector(finishedMove:parsedResponse:)
								failedSelector:@selector(failedMove)];
	
	// save selected item category # 
	if ([currentlyUsingItem.categoryKey isEqualToString:@"useable"]) {
		useItemCategoryIndex = 0;
	} else {
		useItemCategoryIndex = 1;
	}
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}

- (void)animatePlayerAttack {
    srand(time(NULL));
    int randInt = rand() % 4;
    if (randInt == 0) {
        [self animatePlayerAttack1_part1];
    } else if (randInt == 1) {
        [self animatePlayerAttack2_part1];        
    } else if (randInt == 2) {
        [self animatePlayerAttack3_part1];
    } else if (randInt == 3) {
        [self animatePlayerAttack4_part1];        
    }
	[[SoundManager sharedManager] playSoundWithType:@"flyattack" vibrate:NO];
}

- (void)animateOpponentAttack {
    [animalImage.layer removeAllAnimations];
    srand(time(NULL));    
    int randInt = rand() % 4;
    if (randInt == 0) {
        [self animateOpponentAttack1_part1];
    } else if (randInt == 1) {
        [self animateOpponentAttack2_part1];        
    } else if (randInt == 2) {
        [self animateOpponentAttack3_part1];
    } else if (randInt == 3) {
        [self animateOpponentAttack4_part1];        
    }
	[[SoundManager sharedManager] playSoundWithType:@"flyattack" vibrate:NO];
}

- (void)handleAttackTo:(BOOL)isPlayer {
    [self flashAttacked:isPlayer color:RED_BOOM];
    if (isPlayer) {
		ProtagonistAnimal *protagonist = [[BRSession sharedManager] protagonistAnimal];        
        [protagonist updateWithActionResult:currentBattleResult.playerActionResult];
        [self animatePlayerResponse];
    } else {
        [opponentAnimal updateWithActionResult:currentBattleResult.opponentActionResult];
        [self animateOpponentResponse];
    }
}

- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag {

    if (theAnimation == [animalImage.layer animationForKey:@"animatePlayerAttack1_part1"]) {
        [self animatePlayerAttack1_part2];
        
    } else if (theAnimation == [animalImage.layer animationForKey:@"animatePlayerAttack1_part2"]) {
        [self animatePlayerAttack1_part3];
        
    } else if (theAnimation == [animalImage.layer animationForKey:@"animatePlayerAttack1_part3"]) {        
        [animalImage.layer removeAllAnimations];
        animalImage.transform = CGAffineTransformRotate(CGAffineTransformIdentity, 0);        
        [self attackAnimationFinished:YES];        
        
    } else if (theAnimation == [animalImage.layer animationForKey:@"animatePlayerAttack2_part1"]) {
        [self animatePlayerAttack2_part2];
    } else if (theAnimation == [animalImage.layer animationForKey:@"animatePlayerAttack2_part2"]) {
        [self animatePlayerAttack2_part3];
    } else if (theAnimation == [animalImage.layer animationForKey:@"animatePlayerAttack2_part3"]) {
        [self animatePlayerAttack2_part4];        
    } else if (theAnimation == [animalImage.layer animationForKey:@"animatePlayerAttack2_part4"]) {        
        [animalImage.layer removeAllAnimations];
        animalImage.transform = CGAffineTransformRotate(CGAffineTransformIdentity, 0);
        [self attackAnimationFinished:YES];
        
    } else if (theAnimation == [animalImage.layer animationForKey:@"animatePlayerAttack3_part1"]) {
        [self animatePlayerAttack3_part2];
    } else if (theAnimation == [animalImage.layer animationForKey:@"animatePlayerAttack3_part2"]) {
        [self animatePlayerAttack3_part3];
    } else if (theAnimation == [animalImage.layer animationForKey:@"animatePlayerAttack3_part3"]) {
        [self animatePlayerAttack3_part4];
    } else if (theAnimation == [animalImage.layer animationForKey:@"animatePlayerAttack3_part4"]) {        
        [animalImage.layer removeAllAnimations];
        animalImage.transform = CGAffineTransformRotate(CGAffineTransformIdentity, 0);
        [self attackAnimationFinished:YES];
        
    } else if (theAnimation == [animalImage.layer animationForKey:@"animatePlayerAttack4_part1"]) {
        [self animatePlayerAttack4_part2];
    } else if (theAnimation == [animalImage.layer animationForKey:@"animatePlayerAttack4_part2"]) {
        [self animatePlayerAttack4_part3];
    } else if (theAnimation == [animalImage.layer animationForKey:@"animatePlayerAttack4_part3"]) {
        [self animatePlayerAttack4_part4];
    } else if (theAnimation == [animalImage.layer animationForKey:@"animatePlayerAttack4_part4"]) {
        [animalImage.layer removeAllAnimations];
        animalImage.transform = CGAffineTransformRotate(CGAffineTransformIdentity, 0);
        [self attackAnimationFinished:YES];
        
    } else if (theAnimation == [animalImage.layer animationForKey:@"runAwayAnimation"]) {
        [animalImage.layer removeAllAnimations];
        animalImage.center = CGPointMake(animalImage.center.x + animalImage.frame.size.width + 100,
                                         animalImage.center.y);
        [self postAnimations];
    } else if (theAnimation == [animalImage.layer animationForKey:@"runAwayFailedAnimation"]) {
        [animalImage.layer removeAllAnimations];        
        [self animateOpponentMove];
    }
    
    if (theAnimation == [opponentAnimalImage.layer animationForKey:@"animateOpponentAttack1_part1"]) {
        [self animateOpponentAttack1_part2];
        
    } else if (theAnimation == [opponentAnimalImage.layer animationForKey:@"animateOpponentAttack1_part2"]) {
        [self animateOpponentAttack1_part3];
        
    } else if (theAnimation == [opponentAnimalImage.layer animationForKey:@"animateOpponentAttack1_part3"]) {        
        [opponentAnimalImage.layer removeAllAnimations];
        opponentAnimalImage.transform = CGAffineTransformRotate(CGAffineTransformIdentity, 0);
        [self attackAnimationFinished:NO];
        
    } else if (theAnimation == [opponentAnimalImage.layer animationForKey:@"animateOpponentAttack2_part1"]) {
        [self animateOpponentAttack2_part2];
    } else if (theAnimation == [opponentAnimalImage.layer animationForKey:@"animateOpponentAttack2_part2"]) {
        [self animateOpponentAttack2_part3];
    } else if (theAnimation == [opponentAnimalImage.layer animationForKey:@"animateOpponentAttack2_part3"]) {
        [self animateOpponentAttack2_part4];        
    } else if (theAnimation == [opponentAnimalImage.layer animationForKey:@"animateOpponentAttack2_part4"]) {        
        [opponentAnimalImage.layer removeAllAnimations];
        opponentAnimalImage.transform = CGAffineTransformRotate(CGAffineTransformIdentity, 0); 
        [self attackAnimationFinished:NO];
        
    } else if (theAnimation == [opponentAnimalImage.layer animationForKey:@"animateOpponentAttack3_part1"]) {
        [self animateOpponentAttack3_part2];
    } else if (theAnimation == [opponentAnimalImage.layer animationForKey:@"animateOpponentAttack3_part2"]) {
        [self animateOpponentAttack3_part3];
    } else if (theAnimation == [opponentAnimalImage.layer animationForKey:@"animateOpponentAttack3_part3"]) {
        [self animateOpponentAttack3_part4];
    } else if (theAnimation == [opponentAnimalImage.layer animationForKey:@"animateOpponentAttack3_part4"]) {        
        [opponentAnimalImage.layer removeAllAnimations];
        opponentAnimalImage.transform = CGAffineTransformRotate(CGAffineTransformIdentity, 0);
        [self attackAnimationFinished:NO];
        
    } else if (theAnimation == [opponentAnimalImage.layer animationForKey:@"animateOpponentAttack4_part1"]) {
        [self animateOpponentAttack4_part2];
    } else if (theAnimation == [opponentAnimalImage.layer animationForKey:@"animateOpponentAttack4_part2"]) {
        [self animateOpponentAttack4_part3];
    } else if (theAnimation == [opponentAnimalImage.layer animationForKey:@"animateOpponentAttack4_part3"]) {
        [opponentAnimalImage.layer removeAllAnimations];
        opponentAnimalImage.transform = CGAffineTransformRotate(CGAffineTransformIdentity, 0);
        [self attackAnimationFinished:NO];
        
    } else if (theAnimation == [opponentAnimalImage.layer animationForKey:@"animateOpponentSpellResponse"]) {
        [opponentAnimalImage.layer removeAllAnimations];
        [self attackAnimationFinished:YES];
    } else if (theAnimation == [animalImage.layer animationForKey:@"animatePlayerSpellResponse"]) {
        [animalImage.layer removeAllAnimations];
        [self attackAnimationFinished:NO];        
    }
}

#pragma mark Player Attack Animations

- (void)animatePlayerAttack1_part1 {
#define ATTACK_ONE_1_DURATION .4
    [self.view bringSubviewToFront:animalImage];        
    
    CABasicAnimation* moveAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
    moveAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(opponentAnimalImage.frame.origin.x + opponentAnimalImage.frame.size.width, 
                                                                  opponentAnimalImage.frame.origin.y + opponentAnimalImage.frame.size.height)];
    moveAnimation.duration = ATTACK_ONE_1_DURATION; 
    moveAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    
    CABasicAnimation* spinAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    spinAnimation.toValue = [NSNumber numberWithFloat:-M_PI / 4];
    spinAnimation.duration = ATTACK_ONE_1_DURATION;
    
    CAAnimationGroup *theGroup = [CAAnimationGroup animation];
	theGroup.animations = [NSArray arrayWithObjects:moveAnimation, spinAnimation, nil];
    theGroup.duration = ATTACK_ONE_1_DURATION;
    
    theGroup.removedOnCompletion = NO;
    theGroup.fillMode = kCAFillModeBoth;
    theGroup.delegate = self;
    
    [animalImage.layer addAnimation:theGroup forKey:@"animatePlayerAttack1_part1"];
}

- (void)animatePlayerAttack1_part2 {
#define ATTACK_ONE_2_DURATION .4   
    [self handleAttackTo:NO];
    [animalImage.layer removeAnimationForKey:@"animatePlayerAttack1_part1"];
    
    animalImage.transform = CGAffineTransformRotate(CGAffineTransformIdentity, -M_PI / 4);
    
    CABasicAnimation *moveAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
    moveAnimation.fromValue = [NSValue valueWithCGPoint:CGPointMake(opponentAnimalImage.frame.origin.x + opponentAnimalImage.frame.size.width, 
                                                                    opponentAnimalImage.frame.origin.y + opponentAnimalImage.frame.size.height)];
    
    moveAnimation.toValue = 
    [NSValue valueWithCGPoint:CGPointMake(-animalImage.frame.size.height, -animalImage.frame.size.width)];
    moveAnimation.duration = ATTACK_ONE_2_DURATION; 
    moveAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    moveAnimation.delegate = self;
    moveAnimation.fillMode = kCAFillModeBoth;        
    moveAnimation.removedOnCompletion = NO;
    
    [animalImage.layer addAnimation:moveAnimation forKey:@"animatePlayerAttack1_part2"];
}

- (void)animatePlayerAttack1_part3 {
#define ATTACK_ONE_3_DURATION .3    
    [animalImage.layer removeAnimationForKey:@"animatePlayerAttack1_part2"];       
    
    CABasicAnimation* moveAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
    CGPoint startingPoint = CGPointMake(animalImage.center.x + animalImage.frame.size.width, 
                                        animalImage.center.y + animalImage.frame.size.height);
    moveAnimation.fromValue = [NSValue valueWithCGPoint:startingPoint];
    moveAnimation.toValue = [NSValue valueWithCGPoint:animalImage.center];
    
    moveAnimation.duration = ATTACK_ONE_3_DURATION; 
    moveAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    CABasicAnimation* spinAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    spinAnimation.toValue = [NSNumber numberWithFloat:0];
    spinAnimation.duration = ATTACK_ONE_3_DURATION;
    
    CAAnimationGroup *theGroup = [CAAnimationGroup animation];
    theGroup.animations = [NSArray arrayWithObjects:moveAnimation, spinAnimation, nil];
    theGroup.duration = ATTACK_ONE_3_DURATION;
    
    theGroup.removedOnCompletion = NO;
    theGroup.fillMode = kCAFillModeBoth;
    theGroup.delegate = self;
    
    [animalImage.layer addAnimation:theGroup forKey:@"animatePlayerAttack1_part3"];
}

- (void)animatePlayerAttack2_part1 {
#define ATTACK_TWO_1_DURATION .4
    [self.view bringSubviewToFront:animalImage];    
    
    CABasicAnimation* moveAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
    moveAnimation.toValue = 
        [NSValue valueWithCGPoint:CGPointMake(animalImage.center.x, -animalImage.frame.size.height / 2)];
    moveAnimation.duration = ATTACK_TWO_1_DURATION; 
    moveAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    
    moveAnimation.removedOnCompletion = NO;
    moveAnimation.fillMode = kCAFillModeBoth;
    moveAnimation.delegate = self;
    
    [animalImage.layer addAnimation:moveAnimation forKey:@"animatePlayerAttack2_part1"]; 
}

- (void)animatePlayerAttack2_part2 {
    [animalImage.layer removeAnimationForKey:@"animatePlayerAttack2_part1"];           
#define ATTACK_TWO_2_DURATION .1
    animalImage.transform = CGAffineTransformRotate(CGAffineTransformIdentity, -M_PI);
    
    CABasicAnimation* moveAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
    moveAnimation.fromValue = 
        [NSValue valueWithCGPoint:CGPointMake(opponentAnimalImage.center.x, -animalImage.frame.size.height / 2)];
    moveAnimation.toValue = 
        [NSValue valueWithCGPoint:CGPointMake(opponentAnimalImage.center.x, opponentAnimalImage.frame.origin.y)];
    moveAnimation.duration = ATTACK_TWO_2_DURATION; 
    moveAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    
    moveAnimation.removedOnCompletion = NO;
    moveAnimation.fillMode = kCAFillModeBoth;
    moveAnimation.delegate = self;
    
    [animalImage.layer addAnimation:moveAnimation forKey:@"animatePlayerAttack2_part2"];    
}

- (void)animatePlayerAttack2_part3 {
    [animalImage.layer removeAnimationForKey:@"animatePlayerAttack2_part2"];
#define ATTACK_TWO_3_DURATION .3
    [self handleAttackTo:NO];   
    
    CABasicAnimation* moveAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
    moveAnimation.fromValue = 
        [NSValue valueWithCGPoint:CGPointMake(opponentAnimalImage.center.x, opponentAnimalImage.frame.origin.y)];
    moveAnimation.toValue = 
        [NSValue valueWithCGPoint:CGPointMake(opponentAnimalImage.center.x, 
                                              FRAME_HEIGHT_WITH_NO_BARS + animalImage.frame.size.height / 2)];
    moveAnimation.duration = ATTACK_TWO_3_DURATION; 
    moveAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    
    moveAnimation.removedOnCompletion = NO;
    moveAnimation.fillMode = kCAFillModeBoth;
    moveAnimation.delegate = self;    
    
    [animalImage.layer addAnimation:moveAnimation forKey:@"animatePlayerAttack2_part3"];    
}

- (void)animatePlayerAttack2_part4 {
    [animalImage.layer removeAnimationForKey:@"animatePlayerAttack2_part3"];
#define ATTACK_TWO_4_DURATION .4
    animalImage.transform = CGAffineTransformRotate(CGAffineTransformIdentity, 0);    
     
    CABasicAnimation* moveAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
    moveAnimation.fromValue = 
        [NSValue valueWithCGPoint:CGPointMake(animalImage.center.x, 
                                              FRAME_HEIGHT_WITH_NO_BARS + animalImage.frame.size.height / 2)];
    moveAnimation.toValue = [NSValue valueWithCGPoint:animalImage.center];
    moveAnimation.duration = ATTACK_TWO_4_DURATION; 
    moveAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    moveAnimation.removedOnCompletion = NO;
    moveAnimation.fillMode = kCAFillModeBoth;
    moveAnimation.delegate = self;    
    
    [animalImage.layer addAnimation:moveAnimation forKey:@"animatePlayerAttack2_part4"];  
}

- (void)animatePlayerAttack3_part1 {
#define ATTACK_THREE_1_DURATION .4
    [self.view bringSubviewToFront:animalImage];        
    
    CABasicAnimation* moveAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
    moveAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(FRAME_WIDTH + 100, 
                                                                  opponentAnimalImage.center.y)];
    moveAnimation.duration = ATTACK_THREE_1_DURATION; 
    moveAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    
    CABasicAnimation* spinAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    spinAnimation.toValue = [NSNumber numberWithFloat:M_PI / 4];
    spinAnimation.duration = ATTACK_THREE_1_DURATION;
    
    CAAnimationGroup *theGroup = [CAAnimationGroup animation];
	theGroup.animations = [NSArray arrayWithObjects:moveAnimation, spinAnimation, nil];
    theGroup.duration = ATTACK_THREE_1_DURATION;
    
    theGroup.removedOnCompletion = NO;
    theGroup.fillMode = kCAFillModeBoth;
    theGroup.delegate = self;
    
    [animalImage.layer addAnimation:theGroup forKey:@"animatePlayerAttack3_part1"];    
}

- (void)animatePlayerAttack3_part2 {
    [animalImage.layer removeAnimationForKey:@"animatePlayerAttack3_part1"];           
#define ATTACK_THREE_2_DURATION .3
    animalImage.transform = CGAffineTransformRotate(CGAffineTransformIdentity, -M_PI / 2);
    
    CABasicAnimation* moveAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
    moveAnimation.fromValue = [NSValue valueWithCGPoint:CGPointMake(FRAME_WIDTH + animalImage.frame.size.width, opponentAnimalImage.center.y)];
    moveAnimation.toValue = [NSValue valueWithCGPoint:opponentAnimalImage.center];
    moveAnimation.duration = ATTACK_THREE_2_DURATION; 
    moveAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    
    moveAnimation.removedOnCompletion = NO;
    moveAnimation.fillMode = kCAFillModeBoth;
    moveAnimation.delegate = self;
    
    [animalImage.layer addAnimation:moveAnimation forKey:@"animatePlayerAttack3_part2"];    
}

- (void)animatePlayerAttack3_part3 {
    [animalImage.layer removeAnimationForKey:@"animatePlayerAttack3_part2"];           
    [self handleAttackTo:NO];       
#define ATTACK_THREE_3_DURATION .1
    
    CABasicAnimation* moveAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
    moveAnimation.fromValue = [NSValue valueWithCGPoint:opponentAnimalImage.center];
    moveAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(-animalImage.frame.size.width, opponentAnimalImage.center.y)];
    moveAnimation.duration = ATTACK_THREE_3_DURATION; 
    moveAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    
    moveAnimation.removedOnCompletion = NO;
    moveAnimation.fillMode = kCAFillModeBoth;
    moveAnimation.delegate = self;
    
    [animalImage.layer addAnimation:moveAnimation forKey:@"animatePlayerAttack3_part3"];    
}

- (void)animatePlayerAttack3_part4 {
    [animalImage.layer removeAnimationForKey:@"animatePlayerAttack3_part3"];
#define ATTACK_THREE_4_DURATION .5
    animalImage.transform = CGAffineTransformRotate(CGAffineTransformIdentity, M_PI / 4);
    
    CABasicAnimation* moveAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
    moveAnimation.fromValue = [NSValue valueWithCGPoint:CGPointMake(-animalImage.frame.size.width, 
                                                                  animalImage.center.y + 100)];
    moveAnimation.toValue = [NSValue valueWithCGPoint:animalImage.center];
    
    moveAnimation.duration = ATTACK_THREE_4_DURATION; 
    moveAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    CABasicAnimation* spinAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    spinAnimation.toValue = [NSNumber numberWithFloat:0];
    spinAnimation.duration = ATTACK_THREE_4_DURATION;
    
    CAAnimationGroup *theGroup = [CAAnimationGroup animation];
	theGroup.animations = [NSArray arrayWithObjects:moveAnimation, spinAnimation, nil];
    theGroup.duration = ATTACK_THREE_4_DURATION;
    
    theGroup.removedOnCompletion = NO;
    theGroup.fillMode = kCAFillModeBoth;
    theGroup.delegate = self;
    
    [animalImage.layer addAnimation:theGroup forKey:@"animatePlayerAttack3_part4"];    
}

- (void)animatePlayerAttack4_part1 {
#define ATTACK_FOUR_1_DURATION .3
    [self.view bringSubviewToFront:animalImage];
    
    CABasicAnimation* moveAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
    moveAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(animalImage.center.x,
                                                                  animalImage.center.y + animalImage.frame.size.height)];
    moveAnimation.duration = ATTACK_FOUR_1_DURATION;
    moveAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    
    CABasicAnimation* spinAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    spinAnimation.toValue = [NSNumber numberWithFloat:-M_PI / 2];
    spinAnimation.duration = ATTACK_FOUR_1_DURATION;
    
    CAAnimationGroup *theGroup = [CAAnimationGroup animation];
	theGroup.animations = [NSArray arrayWithObjects:moveAnimation, spinAnimation, nil];
    theGroup.duration = ATTACK_FOUR_1_DURATION;
    
    theGroup.removedOnCompletion = NO;
    theGroup.fillMode = kCAFillModeBoth;
    theGroup.delegate = self;
    
    [animalImage.layer addAnimation:theGroup forKey:@"animatePlayerAttack4_part1"];    
}

- (void)animatePlayerAttack4_part2 {
#define ATTACK_FOUR_2_DURATION .3
    [animalImage.layer removeAnimationForKey:@"animatePlayerAttack4_part1"];
    
    animalImage.transform = CGAffineTransformRotate(CGAffineTransformIdentity, -M_PI / 2);
 
    CAKeyframeAnimation *moveAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
/*    moveAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(animalImage.center.x,
                                                                  animalImage.center.y + animalImage.frame.size.height)];*/

    CGMutablePathRef thePath = CGPathCreateMutable();
    CGPathMoveToPoint(thePath, NULL, animalImage.center.x, animalImage.center.y + animalImage.frame.size.height);
    
    CGPathAddCurveToPoint(thePath, NULL,
                          opponentAnimalImage.center.x + (opponentAnimalImage.center.x - animalImage.center.x) / 2, 
                          animalImage.center.y + animalImage.frame.size.height,
                          
                          opponentAnimalImage.center.x, animalImage.center.y,
                          opponentAnimalImage.center.x, opponentAnimalImage.center.y);

    moveAnimation.path = thePath;
    moveAnimation.duration = ATTACK_FOUR_2_DURATION;
    moveAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
        
    CABasicAnimation* spinAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    spinAnimation.toValue = [NSNumber numberWithFloat:0];
    spinAnimation.duration = ATTACK_FOUR_2_DURATION;
    
    CAAnimationGroup *theGroup = [CAAnimationGroup animation];
	theGroup.animations = [NSArray arrayWithObjects:moveAnimation, spinAnimation, nil];
    theGroup.duration = ATTACK_FOUR_2_DURATION;
    
    theGroup.removedOnCompletion = NO;
    theGroup.fillMode = kCAFillModeBoth;
    theGroup.delegate = self;
    
    [animalImage.layer addAnimation:theGroup forKey:@"animatePlayerAttack4_part2"]; 
    
    CFRelease(thePath);    
}

- (void)animatePlayerAttack4_part3 {
#define ATTACK_FOUR_3_DURATION .1
    [animalImage.layer removeAnimationForKey:@"animatePlayerAttack4_part2"];
    [self handleAttackTo:NO];               
    animalImage.transform = CGAffineTransformRotate(CGAffineTransformIdentity, 0);
    
    CABasicAnimation* moveAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
    moveAnimation.fromValue = [NSValue valueWithCGPoint:opponentAnimalImage.center];
    moveAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(opponentAnimalImage.center.x, -animalImage.frame.size.height)];
    moveAnimation.duration = ATTACK_FOUR_3_DURATION; 
    moveAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    
    moveAnimation.removedOnCompletion = NO;
    moveAnimation.fillMode = kCAFillModeBoth;
    moveAnimation.delegate = self;
    
    [animalImage.layer addAnimation:moveAnimation forKey:@"animatePlayerAttack4_part3"];  
}

- (void)animatePlayerAttack4_part4 {
#define ATTACK_FOUR_4_DURATION .5
    [animalImage.layer removeAnimationForKey:@"animatePlayerAttack4_part3"];    
    animalImage.transform = CGAffineTransformRotate(CGAffineTransformIdentity, M_PI / 4);    
    
    CABasicAnimation* moveAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
    moveAnimation.fromValue = [NSValue valueWithCGPoint:CGPointMake(FRAME_WIDTH + animalImage.frame.origin.x,
                                                                  animalImage.center.y - 2 * animalImage.frame.size.height)];
    
    moveAnimation.toValue = [NSValue valueWithCGPoint:animalImage.center];
    
    moveAnimation.duration = ATTACK_FOUR_4_DURATION;
    moveAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    CABasicAnimation* spinAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    spinAnimation.toValue = [NSNumber numberWithFloat:0];
    spinAnimation.duration = ATTACK_FOUR_4_DURATION;
    
    CAAnimationGroup *theGroup = [CAAnimationGroup animation];
	theGroup.animations = [NSArray arrayWithObjects:moveAnimation, spinAnimation, nil];
    theGroup.duration = ATTACK_FOUR_4_DURATION;
    
    theGroup.removedOnCompletion = NO;
    theGroup.fillMode = kCAFillModeBoth;
    theGroup.delegate = self;
    
    [animalImage.layer addAnimation:theGroup forKey:@"animatePlayerAttack4_part4"];    
}

#pragma mark Run Animations
- (void)runAwayAnimation {
    CABasicAnimation* moveAnimation = [CABasicAnimation animationWithKeyPath:@"position.x"];
    moveAnimation.toValue = [NSNumber numberWithFloat:animalImage.center.x + animalImage.frame.size.width + 100];
    moveAnimation.duration = .5;
    moveAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    
    CAKeyframeAnimation* waddleAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation"];
    NSMutableArray *values = [[NSMutableArray alloc] initWithCapacity:5];
    NSMutableArray *timings = [[NSMutableArray alloc] initWithCapacity:5];

    NSNumber *initialRotation = [[NSNumber alloc] initWithFloat:0];
#define WADDLE_FRACTION .0625
#define WADDLE_TIME .25    
    NSNumber *clockwiseRotation = [[NSNumber alloc] initWithFloat:WADDLE_FRACTION * M_PI];
    NSNumber *counterClockwiseRotation = [[NSNumber alloc] initWithFloat:WADDLE_FRACTION * -M_PI];    
    [values addObject:initialRotation];
    
    int i = 0;

    while (i < floor(moveAnimation.duration / WADDLE_TIME)) {
        // rotate clockwise
        [values addObject:clockwiseRotation];
        [timings addObject:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
        // return to center
        [values addObject:initialRotation];
        [timings addObject:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];        
        // rotate counter-clockwise
        [values addObject:counterClockwiseRotation];
        [timings addObject:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
        // return to center
        [values addObject:initialRotation];
        [timings addObject:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
        
        i += 1;
    }
    [initialRotation release];
    [clockwiseRotation release];
    [counterClockwiseRotation release];
    
    waddleAnimation.values = values;
    waddleAnimation.timingFunctions = timings;
    waddleAnimation.duration = floor(moveAnimation.duration / WADDLE_TIME) * WADDLE_TIME;
    waddleAnimation.removedOnCompletion = NO;
    waddleAnimation.fillMode = kCAFillModeBoth; 
    
    
    CAAnimationGroup *theGroup = [CAAnimationGroup animation];
    
    NSArray *animationGroup = [[NSArray alloc] initWithObjects:moveAnimation, waddleAnimation, nil];
	theGroup.animations = animationGroup;
    [animationGroup release];
    
    theGroup.duration = moveAnimation.duration;
    theGroup.removedOnCompletion = NO;
    theGroup.fillMode = kCAFillModeBoth;
    theGroup.delegate = self;
    
    [animalImage.layer addAnimation:theGroup forKey:@"runAwayAnimation"];
    [values release];
    [timings release];
}

- (void)runAwayFailedAnimation {
    debug_NSLog(@"run away failed");
    CAKeyframeAnimation* moveAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position.x"];
    NSMutableArray *values = [[NSMutableArray alloc] initWithCapacity:5];
    NSMutableArray *timings = [[NSMutableArray alloc] initWithCapacity:5];
    [values addObject:[NSNumber numberWithFloat:animalImage.center.x]];
    
    [values addObject:[NSNumber numberWithFloat:animalImage.center.x + 50]];
    [timings addObject:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];

    [values addObject:[NSNumber numberWithFloat:animalImage.center.x]];
    [timings addObject:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
    
    moveAnimation.values = values;
    moveAnimation.timingFunctions = timings;
    moveAnimation.duration = .5;
    
    [values release];
    [timings release];
    
    CAKeyframeAnimation* waddleAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation"];
    NSMutableArray *waddleValues = [[NSMutableArray alloc] initWithCapacity:5];
    NSMutableArray *waddleTimings = [[NSMutableArray alloc] initWithCapacity:5];
    
    int i = 0;
    NSNumber *initialRotation = [[NSNumber alloc] initWithFloat:0];
#define WADDLE_FRACTION .0625
#define WADDLE_TIME .25    
    NSNumber *clockwiseRotation = [[NSNumber alloc] initWithFloat:WADDLE_FRACTION * M_PI];
    NSNumber *counterClockwiseRotation = [[NSNumber alloc] initWithFloat:WADDLE_FRACTION * -M_PI]; 
    
    [waddleValues addObject:initialRotation]; 
    
    while (i < floor(moveAnimation.duration / WADDLE_TIME)) {
        // rotate clockwise
        [waddleValues addObject:clockwiseRotation];
        [waddleTimings addObject:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
        // return to center
        [waddleValues addObject:initialRotation];
        [waddleTimings addObject:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];        
        // rotate counter-clockwise
        [waddleValues addObject:counterClockwiseRotation];
        [waddleTimings addObject:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
        // return to center
        [waddleValues addObject:initialRotation];
        [waddleTimings addObject:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
        
        i += 1;
    }
    [initialRotation release];
    [clockwiseRotation release];
    [counterClockwiseRotation release];
    
    waddleAnimation.values = waddleValues;
    waddleAnimation.timingFunctions = waddleTimings;
    waddleAnimation.duration = floor(moveAnimation.duration / WADDLE_TIME) * WADDLE_TIME;
    waddleAnimation.removedOnCompletion = NO;
    waddleAnimation.fillMode = kCAFillModeBoth; 
    
    [waddleValues release];
    [waddleTimings release];
    
    CAAnimationGroup *theGroup = [CAAnimationGroup animation];
    
    NSArray *animationGroup = [[NSArray alloc] initWithObjects:moveAnimation, waddleAnimation, nil];
	theGroup.animations = animationGroup;
    [animationGroup release];
    
    theGroup.duration = moveAnimation.duration;
    theGroup.removedOnCompletion = NO;
    theGroup.fillMode = kCAFillModeBoth;
    theGroup.delegate = self;
    
    [animalImage.layer addAnimation:theGroup forKey:@"runAwayFailedAnimation"];
}

#pragma mark Opponent Animal Attack Animations
- (void)animateOpponentAttack1_part1 {
#define OPP_ATTACK_ONE_1_DURATION .4
    
    [self.view bringSubviewToFront:opponentAnimalImage];
    
    CABasicAnimation* moveAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
    moveAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(animalImage.frame.origin.x, 
                                                                  animalImage.frame.origin.y)];
    moveAnimation.duration = OPP_ATTACK_ONE_1_DURATION; 
    moveAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    
    CABasicAnimation* spinAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    
    NSNumber *temp = [[NSNumber alloc] initWithFloat:-M_PI / 4];
    spinAnimation.toValue = temp;
    [temp release];
    
    spinAnimation.duration = OPP_ATTACK_ONE_1_DURATION;
    
    CAAnimationGroup *theGroup = [CAAnimationGroup animation];
    
    NSArray *animationGroup = [[NSArray alloc] initWithObjects:moveAnimation, spinAnimation, nil];
	theGroup.animations = animationGroup;
    [animationGroup release];

    theGroup.duration = OPP_ATTACK_ONE_1_DURATION;    
    theGroup.removedOnCompletion = NO;
    theGroup.fillMode = kCAFillModeBoth;
    theGroup.delegate = self;
    
    [opponentAnimalImage.layer addAnimation:theGroup forKey:@"animateOpponentAttack1_part1"];
}

- (void)animateOpponentAttack1_part2 {
    [self handleAttackTo:YES];
    [opponentAnimalImage.layer removeAnimationForKey:@"animateOpponentAttack1_part1"];           
#define OPP_ATTACK_TWO_2_DURATION .2
    opponentAnimalImage.transform = CGAffineTransformRotate(CGAffineTransformIdentity, -M_PI / 4);
    
    CABasicAnimation* moveAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
    moveAnimation.fromValue = [NSValue valueWithCGPoint:CGPointMake(animalImage.frame.origin.x, animalImage.frame.origin.y)];
    moveAnimation.toValue = 
        [NSValue valueWithCGPoint:CGPointMake(animalImage.center.x + animalImage.frame.size.width, 
                                              animalImage.frame.origin.y + animalImage.frame.size.height)];
    moveAnimation.duration = OPP_ATTACK_TWO_2_DURATION; 
    moveAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    
    moveAnimation.removedOnCompletion = NO;
    moveAnimation.fillMode = kCAFillModeBoth;
    moveAnimation.delegate = self;
    
    [opponentAnimalImage.layer addAnimation:moveAnimation forKey:@"animateOpponentAttack1_part2"];    
}


- (void)animateOpponentAttack1_part3 {
    [opponentAnimalImage.layer removeAnimationForKey:@"animateOpponentAttack1_part2"];
#define OPP_ATTACK_TWO_3_DURATION .3
    CABasicAnimation* moveAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
    CGPoint startingPoint = CGPointMake(opponentAnimalImage.center.x - opponentAnimalImage.frame.size.width, 
                                        opponentAnimalImage.center.y - opponentAnimalImage.frame.size.height);
    moveAnimation.fromValue = [NSValue valueWithCGPoint:startingPoint];
    moveAnimation.toValue = [NSValue valueWithCGPoint:opponentAnimalImage.center];
    
    moveAnimation.duration = OPP_ATTACK_TWO_3_DURATION; 
    moveAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    CABasicAnimation* spinAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    
    NSNumber *temp = [[NSNumber alloc] initWithFloat:0];
    spinAnimation.toValue = temp;
    [temp release];
    
    spinAnimation.duration = OPP_ATTACK_TWO_3_DURATION;
    
    CAAnimationGroup *theGroup = [CAAnimationGroup animation];
    
    NSArray *animationGroup = [[NSArray alloc] initWithObjects:moveAnimation, spinAnimation, nil];
	theGroup.animations = animationGroup;
    [animationGroup release];
    
    theGroup.duration = OPP_ATTACK_TWO_3_DURATION;
    
    theGroup.removedOnCompletion = NO;
    theGroup.fillMode = kCAFillModeBoth;
    theGroup.delegate = self;
    
    
    [opponentAnimalImage.layer addAnimation:theGroup forKey:@"animateOpponentAttack1_part3"];    
}

- (void)animateOpponentAttack2_part1 {
    [self.view bringSubviewToFront:opponentAnimalImage];
#define OPP_ATTACK_TWO_1_DURATION .2
    CABasicAnimation* moveAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
    moveAnimation.toValue = 
        [NSValue valueWithCGPoint:CGPointMake(opponentAnimalImage.center.x, -opponentAnimalImage.frame.size.height / 2)];
    moveAnimation.duration = OPP_ATTACK_TWO_1_DURATION; 
    moveAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    
    moveAnimation.removedOnCompletion = NO;
    moveAnimation.fillMode = kCAFillModeBoth;
    moveAnimation.delegate = self;
    
    [opponentAnimalImage.layer addAnimation:moveAnimation forKey:@"animateOpponentAttack2_part1"]; 
}

- (void)animateOpponentAttack2_part2 {
    [opponentAnimalImage.layer removeAnimationForKey:@"animateOpponentAttack2_part1"];           
#define OPP_ATTACK_TWO_1_DURATION .2
    opponentAnimalImage.transform = CGAffineTransformRotate(CGAffineTransformIdentity, -M_PI);
    
    CABasicAnimation* moveAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
    moveAnimation.fromValue = 
        [NSValue valueWithCGPoint:CGPointMake(animalImage.center.x, -opponentAnimalImage.frame.size.height / 2)];
    moveAnimation.toValue = 
        [NSValue valueWithCGPoint:CGPointMake(animalImage.center.x, animalImage.frame.origin.y)];
    moveAnimation.duration = OPP_ATTACK_TWO_1_DURATION; 
    moveAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    
    moveAnimation.removedOnCompletion = NO;
    moveAnimation.fillMode = kCAFillModeBoth;
    moveAnimation.delegate = self;
    
    [opponentAnimalImage.layer addAnimation:moveAnimation forKey:@"animateOpponentAttack2_part2"];    
}


- (void)animateOpponentAttack2_part3 {
    [self handleAttackTo:YES];    
    [opponentAnimalImage.layer removeAnimationForKey:@"animateOpponentAttack2_part2"];
#define OPP_ATTACK_TWO_3_DURATION .3
    
    CABasicAnimation* moveAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
    moveAnimation.fromValue = 
        [NSValue valueWithCGPoint:CGPointMake(animalImage.center.x, animalImage.frame.origin.y)];
    moveAnimation.toValue = 
        [NSValue valueWithCGPoint:CGPointMake(animalImage.center.x, 
                                            FRAME_HEIGHT_WITH_NO_BARS + opponentAnimalImage.frame.size.height / 2)];
    moveAnimation.duration = OPP_ATTACK_TWO_3_DURATION; 
    moveAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    
    moveAnimation.removedOnCompletion = NO;
    moveAnimation.fillMode = kCAFillModeBoth;
    moveAnimation.delegate = self;    
    
    [opponentAnimalImage.layer addAnimation:moveAnimation forKey:@"animateOpponentAttack2_part3"];    
}

- (void)animateOpponentAttack2_part4 {
    [opponentAnimalImage.layer removeAnimationForKey:@"animateOpponentAttack2_part3"];
#define OPP_ATTACK_TWO_4_DURATION .4
    opponentAnimalImage.transform = CGAffineTransformRotate(CGAffineTransformIdentity, 0);    
    
    CABasicAnimation* moveAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
    moveAnimation.fromValue = 
    [NSValue valueWithCGPoint:CGPointMake(opponentAnimalImage.center.x, 
                                          FRAME_HEIGHT_WITH_NO_BARS + opponentAnimalImage.frame.size.height / 2)];
    moveAnimation.toValue = [NSValue valueWithCGPoint:opponentAnimalImage.center];
    moveAnimation.duration = ATTACK_TWO_4_DURATION; 
    moveAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    moveAnimation.removedOnCompletion = NO;
    moveAnimation.fillMode = kCAFillModeBoth;
    moveAnimation.delegate = self;    
    
    [opponentAnimalImage.layer addAnimation:moveAnimation forKey:@"animateOpponentAttack2_part4"];  
}


- (void)animateOpponentAttack3_part1 {
#define OPP_ATTACK_THREE_1_DURATION .4
    [self.view bringSubviewToFront:opponentAnimalImage];        
    
    CABasicAnimation* moveAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
    moveAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(-opponentAnimalImage.frame.size.width,
                                                                  animalImage.center.y)];
    moveAnimation.duration = OPP_ATTACK_THREE_1_DURATION; 
    moveAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    
    CABasicAnimation* spinAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    spinAnimation.toValue = [NSNumber numberWithFloat:M_PI / 2];
    spinAnimation.duration = OPP_ATTACK_THREE_1_DURATION;
    
    CAAnimationGroup *theGroup = [CAAnimationGroup animation];
	theGroup.animations = [NSArray arrayWithObjects:moveAnimation, spinAnimation, nil];
    theGroup.duration = OPP_ATTACK_THREE_1_DURATION;
    
    theGroup.removedOnCompletion = NO;
    theGroup.fillMode = kCAFillModeBoth;
    theGroup.delegate = self;
    
    [opponentAnimalImage.layer addAnimation:theGroup forKey:@"animateOpponentAttack3_part1"];    
}

- (void)animateOpponentAttack3_part2 {
    [opponentAnimalImage.layer removeAnimationForKey:@"animateOpponentAttack3_part1"];           
#define OPP_ATTACK_THREE_2_DURATION .3
    opponentAnimalImage.transform = CGAffineTransformRotate(CGAffineTransformIdentity, M_PI / 2);
    
    CABasicAnimation* moveAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
    moveAnimation.fromValue = [NSValue valueWithCGPoint:CGPointMake(-opponentAnimalImage.frame.size.width, animalImage.center.y)];
    moveAnimation.toValue = [NSValue valueWithCGPoint:animalImage.center];
    moveAnimation.duration = OPP_ATTACK_THREE_2_DURATION; 
    moveAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    
    moveAnimation.removedOnCompletion = NO;
    moveAnimation.fillMode = kCAFillModeBoth;
    moveAnimation.delegate = self;
    
    [opponentAnimalImage.layer addAnimation:moveAnimation forKey:@"animateOpponentAttack3_part2"];    
}

- (void)animateOpponentAttack3_part3 {
    [opponentAnimalImage.layer removeAnimationForKey:@"animateOpponentAttack3_part2"];           
    [self handleAttackTo:YES];       
#define OPP_ATTACK_THREE_3_DURATION .1
    
    CABasicAnimation* moveAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
    moveAnimation.fromValue = [NSValue valueWithCGPoint:animalImage.center];
    moveAnimation.toValue = 
        [NSValue valueWithCGPoint:CGPointMake(FRAME_WIDTH + opponentAnimalImage.frame.size.width, 
                                              animalImage.center.y)];
    moveAnimation.duration = OPP_ATTACK_THREE_3_DURATION; 
    moveAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    
    moveAnimation.removedOnCompletion = NO;
    moveAnimation.fillMode = kCAFillModeBoth;
    moveAnimation.delegate = self;
    
    [opponentAnimalImage.layer addAnimation:moveAnimation forKey:@"animateOpponentAttack3_part3"];    
}

- (void)animateOpponentAttack3_part4 {
    [opponentAnimalImage.layer removeAnimationForKey:@"animateOpponentAttack3_part3"];
#define OPP_ATTACK_THREE_4_DURATION .5
    opponentAnimalImage.transform = CGAffineTransformRotate(CGAffineTransformIdentity, M_PI / 4);
    
    CABasicAnimation* moveAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
    moveAnimation.fromValue = [NSValue valueWithCGPoint:CGPointMake(FRAME_WIDTH + animalImage.frame.size.width, 
                                                                    -animalImage.frame.size.height)];
    moveAnimation.toValue = [NSValue valueWithCGPoint:opponentAnimalImage.center];
    
    moveAnimation.duration = OPP_ATTACK_THREE_4_DURATION; 
    moveAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    CABasicAnimation* spinAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    spinAnimation.toValue = [NSNumber numberWithFloat:0];
    spinAnimation.duration = OPP_ATTACK_THREE_4_DURATION;
    
    CAAnimationGroup *theGroup = [CAAnimationGroup animation];
	theGroup.animations = [NSArray arrayWithObjects:moveAnimation, spinAnimation, nil];
    theGroup.duration = OPP_ATTACK_THREE_4_DURATION;
    
    theGroup.removedOnCompletion = NO;
    theGroup.fillMode = kCAFillModeBoth;
    theGroup.delegate = self;
    
    [opponentAnimalImage.layer addAnimation:theGroup forKey:@"animateOpponentAttack3_part4"];    
}

- (void)animateOpponentAttack4_part1 {
#define OPP_ATTACK_FOUR_1_DURATION .3
    [self.view bringSubviewToFront:opponentAnimalImage];
    
    CABasicAnimation* moveAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
    moveAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(-opponentAnimalImage.frame.size.width,
                                                                  opponentAnimalImage.center.y)];
    moveAnimation.duration = OPP_ATTACK_FOUR_1_DURATION;
    moveAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    
    CABasicAnimation* spinAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    spinAnimation.toValue = [NSNumber numberWithFloat:-M_PI / 2];
    spinAnimation.duration = OPP_ATTACK_FOUR_1_DURATION;
    
    CAAnimationGroup *theGroup = [CAAnimationGroup animation];
	theGroup.animations = [NSArray arrayWithObjects:moveAnimation, spinAnimation, nil];
    theGroup.duration = OPP_ATTACK_FOUR_1_DURATION;
    
    theGroup.removedOnCompletion = NO;
    theGroup.fillMode = kCAFillModeBoth;
    theGroup.delegate = self;
    
    [opponentAnimalImage.layer addAnimation:theGroup forKey:@"animateOpponentAttack4_part1"];    
}

- (void)animateOpponentAttack4_part2 {
#define OPP_ATTACK_FOUR_2_DURATION .4
    [opponentAnimalImage.layer removeAnimationForKey:@"animateOpponentAttack4_part1"];
    
    opponentAnimalImage.transform = CGAffineTransformRotate(CGAffineTransformIdentity, M_PI / 2);
    
    CAKeyframeAnimation *moveAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    
    CGMutablePathRef thePath = CGPathCreateMutable();
    CGPathMoveToPoint(thePath, NULL, -opponentAnimalImage.frame.size.width, 
                      animalImage.center.y + 2 * opponentAnimalImage.frame.size.height);
    
    CGPathAddCurveToPoint(thePath, NULL,
                          opponentAnimalImage.center.x + (opponentAnimalImage.center.x - animalImage.center.x) / 2, 
                          animalImage.center.y + 2 * opponentAnimalImage.frame.size.height,
                          
                          animalImage.center.x, animalImage.center.y + opponentAnimalImage.frame.size.height,
                          animalImage.center.x, animalImage.center.y);
    
    moveAnimation.path = thePath;
    moveAnimation.duration = OPP_ATTACK_FOUR_2_DURATION;
    moveAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    
    CABasicAnimation* spinAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    spinAnimation.toValue = [NSNumber numberWithFloat:0];
    spinAnimation.duration = OPP_ATTACK_FOUR_2_DURATION;
    
    CAAnimationGroup *theGroup = [CAAnimationGroup animation];
	theGroup.animations = [NSArray arrayWithObjects:moveAnimation, spinAnimation, nil];
    theGroup.duration = OPP_ATTACK_FOUR_2_DURATION;
    
    theGroup.removedOnCompletion = NO;
    theGroup.fillMode = kCAFillModeBoth;
    theGroup.delegate = self;
    
    [opponentAnimalImage.layer addAnimation:theGroup forKey:@"animateOpponentAttack4_part2"]; 
    
    CFRelease(thePath);    
}

- (void)animateOpponentAttack4_part3 {
#define OPP_ATTACK_FOUR_3_DURATION .7
    [opponentAnimalImage.layer removeAnimationForKey:@"animateOpponentAttack4_part2"];
    [self handleAttackTo:YES];
    
    opponentAnimalImage.transform = CGAffineTransformRotate(CGAffineTransformIdentity, 0);
    
    CAKeyframeAnimation *moveAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    
    CGMutablePathRef thePath = CGPathCreateMutable();
    CGPathMoveToPoint(thePath, NULL, animalImage.center.x, animalImage.center.y);
    
    CGPathAddCurveToPoint(thePath, NULL,
                          animalImage.center.x, -2 * opponentAnimalImage.frame.size.height,
                          
                          opponentAnimalImage.center.x, -2 * opponentAnimalImage.frame.size.height,
                          opponentAnimalImage.center.x, opponentAnimalImage.center.y);
    
    moveAnimation.path = thePath;
    moveAnimation.duration = OPP_ATTACK_FOUR_3_DURATION;
    moveAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    CABasicAnimation* spinAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    spinAnimation.toValue = [NSNumber numberWithFloat:-2 * M_PI];
    spinAnimation.duration = OPP_ATTACK_FOUR_3_DURATION;
    
    CAAnimationGroup *theGroup = [CAAnimationGroup animation];
	theGroup.animations = [NSArray arrayWithObjects:moveAnimation, spinAnimation, nil];
    theGroup.duration = OPP_ATTACK_FOUR_3_DURATION;
    
    theGroup.removedOnCompletion = NO;
    theGroup.fillMode = kCAFillModeBoth;
    theGroup.delegate = self;
    
    [opponentAnimalImage.layer addAnimation:theGroup forKey:@"animateOpponentAttack4_part3"]; 
    
    CFRelease(thePath);    
}

- (void)flashAttacked:(BOOL)isPlayer color:(NSInteger)color {
    CGAffineTransform resultsTransformRegular = CGAffineTransformMakeScale(1.0, 1.0);
    CGAffineTransform resultsTransformUp = CGAffineTransformMakeScale(2.0, 2.0); //CGAffineTransformMakeTranslation(0, -200);    
    
    if (color == RED_BOOM) {
        currentlyUsingBoomView = redBoomView;
    } else if (color == YELLOW_BOOM) {
        currentlyUsingBoomView = yellowBoomView;        
    } else {
        currentlyUsingBoomView = purpleBoomView;
    }
    
    currentlyUsingBoomView.alpha = 0;    
    if (currentlyUsingBoomView.superview == nil) {
        [self.view addSubview:currentlyUsingBoomView];
    }
    
    [self.view bringSubviewToFront:currentlyUsingBoomView];
    currentlyUsingBoomView.transform = resultsTransformRegular;    
    currentlyUsingBoomView.center = isPlayer ? animalImage.center : opponentAnimalImage.center;
        
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:.0625];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(finishedFlashing:finished:context:)];
    [currentlyUsingBoomView setTransform:resultsTransformUp];    
    [currentlyUsingBoomView setAlpha:.8];
    
    [UIView commitAnimations];
}

-(void)finishedFlashing:(NSString *)animationID finished:(BOOL)finished context:(void *)context {
    CGAffineTransform resultsTransformUp = CGAffineTransformMakeScale(2.5, 2.5); //CGAffineTransformMakeTranslation(0, -200);    
    
	if (currentlyUsingBoomView == redBoomView) {
		[[SoundManager sharedManager] playSoundWithType:@"hit" vibrate:NO];
	} else if (currentlyUsingBoomView == yellowBoomView) {
		[[SoundManager sharedManager] playSoundWithType:@"spellhit" vibrate:NO];
	}
	
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:.0625];
    [currentlyUsingBoomView setAlpha:0];
    [currentlyUsingBoomView setTransform:resultsTransformUp];
    [UIView commitAnimations];
}


- (void)animateOpponentSpellResponse {
#define RESPONSE_SPELL_DURATION 1.25
#define RESPONSE_SPELL_MOVEMENT 5
#define RESPONSE_SPELL_SHAKE_COUNT 20
	
    CAKeyframeAnimation *movementAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    movementAnimation.duration = RESPONSE_SPELL_DURATION;
    
    // Create arrays for values and associated timings.
    NSMutableArray *movementValues = [[NSMutableArray alloc] initWithCapacity:5];
    NSMutableArray *movementTimings = [[NSMutableArray alloc] initWithCapacity:5];
    
    [movementValues addObject:[NSValue valueWithCGPoint:opponentAnimalImage.center]];
    
	
    for (int i = 0; i < RESPONSE_SPELL_SHAKE_COUNT; i += 1) {
		
        [movementValues addObject:[NSValue valueWithCGPoint:CGPointMake(opponentAnimalImage.center.x + RESPONSE_SPELL_MOVEMENT, opponentAnimalImage.center.y)]];
        [movementTimings addObject:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
        
        [movementValues addObject:[NSValue valueWithCGPoint:CGPointMake(opponentAnimalImage.center.x - RESPONSE_SPELL_MOVEMENT, opponentAnimalImage.center.y)]];
        [movementTimings addObject:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
    }

    [movementValues addObject:[NSValue valueWithCGPoint:opponentAnimalImage.center]];
    [movementTimings addObject:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
    
    movementAnimation.values = movementValues;
    movementAnimation.timingFunctions = movementTimings;
    movementAnimation.duration = RESPONSE_SPELL_DURATION;
    movementAnimation.removedOnCompletion = NO;
    movementAnimation.fillMode = kCAFillModeBoth;
    movementAnimation.delegate = self;
    
    [movementValues release];
    [movementTimings release];
    
    [opponentAnimalImage.layer addAnimation:movementAnimation forKey:@"animateOpponentSpellResponse"]; 
}

- (void)animatePlayerSpellResponse {
    
    CAKeyframeAnimation *movementAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    movementAnimation.duration = RESPONSE_SPELL_DURATION;
    
    // Create arrays for values and associated timings.
    NSMutableArray *movementValues = [[NSMutableArray alloc] initWithCapacity:5];
    NSMutableArray *movementTimings = [[NSMutableArray alloc] initWithCapacity:5];
    
    [movementValues addObject:[NSValue valueWithCGPoint:animalImage.center]];
	
    
    for (int i = 0; i < RESPONSE_SPELL_SHAKE_COUNT; i += 1) {
		
        [movementValues addObject:[NSValue valueWithCGPoint:CGPointMake(animalImage.center.x + RESPONSE_SPELL_MOVEMENT, animalImage.center.y)]];
        [movementTimings addObject:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
        
        [movementValues addObject:[NSValue valueWithCGPoint:CGPointMake(animalImage.center.x - RESPONSE_SPELL_MOVEMENT, animalImage.center.y)]];
        [movementTimings addObject:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
    }
    
    [movementValues addObject:[NSValue valueWithCGPoint:animalImage.center]];
    [movementTimings addObject:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
    
    movementAnimation.values = movementValues;
    movementAnimation.timingFunctions = movementTimings;
    movementAnimation.duration = RESPONSE_SPELL_DURATION;
    movementAnimation.removedOnCompletion = NO;
    movementAnimation.fillMode = kCAFillModeBoth;
    movementAnimation.delegate = self;
    
    [movementValues release];
    [movementTimings release];
    
    [animalImage.layer addAnimation:movementAnimation forKey:@"animatePlayerSpellResponse"]; 
}


- (void)animateOpponentResponse {
#define OPPONENT_RESPONSE_DURATION .5
    CAKeyframeAnimation* rotateAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation"];
    NSMutableArray *values = [[NSMutableArray alloc] initWithCapacity:5];
    NSMutableArray *timings = [[NSMutableArray alloc] initWithCapacity:5];
    
    NSNumber *initialRotation = [[NSNumber alloc] initWithFloat:0];
    NSNumber *counterClockwiseRotation = [[NSNumber alloc] initWithFloat:-M_PI / 4];
    [values addObject:initialRotation];
    
    // rotate counter-clockwise
    [values addObject:counterClockwiseRotation];
    [timings addObject:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
    // return to center
    [values addObject:initialRotation];
    [timings addObject:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
    
    rotateAnimation.values = values;
    rotateAnimation.timingFunctions = timings;
    rotateAnimation.duration = OPPONENT_RESPONSE_DURATION;    
    
    [initialRotation release];
    [counterClockwiseRotation release];
    [timings release];
    [values release];
    
    CAKeyframeAnimation *movementAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    movementAnimation.duration = 1;
    
    // Create arrays for values and associated timings.
    NSMutableArray *movementValues = [[NSMutableArray alloc] initWithCapacity:5];
    NSMutableArray *movementTimings = [[NSMutableArray alloc] initWithCapacity:5];
    
    [movementValues addObject:[NSValue valueWithCGPoint:opponentAnimalImage.center]];
    
    [movementValues addObject:[NSValue valueWithCGPoint:CGPointMake(opponentAnimalImage.center.x - 100, opponentAnimalImage.center.y)]];
    [movementTimings addObject:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];

    [movementValues addObject:[NSValue valueWithCGPoint:opponentAnimalImage.center]];
    [movementTimings addObject:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
        
    movementAnimation.values = movementValues;
    movementAnimation.timingFunctions = movementTimings;
    movementAnimation.duration = OPPONENT_RESPONSE_DURATION;
    
    [movementValues release];
    [movementTimings release];
 
    CAAnimationGroup *theGroup = [CAAnimationGroup animation];
	theGroup.animations = [NSArray arrayWithObjects:movementAnimation, rotateAnimation, nil];
    theGroup.duration = OPPONENT_RESPONSE_DURATION;
    
    [opponentAnimalImage.layer addAnimation:theGroup forKey:@"animateOpponentResponse"];
}

- (void)animatePlayerResponse {
#define PLAYER_RESPONSE_DURATION .5
    CAKeyframeAnimation* rotateAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation"];
    NSMutableArray *values = [NSMutableArray array];
    NSMutableArray *timings = [NSMutableArray array];
    [values addObject:[NSNumber numberWithFloat:0]];
    
    // rotate counter-clockwise
    [values addObject:[NSNumber numberWithFloat:M_PI / 4]];
    [timings addObject:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
    // return to center
    [values addObject:[NSNumber numberWithFloat:0]];
    [timings addObject:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
    
    rotateAnimation.values = values;
    rotateAnimation.timingFunctions = timings;
    rotateAnimation.duration = OPPONENT_RESPONSE_DURATION;    
    
    CAKeyframeAnimation *movementAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    movementAnimation.duration = 1;
    
    // Create arrays for values and associated timings.
    NSMutableArray *movementValues = [NSMutableArray array];
    NSMutableArray *movementTimings = [NSMutableArray array];
    
    [movementValues addObject:[NSValue valueWithCGPoint:animalImage.center]];
    
    [movementValues addObject:[NSValue valueWithCGPoint:CGPointMake(animalImage.center.x + 100, animalImage.center.y)]];
    [movementTimings addObject:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
    
    [movementValues addObject:[NSValue valueWithCGPoint:animalImage.center]];
    [movementTimings addObject:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
    
    movementAnimation.values = movementValues;
    movementAnimation.timingFunctions = movementTimings;
    movementAnimation.duration = OPPONENT_RESPONSE_DURATION;
    
    CAAnimationGroup *theGroup = [CAAnimationGroup animation];
    NSArray *animationGroup = [[NSArray alloc] initWithObjects:movementAnimation, rotateAnimation, nil];
	theGroup.animations = animationGroup;
    [animationGroup release];

    theGroup.duration = OPPONENT_RESPONSE_DURATION;
    
    [animalImage.layer addAnimation:theGroup forKey:@"animatePlayerResponse"];    
}

- (void)animateItemUsed:(BOOL)isPlayer {
	[[SoundManager sharedManager] playSoundWithType:@"powerup" vibrate:NO];
    [self.view bringSubviewToFront:itemUsedImageView];
    itemUsedImageView.image = nil;
    itemUsedImageView.hasBorder = NO;
	NSString *imageUrl;
    UIView *animalUsingItem;
    NSString *animationId;
    if (isPlayer) {
        imageUrl = currentlyUsingItem.imageSquare50;
        animalUsingItem = animalImage;
        animationId = @"animateItemUsedPlayer";        
    } else {
        imageUrl = opponentUsingItem.imageSquare50;
        animalUsingItem = opponentAnimalImage;
        animationId = @"animateItemUsedOpponent";        
    }
    
	[itemUsedImageView loadImageWithUrl:imageUrl];

    itemUsedImageView.center = CGPointMake(animalUsingItem.center.x, -100);
    itemUsedImageView.alpha = 1;
    
    [UIView beginAnimations:animationId context:NULL];
    [UIView setAnimationDuration:0.75];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(finishedUsingItem:finished:context:)];
    itemUsedImageView.center = animalUsingItem.center;
    [UIView commitAnimations];    
}

- (void)animateSpellUsed:(BOOL)onPlayer {
#define ANIMATE_SPELL_DURATION 1
    [[SoundManager sharedManager] playSoundWithType:@"spell" vibrate:NO];	
    // basic view setup
    [self.view bringSubviewToFront:itemUsedImageView];
    itemUsedImageView.image = nil;
    itemUsedImageView.hasBorder = NO;
    
    NSString *imageUrl, *animationId;
    UIView *fromImageView;    
    
    if (onPlayer) {
        animationId = @"animateSpellUsedOnPlayer";
        imageUrl = currentlyAttackedBySpell.imageSquare100;
        
        fromImageView = opponentAnimalImage;
    } else {
        animationId = @"animateSpellUsedOnOpponent";
        imageUrl = opponentAttackedBySpell.imageSquare100;
        
        fromImageView = animalImage;
    }

    itemUsedImageView.alpha = 0;
    [itemUsedImageView loadImageWithUrl:imageUrl];
    
    [UIView beginAnimations:animationId context:NULL];
    [UIView setAnimationDuration:0.5];
    
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(finishedUsingFading:finished:context:)];
     
    fromImageView.alpha = .5;
    [UIView commitAnimations];
}

- (void)finishedUsingFading:(NSString *)animationID finished:(BOOL)finished context:(void *)context {
    [UIView beginAnimations:animationID context:NULL];
    [UIView setAnimationDuration:0.5];
    
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(finishedUsingSpell:finished:context:)];
    
    if ([animationID isEqualToString:@"animateSpellUsedOnPlayer"]) {
        opponentAnimalImage.alpha = 1;
    } else {
        animalImage.alpha = 1;        
    }
    [UIView commitAnimations];
}



- (void)finishedUsingItem:(NSString *)animationID finished:(BOOL)finished context:(void *)context {
    NSString *hideAnimationId;
    if ([animationID isEqualToString:@"animateItemUsedPlayer"]) {
        if (currentBattleResult.playerItemActionResult != nil) {
            [[[BRSession sharedManager] protagonistAnimal] updateWithActionResult:currentBattleResult.playerItemActionResult];
            [itemActionResult mergeWithActionResult:currentBattleResult.playerItemActionResult];
        }
        hideAnimationId = @"animateItemHiddenPlayer";
    } else {
        if (currentBattleResult.opponentItemActionResult != nil) {
            [opponentAnimal updateWithActionResult:currentBattleResult.opponentItemActionResult];
        }
        hideAnimationId = @"animateItemHiddenOpponent";
    } 
    
    [UIView beginAnimations:hideAnimationId context:NULL];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(finishedHidingItem:finished:context:)];    
    itemUsedImageView.alpha = 0;
    [UIView commitAnimations];
}

- (void)finishedHidingItem:(NSString *)animationID finished:(BOOL)finished context:(void *)context {
    [self attackAnimationFinished:[animationID isEqualToString:@"animateItemHiddenPlayer"]];     
}

- (void)finishedUsingSpell:(NSString *)animationID finished:(BOOL)finished context:(void *)context {
	[[SoundManager sharedManager] playSoundWithType:@"spellhit" vibrate:NO];	
    itemUsedImageView.alpha = 1;
    BOOL isPlayer;
    if ([animationID isEqualToString:@"animateSpellUsedOnPlayer"]) {
        opponentAnimalImage.alpha = 1;
        itemUsedImageView.center = animalImage.center;
        [[[BRSession sharedManager] protagonistAnimal] updateWithActionResult:currentBattleResult.playerSpellActionResult];
        [itemActionResult mergeWithActionResult:currentBattleResult.playerSpellActionResult];
        [self animatePlayerSpellResponse];
        isPlayer = YES;
    } else {
        animalImage.alpha = 1;
        itemUsedImageView.center = opponentAnimalImage.center;
        [opponentAnimal updateWithActionResult:currentBattleResult.opponentSpellActionResult];
        [self animateOpponentSpellResponse];        
        isPlayer = NO;
    }
    _scale = 2;    
    
    [UIView beginAnimations:nil context:NULL];
#define FADING_DURATION RESPONSE_SPELL_DURATION / 2
    [UIView setAnimationDuration:FADING_DURATION];
    itemUsedImageView.alpha = 0;
#define TIMER_INTERVAL .01
    [NSTimer scheduledTimerWithTimeInterval:TIMER_INTERVAL target:self selector:@selector(handleTimer:) userInfo:nil repeats:YES];    
    [UIView commitAnimations];
}

-(void)handleTimer:(NSTimer *)timer {
	_angle += 1;
    _spinCount += 1;
    _scale -= .1;
    
	if (_angle > 6.283) { 
		_angle = 0;
	}
    
    if (_spinCount == (int) (FADING_DURATION / TIMER_INTERVAL)) {
        _spinCount = 0;
        _angle = 0;
        _scale = 1.0;

        [timer invalidate];
    }
    
    CGAffineTransform resultsTransformUp = CGAffineTransformMakeScale(_scale, _scale);        	
	CGAffineTransform resultsTransformRotate = CGAffineTransformMakeRotation(_angle);
	itemUsedImageView.transform = CGAffineTransformConcat(resultsTransformUp, resultsTransformRotate);
}


- (void)dealloc {
    debug_NSLog(@"deallocing battle view controller");
    [redColorView release];
	[opponentAnimal release];
    [opponentUsingItem release];
    [currentlyUsingItem release];
    [opponentAttackedBySpell release];
    [currentlyAttackedBySpell release];    
    
	[battleId release];	
    [currentBattleResult release];
    [battleText release];
    [itemUsedImageView release];
    [itemActionResult release];
    
    [opponentAnimalImage release];
    [opponentWeaponImage release];
    [opponentArmorImage release];
    [opponentAccessory1Image release];
    [opponentAccessory2Image release];
    [opponentNameLabel release];
    [opponentHealthLabel release];
    [opponentHealthProgressView release];
    
    [animalImage release];
    [weaponImage release];
    [armorImage release];
    [accessory1Image release];
    [accessory2Image release];
    [nameLabel release];
    [healthLabel release];
    [loadingLabel release];
    [healthProgressView release];
    [loadingActivityIndicator release];
    
    [runButton release];
    [attackButton release];
    [itemButton release];
    
    [historyView release];
    
    [redBoomView release];
    [yellowBoomView release];
    [purpleBoomView release];
	
	[backgroundImage release];
    
    [super dealloc];
}

#pragma mark BRDialogDelegate methods
- (void)dialogDidDismiss:(BRDialog*)dialog {
	[self dismissBattleControllers];
}

@end
