/**
 * BattleListViewController.h
 * Copyright Miraphonic, Inc 2009. All rights reserved.
 *
 * @author Amit Matani 
 * @created 2/1/09.
 */


#import "BasicTopLevelViewController.h"

@class RDCContainerController, Challenger;

@protocol BattleManager

- (void)startBattleWithChallenger:(Challenger *)challenger;

@end



@interface BattleListViewController : BasicTopLevelViewController <BattleManager> {
	RDCContainerController *challengerTableContainer;
	BOOL newLogin;
}

@property (nonatomic, readonly) RDCContainerController *challengerTableContainer;

- (void)failedStartingBattle;
- (void)failedToStartBattle:(NSString *)message;

@end
