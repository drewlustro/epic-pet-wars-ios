//
//  BuyAmountViewController.m
//  battleroyale
//
//  Created by Amit Matani on 3/23/09.
//  Copyright 2009 Miraphonic, Inc. All rights reserved.
//

#import "BuyAmountViewController.h"
#import "Item.h"
#import "BRSession.h"
#import "RemoteImageViewWithFileStore.h"
#import "ProtagonistAnimal.h"
#import "ItemDetailWebViewController.h"
#import "Utility.h"

@implementation BuyAmountViewController
@synthesize cost, money, buyButton;

- (id)initWithItemDetailViewController:(ItemDetailWebViewController *)idvc {
    if (self = [super initWithNibName:@"BuyAmountView" bundle:[NSBundle mainBundle] itemDetailViewController:idvc]) {

        self.title = [NSString stringWithFormat:@"Buy %@", itemDetailViewController.item.name];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    Item *item = itemDetailViewController.item;
    money.text = [NSString stringWithFormat:@"¥%d", [[[BRSession sharedManager] protagonistAnimal] money]];
    [self setCostText:1];
    owned.text = [NSString stringWithFormat:@"%d", item.numOwned];
    
    [buyButton addTarget:self action:@selector(buyClicked) forControlEvents:UIControlEventTouchUpInside];

}

- (void)buyClicked {
    [itemDetailViewController buyItemWithAmount:[self rowToAmount:[picker selectedRowInComponent:0]]];
}
    
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [NSString stringWithFormat:@"%d", [self rowToAmount:row]];
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    Item *item = itemDetailViewController.item;
    if ([item.categoryKey isEqualToString:@"background"]) {
        return 1;
    } else if ([item.categoryKey isEqualToString:@"investment"] ||
               [item.categoryKey isEqualToString:@"useable"] ||
               [item.categoryKey isEqualToString:@"spell"]) {
        return 14;        
    } else {
        return 5;        
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    [self setCostText:[self rowToAmount:row]];
}


- (NSInteger)rowToAmount:(NSInteger)row {
    NSInteger amount = row + 1;
    if (amount > 9) {
        amount = ((amount + 1) % 10) * 10;
    }
    return amount;
}

- (void)setCostText:(NSInteger)numToPurcahse {
    // get the currently selected amount
    int yenRequired = numToPurcahse * itemDetailViewController.item.cost;

    cost.text = [NSString stringWithFormat:@"¥%d", yenRequired];
    if (yenRequired > [[BRSession sharedManager] protagonistAnimal].money) {
        cost.textColor = WEBCOLOR(0x870000FF);
        buyButton.enabled = NO;
    } else {
        cost.textColor = WEBCOLOR(0x1B8600FF);
        buyButton.enabled = YES;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}


- (void)dealloc {
    [cost release]; 
    [money release];
    [buyButton release];
    [super dealloc];
}


@end
