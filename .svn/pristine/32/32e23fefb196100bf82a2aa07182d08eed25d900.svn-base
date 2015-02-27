/**
 * HUDViewController.h
 * Copyright Miraphonic, Inc 2009. All rights reserved.
 *
 * HUDViewController manages the hudview.  It shows the heads up display
 * that is common to all screens
 *
 * @author Amit Matani
 * @created 1/19/09
 */
#import "BattleRoyale.h"
#import "BRGlobal.h"

@class HUDComaViewController, PDColoredProgressView, BlinkingUILabel;
@interface HUDViewController : MegaViewController {
    IBOutlet BlinkingUILabel *hpLabel, *energyLabel, *yenLabel, *moodLabel, 
                             *posseLabel, *respectPointsLabel, *lvlLabel, 
                             *experienceLabel, *cashFlowLabel, *bankFundsLabel;
    IBOutlet UILabel *refreshEnergyLabel;
    IBOutlet BlinkingUILabel *atkLabel;
    IBOutlet BlinkingUILabel *defLabel;
	IBOutlet PDColoredProgressView *experienceProgressView;
	IBOutlet PDColoredProgressView *hpProgressView;    
    IBOutlet UIButton *respectButton;
    IBOutlet UILabel *refreshHpLabel, *refreshMoneyLabel;
    IBOutlet UILabel *cashFlowKeyLabel;
	
	HUDComaViewController *comaController;
	UIViewController *_ownerViewController;
	
//    NSMutableArray *blinkQueue;
}

@property (nonatomic, retain) BlinkingUILabel *hpLabel, *energyLabel, *yenLabel, *moodLabel, 
                                                *posseLabel, *respectPointsLabel, *lvlLabel, 
                                                *experienceLabel, *cashFlowLabel, *bankFundsLabel;
@property (nonatomic, retain) UILabel *refreshEnergyLabel;
@property (nonatomic, retain) BlinkingUILabel *atkLabel;
@property (nonatomic, retain) BlinkingUILabel *defLabel;
@property (nonatomic, retain) PDColoredProgressView *experienceProgressView;
@property (nonatomic, retain) UIButton *respectButton;
@property (nonatomic, retain) UILabel *refreshHpLabel, *refreshMoneyLabel;
@property (nonatomic, retain) UILabel *cashFlowKeyLabel;
@property (nonatomic, retain) PDColoredProgressView *hpProgressView;

@property (nonatomic, assign) UIViewController *ownerViewController;

/** 
 * Reset will reload all data in the views to conform to the
 * data in the session.  This is called usually on login
 */
- (void)reset;
- (void)configureCashFlowDisplay:(BOOL)animate;
- (void)showComaOverlay;
- (void)hideComaOverlay;
- (void)cleanup;
- (void)respectButtonClicked;

@end
