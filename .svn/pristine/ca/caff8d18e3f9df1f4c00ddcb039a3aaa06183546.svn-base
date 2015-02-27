//
//  SpellItemDetailViewController.m
//  battleroyale
//
//  Created by Amit Matani on 5/24/09.
//  Copyright 2009 Miraphonic, Inc. All rights reserved.
//

#import "SpellItemDetailViewController.h"

#import "HUDViewController.h"
#import "BRSession.h"
#import "Item.h"
#import "BRAppDelegate.h"
#import "RemoteImageViewWithFileStore.h"
#import "Consts.h"
#import "ProtagonistAnimal.h"
#import "BRRestClient.h"
#import "ActionResult.h"
#import "Notifier.h"
#import "AbstractRDTWithCategoriesController.h"
#import "Utility.h"
#import "NeedsMoneyViewController.h"
#import "OwnedEquipmentSet.h"
#import "BuyAmountViewController.h"
#import "SellAmountViewController.h"


@implementation SpellItemDetailViewController

#define PADDING 10
#define FONT_SIZE 14
#define MINIMUM_FONT_SIZE 10
#define KEY_WIDTH 120
#define VALUE_WIDTH 50
#define BUTTON_HEIGHT 46
#define BUTTON_WIDTH 140
#define BUTTON_FONT_SIZE 13

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/


// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
	
	UIView *viewTemp = [[UIView alloc] initWithFrame:CGRectMake(0, 0, FRAME_WIDTH, FRAME_HEIGHT_WITH_NO_BARS)];
    self.view = viewTemp;
    [viewTemp release];
	
    [self.view addSubview:hud.view];
	
    CGFloat y = hud.view.frame.origin.y + hud.view.frame.size.height;
    CGFloat imageWidth = 100;
    
	UIImageView *gradientBg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"item_view_bg.png"]];
	gradientBg.frame = CGRectMake(0, y, 320, 340);
	[self.view addSubview:gradientBg];
	[gradientBg release];
	
	y += PADDING;
    RemoteImageViewWithFileStore *itemImageView = 
	[[RemoteImageViewWithFileStore alloc] initWithFrame:CGRectMake(FRAME_WIDTH - PADDING - imageWidth, y, imageWidth, imageWidth)];
    itemImageView.hasBorder = NO;
    
    [itemImageView loadImageWithUrl:item.imageSquare100];
    [self.view addSubview:itemImageView];
    
    CGFloat height = 20;
    
    [self setupCashflowLabelWithValue:item.cashFlow 
							 withRect:CGRectMake(itemImageView.frame.origin.x, y + imageWidth + PADDING, imageWidth, height)];
    
    CGFloat x = PADDING;
	
    CGFloat width = KEY_WIDTH;
	
    if (item.boostHp != 0) {
        [self setupLabelWithName:@"HP Effect" andValue:item.boostHp withRect:CGRectMake(x, y, width, height)];
        y += height;
    }
    
    if (item.boostHpMax != 0) {
        [self setupLabelWithName:@"Max HP Effect" andValue:item.boostHpMax withRect:CGRectMake(x, y, width, height)];
        y += height;
    }
	
	/*
    if (item.boostEnergy != 0) {
        [self setupLabelWithName:@"Restores Energy" andValue:item.boostEnergy withRect:CGRectMake(x, y, width, height)];
        y += height;
    }
	
    if (item.boostEnergyMax != 0) {
        [self setupLabelWithName:@"Max Energy Boost" andValue:item.boostEnergyMax withRect:CGRectMake(x, y, width, height)];
        y += height;
    }
	*/
	
    if (item.boostAtk != 0) {
        [self setupLabelWithName:@"Attack Effect" andValue:item.boostAtk withRect:CGRectMake(x, y, width, height)];
        y += height;
    }
	
    if (item.boostDef != 0) {
        [self setupLabelWithName:@"Defense Effect" andValue:item.boostDef withRect:CGRectMake(x, y, width, height)];
        y += height;
    }
    
    if (item.boostMood != 0) {
        [self setupLabelWithName:@"Mood Effect" andValue:item.boostMood withRect:CGRectMake(x, y, width, height)];
        y += height;
    }
	
	if ([item.category isEqualToString:@"0"]) {
		[self setupLabelWithName:@"Useable In Battle?" andTextValue:(item.isUseableInBattle ? @"Yes" : @"No") withRect:CGRectMake(x, y, width, height)];
        y += height;        
	}
	
	if ([item.category isEqualToString:@"0"]) {
		[self setupLabelWithName:@"Battle Only?" andTextValue:(item.isBattleOnly ? @"Yes" : @"No") withRect:CGRectMake(x, y, width, height)];
	}
	
	y = 270;
	
    
    UILabel *requiresLevel = 
	[[UILabel alloc] initWithFrame:CGRectMake(x, y, FRAME_WIDTH - imageWidth - 3 * PADDING, height)];
    requiresLevel.text = [NSString stringWithFormat:@"Requires Level %@", item.requiresLevel];
    requiresLevel.minimumFontSize = MINIMUM_FONT_SIZE;
    requiresLevel.adjustsFontSizeToFitWidth = YES;
	requiresLevel.backgroundColor = [UIColor clearColor];
    requiresLevel.font = [UIFont boldSystemFontOfSize:FONT_SIZE];
	requiresLevel.textColor = (UIColor *) WEBCOLOR(0x0E4D91FF);
    [self.view addSubview:requiresLevel];
    [requiresLevel release];
    
    [numOwnedLabel release];
	CGFloat costsWidth = imageWidth * 1.5;
    numOwnedLabel = [[UILabel alloc] initWithFrame:CGRectMake(320 - PADDING - costsWidth, y, 
															  costsWidth, height)];
	
    numOwnedLabel.font = [UIFont boldSystemFontOfSize:FONT_SIZE];
    numOwnedLabel.text = [NSString stringWithFormat:@"Casts Owned: %d", item.numOwned];
	numOwnedLabel.backgroundColor = [UIColor clearColor];
    numOwnedLabel.textAlignment = UITextAlignmentRight;
	
    [self.view addSubview:numOwnedLabel];
    
    [itemImageView release];
	
	y = [self setupButtonsAtPoint:CGPointMake(x, y + numOwnedLabel.frame.size.height)];
	
	UILabel *spellExplanation = [[UILabel alloc] initWithFrame:CGRectMake(PADDING, y, 320 - PADDING * 2, 60)];
	spellExplanation.numberOfLines = 0;
	spellExplanation.backgroundColor = [UIColor clearColor];
	spellExplanation.shadowColor = [UIColor blackColor];
	spellExplanation.shadowOffset = CGSizeMake(0, -1);
	spellExplanation.font = [UIFont boldSystemFontOfSize:13];
	spellExplanation.textAlignment = UITextAlignmentCenter;
	spellExplanation.textColor = [UIColor whiteColor];
	spellExplanation.text = @"Spells are used against your opponent in battle.\nYou get one (1) cast per spell bought.";
	[self.view addSubview:spellExplanation];
	[spellExplanation release];
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
