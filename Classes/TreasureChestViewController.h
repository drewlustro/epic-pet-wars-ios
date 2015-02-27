//
//  TreasureChestViewController.h
//  battleroyale
//
//  Created by Amit Matani on 4/23/09.
//  Copyright 2009 Miraphonic, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BRGlobal.h"
#import "RestOperation.h"

@interface TreasureChestViewController : MegaViewController <UITextFieldDelegate, RestResponseDelegate> {
	IBOutlet UITextField *treasureCodeTextField;
	IBOutlet UIButton *treasureCodeButton;
}

@property (nonatomic, retain) UITextField *treasureCodeTextField;
@property (nonatomic, retain) UIButton *treasureCodeButton;

@end
