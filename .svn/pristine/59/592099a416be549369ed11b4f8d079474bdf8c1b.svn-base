/**
 * BattleLostViewController.m
 * Copyright Miraphonic, Inc 2009. All rights reserved.
 *
 * @author Amit Matani 
 * @created 2/2/09.
 */

#import "BattleLostViewController.h"
#import "BattleResult.h"
#import "Animal.h"
#import "Consts.h"
#import "ActionResult.h"

@implementation BattleLostViewController
@synthesize moneyLabel;

-(id)initWithBattleResult:(BattleResult *)result opponent:(Animal *)opponent 
	 battleViewController:(BattleViewController *)_battleViewController {
	if (self = [super initWithNibName:@"BattleLostView" battleResult:result 
					  opponent:opponent battleViewController:_battleViewController]) {
	}
	return self;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    moneyLabel.text = [NSString stringWithFormat:@"¥%d", -1 * [battleResult.playerActionResult.money intValue]];
	[[SoundManager sharedManager] playSoundWithType:@"battlelost" vibrate:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}


- (void)dealloc {
    debug_NSLog(@"deallocing battle lost");
    [moneyLabel release];
    [super dealloc];
}


@end
