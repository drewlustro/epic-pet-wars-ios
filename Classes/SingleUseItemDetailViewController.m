//
//  SingleUseItemDetailViewController.m
//  battleroyale
//
//  Created by Amit Matani on 1/29/09.
//  Copyright 2009 Miraphonic, Inc. All rights reserved.
//

#import "SingleUseItemDetailViewController.h"
#import "Consts.h"
#import "Item.h"
#import "BRAppDelegate.h"
#import "Notifier.h"
#import "BRRestClient.h"
#import "BRSession.h"
#import "ActionResult.h"
#import "ProtagonistAnimal.h"
#import "Utility.h"


@implementation SingleUseItemDetailViewController
#define PADDING 10
#define BUTTON_WIDTH 280
#define BUTTON_HEIGHT 46
#define BUTTON_FONT_SIZE 13

- (CGFloat)setupButtonsAtPoint:(CGPoint)point {
    CGFloat y = [super setupButtonsAtPoint:point] + PADDING;
    UIColor *shadowColor = WEBCOLOR(0x6f4f00ff);
	ProtagonistAnimal *protagonist = [[BRSession sharedManager] protagonistAnimal];
	
    useButton = [[UIButton alloc] init];
	useButton.frame = CGRectMake(20, y, BUTTON_WIDTH, BUTTON_HEIGHT);
	useButton.font = [UIFont boldSystemFontOfSize:BUTTON_FONT_SIZE];
	useButton.titleShadowOffset = CGSizeMake(0, -1);
	useButton.showsTouchWhenHighlighted = YES;
    [useButton setTitle:@"Use Item" forState:UIControlStateNormal];
	[useButton setBackgroundImage:[UIImage imageNamed:@"unequip_button.png"] forState:UIControlStateNormal];
	
	[useButton setTitleShadowColor:shadowColor forState:UIControlStateNormal];
	[useButton setTitleShadowColor:[UIColor clearColor] forState:UIControlStateDisabled];
	[useButton setBackgroundImage:[UIImage imageNamed:@"use_button.png"] forState:UIControlStateDisabled];
	// disabled message must be appropriate
	if (protagonist.level < [item.requiresLevel intValue]) {
		NSString *title = [NSString stringWithFormat:@"Requires Level %@ to Use", item.requiresLevel];
		[useButton setTitle:title forState:UIControlStateDisabled];
	} else {
		[useButton setTitle:@"Buy One to Use" forState:UIControlStateDisabled];
	}
	
    [useButton addTarget:self action:@selector(useItem) 
                 forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:useButton];
	
    [self configureButton];
    return BUTTON_HEIGHT + y;
}


- (void)useItem {
    if (item.numOwned <= 0) { return; }
    [[BRAppDelegate sharedManager] showLoadingOverlayWithText:@"Using Item"];
    [[BRRestClient sharedManager] item_useItem:item.itemId
        target:self 
        finishedSelector:@selector(finishedUsing:parsedResponse:) 
        failedSelector:@selector(failedUsing)];    
}

- (void)finishedUsing:(NSNumber *)responseInt parsedResponse:(NSDictionary *)parsedResponse {
    if (![BRRestClient isResponseSuccessful:responseInt]) {
        [self failedAction:[parsedResponse objectForKey:@"response_message"]];
        return;
    }
	
	[[SoundManager sharedManager] playSoundWithType:@"powerup" vibrate:NO];
	
    [[BRAppDelegate sharedManager] hideLoadingOverlay];
    ActionResult *actionResult = 
        [[ActionResult alloc] initWithApiResponse:[parsedResponse objectForKey:@"action_result"]];
    [[[BRSession sharedManager] protagonistAnimal] updateWithActionResult:actionResult];
    
    [[BRAppDelegate sharedManager] showNotification:actionResult.formattedResponse 
              withWidth:[actionResult.formattedResponseWidth floatValue]
              andHeight:[actionResult.formattedResponseHeight floatValue]];
	
	[actionResult release];

    [self decrementNumOwned:1];
}

- (void)failedUsing {
    [self failedAction:@"Unknown Error"];    
}

- (void)configureButton {
    ProtagonistAnimal *protagonist = [[BRSession sharedManager] protagonistAnimal];
    useButton.hidden = item.numOwned <= 0;
    useButton.enabled = protagonist.level >= [item.requiresLevel intValue];
}

- (void)decrementNumOwned:(NSInteger)amount {
    [super decrementNumOwned:amount];
    if (item.numOwned < 1) {
        [self configureButton];
    }
}

- (void)incrementNumOwned:(NSInteger)amount {
    [super incrementNumOwned:amount];
    if (item.numOwned >= 1) {    
        [self configureButton]; 
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}


- (void)dealloc {
    [useButton release];
    [super dealloc];
}


@end
