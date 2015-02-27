//
//  ItemReceivedViewController.h
//  battleroyale
//
//  Created by Amit Matani on 4/11/09.
//  Copyright 2009 Miraphonic, Inc. All rights reserved.
//

#import "BRGlobal.h"

@class RemoteImageViewWithFileStore, Item;
@interface ItemReceivedViewController : MegaViewController {
    IBOutlet RemoteImageViewWithFileStore *itemImage;
    IBOutlet UILabel *itemName;
	IBOutlet UILabel *itemDetails;
    IBOutlet UIButton *continueButton;
    
    Item *item;
}

@property (nonatomic, retain) RemoteImageViewWithFileStore *itemImage;
@property (nonatomic, retain) UILabel *itemName, *itemDetails;
@property (nonatomic, retain) UIButton *continueButton;

- (id)initWithItem:(Item *)_item;
- (void)continueButtonTapped;

@end
