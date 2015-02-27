/**
 * SingleEquipItemDetailViewController.m
 * Copyright Miraphonic, Inc 2009. All rights reserved.
 *
 * The SingleEquipItemDetailViewController adds the ability to equip an
 * item to the ItemDetailViewController
 *
 * @author Amit Matani
 * @created 1/28/09
 */
#import "SingleEquipItemDetailViewController.h"
#import "Consts.h"
#import "BRSession.h"
#import "ProtagonistAnimal.h"
#import "Item.h"
#import "BRAppDelegate.h"
#import "BRRestClient.h"
#import "Utility.h"
#import "ActionResult.h"

@implementation SingleEquipItemDetailViewController
#define PADDING 10
#define BUTTON_WIDTH 280
#define BUTTON_HEIGHT 46
#define BUTTON_FONT_SIZE 14

- (CGFloat)setupButtonsAtPoint:(CGPoint)point {
    CGFloat y = [super setupButtonsAtPoint:point] + PADDING;
	UIColor *shadowColor = [UIColor blackColor];
    ProtagonistAnimal *protagonist = [[BRSession sharedManager] protagonistAnimal];
	
    equipButton = [[UIButton alloc] init];
	equipButton.frame = CGRectMake(20, y, BUTTON_WIDTH, BUTTON_HEIGHT);
	equipButton.font = [UIFont boldSystemFontOfSize:BUTTON_FONT_SIZE];
	equipButton.titleShadowOffset = CGSizeMake(0, -1);
	equipButton.showsTouchWhenHighlighted = YES;
    [equipButton setTitle:@"Equip Item" forState:UIControlStateNormal];
	
	// disabled message must be appropriate
	if (protagonist.level < [item.requiresLevel intValue]) {
		NSString *title = [NSString stringWithFormat:@"Requires Level %@ to Equip", item.requiresLevel];
		[equipButton setTitle:title forState:UIControlStateDisabled];
	} else {
		[equipButton setTitle:@"Buy One in Order to Equip" forState:UIControlStateDisabled];
	}	
	
	[equipButton setTitleShadowColor:shadowColor forState:UIControlStateNormal];
	[equipButton setTitleShadowColor:[UIColor clearColor] forState:UIControlStateDisabled];
	[equipButton setBackgroundImage:[UIImage imageNamed:@"equip_button.png"] forState:UIControlStateNormal];
    [equipButton addTarget:self action:@selector(equipItem:) 
                 forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:equipButton];
	
    [self configureButton];
    return BUTTON_HEIGHT + y;
}

- (void)equipItem:(id)sender {
    [[BRAppDelegate sharedManager] showLoadingOverlayWithText:@"Equipping..."];
    [[BRRestClient sharedManager] item_equipItem:item.itemId slot:0
        target:self 
        finishedSelector:@selector(finishedEquiping:parsedResponse:) 
        failedSelector:@selector(failedEquiping)];
}

- (void)finishedEquiping:(NSNumber *)responseCode 
        parsedResponse:(NSDictionary *)parsedResponse {
    if (![BRRestClient isResponseSuccessful:responseCode]) {
        [self failedAction:[parsedResponse objectForKey:@"response_message"]];
        return;
    }

    ProtagonistAnimal *protagonist = [[BRSession sharedManager] protagonistAnimal];
    [protagonist equipItem:item inPosition:item.categoryKey];
    [self configureButton];
    [[BRAppDelegate sharedManager] hideLoadingOverlay];
    
    ActionResult *actionResult = [[ActionResult alloc] initWithApiResponse:[parsedResponse objectForKey:@"action_result"]];    
    if (actionResult.formattedResponse != nil) {
        [[BRAppDelegate sharedManager] showNotification:actionResult.formattedResponse 
                                              withWidth:[actionResult.formattedResponseWidth floatValue]
                                              andHeight:[actionResult.formattedResponseHeight floatValue]];
    }
    [actionResult release];

}

- (void)failedEquiping {
    [self failedAction:@"Unknown Error"];
}

- (void)unequipItem:(id)sender {
    [[BRAppDelegate sharedManager] showLoadingOverlayWithText:@"Unequipping..."];    
    [[BRRestClient sharedManager] item_unequipItem:item.itemId 
        slot:0 target:self 
        finishedSelector:@selector(finishedUnequiping:parsedResponse:) 
        failedSelector:@selector(failedUnequiping)];
}

- (void)finishedUnequiping:(NSNumber *)responseCode 
        parsedResponse:(NSDictionary *)parsedResponse {
    if (![BRRestClient isResponseSuccessful:responseCode]) {
        [self failedAction:[parsedResponse objectForKey:@"response_message"]];
        return;
    }        
    [[[BRSession sharedManager] protagonistAnimal] equipItem:nil inPosition:item.categoryKey];
    [self configureButton];
    [[BRAppDelegate sharedManager] hideLoadingOverlay];        
    
    ActionResult *actionResult = [[ActionResult alloc] initWithApiResponse:[parsedResponse objectForKey:@"action_result"]];    
    if (actionResult.formattedResponse != nil) {
        [[BRAppDelegate sharedManager] showNotification:actionResult.formattedResponse 
                                              withWidth:[actionResult.formattedResponseWidth floatValue]
                                              andHeight:[actionResult.formattedResponseHeight floatValue]];
    }
    [actionResult release];
}

- (void)failedUnequiping {
    [self failedAction:@"Unknown Error"];
}


- (void)configureButton {
    debug_NSLog(@"configure button");
    NSString *buttonTitle;
	UIImage *buttonBackground;
	UIColor *shadowColor;
	
    SEL buttonTarget;
    if ([[[BRSession sharedManager] protagonistAnimal] isEquiped:item inSlot:0]) {
        buttonTitle = @"Unequip Item";
        buttonTarget = @selector(unequipItem:);
		buttonBackground = [UIImage imageNamed:@"unequip_button.png"];
		shadowColor = WEBCOLOR(0x6f4f00ff);
    } else {
        buttonTitle = @"Equip Item";
        buttonTarget = @selector(equipItem:);
		buttonBackground = [UIImage imageNamed:@"equip_button.png"];
		shadowColor = [UIColor blackColor];
    }
    [equipButton setTitle:buttonTitle forState:UIControlStateNormal];
	[equipButton setTitleShadowColor:shadowColor forState:UIControlStateNormal];
	[equipButton setBackgroundImage:buttonBackground forState:UIControlStateNormal];
    [equipButton removeTarget:self action:NULL
                  forControlEvents:UIControlEventTouchUpInside];
    [equipButton addTarget:self action:buttonTarget 
                  forControlEvents:UIControlEventTouchUpInside];
    
    ProtagonistAnimal *protagonist = [[BRSession sharedManager] protagonistAnimal];
    equipButton.hidden = item.numOwned <= 0;
    equipButton.enabled = protagonist.level >= [item.requiresLevel intValue];
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
    [equipButton release];
    [super dealloc];
}


@end
