//
//  LeveledUpViewController.h
//  battleroyale
//
//  Created by Amit Matani on 3/11/09.
//  Copyright 2009 Miraphonic, Inc. All rights reserved.
//

#import "BRGlobal.h"

@class ActionResult, RemoteImageViewWithFileStore;
@interface LeveledUpViewController : MegaViewController {
    IBOutlet UILabel *attackIncreasedLabel, *defenseIncreasedLabel, 
                     *hpMaxIncreasedLabel, *energyIncreasedLabel,
                     *hpRefreshedLabel, *energyRefreshedLabel,
                     *itemName;
    IBOutlet UIButton *continueButton;
    IBOutlet RemoteImageViewWithFileStore *itemImage;
    
    ActionResult *actionResult;
    
    IBOutlet UIView *whatsNextView, *itemView;
}

@property (nonatomic, retain) UILabel *attackIncreasedLabel, *defenseIncreasedLabel, 
                                      *hpMaxIncreasedLabel, *energyIncreasedLabel,
                                      *hpRefreshedLabel, *energyRefreshedLabel,
                                      *itemName;
@property (nonatomic, retain) UIButton *continueButton;
@property (nonatomic, retain) UIView *whatsNextView, *itemView;
@property (nonatomic, retain) RemoteImageViewWithFileStore *itemImage;

- (id)initWithActionResult:(ActionResult *)_actionResult;
- (void)continueButtonTapped;

@end
