/**
 * HUDComaViewController.h
 * Copyright Miraphonic, Inc 2009. All rights reserved.
 *
 * @author Amit Matani 
 * @created 2/4/09.
 */


#import "BRGlobal.h"

@class HUDViewController;
@interface HUDComaViewController : MegaViewController {
	IBOutlet UILabel *moneyLabel;
	IBOutlet UILabel *respectPointsLabel;
	IBOutlet UILabel *reviveTimerLabel;
	
	IBOutlet UIButton *hospitalButton;
    IBOutlet UIButton *battleMasterButton;
	HUDViewController *_hudViewController;
}

@property (nonatomic, retain)  UILabel *moneyLabel;
@property (nonatomic, retain)  UILabel *respectPointsLabel;
@property (nonatomic, retain)  UILabel *reviveTimerLabel;

@property (nonatomic, retain)  UIButton *hospitalButton;
@property (nonatomic, retain)  UIButton *battleMasterButton;
@property (nonatomic, assign)  HUDViewController *hudViewController;


- (void)reset;
- (void)finishedUsingHospital:(NSNumber *)responseInt parsedResponse:(NSDictionary *)parsedResponse;

- (void)failedUsingHospital;
- (void)cleanup;

@end
