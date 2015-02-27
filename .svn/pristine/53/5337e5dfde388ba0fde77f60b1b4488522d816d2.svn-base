//
//  ProfileWebViewController.m
//  battleroyale
//
//  Created by Amit Matani on 12/23/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "ProfileWebViewController.h"


@implementation ProfileWebViewController

- (id)initWithAnimalId:(NSString *)animalId {
	if (self = [super init]) {
		_webViewController = [[BRWebViewController alloc] init];
		_animalId = [animalId copy];
		_isBot = @"0";
		_hud = [[HUDViewController alloc] init];
	}
	return self;	
}

- (id)initWithAnimalId:(NSString *)animalId isBot:(NSString *)isBot {
	if (self = [super init]) {
		_webViewController = [[BRWebViewController alloc] init];
		_animalId = [animalId copy];
		_isBot = [isBot copy];
		_hud = [[HUDViewController alloc] init];
	}
	return self;	
}



- (void)loadView {
	[super loadView];
	
	_hud.ownerViewController = self;
	
    [self.view addSubview:_hud.view];
    
	CGFloat height = self.view.frame.size.height - _hud.view.height;
    CGRect rect = CGRectMake(0, _hud.view.height, FRAME_WIDTH, height);
	
	[_webViewController setContainer:self];
	_webViewController.view.frame = rect;
	[_webViewController loadDataWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[[BRSession sharedManager] getProfileUrl:_animalId isBot:_isBot]]]];

	[self.view addSubview:_webViewController.view];
}


- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [_hud cleanup];
    [_hud release];
	[_webViewController release];
	[_animalId release];
	[_isBot release];
    [super dealloc];
}


@end
