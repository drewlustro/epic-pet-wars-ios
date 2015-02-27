//
//  NeedsMoneyViewController.h
//  battleroyale
//
//  Created by Amit Matani on 3/4/09.
//  Copyright 2009 Miraphonic, Inc. All rights reserved.
//

#import "BRGlobal.h"

@interface NeedsMoneyViewController : MegaViewController {
    IBOutlet UIButton *respectButton;
    IBOutlet UIButton *jobButton;
    IBOutlet UIButton *battleButton;
    IBOutlet UIButton *okButton;
    
    IBOutlet UILabel *bankBalanceLabel;
}

- (void)okButtonTapped;

@property (nonatomic, retain) UIButton *respectButton, *jobButton, *battleButton, *okButton;
@property (nonatomic, retain) UILabel *bankBalanceLabel;

@end
