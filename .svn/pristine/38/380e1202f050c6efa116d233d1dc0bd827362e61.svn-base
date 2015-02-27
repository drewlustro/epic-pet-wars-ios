//
//  BackgroundItemDetailViewController.m
//  battleroyale
//
//  Created by Amit Matani on 3/10/09.
//  Copyright 2009 Miraphonic, Inc. All rights reserved.
//

#import "BackgroundItemDetailViewController.h"
#import "Consts.h"
#import "HUDViewController.h"
#import "RemoteImageViewWithFileStore.h"
#import "BRAppDelegate.h"
#import "Item.h"
#import "Utility.h"
#import "BRSession.h"
#import "ProtagonistAnimal.h"

#define PADDING 10
#define EXPLANATION_FONT_SIZE 14
#define EXPLANATION_HEIGHT 50

@implementation BackgroundItemDetailViewController



// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
    [super loadView];
    
    [self.view addSubview:hud.view];
    
    CGFloat y = hud.view.frame.origin.y + hud.view.frame.size.height;
    
	UIImageView *gradientBg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"gradient_gray_bg.png"]];
	gradientBg.frame = CGRectMake(0, y, 320, 480);
	[self.view addSubview:gradientBg];
	[gradientBg release];
	
    RemoteImageViewWithFileStore *itemImageView = 
        [[RemoteImageViewWithFileStore alloc] initWithFrame:CGRectMake(0, y, FRAME_WIDTH, 180)];
    itemImageView.hasBorder = NO;
    [itemImageView loadImageWithUrl:item.iphoneBackgroundImage];
    [self.view addSubview:itemImageView];    
    [itemImageView release];
    
    y += itemImageView.frame.size.height;
	y += PADDING;
	
	UILabel *explanation = [[UILabel alloc] initWithFrame:CGRectMake(PADDING, y, FRAME_WIDTH - PADDING * 2, EXPLANATION_HEIGHT)];
	explanation.backgroundColor = [UIColor clearColor];
	explanation.font = [UIFont boldSystemFontOfSize:EXPLANATION_FONT_SIZE];
	explanation.textAlignment = UITextAlignmentCenter;
	explanation.numberOfLines = 0;
	explanation.text = @"Show some style & treat your pet to a custom environment! It will appear on your home view and public profile.";
	[self.view addSubview:explanation];
	[explanation release];
	
	y += EXPLANATION_HEIGHT;
    
    [self setupButtonsAtPoint:CGPointMake(0, y)];
}

- (CGFloat)setupButtonsAtPoint:(CGPoint)point {
    
#define BUTTON_HEIGHT 46
#define BUTTON_WIDTH 280
#define BUTTON_FONT_SIZE 13
	
    CGFloat y = point.y + PADDING;
	

	UIFont *buttonFont = [UIFont boldSystemFontOfSize:BUTTON_FONT_SIZE];
	UIColor *shadowColor;
	
    [mainButton release];
    mainButton = [[UIButton alloc] init];
	shadowColor = WEBCOLOR(0x001958ff);
	mainButton.frame = CGRectMake((FRAME_WIDTH - BUTTON_WIDTH) / 2, y, BUTTON_WIDTH, BUTTON_HEIGHT);
	mainButton.font = buttonFont;
	mainButton.titleShadowOffset = CGSizeMake(0, -1);
	mainButton.showsTouchWhenHighlighted = YES;
	[mainButton setTitleShadowColor:shadowColor forState:UIControlStateNormal];
	[mainButton setTitleShadowColor:[UIColor clearColor] forState:UIControlStateDisabled];

	[self.view addSubview:mainButton];
    
    
    [self configureButton];
    return 0;
}

- (void)configureButton {
    [mainButton removeTarget:self action:NULL forControlEvents:UIControlEventTouchUpInside];
    if (item.numOwned > 0) {
        if ([[[BRSession sharedManager] protagonistAnimal] isEquiped:item inSlot:0]) {
            [mainButton setTitle:[NSString stringWithFormat:@"Stop Using Background", item.cost] forState:UIControlStateNormal];
			[mainButton setBackgroundImage:[UIImage imageNamed:@"use_button.png"] forState:UIControlStateNormal]; 
            [mainButton addTarget:self action:@selector(unequipItem:) forControlEvents:UIControlEventTouchUpInside];
        } else {
            [mainButton setTitle:[NSString stringWithFormat:@"Use Background", item.cost] forState:UIControlStateNormal];  
			[mainButton setBackgroundImage:[UIImage imageNamed:@"new_account_button.png"] forState:UIControlStateNormal]; 
            [mainButton addTarget:self action:@selector(equipItem:) forControlEvents:UIControlEventTouchUpInside];            
        }
    } else {
        [mainButton setTitle:[NSString stringWithFormat:@"Buy For ¥%d", item.cost] forState:UIControlStateNormal];
		[mainButton setBackgroundImage:[UIImage imageNamed:@"use_button.png"] forState:UIControlStateNormal]; 
        [mainButton addTarget:self action:@selector(buyItemClicked) forControlEvents:UIControlEventTouchUpInside];       
    }
}

- (void)finishedPurchase:(NSNumber *)responseInt parsedResponse:(NSDictionary *)parsedResponse {
    [super finishedPurchase:responseInt parsedResponse:parsedResponse];
    [self configureButton];
}


/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}


- (void)dealloc {
    [super dealloc];
}


@end
