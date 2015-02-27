//
//  SingleEquipItemDetailWebViewController.m
//  battleroyale
//
//  Created by Amit Matani on 1/7/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SingleEquipItemDetailWebViewController.h"
#import "Consts.h"
#import "BRSession.h"
#import "ProtagonistAnimal.h"
#import "Item.h"
#import "BRAppDelegate.h"
#import "BRRestClient.h"
#import "Utility.h"
#import "ActionResult.h"

@implementation SingleEquipItemDetailWebViewController
#define PADDING 5
#define BUTTON_WIDTH 120
#define BUTTON_HEIGHT 45
#define BUTTON_FONT_SIZE 14

- (CGFloat)setupActionButtonsAtPoint:(CGPoint)point {
    CGFloat y = [super setupActionButtonsAtPoint:point] + PADDING;
	
    equipButton = [[UIButton alloc] init];
	equipButton.frame = CGRectMake(point.x, y, BUTTON_WIDTH, BUTTON_HEIGHT);
	equipButton.font = [UIFont boldSystemFontOfSize:BUTTON_FONT_SIZE];
	equipButton.titleShadowOffset = CGSizeMake(0, -1);
	equipButton.showsTouchWhenHighlighted = YES;
    [equipButton setTitle:@"Equip" forState:UIControlStateNormal];
	
//	[equipButton setTitleShadowColor:shadowColor forState:UIControlStateNormal];
	[equipButton setTitleShadowColor:[UIColor clearColor] forState:UIControlStateDisabled];
	
	[self configureActionButtons];
	
	[self.view addSubview:equipButton];
    return BUTTON_HEIGHT + y;
}

- (void)configureActionButtons {
	BOOL isEquiped = [[[BRSession sharedManager] protagonistAnimal] isEquiped:_item inSlot:0];
	_item.equipped = isEquiped ? 1 : 0;
	[super configureActionButtons];
    debug_NSLog(@"configure button");
    NSString *buttonTitle;
	UIImage *buttonBackground;
	UIColor *shadowColor;
    ProtagonistAnimal *protagonist = [[BRSession sharedManager] protagonistAnimal];
	
    SEL buttonTarget;
    if (isEquiped) {
        buttonTitle = @"Unequip";
        buttonTarget = @selector(unequipItem:);
		buttonBackground = [UIImage imageNamed:@"item_view_button_120_red.png"];
		shadowColor = WEBCOLOR(0x6f4f00ff);
    } else {
		if (protagonist.level >= [_item.requiresLevel intValue]) {
			buttonTitle = @"Equip";
		} else {
			buttonTitle = [NSString stringWithFormat:@"Req. Level %@", _item.requiresLevel];  
		}
        buttonTarget = @selector(equipItem:);
		buttonBackground = [UIImage imageNamed:@"item_view_button_120_green.png"];
		shadowColor = [UIColor blackColor];
    }
    [equipButton setTitle:buttonTitle forState:UIControlStateNormal];
	[equipButton setTitleShadowColor:shadowColor forState:UIControlStateNormal];
	[equipButton setBackgroundImage:buttonBackground forState:UIControlStateNormal];
    [equipButton removeTarget:self action:NULL
			 forControlEvents:UIControlEventTouchUpInside];
    [equipButton addTarget:self action:buttonTarget 
		  forControlEvents:UIControlEventTouchUpInside];
    
//    equipButton.hidden = _item.numOwned <= 0;
    equipButton.enabled = protagonist.level >= [_item.requiresLevel intValue] && _item.numOwned > 0;
}


- (void)equipItem:(id)sender {
	if ([[[[BRSession sharedManager] protagonistAnimal] itemManager] equipItem:_item slot:0]) {
		[[BRAppDelegate sharedManager] showLoadingOverlayWithText:@"Equipping"];
	}
}

- (void)unequipItem:(id)sender {
	if ([[[[BRSession sharedManager] protagonistAnimal] itemManager] unequipItem:_item slot:0]) {
		[[BRAppDelegate sharedManager] showLoadingOverlayWithText:@"Unequipping"];
	}
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}


- (void)dealloc {
    [equipButton release];
    [super dealloc];
}


- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
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
