//
//  BasicTopLevelViewController.m
//  battleroyale
//
//  Created by Amit Matani on 1/30/09.
//  Copyright 2009 Miraphonic, Inc. All rights reserved.
//

#import "BasicTopLevelViewController.h"
#import "HUDViewController.h"
#import "Notifier.h"
#import "HUDViewController.h"
#import "Consts.h"
#import "ProtagonistAnimal.h"
#import "BRSession.h"

@implementation BasicTopLevelViewController

- (id)init {
    if (self = [super init]) {
        hud = [[HUDViewController alloc] init];
		hud.ownerViewController = self;
    }
    return self;
}

- (void)loadView {
    [super loadView];
    
    [self loadViewAndRespondWithY];
	
	ProtagonistAnimal *animal = [[BRSession sharedManager] protagonistAnimal];
	if (animal != nil && animal.hp == 0) {
		[self showDeathView];
	}
}

- (CGFloat)loadViewAndRespondWithY {
    [self.view addSubview:hud.view];
    CGFloat y = hud.view.frame.origin.y + hud.view.frame.size.height;
    return y;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}
- (void)handleSelected {}

- (void)handleLogin {
//	[self removeDeathView]; 
}

- (void)handleLogout {}

- (void)handleDeath {
	[self showDeathView];
}

- (void)handleRevive {
	[self removeDeathView];
}

- (void)showDeathView {/*
	[deathBackground removeFromSuperview];
	[deathBackground release];
	
	CGFloat y = hud.view.frame.origin.y + hud.view.frame.size.height;
	deathBackground = [[UIView alloc] initWithFrame:CGRectMake(0, y, FRAME_WIDTH, FRAME_HEIGHT_WITH_ALL_BARS)];
	deathBackground.backgroundColor = [UIColor blackColor];
	deathBackground.alpha = .95;
	
	UILabel *youAreDeadLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, FRAME_WIDTH, 100)];
	youAreDeadLabel.textAlignment = UITextAlignmentCenter;
	youAreDeadLabel.textColor = [UIColor whiteColor];
	youAreDeadLabel.backgroundColor = [UIColor clearColor];
	youAreDeadLabel.numberOfLines = 0;
	youAreDeadLabel.text = @"You animal is currently in a coma.\nYou must revive before performing any actions.";
	[deathBackground addSubview:youAreDeadLabel];
	[youAreDeadLabel release];
	
	[self.view addSubview:deathBackground];*/
}

- (void)removeDeathView {
	if ([deathBackground superview] != nil) {
		[deathBackground removeFromSuperview];
		[deathBackground release];
		deathBackground = nil;
	}
}

- (void)dealloc {
    [super dealloc];
}


@end
