/**
 * BattleViewController.h
 * Copyright Miraphonic, Inc 2009. All rights reserved.
 *
 * @author Amit Matani 
 * @created 2/2/09.
 */


#import "BRGlobal.h"
#import "BRDialog.h"

@class RemoteImageViewWithFileStore, Animal, Item, ActionResult, PDColoredProgressView, BattleResult;

@protocol UseItemDelegate

- (void)useItemInBattle:(Item *)item;

@end

@interface BattleViewController : MegaViewController <UseItemDelegate, BRDialogDelegate> {
	IBOutlet RemoteImageViewWithFileStore *opponentAnimalImage;
	IBOutlet RemoteImageViewWithFileStore *opponentWeaponImage;
	IBOutlet RemoteImageViewWithFileStore *opponentArmorImage;
	IBOutlet RemoteImageViewWithFileStore *opponentAccessory1Image;
	IBOutlet RemoteImageViewWithFileStore *opponentAccessory2Image;
	IBOutlet RemoteImageViewWithFileStore *backgroundImage;
	IBOutlet UILabel *opponentNameLabel;
	IBOutlet UILabel *opponentHealthLabel;
	IBOutlet PDColoredProgressView *opponentHealthProgressView;
	
	IBOutlet RemoteImageViewWithFileStore *animalImage;
	IBOutlet RemoteImageViewWithFileStore *weaponImage;
	IBOutlet RemoteImageViewWithFileStore *armorImage;
	IBOutlet RemoteImageViewWithFileStore *accessory1Image;
	IBOutlet RemoteImageViewWithFileStore *accessory2Image;
	IBOutlet UILabel *nameLabel;
	IBOutlet UILabel *healthLabel, *loadingLabel;
	IBOutlet PDColoredProgressView *healthProgressView;
    IBOutlet UIActivityIndicatorView *loadingActivityIndicator;
	
	IBOutlet UIButton *attackButton;
	IBOutlet UIButton *runButton, *itemButton;
	
	IBOutlet UIWebView *historyView;
	
	Animal *opponentAnimal;
	NSString *battleId;
	NSString *battleText;
	Item *currentlyUsingItem;
    Item *opponentUsingItem;
    
    Item *currentlyAttackedBySpell;
    Item *opponentAttackedBySpell;
	
	ActionResult *itemActionResult;
    
    UIView *redColorView;
    RemoteImageViewWithFileStore *itemUsedImageView;
    
    UIImageView *redBoomView, *purpleBoomView, *yellowBoomView, *currentlyUsingBoomView;
    
    BattleResult *currentBattleResult;
    
    float _angle, _spinCount, _scale;
	
	NSInteger useItemCategoryIndex;
}

@property (nonatomic, retain) RemoteImageViewWithFileStore *opponentAnimalImage;
@property (nonatomic, retain) RemoteImageViewWithFileStore *opponentWeaponImage;
@property (nonatomic, retain) RemoteImageViewWithFileStore *opponentArmorImage;
@property (nonatomic, retain) RemoteImageViewWithFileStore *opponentAccessory1Image;
@property (nonatomic, retain) RemoteImageViewWithFileStore *opponentAccessory2Image, *backgroundImage;
@property (nonatomic, retain) UILabel *opponentNameLabel;
@property (nonatomic, retain) UILabel *opponentHealthLabel;
@property (nonatomic, retain) PDColoredProgressView *opponentHealthProgressView;

@property (nonatomic, retain) RemoteImageViewWithFileStore *animalImage;
@property (nonatomic, retain) RemoteImageViewWithFileStore *weaponImage;
@property (nonatomic, retain) RemoteImageViewWithFileStore *armorImage;
@property (nonatomic, retain) RemoteImageViewWithFileStore *accessory1Image;
@property (nonatomic, retain) RemoteImageViewWithFileStore *accessory2Image;
@property (nonatomic, retain) UILabel *nameLabel;
@property (nonatomic, retain) UILabel *healthLabel, *loadingLabel;
@property (nonatomic, retain) PDColoredProgressView *healthProgressView;
@property (nonatomic, retain) UIActivityIndicatorView *loadingActivityIndicator;

@property (nonatomic, retain) UIButton *attackButton;
@property (nonatomic, retain) UIButton *runButton, *itemButton;

@property (nonatomic, retain) UIWebView *historyView;

@property (nonatomic, assign) NSInteger useItemCategoryIndex;

- (id)initWithOpponentAnimal:(Animal *)opponent andBattleId:(NSString *)battle andInitialAction:(ActionResult *)actionResult;
- (void)failedMove;
- (void)configureProtagonistHpDisplay:(BOOL)animate;
- (void)configureOpponentHpDisplay:(BOOL)animate;
- (void)setBattleText:(NSString *)_value;
- (void)flashAttacked:(BOOL)isPlayer color:(NSInteger)color;

- (void)animateOpponentResponse;
- (void)animatePlayerResponse;
- (void)animateOpponentAttack;
- (void)animatePlayerAttack;
- (void)postAnimations;

- (void)animatePlayerAttack1_part1;
- (void)animatePlayerAttack1_part2;
- (void)animatePlayerAttack1_part3;

- (void)animatePlayerAttack2_part1;
- (void)animatePlayerAttack2_part2;
- (void)animatePlayerAttack2_part3;
- (void)animatePlayerAttack2_part4;

- (void)animatePlayerAttack3_part1;
- (void)animatePlayerAttack3_part2;
- (void)animatePlayerAttack3_part3;
- (void)animatePlayerAttack3_part4;

- (void)animatePlayerAttack4_part1;
- (void)animatePlayerAttack4_part2;
- (void)animatePlayerAttack4_part3;
- (void)animatePlayerAttack4_part4;

- (void)animateOpponentAttack1_part1;
- (void)animateOpponentAttack1_part2;
- (void)animateOpponentAttack1_part3;

- (void)animateOpponentAttack2_part1;
- (void)animateOpponentAttack2_part2;
- (void)animateOpponentAttack2_part3;
- (void)animateOpponentAttack2_part4;

- (void)animateOpponentAttack3_part1;
- (void)animateOpponentAttack3_part2;
- (void)animateOpponentAttack3_part3;
- (void)animateOpponentAttack3_part4;

- (void)animateOpponentAttack4_part1;
- (void)animateOpponentAttack4_part2;
- (void)animateOpponentAttack4_part3;

- (void)runAwayAnimation;
- (void)runAwayFailedAnimation;

- (void)dismissBattleControllers;

- (void)animateItemUsed:(BOOL)isPlayer;
- (void)animateSpellUsed:(BOOL)onPlayer;


@end
