//
//  DoubleEquipItemDetailViewController.h
//  battleroyale
//
//  Created by Amit Matani on 1/29/09.
//  Copyright 2009 Miraphonic, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ItemDetailViewController.h"

@interface DoubleEquipItemDetailViewController : ItemDetailViewController {
    UIButton *equipButton0, *equipButton1, *selectedButton;
}

- (void)equipItem:(id)sender;
- (void)unequipItem:(id)sender;
- (void)configureButton:(UIButton *)button;
- (void)finishedEquiping:(NSNumber *)responseCode 
    parsedResponse:(NSDictionary *)parsedResponse;
- (void)failedEquiping;

- (void)finishedUnequiping:(NSNumber *)responseCode 
    parsedResponse:(NSDictionary *)parsedResponse;

- (void)failedUnequiping;

@end
