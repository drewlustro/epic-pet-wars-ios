//
//  ItemAmountViewController.h
//  battleroyale
//
//  Created by Amit Matani on 3/24/09.
//  Copyright 2009 Miraphonic, Inc. All rights reserved.
//

#import "BRGlobal.h"

@class ItemDetailWebViewController, RemoteImageViewWithFileStore;
@interface ItemAmountViewController : MegaViewController <UIPickerViewDelegate, UIPickerViewDataSource> {
    ItemDetailWebViewController *itemDetailViewController;
    IBOutlet UIPickerView *picker;
    IBOutlet UILabel *owned;
    IBOutlet UIButton *cancelButton;
    IBOutlet RemoteImageViewWithFileStore *itemImage;
}

@property (nonatomic, assign) ItemDetailWebViewController *itemDetailViewController;
@property (nonatomic, retain) UIPickerView *picker;
@property (nonatomic, retain) UILabel *owned;
@property (nonatomic, retain) RemoteImageViewWithFileStore *itemImage;
@property (nonatomic, retain) UIButton *cancelButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil 
itemDetailViewController:(ItemDetailWebViewController *)itemDetailViewController;
- (void)cancelButtonClicked;

@end
