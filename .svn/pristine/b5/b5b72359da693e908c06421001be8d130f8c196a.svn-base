/**
 * BattleRanViewController.m
 * Copyright Miraphonic, Inc 2009. All rights reserved.
 *
 * @author Amit Matani 
 * @created 2/3/09.
 */

#import "BattleRanViewController.h"
#import "BattleViewController.h"
#import "BattleResult.h"
#import "Animal.h"
#import "Consts.h"

@implementation BattleRanViewController

-(id)initWithBattleResult:(BattleResult *)result opponent:(Animal *)opponent 
	 battleViewController:(BattleViewController *)_battleViewController {
	if (self = [super initWithNibName:@"BattleRanView" battleResult:result 
							 opponent:opponent battleViewController:_battleViewController]) {
	}
	return self;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	[okayButton addTarget:battleViewController action:@selector(dismissBattleControllers) 
		 forControlEvents:UIControlEventTouchUpInside];
	[[SoundManager sharedManager] playSoundWithType:@"battlerun" vibrate:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}


- (void)dealloc {
    debug_NSLog(@"deallocing battle won");
    [super dealloc];
}


@end
 