//
//  InvestmentItemDetailViewController.m
//  battleroyale
//
//  Created by Amit Matani on 3/22/09.
//  Copyright 2009 Miraphonic, Inc. All rights reserved.
//

#import "InvestmentItemDetailViewController.h"
#import "Consts.h"
#import "HUDViewController.h"
#import "RemoteImageViewWithFileStore.h"
#import "Item.h"
#import "Utility.h"
#import "BRSession.h"
#import "ProtagonistAnimal.h"

#define PADDING 10
#define FONT_SIZE 14
#define MINIMUM_FONT_SIZE 10
#define KEY_WIDTH 120
#define VALUE_WIDTH 50
#define BUTTON_HEIGHT 46
#define BUTTON_WIDTH 140
#define BUTTON_FONT_SIZE 13

@implementation InvestmentItemDetailViewController

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
    
    CGFloat x = PADDING;
    y -= PADDING;
    
    UILabel *incomeLabel = [[UILabel alloc] initWithFrame:CGRectMake(PADDING, y, itemImageView.frame.origin.x - 3 * PADDING, 40)];
    incomeLabel.font = [UIFont boldSystemFontOfSize:30];
    incomeLabel.textAlignment = UITextAlignmentCenter;
    incomeLabel.backgroundColor = [UIColor clearColor];
    incomeLabel.textColor = [UIColor darkGrayColor];
    incomeLabel.text = @"Income";
    [self.view addSubview:incomeLabel];
    
    UILabel *cashflowLabel = [[UILabel alloc] initWithFrame:CGRectMake(PADDING, y + incomeLabel.frame.size.height, incomeLabel.frame.size.width, incomeLabel.frame.size.height)];
    cashflowLabel.font = [UIFont boldSystemFontOfSize:30];
    cashflowLabel.textAlignment = UITextAlignmentCenter;
    cashflowLabel.backgroundColor = [UIColor clearColor];
    cashflowLabel.textColor = WEBCOLOR(0x1B8600FF);
    cashflowLabel.text = [NSString stringWithFormat:@"¥%d", item.cashFlow];
    [self.view addSubview:cashflowLabel];
    
    UILabel *descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(PADDING, cashflowLabel.frame.origin.y + 
                                                                                    cashflowLabel.frame.size.height, 
                                                                          incomeLabel.frame.size.width, incomeLabel.frame.size.height)];
    descriptionLabel.font = [UIFont boldSystemFontOfSize:14];
    descriptionLabel.textAlignment = UITextAlignmentCenter;
    descriptionLabel.backgroundColor = [UIColor clearColor];
    descriptionLabel.textColor = [UIColor darkGrayColor];
    descriptionLabel.text = [NSString stringWithFormat:@"Every %d Minutes", 
                                 [[[BRSession sharedManager] protagonistAnimal] moneyRefreshSeconds] / 60];
    [self.view addSubview:descriptionLabel];
    
    [incomeLabel release];
    [cashflowLabel release];
    
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}


- (void)dealloc {
    [super dealloc];
}


@end
