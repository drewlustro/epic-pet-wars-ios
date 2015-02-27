//
//  BuyAmountViewController.h
//  battleroyale
//
//  Created by Amit Matani on 3/23/09.
//  Copyright 2009 Miraphonic, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ItemAmountViewController.h"

@interface BuyAmountViewController : ItemAmountViewController {
    IBOutlet UILabel *cost, *money;
    IBOutlet UIButton *buyButton;
}

@property (nonatomic, retain) UILabel *cost, *money;
@property (nonatomic, retain) UIButton *buyButton;

- (void)setCostText:(NSInteger)numToPurcahse;
- (id)initWithItemDetailViewController:(ItemDetailWebViewController *)idvc;
- (NSInteger)rowToAmount:(NSInteger)row;

@end
