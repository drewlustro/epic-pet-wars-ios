/**
 * BattleResult.h
 * Copyright Miraphonic, Inc 2009. All rights reserved.
 *
 * @author Amit Matani 
 * @created 2/2/09.
 */

#import <Foundation/Foundation.h>
#import "AbstractRestRequestedModel.h"

@class ActionResult;
@interface BattleResult : AbstractRestRequestedModel {
    NSString *failure;
    NSString *reason;
    NSString *message;
    NSString *formattedResponse;
    NSString *formattedResponseWidth;
    NSString *formattedResponseHeight;
    NSString *battleId;
    NSNumber *playerRunAwayResult;
    NSString *battleFirstMove;
    NSString *playerExpWon;
    BOOL flagPlayerWon;
    BOOL flagChallengerWon;
	
	NSString *_postBattleHTML;
	
	ActionResult *playerActionResult;
	ActionResult *opponentActionResult;
	
	ActionResult *playerItemActionResult;
	ActionResult *opponentItemActionResult;
    
	ActionResult *playerSpellActionResult;
	ActionResult *opponentSpellActionResult;        
    
}

@property (nonatomic, copy) NSString *failure;
@property (nonatomic, copy) NSString *reason;
@property (nonatomic, copy) NSString *message;
@property (nonatomic, copy) NSString *formattedResponse;
@property (nonatomic, copy) NSString *formattedResponseWidth;
@property (nonatomic, copy) NSString *formattedResponseHeight;
@property (nonatomic, copy) NSString *battleId;
@property (nonatomic, copy) NSNumber *playerRunAwayResult;
@property (nonatomic, copy) NSString *battleFirstMove;
@property (nonatomic, copy) NSString *playerExpWon;
@property (nonatomic, assign) BOOL flagPlayerWon;
@property (nonatomic, assign) BOOL flagChallengerWon;
@property (nonatomic, retain) ActionResult *playerActionResult;
@property (nonatomic, retain) ActionResult *opponentActionResult;
@property (nonatomic, retain) ActionResult *playerItemActionResult;
@property (nonatomic, retain) ActionResult *opponentItemActionResult;
@property (nonatomic, retain) ActionResult *playerSpellActionResult;
@property (nonatomic, retain) ActionResult *opponentSpellActionResult;
@property (nonatomic, copy) NSString *postBattleHTML;

- (BOOL)didPlayerRunAwaySuccessfully;
- (BOOL)didPlayerFailRunning;
- (BOOL)didPlayerGoFirst;
- (BOOL)didPlayerRunAwaySuccessfully;

@end
