//
//  ItemReceivedViewController.m
//  battleroyale
//
//  Created by Amit Matani on 4/11/09.
//  Copyright 2009 Miraphonic, Inc. All rights reserved.
//

#import "ItemReceivedViewController.h"
#import "Item.h"
#import "BRGlobal.h"
#import "RemoteImageViewWithFileStore.h"

@implementation ItemReceivedViewController
@synthesize continueButton, itemName, itemDetails, itemImage;

- (id)initWithItem:(Item *)_item {
    if (self = [super initWithNibName:@"ItemReceivedView" bundle:[NSBundle mainBundle]]) {
        item = [_item retain];
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    itemName.text = item.name;
	itemDetails.text = item.details;
    [itemImage loadImageWithUrl:item.imageSquare100];
    
    [continueButton addTarget:self action:@selector(continueButtonTapped) forControlEvents:UIControlEventTouchUpInside];
	[[SoundManager sharedManager] playSoundWithType:@"itemfound" vibrate:NO];
}

- (void)continueButtonTapped {		
	[self dismissTopMostModalViewControllerWithAnimationAndSound];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}


- (void)dealloc {
    [item release];
    [itemImage release];
    [itemName release];
	[itemDetails release];
    [continueButton release];
    [super dealloc];
}


@end
