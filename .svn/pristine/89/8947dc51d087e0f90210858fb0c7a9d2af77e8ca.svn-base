//
//  TopLevelWebViewController.m
//  battleroyale
//
//  Created by Amit Matani on 12/23/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "TopLevelWebViewController.h"


#import "BRSession.h"
#import "BRRestClient.h"
#import "BRTabManager.h"
#import "BRAppDelegate.h"
#import "ProtagonistAnimal.h"


@implementation TopLevelWebViewController

- (id)init {
    if (self = [super init]) {
		_webViewController = [[BRWebViewController alloc] init];
		[[[BRSession sharedManager] protagonistAnimal] registerObserverToAllProperties:self];
        [[BRSession sharedManager] registerObserverForProtagonistAnimal:self];
    }
    return self;
}

- (void)reloadRequest {
	_dirty = NO;
}

- (void)reloadData {
	if ([[[BRAppDelegate sharedManager] tabManager] getSelectedViewController] != [self navigationController]) {
		_dirty = YES; 
	} else {
		[self reloadRequest];
	}

}

// Implement loadView to create a view hierarchy programmatically, without using a nib.

- (CGFloat)loadViewAndRespondWithY {
	self.view.backgroundColor = [UIColor blackColor];
    CGFloat y = [super loadViewAndRespondWithY];
    
    CGFloat height = self.view.frame.size.height - y;
    debug_NSLog(@"y is fro load %f", height);    
    CGRect rect = CGRectMake(0, y, FRAME_WIDTH, height);
	
	[_webViewController setContainer:self];
	_webViewController.view.frame = rect;
	
	[self.view addSubview:_webViewController.view];
	[self reloadRequest];
	
    return y;
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
	[_webViewController release];
    [super dealloc];
}

// TODO, needs to watch for level up

#pragma mark TopLevelController methods
- (void)handleSelected {
	if ((_newLogin || _dirty) && _webViewController.hasStartedInitialLoad) {
		[self reloadRequest];
	}
    _newLogin = NO;
}

- (void)handleLogin {
	[super handleLogin];
    _newLogin = YES;
}

#pragma mark Oberserver methods

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object
						change:(NSDictionary *)change context:(void *)context {       
    if ([keyPath isEqualToString:@"protagonistAnimal"]) {
        [[[BRSession sharedManager] protagonistAnimal] registerObserverToAllProperties:self];
        return;
    }    
    if ([keyPath isEqualToString:@"level"]) {
		[self reloadData];
	}
}

- (void)handleLogout {}
@end
