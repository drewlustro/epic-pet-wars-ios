/**
 * BattleItemTableViewContainerViewController.h
 * Copyright Miraphonic, Inc 2009. All rights reserved.
 *
 * @author Amit Matani 
 * @created 2/10/09.
 */


#import <UIKit/UIKit.h>
#import "RDCContainerController.h"
#import "BattleViewController.h"

@class BattleViewController;
@interface BattleItemTableViewContainerViewController : RDCContainerController <UseItemDelegate> {
	BattleViewController *battleViewController;
}

- (id)initWithIndexSelected:(NSInteger)index;

@property (nonatomic, assign) BattleViewController *battleViewController;


@end
