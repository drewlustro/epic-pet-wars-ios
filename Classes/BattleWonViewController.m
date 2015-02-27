/**
 * BattleWonViewController.m
 * Copyright Miraphonic, Inc 2009. All rights reserved.
 *
 * @author Amit Matani 
 * @created 2/2/09.
 */

#import "BattleWonViewController.h"
#import "BattleViewController.h"
#import "BattleResult.h"
#import "Animal.h"
#import "Consts.h"
#import "ActionResult.h"
#import "BRSession.h"
#import "ProtagonistAnimal.h"
#import "BRAppDelegate.h"
#import "BRTabManager.h"
#import "Item.h"
#import "RemoteImageViewWithFileStore.h"

@implementation BattleWonViewController
@synthesize experienceLabel, moneyLabel, winsLabel, leveledUpLabel, whatsNextView, itemView, itemName, itemImage, itemDetails;

-(id)initWithBattleResult:(BattleResult *)result opponent:(Animal *)opponent 
	 battleViewController:(BattleViewController *)_battleViewController {
	if (self = [super initWithNibName:@"BattleWonView" battleResult:result 
							 opponent:opponent battleViewController:_battleViewController]) {
	}
	return self;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    experienceLabel.text = [NSString stringWithFormat:@"%@ EXP", battleResult.playerActionResult.exp];
    moneyLabel.text = [NSString stringWithFormat:@"¥%@", battleResult.playerActionResult.money]; 
    ProtagonistAnimal *protagonist = [[BRSession sharedManager] protagonistAnimal];
    NSString *wins = [[NSString alloc] initWithFormat:@"%d", [protagonist.wins intValue] + 1];
    protagonist.wins = wins;
    winsLabel.text = wins;
    [wins release];
    
    leveledUpLabel.hidden = battleResult.playerActionResult.level == nil;
    
    if (battleResult.playerActionResult.item == nil) {
        itemView.hidden = YES;
    } else {
        whatsNextView.hidden = YES;
        itemName.text = battleResult.playerActionResult.item.name;
		itemDetails.text = battleResult.playerActionResult.item.details;
        [itemImage loadImageWithUrl:battleResult.playerActionResult.item.imageSquare100];
    }
	
	[[SoundManager sharedManager] playSoundWithType:@"battlewon" vibrate:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}


- (void)dealloc {
	debug_NSLog(@"deallocing battle won");
    [experienceLabel release];
    [moneyLabel release];
    [winsLabel release];
    [leveledUpLabel release];
    [whatsNextView release];
    [itemView release];
    [itemName release];
	[itemDetails release];
    [itemImage release];
    [super dealloc];
}
@end
