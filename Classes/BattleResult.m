/**
 * BattleResult.m
 * Copyright Miraphonic, Inc 2009. All rights reserved.
 *
 * @author Amit Matani 
 * @created 2/2/09.
 */

#import "BattleResult.h"
#import "ActionResult.h"
#import "Consts.h"

@implementation BattleResult
@synthesize failure, reason, message, formattedResponse, formattedResponseWidth, 
formattedResponseHeight, battleId, playerRunAwayResult, battleFirstMove, 
playerExpWon, flagPlayerWon, flagChallengerWon, playerActionResult, 
playerItemActionResult, opponentItemActionResult, opponentActionResult,
playerSpellActionResult, opponentSpellActionResult, postBattleHTML = _postBattleHTML;

static NSDictionary *fieldMap;
+ (void)initialize {
    if (self = [BattleResult class]) {
        if (fieldMap == nil) {
			fieldMap = [[NSDictionary alloc] initWithObjectsAndKeys:
						@"setFailure:", @"failure",
						@"setReason:", @"reason",
						@"setMessage:", @"message",
						@"setFormattedResponse:", @"formatted_response",
						@"setFormattedResponseWidth:", @"formatted_response_width",
						@"setFormattedResponseHeight:", @"formatted_response_height",
						@"setBattleId:", @"battle_id",
						@"setPlayerRunAwayResult:", @"player_run_away_result",
						@"setBattleFirstMove:", @"battle_first_move",
						@"setPlayerExpWon:", @"player_exp_won",
						@"setFlagPlayerWonWithNumber:", @"flag_player_won",
						@"setFlagChallengerWonWithNumber:", @"flag_challenger_won",						
						@"setPlayerActionResultWithApiResponse:", @"player_action_result",
						@"setPlayerItemActionResultWithApiResponse:", @"player_item_action_result",		
                        
						@"setOpponentActionResultWithApiResponse:", @"challenger_action_result",
						@"setOpponentItemActionResultWithApiResponse:", @"challenger_item_action_result",
						
                        @"setPlayerSpellActionResultWithApiResponse:", @"player_spell_action_result",						                        
						@"setOpponentSpellActionResultWithApiResponse:", @"challenger_spell_action_result",
						
						@"setPostBattleHTML:", @"post_battle_html",
                        
						nil
						];
        }
    }
}

+ (NSDictionary *)GetFieldMapHelper {
    return fieldMap;
}

- (void)setOpponentActionResultWithApiResponse:(NSDictionary *)_value {
	ActionResult *ar = [[ActionResult alloc] initWithApiResponse:_value];
	self.opponentActionResult = ar;
	[ar release];
}

- (void)setPlayerActionResultWithApiResponse:(NSDictionary *)_value {
	ActionResult *ar = [[ActionResult alloc] initWithApiResponse:_value];
	self.playerActionResult = ar;
	[ar release];
}

- (void)setOpponentItemActionResultWithApiResponse:(NSDictionary *)_value {
	ActionResult *ar = [[ActionResult alloc] initWithApiResponse:_value];
	self.opponentItemActionResult = ar;
	[ar release];
}

- (void)setPlayerItemActionResultWithApiResponse:(NSDictionary *)_value {
	ActionResult *ar = [[ActionResult alloc] initWithApiResponse:_value];
	self.playerItemActionResult = ar;
	[ar release];
}

- (void)setOpponentSpellActionResultWithApiResponse:(NSDictionary *)_value {
	ActionResult *ar = [[ActionResult alloc] initWithApiResponse:_value];
	self.opponentSpellActionResult = ar;
	[ar release];
}

- (void)setPlayerSpellActionResultWithApiResponse:(NSDictionary *)_value {
	ActionResult *ar = [[ActionResult alloc] initWithApiResponse:_value];
	self.playerSpellActionResult = ar;
	[ar release];
}

- (void)setFlagPlayerWonWithNumber:(NSNumber *)_value {
	self.flagPlayerWon = _value != nil && [_value intValue] == 1;	
}

- (void)setFlagChallengerWonWithNumber:(NSNumber *)_value {
	self.flagChallengerWon = _value != nil && [_value intValue] == 1;
}

- (BOOL)didPlayerRunAwaySuccessfully {
	return playerRunAwayResult != nil && [playerRunAwayResult intValue] == 2;
}

- (BOOL)didPlayerFailRunning {
	return playerRunAwayResult != nil && [playerRunAwayResult intValue] == 1;
}

- (BOOL)didPlayerGoFirst {
    return [self.battleFirstMove isEqualToString:@"player"];
}

- (void)dealloc {
    debug_NSLog(@"deallocing action result");
	[failure release];
	[reason release];
	[message release];
	[formattedResponse release];
	[formattedResponseWidth release];
	[formattedResponseHeight release];
	[battleId release];
	[playerRunAwayResult release];
	[battleFirstMove release];
	[playerExpWon release];
	[playerActionResult release];
	[opponentActionResult release];
    [playerItemActionResult release];
	[opponentItemActionResult release];
    [playerSpellActionResult release];
    [opponentSpellActionResult release];
	[_postBattleHTML release];
	[super dealloc];
}

@end
