//
//  OwnedItemTableViewContainerController.m
//  battleroyale
//
//  Created by Amit Matani on 3/22/09.
//  Copyright 2009 Miraphonic, Inc. All rights reserved.
//

#import "OwnedItemTableViewContainerController.h"
#import "OwnedItemTableViewController.h"

@implementation OwnedItemTableViewContainerController

- (id)init {
    OwnedItemTableViewController *ownedItemTableViewController = [[OwnedItemTableViewController alloc] init];
    if (self = [super initWithItemTableViewController:ownedItemTableViewController]) {
        self.title = @"My Items";
    }
    [ownedItemTableViewController release];
    return self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}

- (void)dealloc {
    [super dealloc];
}

@end
