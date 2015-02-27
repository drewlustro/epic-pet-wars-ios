//
//  ItemDetailWebViewController.m
//  battleroyale
//
//  Created by Amit Matani on 1/6/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ItemDetailWebViewController.h"
#import "HUDViewController.h"
#import "Item.h"
#import "RemoteImageViewWithFileStore.h"
#import "ItemWebViewController.h"
#import "NeedsMoneyViewController.h"
#import "BuyAmountViewController.h"
#import "ActionResult.h"
#import "SellAmountViewController.h"
#import "ProtagonistAnimal.h"
#import "OwnedEquipmentSet.h"
#import "ItemTableViewController.h"

#define FONT_SIZE 14
#define BUTTON_WIDTH 120
#define BUTTON_HEIGHT 45
#define BUTTON_FONT_SIZE 14

@implementation ItemDetailWebViewController

@synthesize item = _item, containerTable = _containerTable;

- (id)initWithItem:(Item *)item htmlTemplate:(NSString *)htmlTemplate {
    if (self = [super init]) {
		_item = [item retain];
		
        _hud = [[HUDViewController alloc] init];
		_hud.ownerViewController = self;
		_webViewController = [[ItemWebViewController alloc] initWithItem:_item];
		_htmlTemplate = [htmlTemplate copy];
		
		[[[BRSession sharedManager] protagonistAnimal] itemManager].delegate = self;
    }
    return self;
}

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
	// Base View
    UIView *viewTemp = [[UIView alloc] initWithFrame:CGRectMake(0, 0, FRAME_WIDTH, FRAME_HEIGHT_WITH_NO_BARS)];
    self.view = viewTemp;
    [viewTemp release];
	
	// HUD
    [self.view addSubview:_hud.view];
	
    CGFloat yBelowHud = _hud.view.frame.origin.y + _hud.view.frame.size.height;
	
	// Left Background
	UIImageView *bg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"item_view_left_bg.png"]];
	bg.frame = CGRectMake(0, yBelowHud, BUTTON_WIDTH, 340);
	[self.view addSubview:bg];
	[bg release];
	
	// Item Image
    CGFloat imageWidth = 100;
#define HORIZONTAL_PADDING 10
#define VERTICAL_PADDING 5
	yBelowHud += VERTICAL_PADDING;
    RemoteImageViewWithFileStore *itemImageView = 
		[[RemoteImageViewWithFileStore alloc] initWithFrame:CGRectMake(HORIZONTAL_PADDING, yBelowHud, imageWidth, imageWidth)];
    itemImageView.hasBorder = NO;
    
    [itemImageView loadImageWithUrl:_item.imageSquare100];
    [self.view addSubview:itemImageView];
	
	
	// Num Owned Label
	CGFloat leftY = yBelowHud + imageWidth + VERTICAL_PADDING / 2;
	[_numOwnedLabel release];
    _numOwnedLabel = [[UILabel alloc] initWithFrame:CGRectMake(itemImageView.frame.origin.x, leftY, imageWidth, 20)];
    _numOwnedLabel.font = [UIFont boldSystemFontOfSize:FONT_SIZE];
    _numOwnedLabel.text = [NSString stringWithFormat:@"You Own: %d", _item.numOwned];
	_numOwnedLabel.backgroundColor = [UIColor clearColor];
	_numOwnedLabel.textColor = [UIColor whiteColor];
    _numOwnedLabel.textAlignment = UITextAlignmentCenter;
    [self.view addSubview:_numOwnedLabel];
	leftY += _numOwnedLabel.frame.size.height + VERTICAL_PADDING / 2;
	
	// WebView
	_webViewController.view.frame = CGRectMake(imageWidth + 2 * HORIZONTAL_PADDING, yBelowHud - VERTICAL_PADDING, FRAME_WIDTH - imageWidth - 2 * HORIZONTAL_PADDING, FRAME_HEIGHT_WITH_NO_BARS - yBelowHud + VERTICAL_PADDING);
	[self.view addSubview:_webViewController.view];
	
	
	// Buy Button
	UIButton *buyButton = [[UIButton alloc] init];
//	shadowColor = WEBCOLOR(0x001958ff);
	buyButton.frame = CGRectMake(0, leftY, BUTTON_WIDTH, BUTTON_HEIGHT);
    [buyButton setTitle:@"Buy" forState:UIControlStateNormal];
	[buyButton setTitle:@"N/A in Shop" forState:UIControlStateDisabled];
    buyButton.enabled = _item.inShop;
    [buyButton addTarget:self action:@selector(buyItemClicked) forControlEvents:UIControlEventTouchUpInside];
	buyButton.font = [UIFont boldSystemFontOfSize:BUTTON_FONT_SIZE];
	buyButton.titleShadowOffset = CGSizeMake(0, -1);
	buyButton.showsTouchWhenHighlighted = YES;
	[buyButton setBackgroundImage:[UIImage imageNamed:@"item_view_button_120_blue.png"] forState:UIControlStateNormal];
	[self.view addSubview:buyButton];
	[buyButton release];
	
	// Sell Button
	leftY += buyButton.frame.size.height + VERTICAL_PADDING;
	[_sellButton release];
	_sellButton = [[UIButton alloc] init];
	//	shadowColor = WEBCOLOR(0x001958ff);
	_sellButton.frame = CGRectMake(0, leftY, BUTTON_WIDTH, BUTTON_HEIGHT);
    [_sellButton setTitle:@"Sell" forState:UIControlStateNormal];
    _sellButton.enabled = _item.inShop;
    [_sellButton addTarget:self action:@selector(sellItemClicked) forControlEvents:UIControlEventTouchUpInside];
	_sellButton.font = [UIFont boldSystemFontOfSize:BUTTON_FONT_SIZE];
	_sellButton.titleShadowOffset = CGSizeMake(0, -1);
	_sellButton.showsTouchWhenHighlighted = YES;
	[_sellButton setBackgroundImage:[UIImage imageNamed:@"item_view_button_120_teal.png"] forState:UIControlStateNormal];
	_sellButton.enabled = _item.numOwned > 0 && _item.sellPrice > 0;
	[self.view addSubview:_sellButton];
	
	
	NSString *path = [[NSBundle mainBundle] bundlePath];
    NSURL *baseURL = [NSURL fileURLWithPath:path];    
    [(UIWebView *)_webViewController.view loadHTMLString:_htmlTemplate baseURL:baseURL];
	
	[self setupActionButtonsAtPoint:CGPointMake(0, _sellButton.frame.origin.y + _sellButton.frame.size.height)];
}

- (CGFloat)setupActionButtonsAtPoint:(CGPoint)point {
	return point.y;
}
- (void)configureActionButtons {
    _numOwnedLabel.text = [NSString stringWithFormat:@"You Own: %d", _item.numOwned];
    _sellButton.enabled = _item.numOwned > 0 && _item.sellPrice > 0;
	[_webViewController reloadLocalData];
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
	[_hud release];
	[_webViewController release];
	[_item release];
	[_htmlTemplate release];
	[[[BRSession sharedManager] protagonistAnimal] itemManager].delegate = nil;
	
    [super dealloc];
}

#pragma mark Button Action Responders

/** 
 * buyItem is called when the buy button is clicked.  It will put up a loading
 * screen and request to purchase the item from the server
 */
- (void)buyItemClicked {
    ProtagonistAnimal *protagonist = [[BRSession sharedManager] protagonistAnimal];    
    if (_item.cost > protagonist.money) {
        // TODO add a link to the Battle Master
        
        NeedsMoneyViewController *nmvc = [[NeedsMoneyViewController alloc] init];    
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:nmvc];        
        [self presentModalViewController:navigationController animated:YES];
        [nmvc release];
        [navigationController release];        
        return;
    }
    
    BuyAmountViewController *bavc = [[BuyAmountViewController alloc] initWithItemDetailViewController:self];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:bavc];	
    [self presentModalViewController:nav animated:YES];
    [bavc release];
    [nav release];
}

- (void)sellItemClicked {
    if (_item.numOwned <= 0) { return; }
    // then attempt the sale
	
    SellAmountViewController *savc = [[SellAmountViewController alloc] initWithItemDetailViewController:self];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:savc];	
    [self presentModalViewController:nav animated:YES];
    [savc release];
    [nav release];
}

- (void)sellItemWithAmount:(NSInteger)amount {
	if ([[[[BRSession sharedManager] protagonistAnimal] itemManager] sellItem:_item amount:amount]) {
		[[BRAppDelegate sharedManager] showLoadingOverlayWithText:@"Selling"];
	}
}


- (void)buyItemWithAmount:(NSInteger)amount {
	if ([[[[BRSession sharedManager] protagonistAnimal] itemManager] purchaseItem:_item amount:amount]) {
		[[BRAppDelegate sharedManager] showLoadingOverlayWithText:@"Purchasing"];
	}     
}

#pragma mark ProtagonistAnimalItemManagerDelegate
- (void)purchasedItem:(Item *)item result:(ActionResult *)actionResult {
    [[BRAppDelegate sharedManager] hideLoadingOverlay];
	[[SoundManager sharedManager] playSoundWithType:@"buy" vibrate:NO];
    [self dismissModalViewControllerAnimated:YES];
	
	[[BRAppDelegate sharedManager] showNotification:actionResult.formattedResponse 
										  withWidth:[actionResult.formattedResponseWidth floatValue]
										  andHeight:[actionResult.formattedResponseHeight floatValue]];
	
	[self configureActionButtons];
	[_containerTable softReload];
}

- (void)failedToPurchaseItem:(Item *)item message:(NSString *)message {
    [[BRAppDelegate sharedManager] hideLoadingOverlay];
    [self alertWithTitle:@"Error" message:message];
}

- (void)soldItem:(Item *)item result:(ActionResult *)actionResult {
	[[SoundManager sharedManager] playSoundWithType:@"sell" vibrate:NO];	
    [[BRAppDelegate sharedManager] hideLoadingOverlay];
    [self dismissModalViewControllerAnimated:YES];    
	
	
	[[BRAppDelegate sharedManager] showNotification:actionResult.formattedResponse 
										  withWidth:[actionResult.formattedResponseWidth floatValue]
										  andHeight:[actionResult.formattedResponseHeight floatValue]];
	
	[self configureActionButtons];
	[_containerTable softReload];
}

- (void)failedToSellItem:(Item *)item message:(NSString *)message {
    [[BRAppDelegate sharedManager] hideLoadingOverlay];
    [self alertWithTitle:@"Error" message:message];
}



@end
