//
//  SingleUseItemDetailWebViewController.m
//  battleroyale
//
//  Created by Amit Matani on 1/8/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SingleUseItemDetailWebViewController.h"
#import "Consts.h"
#import "Item.h"
#import "BRAppDelegate.h"
#import "Notifier.h"
#import "BRRestClient.h"
#import "BRSession.h"
#import "ActionResult.h"
#import "ProtagonistAnimal.h"
#import "Utility.h"


@implementation SingleUseItemDetailWebViewController

#define PADDING 5
#define BUTTON_WIDTH 120
#define BUTTON_HEIGHT 45
#define BUTTON_FONT_SIZE 13


- (CGFloat)setupActionButtonsAtPoint:(CGPoint)point {
    CGFloat y = [super setupActionButtonsAtPoint:point] + PADDING;
	
//    UIColor *shadowColor = WEBCOLOR(0x6f4f00ff);
	ProtagonistAnimal *protagonist = [[BRSession sharedManager] protagonistAnimal];
	
    _useButton = [[UIButton alloc] init];
	_useButton.frame = CGRectMake(point.x, y, BUTTON_WIDTH, BUTTON_HEIGHT);
	_useButton.font = [UIFont boldSystemFontOfSize:BUTTON_FONT_SIZE];
	_useButton.titleShadowOffset = CGSizeMake(0, -1);
	_useButton.showsTouchWhenHighlighted = YES;
	[_useButton setTitle:@"Use" forState:UIControlStateNormal];
	
	if (_item.isBattleOnly) {
		[_useButton setTitle:@"Battle Only" forState:UIControlStateDisabled];
	} else if (protagonist.level < [_item.requiresLevel intValue]) {
		NSString *title = [NSString stringWithFormat:@"Req. Level %@", _item.requiresLevel];
		[_useButton setTitle:title forState:UIControlStateDisabled];
	}
	
	[_useButton setBackgroundImage:[UIImage imageNamed:@"item_view_button_120_green.png"] forState:UIControlStateNormal];
	
//	[_useButton setTitleShadowColor:shadowColor forState:UIControlStateNormal];
	[_useButton setTitleShadowColor:[UIColor clearColor] forState:UIControlStateDisabled];
	
    [_useButton addTarget:self action:@selector(useItem) 
		forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:_useButton];
	
    [self configureActionButtons];
    return BUTTON_HEIGHT + y;
}


- (void)useItem {
	if ([[[[BRSession sharedManager] protagonistAnimal] itemManager] useItem:_item]) {
		[[BRAppDelegate sharedManager] showLoadingOverlayWithText:@"Using Item"];
	}
}


- (void)configureActionButtons {
	[super configureActionButtons];
	ProtagonistAnimal *protagonist = [[BRSession sharedManager] protagonistAnimal];
    _useButton.enabled =  _item.numOwned > 0 && protagonist.level >= [_item.requiresLevel intValue] && !_item.isBattleOnly;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}


- (void)dealloc {
    [_useButton release];
    [super dealloc];
}

#pragma mark ProtagonistAnimalItemManagerDelegate methods

- (void)usedItem:(Item *)item result:(ActionResult *)actionResult {
	[[SoundManager sharedManager] playSoundWithType:@"powerup" vibrate:NO];
    [[BRAppDelegate sharedManager] hideLoadingOverlay];
    [[BRAppDelegate sharedManager] showNotification:actionResult.formattedResponse 
										  withWidth:[actionResult.formattedResponseWidth floatValue]
										  andHeight:[actionResult.formattedResponseHeight floatValue]];
	[self configureActionButtons];
	[_containerTable softReload];
	
}
- (void)failedToUseItem:(Item *)item message:(NSString *)message {
	[self alertWithTitle:@"Error" message:message];
    [[BRAppDelegate sharedManager] hideLoadingOverlay];
}


@end
