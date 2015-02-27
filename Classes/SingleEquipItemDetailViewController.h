/**
 * SingleEquipItemDetailViewController.h
 * Copyright Miraphonic, Inc 2009. All rights reserved.
 *
 * The SingleEquipItemDetailViewController adds the ability to equip an
 * item to the ItemDetailViewController
 *
 * @author Amit Matani
 * @created 1/28/09
 */


#import <UIKit/UIKit.h>
#import "ItemDetailViewController.h"

@interface SingleEquipItemDetailViewController : ItemDetailViewController {
    UIButton *equipButton;
}

- (void)equipItem:(id)sender;

- (void)finishedEquiping:(NSNumber *)responseCode 
    parsedResponse:(NSDictionary *)parsedResponse;

- (void)failedEquiping;

- (void)unequipItem:(id)sender;

- (void)finishedUnequiping:(NSNumber *)responseCode 
    parsedResponse:(NSDictionary *)parsedResponse;
    
- (void)failedUnequiping;

- (void)configureButton;

@end
