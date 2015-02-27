/**
 * BattleResultViewController.h
 * Copyright Miraphonic, Inc 2009. All rights reserved.
 *
 * @author Amit Matani 
 * @created 2/2/09.
 */


#import "BRGlobal.h"

@class Animal, BattleResult, BattleViewController;
@interface BattleResultViewController : MegaViewController {
	Animal *opponentAnimal;
	BattleResult *battleResult;
	BattleViewController *battleViewController;
    IBOutlet UIButton *okayButton, *battleMasterButton, *leaveCommentButton;
}

-(id)initWithNibName:(NSString *)nibName battleResult:(BattleResult *)result
	 opponent:(Animal *)opponent battleViewController:(BattleViewController *)battleViewController;
- (void)dismissBattleControllersAndShowBattleMaster;

@property (nonatomic, retain) UIButton *okayButton, *battleMasterButton, *leaveCommentButton;
@end
