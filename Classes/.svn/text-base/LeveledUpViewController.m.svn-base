//
//  LeveledUpViewController.m
//  battleroyale
//
//  Created by Amit Matani on 3/11/09.
//  Copyright 2009 Miraphonic, Inc. All rights reserved.
//

#import "LeveledUpViewController.h"
#import "ActionResult.h"
#import "Item.h"
#import "BRGlobal.h"
#import "RemoteImageViewWithFileStore.h"

@implementation LeveledUpViewController
@synthesize attackIncreasedLabel, defenseIncreasedLabel, 
            hpMaxIncreasedLabel, energyIncreasedLabel,
            hpRefreshedLabel, energyRefreshedLabel, continueButton,
            whatsNextView, itemName, itemImage, itemView;

// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithActionResult:(ActionResult *)_actionResult {
    if (self = [super initWithNibName:@"LeveledUpView" bundle:[NSBundle mainBundle]]) {
        actionResult = [_actionResult retain];
    }
    return self;
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    
    attackIncreasedLabel.text = [NSString stringWithFormat:@"+%d", [actionResult.atk intValue]];
    defenseIncreasedLabel.text = [NSString stringWithFormat:@"+%d", [actionResult.def intValue]];
    energyIncreasedLabel.text = [NSString stringWithFormat:@"+%d", [actionResult.energyMax intValue]];
    hpMaxIncreasedLabel.text = [NSString stringWithFormat:@"+%d", [actionResult.hpMax intValue]];
    
    hpRefreshedLabel.hidden =  [actionResult.hp intValue] <= 0;
    energyRefreshedLabel.hidden =  [actionResult.energy intValue] <= 0;
    [continueButton addTarget:self action:@selector(continueButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    
    if (actionResult.item != nil) {
        whatsNextView.hidden = YES;
        itemName.text = actionResult.item.name;
        [itemImage loadImageWithUrl:actionResult.item.imageSquare100];        
    } else {
        itemView.hidden = YES;
    }
	
	[[SoundManager sharedManager] playSoundWithType:@"levelup" vibrate:NO];
}

- (void)continueButtonTapped {		
	[self dismissTopMostModalViewControllerWithAnimationAndSound];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}


- (void)dealloc {
    [actionResult release];
    [attackIncreasedLabel release];
    [defenseIncreasedLabel release];
    [hpMaxIncreasedLabel release];
    [energyIncreasedLabel release];
    [hpRefreshedLabel release];
    [energyRefreshedLabel release];
    [continueButton release];
    [itemImage release];
    [itemName release];
    [itemView release];
    [whatsNextView release];
    [super dealloc];
}


@end
