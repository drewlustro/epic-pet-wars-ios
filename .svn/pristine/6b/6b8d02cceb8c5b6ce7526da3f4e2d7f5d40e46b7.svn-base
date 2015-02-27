//
//  DoubleEquipItemDetailViewController.m
//  battleroyale
//
//  Created by Amit Matani on 1/29/09.
//  Copyright 2009 Miraphonic, Inc. All rights reserved.
//

#import "DoubleEquipItemDetailViewController.h"
#import "BRSession.h"
#import "ProtagonistAnimal.h"
#import "Item.h"
#import "BRAppDelegate.h"
#import "BRRestClient.h"
#import "Utility.h"
#import "ActionResult.h"

#define PADDING 10
#define BUTTON_WIDTH 140
#define BUTTON_HEIGHT 46
#define BUTTON_FONT_SIZE 13

@implementation DoubleEquipItemDetailViewController

- (CGFloat)setupButtonsAtPoint:(CGPoint)point {
    CGFloat y = [super setupButtonsAtPoint:point] + PADDING;
    UIColor *shadowColor = [UIColor blackColor];
	ProtagonistAnimal *protagonist = [[BRSession sharedManager] protagonistAnimal];
	
    equipButton0 = [[UIButton alloc] init];
	equipButton0.frame = CGRectMake(10, y, BUTTON_WIDTH, BUTTON_HEIGHT);
	equipButton0.font = [UIFont boldSystemFontOfSize:BUTTON_FONT_SIZE];
	equipButton0.titleShadowOffset = CGSizeMake(0, -1);
	equipButton0.showsTouchWhenHighlighted = YES;
	[equipButton0 setTitleShadowColor:shadowColor forState:UIControlStateNormal];
	[equipButton0 setTitleShadowColor:[UIColor clearColor] forState:UIControlStateDisabled];
	[equipButton0 setBackgroundImage:[UIImage imageNamed:@"equip_button_140.png"] forState:UIControlStateNormal];
	
	// disabled message must be appropriate
	if (protagonist.level < [item.requiresLevel intValue]) {
		NSString *title = [NSString stringWithFormat:@"Req. Level %@", item.requiresLevel];
		[equipButton0 setTitle:title forState:UIControlStateDisabled];
	} else {
		[equipButton0 setTitle:@"Buy One to Equip" forState:UIControlStateDisabled];
	}	
	
	[self.view addSubview:equipButton0];
	
    equipButton1 = [[UIButton alloc] init];
	equipButton1.frame = CGRectMake(equipButton0.frame.origin.x + BUTTON_WIDTH + PADDING * 2, y, BUTTON_WIDTH, BUTTON_HEIGHT);
	equipButton1.font = [UIFont boldSystemFontOfSize:BUTTON_FONT_SIZE];
	equipButton1.titleShadowOffset = CGSizeMake(0, -1);
	equipButton1.showsTouchWhenHighlighted = YES;
	[equipButton1 setTitleShadowColor:shadowColor forState:UIControlStateNormal];
	[equipButton1 setTitleShadowColor:[UIColor clearColor] forState:UIControlStateDisabled];
	[equipButton1 setBackgroundImage:[UIImage imageNamed:@"equip_button_140.png"] forState:UIControlStateNormal];
	
	// disabled message must be appropriate
	if (protagonist.level < [item.requiresLevel intValue]) {
		NSString *title = [NSString stringWithFormat:@"Req. Level %@", item.requiresLevel];
		[equipButton1 setTitle:title forState:UIControlStateDisabled];
	} else {
		[equipButton1 setTitle:@"Buy One to Equip" forState:UIControlStateDisabled];
	}
	
	[self.view addSubview:equipButton1];
	
    [self configureButton:equipButton0];
    [self configureButton:equipButton1];    
	
    return BUTTON_HEIGHT + y;
}

- (void)equipItem:(id)sender {
    [[BRAppDelegate sharedManager] showLoadingOverlayWithText:@"Equipping"];
    [[BRRestClient sharedManager] item_equipItem:item.itemId 
        slot:equipButton0 == sender ? 0 : 1
        target:self 
        finishedSelector:@selector(finishedEquiping:parsedResponse:) 
        failedSelector:@selector(failedEquiping)];
    selectedButton = sender;
}

- (void)finishedEquiping:(NSNumber *)responseCode 
        parsedResponse:(NSDictionary *)parsedResponse {
    if ([BRRestClient isResponseSuccessful:responseCode]) {
        int slot, otherSlot;
        UIButton *otherButton;    
        if (selectedButton == equipButton0) {
            slot = 0;
            otherSlot = 1;
            otherButton = equipButton1;
        } else {
            slot = 1;
            otherSlot = 0;        
            otherButton = equipButton0;
        }

        ProtagonistAnimal *protagonist = [[BRSession sharedManager] protagonistAnimal];
        if (item.numOwned <= 0) { 
            [[BRAppDelegate sharedManager] hideLoadingOverlay];            
            return; 
        }

        if (item.numOwned == 1 && [protagonist isEquiped:item inSlot:otherSlot]) {
            [protagonist equipItem:nil inPosition:(otherSlot == 0) ? @"accessory1" : @"accessory2"];
            [self configureButton:otherButton];     
        }
        [protagonist equipItem:item inPosition:(slot == 0) ? @"accessory1" : @"accessory2"];
        [self configureButton:selectedButton];        
        [[BRAppDelegate sharedManager] hideLoadingOverlay];
        
        ActionResult *actionResult = [[ActionResult alloc] initWithApiResponse:[parsedResponse objectForKey:@"action_result"]];    
        if (actionResult.formattedResponse != nil) {
            [[BRAppDelegate sharedManager] showNotification:actionResult.formattedResponse 
                                                  withWidth:[actionResult.formattedResponseWidth floatValue]
                                                  andHeight:[actionResult.formattedResponseHeight floatValue]];
        }
        [actionResult release];
    } else {
        [self failedAction:[parsedResponse objectForKey:@"response_message"]];
    }

}

- (void)failedEquiping {
    [self failedAction:@"Unknown Error"];
}

- (void)unequipItem:(id)sender {
    [[BRAppDelegate sharedManager] showLoadingOverlayWithText:@"Unequipping"];    
    [[BRRestClient sharedManager] item_unequipItem:item.itemId 
        slot:equipButton0 == sender ? 0 : 1    
        target:self 
        finishedSelector:@selector(finishedUnequiping:parsedResponse:) 
        failedSelector:@selector(failedUnequiping)];
    selectedButton = sender;
}

- (void)finishedUnequiping:(NSNumber *)responseCode 
        parsedResponse:(NSDictionary *)parsedResponse {
    if ([BRRestClient isResponseSuccessful:responseCode]) {
        int slot = (selectedButton == equipButton1) ? 1 : 0;
        [[[BRSession sharedManager] protagonistAnimal] equipItem:nil inPosition:(slot == 0) ? @"accessory1" : @"accessory2"];
        [self configureButton:selectedButton];
        [[BRAppDelegate sharedManager] hideLoadingOverlay]; 
        
        ActionResult *actionResult = [[ActionResult alloc] initWithApiResponse:[parsedResponse objectForKey:@"action_result"]];    
        if (actionResult.formattedResponse != nil) {
            [[BRAppDelegate sharedManager] showNotification:actionResult.formattedResponse 
                                                  withWidth:[actionResult.formattedResponseWidth floatValue]
                                                  andHeight:[actionResult.formattedResponseHeight floatValue]];
        }
        [actionResult release];
        
    } else {
        [self failedAction:[parsedResponse objectForKey:@"response_message"]];
    }
}

- (void)failedUnequiping {
    [self failedAction:@"Unknown Error"];    
}


- (void)configureButton:(UIButton *)button {
    int slot = (button == equipButton1) ? 1 : 0;
    
    NSString *buttonTitle;
	UIImage *buttonBackground;
	UIColor *shadowColor;
    SEL buttonTarget;
    if ([[[BRSession sharedManager] protagonistAnimal] isEquiped:item inSlot:slot]) {
        buttonTitle = [NSString stringWithFormat:@"Unequip Slot %d", slot + 1];
        buttonTarget = @selector(unequipItem:);
		buttonBackground = [UIImage imageNamed:@"unequip_button_140.png"];
		shadowColor = WEBCOLOR(0x6f4f00ff);
    } else {
        buttonTitle = [NSString stringWithFormat:@"Equip Slot %d", slot + 1];
        buttonTarget = @selector(equipItem:);
		buttonBackground = [UIImage imageNamed:@"equip_button_140.png"];
		shadowColor = [UIColor blackColor];
    }
    [button setTitle:buttonTitle forState:UIControlStateNormal];
	[button setBackgroundImage:buttonBackground forState:UIControlStateNormal];
	[button setTitleShadowColor:shadowColor forState:UIControlStateNormal];
    [button removeTarget:self action:NULL
                  forControlEvents:UIControlEventTouchUpInside];
    [button addTarget:self action:buttonTarget 
                  forControlEvents:UIControlEventTouchUpInside];

    ProtagonistAnimal *protagonist = [[BRSession sharedManager] protagonistAnimal];
    button.hidden = item.numOwned <= 0;
    button.enabled = protagonist.level >= [item.requiresLevel intValue];}

- (void)decrementNumOwned:(NSInteger)amount {
[super decrementNumOwned:amount];
    if (item.numOwned <= 1) {
        [self configureButton:equipButton0];
        [self configureButton:equipButton1];
    }
}

- (void)incrementNumOwned:(NSInteger)amount {
    [super incrementNumOwned:amount];
    if (item.numOwned >= 1) {    
        [self configureButton:equipButton0];        
        [self configureButton:equipButton1];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}


- (void)dealloc {
    [equipButton0 release];
    [equipButton1 release];
    [super dealloc];
}


@end
