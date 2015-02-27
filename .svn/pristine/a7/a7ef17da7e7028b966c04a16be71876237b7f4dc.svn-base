//
//  DoubleEquip_itemDetailWebViewController.m
//  battleroyale
//
//  Created by Amit Matani on 1/8/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "DoubleEquipItemDetailWebViewController.h"
#import "BRSession.h"
#import "ProtagonistAnimal.h"
#import "Item.h"
#import "BRAppDelegate.h"
#import "BRRestClient.h"
#import "Utility.h"
#import "ActionResult.h"


@implementation DoubleEquipItemDetailWebViewController

#define PADDING 5
#define BUTTON_WIDTH 120
#define BUTTON_HEIGHT 45
#define BUTTON_FONT_SIZE 13

- (void)configureButton:(UIButton *)button {
    int slot = (button == _equipButton1) ? 1 : 0;
    
    NSString *buttonTitle;
	UIImage *buttonBackground;
	UIColor *shadowColor;
    SEL buttonTarget;
    if ([[[BRSession sharedManager] protagonistAnimal] isEquiped:_item inSlot:slot]) {
        buttonTitle = [NSString stringWithFormat:@"Unequip Slot %d", slot + 1];
        buttonTarget = @selector(unequipItem:);
		buttonBackground = [UIImage imageNamed:@"item_view_button_120_red.png"];
		shadowColor = WEBCOLOR(0x6f4f00ff);
		_item.equipped = _item.equipped | (slot == 0 ? 1 : 2);
    } else {
        buttonTitle = [NSString stringWithFormat:@"Equip Slot %d", slot + 1];
        buttonTarget = @selector(equipItem:);
		buttonBackground = [UIImage imageNamed:@"item_view_button_120_green.png"];
		shadowColor = [UIColor blackColor];
		_item.equipped = _item.equipped & (slot == 0 ? 2 : 1);
    }
    [button setTitle:buttonTitle forState:UIControlStateNormal];
	[button setBackgroundImage:buttonBackground forState:UIControlStateNormal];
	[button setTitleShadowColor:shadowColor forState:UIControlStateNormal];
    [button removeTarget:self action:NULL
		forControlEvents:UIControlEventTouchUpInside];
    [button addTarget:self action:buttonTarget 
	 forControlEvents:UIControlEventTouchUpInside];
	
    ProtagonistAnimal *protagonist = [[BRSession sharedManager] protagonistAnimal];
	button.enabled = protagonist.level >= [_item.requiresLevel intValue] & _item.numOwned > 0;
}

- (CGFloat)setupActionButtonsAtPoint:(CGPoint)point {
    CGFloat y = [super setupActionButtonsAtPoint:point] + PADDING;
    UIColor *shadowColor = [UIColor blackColor];
	ProtagonistAnimal *protagonist = [[BRSession sharedManager] protagonistAnimal];
	
    _equipButton0 = [[UIButton alloc] init];
	_equipButton0.frame = CGRectMake(point.x, y, BUTTON_WIDTH, BUTTON_HEIGHT);
	_equipButton0.font = [UIFont boldSystemFontOfSize:BUTTON_FONT_SIZE];
	_equipButton0.titleShadowOffset = CGSizeMake(0, -1);
	_equipButton0.showsTouchWhenHighlighted = YES;
	[_equipButton0 setTitleShadowColor:shadowColor forState:UIControlStateNormal];
	[_equipButton0 setTitleShadowColor:[UIColor clearColor] forState:UIControlStateDisabled];
	
	// disabled message must be appropriate
	if (protagonist.level < [_item.requiresLevel intValue]) {
		NSString *title = [NSString stringWithFormat:@"Req. Level %@", _item.requiresLevel];
		[_equipButton0 setTitle:title forState:UIControlStateDisabled];
	}	
	
	y += _equipButton0.frame.size.height + PADDING;
    _equipButton1 = [[UIButton alloc] init];
	_equipButton1.frame = CGRectMake(point.x, y, BUTTON_WIDTH, BUTTON_HEIGHT);
	_equipButton1.font = [UIFont boldSystemFontOfSize:BUTTON_FONT_SIZE];
	_equipButton1.titleShadowOffset = CGSizeMake(0, -1);
	_equipButton1.showsTouchWhenHighlighted = YES;
	[_equipButton1 setTitleShadowColor:shadowColor forState:UIControlStateNormal];
	[_equipButton1 setTitleShadowColor:[UIColor clearColor] forState:UIControlStateDisabled];
	
	// disabled message must be appropriate
	if (protagonist.level < [_item.requiresLevel intValue]) {
		NSString *title = [NSString stringWithFormat:@"Req. Level %@", _item.requiresLevel];
		[_equipButton1 setTitle:title forState:UIControlStateDisabled];
	}
	
	[self configureActionButtons];
	
	[self.view addSubview:_equipButton0];
	[self.view addSubview:_equipButton1];
	
	
    return BUTTON_HEIGHT + y;
}

- (void)equipItem:(id)sender {
	if ([[[[BRSession sharedManager] protagonistAnimal] itemManager] equipItem:_item slot:_equipButton0 == sender ? 0 : 1]) {
		[[BRAppDelegate sharedManager] showLoadingOverlayWithText:@"Equipping"];
	}
}

- (void)unequipItem:(id)sender {
	if ([[[[BRSession sharedManager] protagonistAnimal] itemManager] unequipItem:_item slot:_equipButton0 == sender ? 0 : 1]) {
		[[BRAppDelegate sharedManager] showLoadingOverlayWithText:@"Unequipping"];
	}
}

- (void)configureActionButtons {
	[self configureButton:_equipButton0];
	[self configureButton:_equipButton1];
	
	[super configureActionButtons];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}


- (void)dealloc {
    [_equipButton0 release];
    [_equipButton1 release];
    [super dealloc];
}

#pragma mark ProtagonistAnimalItemManagerDelegate methods
- (void)handleSuccessfulResult:(ActionResult *)actionResult {
	[self configureActionButtons];
	[_containerTable softReload];
    [[BRAppDelegate sharedManager] hideLoadingOverlay];
    
    if (actionResult.formattedResponse != nil) {
        [[BRAppDelegate sharedManager] showNotification:actionResult.formattedResponse 
                                              withWidth:[actionResult.formattedResponseWidth floatValue]
                                              andHeight:[actionResult.formattedResponseHeight floatValue]];
    }
}

- (void)equippedItem:(Item *)item slot:(NSInteger)slot result:(ActionResult *)actionResult {
	[self handleSuccessfulResult:actionResult];
}

- (void)failedToEquipItem:(Item *)item message:(NSString *)message {
	[self alertWithTitle:@"Error" message:message];
    [[BRAppDelegate sharedManager] hideLoadingOverlay];
}

- (void)unequippedItem:(Item *)item slot:(NSInteger)slot result:(ActionResult *)actionResult {
	[self handleSuccessfulResult:actionResult];
}

- (void)failedToUnequipItem:(Item *)item message:(NSString *)message {
	[self alertWithTitle:@"Error" message:message];
	[[BRAppDelegate sharedManager] hideLoadingOverlay];
}

@end
