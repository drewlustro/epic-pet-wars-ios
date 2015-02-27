/**
 * BattleWonViewController.h
 * Copyright Miraphonic, Inc 2009. All rights reserved.
 *
 * @author Amit Matani 
 * @created 2/2/09.
 */


#import <UIKit/UIKit.h>
#import "BattleResultViewController.h"

@class BattleResult, Animal, BattleViewController, RemoteImageViewWithFileStore;
@interface BattleWonViewController : BattleResultViewController {
    IBOutlet UILabel *experienceLabel, *moneyLabel, *winsLabel, *leveledUpLabel, *itemName, *itemDetails;
    IBOutlet UIView *whatsNextView, *itemView;
    IBOutlet RemoteImageViewWithFileStore *itemImage;
}

-(id)initWithBattleResult:(BattleResult *)result opponent:(Animal *)opponent 
	 battleViewController:(BattleViewController *)_battleViewController;

@property (nonatomic, retain) UILabel *experienceLabel, *moneyLabel, *winsLabel, *leveledUpLabel, *itemName, *itemDetails;
@property (nonatomic, retain) UIView *whatsNextView, *itemView;
@property (nonatomic, retain) RemoteImageViewWithFileStore *itemImage;
@end
