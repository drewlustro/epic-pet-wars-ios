//
//  SellAmountViewController.m
//  battleroyale
//
//  Created by Amit Matani on 3/24/09.
//  Copyright 2009 Miraphonic, Inc. All rights reserved.
//

#import "SellAmountViewController.h"
#import "ItemDetailWebViewController.h"
#import "Item.h"
#import "Utility.h"

@implementation SellAmountViewController
@synthesize sellButton, profit;

- (id)initWithItemDetailViewController:(ItemDetailWebViewController *)idvc {
    if (self = [super initWithNibName:@"SellAmountView" bundle:[NSBundle mainBundle] itemDetailViewController:idvc]) {
        
        self.title = [NSString stringWithFormat:@"Sell %@", itemDetailViewController.item.name];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setProfitText:1];
    profit.textColor = WEBCOLOR(0x1B8600FF);
    
    [sellButton addTarget:self action:@selector(sellClicked) forControlEvents:UIControlEventTouchUpInside];
}

- (void)sellClicked {
    [itemDetailViewController sellItemWithAmount:[picker selectedRowInComponent:0] + 1];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [NSString stringWithFormat:@"%d", row + 1];
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return itemDetailViewController.item.numOwned;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    [self setProfitText:row + 1];
}

- (void)setProfitText:(NSInteger)numToSell {
    profit.text = [NSString stringWithFormat:@"¥%d", numToSell * itemDetailViewController.item.sellPrice];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}


- (void)dealloc {
    [sellButton release];
    [profit release];
    [super dealloc];
}


@end
