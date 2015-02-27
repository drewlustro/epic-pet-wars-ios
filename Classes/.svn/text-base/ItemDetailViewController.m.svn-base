/**
 * ItemDetailViewController.m
 * Copyright Miraphonic, Inc 2009. All rights reserved.
 *
 * The ItemDetailViewController handles the detail view
 * of items.  It shows the items stats as well as
 * gives the ability to sell or buy the item in the store
 *
 * @author Amit Matani
 * @created 1/28/09
 */

#import "ItemDetailViewController.h"
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

@implementation ItemDetailViewController
@synthesize containerTable, item;
#define PADDING 10
#define FONT_SIZE 14
#define MINIMUM_FONT_SIZE 10
#define KEY_WIDTH 120
#define VALUE_WIDTH 50
#define BUTTON_HEIGHT 46
#define BUTTON_WIDTH 140
#define BUTTON_FONT_SIZE 13

static NSNumberFormatter *format;

- (id)initWithItem:(Item *)_item {
    if (self = [super init]) {
		item = [_item retain];

        hud = [[HUDViewController alloc] init];
		hud.ownerViewController = self;
        self.title = item.name;
		
		format = [[NSNumberFormatter alloc] init];
		[format setNumberStyle:NSNumberFormatterDecimalStyle];
    }
    return self;
}

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
        [self setupLabelWithName:@"Restores HP" andValue:item.boostHp withRect:CGRectMake(x, y, width, height)];
        y += height;
    }
    
    if (item.boostHpMax != 0) {
        [self setupLabelWithName:@"Max HP Boost" andValue:item.boostHpMax withRect:CGRectMake(x, y, width, height)];
        y += height;
    }

    if (item.boostEnergy != 0) {
        [self setupLabelWithName:@"Restores Energy" andValue:item.boostEnergy withRect:CGRectMake(x, y, width, height)];
        y += height;
    }

    if (item.boostEnergyMax != 0) {
        [self setupLabelWithName:@"Max Energy Boost" andValue:item.boostEnergyMax withRect:CGRectMake(x, y, width, height)];
        y += height;
    }

    if (item.boostAtk != 0) {
        [self setupLabelWithName:@"Attack" andValue:item.boostAtk withRect:CGRectMake(x, y, width, height)];
        y += height;
    }

    if (item.boostDef != 0) {
        [self setupLabelWithName:@"Defense" andValue:item.boostDef withRect:CGRectMake(x, y, width, height)];
        y += height;
    }
    
    if (item.boostMood != 0) {
        [self setupLabelWithName:@"Mood" andValue:item.boostMood withRect:CGRectMake(x, y, width, height)];
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
    numOwnedLabel = [[UILabel alloc] initWithFrame:CGRectMake(itemImageView.frame.origin.x, y, 
                                                  imageWidth, height)];
                                                  
    numOwnedLabel.font = [UIFont boldSystemFontOfSize:FONT_SIZE];
    numOwnedLabel.text = [NSString stringWithFormat:@"You Own: %d", item.numOwned];
	numOwnedLabel.backgroundColor = [UIColor clearColor];
    numOwnedLabel.textAlignment = UITextAlignmentCenter;
        
    [self.view addSubview:numOwnedLabel];
    
    [itemImageView release];

    [self setupButtonsAtPoint:CGPointMake(x, y + numOwnedLabel.frame.size.height)];

}

- (CGFloat)setupButtonsAtPoint:(CGPoint)point {
	
    CGFloat y = point.y + PADDING;
	
	NSString *buyFor =  [NSString stringWithFormat:@"Buy @ ¥%@", [format stringFromNumber:[NSNumber numberWithUnsignedInt:item.cost]]];
	NSString *sellFor = [NSString stringWithFormat:@"Sell @ ¥%@", [format stringFromNumber:[NSNumber numberWithUnsignedInt:item.sellPrice]]];
	UIFont *buttonFont = [UIFont boldSystemFontOfSize:BUTTON_FONT_SIZE];
	UIColor *shadowColor;
	
    // switch these when doing the real thing, might need to do the resizing thing
    UIButton *buyButton = [UIButton buttonWithType:UIButtonTypeCustom];
	shadowColor = WEBCOLOR(0x001958ff);
	buyButton.frame = CGRectMake(10, y, BUTTON_WIDTH, BUTTON_HEIGHT);
	buyButton.font = buttonFont;
	buyButton.titleShadowOffset = CGSizeMake(0, -1);
    [buyButton setTitle:buyFor forState:UIControlStateNormal];
	[buyButton setTitleShadowColor:shadowColor forState:UIControlStateNormal];
	[buyButton setTitleShadowColor:[UIColor clearColor] forState:UIControlStateDisabled];
	[buyButton setBackgroundImage:[UIImage imageNamed:@"blue_button_140.png"] forState:UIControlStateNormal];
	[buyButton setTitle:@"N/A in Shop" forState:UIControlStateDisabled];
    buyButton.enabled = item.inShop;
	buyButton.showsTouchWhenHighlighted = YES;
    [buyButton addTarget:self action:@selector(buyItemClicked) 
               forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:buyButton];

    sellButton = [[UIButton alloc] init];
	shadowColor = WEBCOLOR(0x356300ff);
	sellButton.frame = CGRectMake(30 + BUTTON_WIDTH, y, BUTTON_WIDTH, BUTTON_HEIGHT);
	sellButton.font = buttonFont;
	sellButton.showsTouchWhenHighlighted = YES;
	sellButton.titleShadowOffset = CGSizeMake(0, -1);
    [sellButton setTitle:sellFor forState:UIControlStateNormal];
	[sellButton setTitleShadowColor:shadowColor forState:UIControlStateNormal];
	[sellButton setTitleShadowColor:[UIColor clearColor] forState:UIControlStateDisabled];
	[sellButton setTitle:@"None Owned" forState:UIControlStateDisabled];
	[sellButton setBackgroundImage:[UIImage imageNamed:@"green_button_140.png"] forState:UIControlStateNormal];
    [sellButton addTarget:self action:@selector(sellItemClicked) 
                forControlEvents:UIControlEventTouchUpInside];
    sellButton.enabled = item.numOwned > 0;
    
    [self.view addSubview:sellButton];    
    return sellButton.frame.origin.y + sellButton.frame.size.height;
}

- (void)setupCashflowLabelWithValue:(NSInteger)value withRect:(CGRect)rect {
    if (value == 0) {
        return;
    }
    
    UILabel *label = [[UILabel alloc] initWithFrame:rect];    

    label.minimumFontSize = MINIMUM_FONT_SIZE;
	label.backgroundColor = [UIColor clearColor];
    label.adjustsFontSizeToFitWidth = YES;
	label.textColor = [UIColor darkGrayColor];
    label.font = [UIFont boldSystemFontOfSize:FONT_SIZE];    
    label.textAlignment = UITextAlignmentCenter;    
    
    CGRect boostRect = 
    CGRectMake(rect.origin.x, rect.origin.y + rect.size.height, rect.size.width, rect.size.height);
    UILabel *boostLabel = [[UILabel alloc] initWithFrame:boostRect];
    
    boostLabel.minimumFontSize = MINIMUM_FONT_SIZE;
    boostLabel.adjustsFontSizeToFitWidth = YES;
	boostLabel.backgroundColor = [UIColor clearColor];
    boostLabel.textAlignment = UITextAlignmentCenter;
    boostLabel.font = [UIFont boldSystemFontOfSize:FONT_SIZE];    
    if (value < 0) {
        label.text = @"Upkeep";
        boostLabel.text = [NSString stringWithFormat:@"-¥%@", [format stringFromNumber:[NSNumber numberWithInt:abs(value)]]];
        boostLabel.textColor = WEBCOLOR(0x870000FF);        

    } else {
        label.text = @"Income";        
        boostLabel.text = [NSString stringWithFormat:@"¥%@", [format stringFromNumber:[NSNumber numberWithInt:value]]];
        boostLabel.textColor = WEBCOLOR(0x1B8600FF);
    }
    
    [self.view addSubview:label];    
    [self.view addSubview:boostLabel];
    
    [label release];    
    [boostLabel release];
}

- (void)setupLabelWithName:(NSString *)name andValue:(NSInteger)value withRect:(CGRect)rect {
    UILabel *label = [[UILabel alloc] initWithFrame:rect];    
    label.text = name;
    label.minimumFontSize = MINIMUM_FONT_SIZE;
	label.backgroundColor = [UIColor clearColor];
    label.adjustsFontSizeToFitWidth = YES;
	label.textColor = [UIColor darkGrayColor];
    label.font = [UIFont boldSystemFontOfSize:FONT_SIZE];    
    [self.view addSubview:label];
    [label release];
    
    CGRect boostRect = 
        CGRectMake(rect.origin.x + rect.size.width, rect.origin.y, VALUE_WIDTH, rect.size.height);
    UILabel *boostLabel = [[UILabel alloc] initWithFrame:boostRect];
    
    boostLabel.minimumFontSize = MINIMUM_FONT_SIZE;
    boostLabel.adjustsFontSizeToFitWidth = YES;
	boostLabel.backgroundColor = [UIColor clearColor];
    boostLabel.textAlignment = UITextAlignmentRight;
    boostLabel.font = [UIFont boldSystemFontOfSize:FONT_SIZE];    
    
    if (value > 0) {
        boostLabel.text = [NSString stringWithFormat:@"+%@", [format stringFromNumber:[NSNumber numberWithInt:value]]];
        boostLabel.textColor = WEBCOLOR(0x1B8600FF);
    } else if (value < 0) {
        boostLabel.text = [NSString stringWithFormat:@"%@", [format stringFromNumber:[NSNumber numberWithInt:value]]];        
        boostLabel.textColor = WEBCOLOR(0x870000FF);
    } else {
        boostLabel.text = [NSString stringWithFormat:@"%@", [format stringFromNumber:[NSNumber numberWithInt:value]]];
        boostLabel.textColor = [UIColor grayColor];                
    }

    [self.view addSubview:boostLabel];
    [boostLabel release];
}

- (void)setupLabelWithName:(NSString *)name andTextValue:(NSString *)value withRect:(CGRect)rect {
    UILabel *label = [[UILabel alloc] initWithFrame:rect];    
    label.text = name;
    label.minimumFontSize = MINIMUM_FONT_SIZE;
	label.backgroundColor = [UIColor clearColor];
    label.adjustsFontSizeToFitWidth = YES;
	label.textColor = [UIColor darkGrayColor];
    label.font = [UIFont boldSystemFontOfSize:FONT_SIZE];    
    [self.view addSubview:label];
    [label release];
    
    CGRect boostRect = 
	CGRectMake(rect.origin.x + rect.size.width, rect.origin.y, VALUE_WIDTH, rect.size.height);
    UILabel *boostLabel = [[UILabel alloc] initWithFrame:boostRect];
    
    boostLabel.minimumFontSize = MINIMUM_FONT_SIZE;
    boostLabel.adjustsFontSizeToFitWidth = YES;
	boostLabel.backgroundColor = [UIColor clearColor];
    boostLabel.textAlignment = UITextAlignmentRight;
    boostLabel.font = [UIFont boldSystemFontOfSize:FONT_SIZE];    
    
    if ([value isEqualToString:@"Yes"]) {
        boostLabel.textColor = WEBCOLOR(0x1B8600FF);
    } else if ([value isEqualToString:@"No"]) {       
        boostLabel.textColor = WEBCOLOR(0x870000FF);
    } else {
        boostLabel.textColor = [UIColor grayColor];                
    }
	
	boostLabel.text = value;
	
    [self.view addSubview:boostLabel];
    [boostLabel release];
}

#pragma mark Button Action Responders

/** 
 * buyItem is called when the buy button is clicked.  It will put up a loading
 * screen and request to purchase the item from the server
 */
- (void)buyItemClicked {
    ProtagonistAnimal *protagonist = [[BRSession sharedManager] protagonistAnimal];    
    if (item.cost > protagonist.money) {
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

- (void)buyItemWithAmount:(NSInteger)amount {
    // the check if we have enough money
    numItemsPurchasingOrSelling = amount;
    // then attempt the purchase
    [[BRAppDelegate sharedManager] showLoadingOverlayWithText:@"Purchasing"];
    [[BRRestClient sharedManager] item_buyItem:item.itemId amount:amount target:self 
                              finishedSelector:@selector(finishedPurchase:parsedResponse:)
                                failedSelector:@selector(failedPurchase)];       
}

- (void)sellItemClicked {
    if (item.numOwned <= 0) { return; }
    // then attempt the sale

    SellAmountViewController *savc = [[SellAmountViewController alloc] initWithItemDetailViewController:self];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:savc];	
    [self presentModalViewController:nav animated:YES];
    [savc release];
    [nav release];
}

- (void)sellItemWithAmount:(NSInteger)amount {
    numItemsPurchasingOrSelling = amount;
    [[BRAppDelegate sharedManager] showLoadingOverlayWithText:@"Selling"];
    [[BRRestClient sharedManager] item_sellItem:item.itemId amount:amount target:self 
                               finishedSelector:@selector(finishedSale:parsedResponse:)
                                 failedSelector:@selector(failedSale)];   
}

#pragma mark action responders
- (void)finishedPurchase:(NSNumber *)responseInt parsedResponse:(NSDictionary *)parsedResponse {
    if (![BRRestClient isResponseSuccessful:responseInt]) {
        [self failedAction:[parsedResponse objectForKey:@"response_message"]];
        return;
    }
	
	[[SoundManager sharedManager] playSoundWithType:@"buy" vibrate:NO];
	
    [[BRAppDelegate sharedManager] hideLoadingOverlay];
    [self dismissModalViewControllerAnimated:YES];
    ActionResult *actionResult = 
        [[ActionResult alloc] initWithApiResponse:[parsedResponse objectForKey:@"action_result"]];
    [[[BRSession sharedManager] protagonistAnimal] updateWithActionResult:actionResult];
    
    
    [[BRAppDelegate sharedManager] showNotification:actionResult.formattedResponse 
              withWidth:[actionResult.formattedResponseWidth floatValue]
              andHeight:[actionResult.formattedResponseHeight floatValue]];
    
    [actionResult release];
    [self incrementNumOwned:numItemsPurchasingOrSelling];
}

- (void)failedPurchase {
    [self failedAction:@"Unknown Error"];
}

- (void)finishedSale:(NSNumber *)responseInt parsedResponse:(NSDictionary *)parsedResponse {
    if (![BRRestClient isResponseSuccessful:responseInt]) {
        [self failedAction:[parsedResponse objectForKey:@"response_message"]];
        return;
    }
	
	[[SoundManager sharedManager] playSoundWithType:@"sell" vibrate:NO];
	
    [[BRAppDelegate sharedManager] hideLoadingOverlay];
    [self dismissModalViewControllerAnimated:YES];    
    ActionResult *actionResult = 
        [[ActionResult alloc] initWithApiResponse:[parsedResponse objectForKey:@"action_result"]];
        
    ProtagonistAnimal *animal = [[BRSession sharedManager] protagonistAnimal];
    [animal updateWithActionResult:actionResult];
    
    
    [[BRAppDelegate sharedManager] showNotification:actionResult.formattedResponse 
              withWidth:[actionResult.formattedResponseWidth floatValue]
              andHeight:[actionResult.formattedResponseHeight floatValue]];
              
    [actionResult release];
    
    [self decrementNumOwned:numItemsPurchasingOrSelling];
}

- (void)incrementNumOwned:(NSInteger)amount {
    if (item.numOwned <= 0) {
        [[[[BRSession sharedManager] protagonistAnimal] equipment] addItem:item];
        [self.containerTable softReload];        
    }
    item.numOwned += amount;
    numOwnedLabel.text = [NSString stringWithFormat:@"You Own: %d", item.numOwned];
    sellButton.enabled = item.numOwned > 0;    
}

- (void)decrementNumOwned:(NSInteger)amount {
    ProtagonistAnimal *animal = [[BRSession sharedManager] protagonistAnimal];
    [animal.equipment decrementOwnedCountForItem:item count:amount];

    numOwnedLabel.text = [NSString stringWithFormat:@"You Own: %d", item.numOwned];
    
    if (item.numOwned == 1 && [item.categoryKey isEqualToString:@"accessory"] && 
        [animal numEquiped:item] > 1) {
        // since the item is equiped in both slots we can just
        // unequip one slot
        [animal equipItem:nil inPosition:@"accessory2"]; 
    }
    
    if (item.numOwned == 0) {
        Item *tempItem = [item copy];
        [item release];
        item = tempItem;
        [self.containerTable softReload];
        
        NSString *key = nil;
        int numEquiped = [animal numEquiped:item];
        if (numEquiped > 0) {
            if ([item.categoryKey isEqualToString:@"accessory"]) {
                if (numEquiped > 1) {
                    [animal equipItem:nil inPosition:@"accessory1"];
                    [animal equipItem:nil inPosition:@"accessory2"];
                } else {
                    key = [animal isEquiped:item inSlot:0] ? @"accessory1" : @"accessory2";
                }
            } else {
                key = item.categoryKey;
            }
        }
        if (key != nil) {
            [animal equipItem:nil inPosition:key];
        }
    }    
    sellButton.enabled = item.numOwned > 0;    
}

- (void)failedSale {
    [self failedAction:@"Unknown Error"];
}

- (void)failedAction:(NSString *)message {
	[[BRAppDelegate sharedManager] hideLoadingOverlay];	        
    UIAlertView *failedToDoAction = 
        [[UIAlertView alloc] initWithTitle:@"Unable To Perform Action"
                                   message:message
                                  delegate:self 
                         cancelButtonTitle:@"OK" 
                         otherButtonTitles:nil];
    [failedToDoAction show];
    [failedToDoAction release];    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}


- (void)dealloc {
    debug_NSLog(@"dealloc item");
    [hud cleanup];
    [hud release];
    [item release];
    [numOwnedLabel release];
    [sellButton release];
    [super dealloc];
}


@end
