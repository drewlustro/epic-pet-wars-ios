//
//  JobWebViewController.m
//  battleroyale
//
//  Created by Amit Matani on 12/22/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "JobWebViewController.h"
#import "BRSession.h"
#import "BRRestClient.h"
#import "OwnedItemTableViewContainerController.h"
#import "BRAppDelegate.h"

@implementation JobWebViewController

- (id)init {
    if (self = [super init]) {
        self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Train" image:[UIImage imageNamed:@"tab_bar_jobs.png"] tag:1];
		self.title = @"Train";
    }
    return self;
}

- (void)reloadRequest {
	[super reloadRequest];
	[_webViewController loadDataWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[[BRSession sharedManager] getJobsUrl]] cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:60.0]];
}

- (void)reloadData {
	if ([[[BRAppDelegate sharedManager] tabManager] getSelectedViewController] != [self navigationController]) {
		_dirty = YES; 
	}
}

- (void)postBossReloadData {
	if (!_newLogin) {
		[self reloadRequest];
	}
}

- (void)equipmentButtonClicked {
	[[SoundManager sharedManager] playSoundWithType:@"popup" vibrate:NO];
    OwnedItemTableViewContainerController *stvcc = [[OwnedItemTableViewContainerController alloc] init];
    
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:stvcc];
    [stvcc release];
    
    [self presentModalViewController:nc animated:YES];
    [nc release];
}

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (CGFloat)loadViewAndRespondWithY {
    CGFloat y = [super loadViewAndRespondWithY];
	
	UIBarButtonItem *myItems = [[UIBarButtonItem alloc] initWithTitle:@"My Items" 
																style:UIBarButtonItemStylePlain 
															   target:self 
															   action:@selector(equipmentButtonClicked)];
    self.navigationItem.leftBarButtonItem = myItems;
    [myItems release];
	
    return y;
}


- (void)dealloc {
    [super dealloc];
}


@end
