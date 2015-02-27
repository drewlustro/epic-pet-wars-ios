/**
 * BattleItemTableViewContainerViewController.m
 * Copyright Miraphonic, Inc 2009. All rights reserved.
 *
 * @author Amit Matani 
 * @created 2/10/09.
 */

#import "BattleItemTableViewContainerViewController.h"
#import "BattleItemsTableViewController.h"
#import "BRGlobal.h"

@implementation BattleItemTableViewContainerViewController
@synthesize battleViewController;

- (id)initWithIndexSelected:(NSInteger)index {
	BattleItemsTableViewController *bitvc = [[BattleItemsTableViewController alloc] initWithIndexSelected:index];
	if (self = [super initWithRemoteDataController:bitvc]) {
		self.title = @"Battle Items";
		[bitvc loadInitialData:NO showLoadingOverlay:NO];		
	}
	[bitvc release];	
	return self;
}

- (void)loadView {
	[super loadView];
	
	UIBarButtonItem *cancelButton = 
		[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
													  target:self 
													  action:@selector(cancelButtonTapped)];
    self.navigationItem.leftBarButtonItem = cancelButton;
    [cancelButton release];
	
	
	[self setViewFrame:CGRectMake(0, 0, FRAME_WIDTH, FRAME_HEIGHT_WITH_NAVIGATION_BAR)];
}

- (void)cancelButtonTapped {		
    [self dismissTopMostModalViewControllerWithAnimationAndSound];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}

- (void)useItemInBattle:(Item *)item {
	[[SoundManager sharedManager] playSoundWithType:@"pet" vibrate:NO];	
	[self dismissTopMostModalViewControllerWithAnimation];
	[battleViewController useItemInBattle:item];
}

- (void)dealloc {
    debug_NSLog(@"deallocing container of battle items");
    [super dealloc];
}


@end
