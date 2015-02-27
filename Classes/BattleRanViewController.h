/**
 * BattleRanViewController.h
 * Copyright Miraphonic, Inc 2009. All rights reserved.
 *
 * @author Amit Matani 
 * @created 2/3/09.
 */


#import <UIKit/UIKit.h>
#import "BattleResultViewController.h"

@class BattleResult, Animal, BattleViewController;
@interface BattleRanViewController : BattleResultViewController {

}

-(id)initWithBattleResult:(BattleResult *)result opponent:(Animal *)opponent 
	 battleViewController:(BattleViewController *)_battleViewController;

@end
