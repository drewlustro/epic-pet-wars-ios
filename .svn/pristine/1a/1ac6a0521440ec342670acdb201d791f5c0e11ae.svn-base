//
//  TopAnimalsWebViewController.m
//  battleroyale
//
//  Created by Amit Matani on 1/11/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "TopAnimalsWebViewController.h"
#import "BRSession.h"
#import "Consts.h"

@implementation TopAnimalsWebViewController

- (id)init {
	if (self = [super init]) {
		_container = self;
		self.title = @"Leaderboards";
	}
	return self;
}
- (void)loadView {
	[super loadView];
	UINavigationBar *navBar = self.navigationController.navigationBar;
	navBar.barStyle = UIBarStyleBlackOpaque;
	
	UIImageView *topLogo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"navigation_bar_logo.png"]];
	topLogo.frame = CGRectMake(FRAME_WIDTH - TOP_BAR_LOGO_WIDTH, 0, TOP_BAR_LOGO_WIDTH, TOP_BAR_LOGO_HEIGHT);
	[navBar addSubview: topLogo];
	[topLogo release];	
	
	[self loadDataWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[[BRSession sharedManager] getTopPlayersUrl]]]];
}


@end
