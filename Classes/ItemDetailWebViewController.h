//
//  ItemDetailWebViewController.h
//  battleroyale
//
//  Created by Amit Matani on 1/6/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "BRGlobal.h"
#import "ProtagonistAnimalItemManager.h"

@class HUDViewController, Item, ItemWebViewController, ProtagonistAnimalItemManagerDelegate, ItemTableViewController;
@interface ItemDetailWebViewController : MegaViewController <ProtagonistAnimalItemManagerDelegate> {
	HUDViewController *_hud;
	Item *_item;
	ItemWebViewController *_webViewController;
	NSString *_htmlTemplate;
	
	UILabel *_numOwnedLabel;
	UIButton *_sellButton;
	
	ItemTableViewController *_containerTable;
}

@property (nonatomic, readonly) Item *item;
@property (nonatomic, assign) ItemTableViewController *containerTable;

- (id)initWithItem:(Item *)item htmlTemplate:(NSString *)htmlTemplate;
- (CGFloat)setupActionButtonsAtPoint:(CGPoint)point;
- (void)configureActionButtons;

- (void)buyItemWithAmount:(NSInteger)amount;
- (void)sellItemWithAmount:(NSInteger)amount;

@end
