//
//  GrowPosseViewController.m
//  battleroyale
//
//  Created by Amit Matani on 8/24/09.
//  Copyright 2009 Miraphonic, Inc. All rights reserved.
//

#import "GrowPosseViewController.h"

#import "FriendCodeViewController.h"
#import "TwitterFriendInviteViewController.h"
#import "InviteContactsViewController.h"
#import "PosseHelpViewController.h"
#import "FacebookFriendsContainerViewController.h"

#import "BRSession.h"
#import "BRAppDelegate.h"
#import "BRRestClient.h"
#import "FBConnect/FBConnect.h"

@implementation GrowPosseViewController

@synthesize hideFriendCode = _hideFriendCode, initialTab = _initialTab;

- (id)init {
    if (self = [super init]) {
        self.title = @"Grow Posse";
		_cachedViewControllers = [[NSMutableDictionary alloc] initWithCapacity:5];
    }
    return self;
}


// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
	if (_titles == nil) {
		_titles = [[NSMutableArray alloc] initWithCapacity:5];
		
		if (!_hideFriendCode) {
			[_titles addObject:INVITE_FRIEND_CODE];
		}
        BRSession *session = [BRSession sharedManager];
        
        if (!session.hideEmailInvite) {
            [_titles addObject:INVITE_EMAIL];
        }
        
        if (!session.hideFacebookInvite) {
            [_titles addObject:INVITE_FACEBOOK];
        }
        
        if (!session.hideTwitterInvite) {
            [_titles addObject:INVITE_TWITTER];
        }
        
		[_titles addObject:INVITE_HELP];
	}

    [super loadView];
    _tabBar = [[ScrollableTabBar alloc] initWithFrame:CGRectZero];
    _tabBar.delegate = self;
    [_tabBar setTabs:_titles];
	
	int index = 0;
	if (_initialTab != nil) {
		index = [_titles indexOfObject:_initialTab];
		if (index == NSNotFound) {
			index = 0;
		}
	}
    _tabBar.selectedIndex = index;
	
	_tabBar.frame = CGRectMake(0, 0, FRAME_WIDTH, 40);
    [self.view addSubview:_tabBar];
	
	[self scrollableTabBar:_tabBar didSelectIndex:index];
}

- (void)attachAndDisplayActiveView {
	// get the offset
	CGFloat offset = _tabBar.frame.size.height;
	CGRect rect = CGRectMake(0, offset, self.view.frame.size.width, self.view.frame.size.height - offset);
	[self.view addSubview:_activeViewController.view];	
	if ([[_activeViewController class] isSubclassOfClass:[RDCContainerController class]]) {
		[(RDCContainerController *)_activeViewController setViewFrame:rect];
	} else {
		_activeViewController.view.frame = rect;
	}
	// run the view will appear shit
}

- (void)selectTab:(NSString *)title {
	int index = [_titles indexOfObject:title];
	if (index != NSNotFound) {
		[_tabBar setSelectedIndex:index];
	}
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
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[_titles release];
//	[_activeViewController release];
	[_tabBar release];
	[_cachedViewControllers release];
    [super dealloc];
}

#pragma mark ScrollableTabBarDelegate Methods
- (BOOL)scrollableTabBar:(ScrollableTabBar *)scrollableTabBar shouldSelectIndex:(NSInteger)index {
	if (_overrideButtonCheck) {
		_overrideButtonCheck = NO;
		return YES;
	}
	
	if (index >= [_titles count]) {
		return NO;
	}
	NSString *title = [_titles objectAtIndex:index];
	if ([title isEqualToString:INVITE_TWITTER]) {
		if (![[BRSession sharedManager] isTwitterUser]) {
			TwitterOAuthLinkerViewController *twitterLinker = [[TwitterOAuthLinkerViewController alloc] init];
			twitterLinker.delegate = self;
			[self presentModalViewControllerWithNavigationBar:twitterLinker];
			[twitterLinker release];
			return NO;
		}
	} else if ([title isEqualToString:INVITE_FACEBOOK]) {
		[[BRSession sharedManager] resumeFacebookSession:self];
		return NO;
	} else if ([title isEqualToString:INVITE_EMAIL]) {
		[self alertWithTitle:@"Invite Contacts" message:@"Can we pull up your contacts? We will never store them." delegate:self
		   cancelButtonTitle:@"Cancel" otherButtonTitle:@"Yes"];
		return NO;
	}

	return YES;
}

- (void)scrollableTabBar:(ScrollableTabBar *)scrollableTabBar didSelectIndex:(NSInteger)index {
	if (index >= [_titles count]) {
		return;
	}
	NSString *title = [_titles objectAtIndex:index];
	BOOL cached = NO;
	
	UIViewController *newActiveViewController = [_cachedViewControllers objectForKey:title];
	
	if (newActiveViewController == nil) { 
	
		// we are doing it this way instead of just by index
		// because we may want to turn certain ones off
		if ([title isEqualToString:INVITE_EMAIL]) {
			newActiveViewController = [[InviteContactsViewController alloc] init];
			
		} else if ([title isEqualToString:INVITE_FACEBOOK]) {
			newActiveViewController = [[FacebookFriendsContainerViewController alloc] init];
			
		} else if ([title isEqualToString:INVITE_TWITTER]) {
			// if we got here we passed the test for checking if the user was a twitter user
			newActiveViewController = [[TwitterFriendInviteViewController alloc] init];		
		} else if ([title isEqualToString:INVITE_FRIEND_CODE]) {
			NSMutableArray *titles = [[NSMutableArray alloc] initWithCapacity:3];
			NSMutableArray *keys = [[NSMutableArray alloc] initWithCapacity:3]; 
            
            BRSession *session = [BRSession sharedManager];
            
            if (!session.hideEmailInvite) {
                [titles addObject:@"E-mail"];
                [keys addObject:INVITE_EMAIL];
            }
            
            if (!session.hideFacebookInvite) {
                [titles addObject:@"Facebook"];
                [keys addObject:INVITE_FACEBOOK];
            }
            
            if (!session.hideTwitterInvite) {
                [titles addObject:@"Twitter"];
                [keys addObject:INVITE_TWITTER];
            }
			
			newActiveViewController = [[FriendCodeViewController alloc] initWithTabTitles:titles keys:keys];
			((FriendCodeViewController *) newActiveViewController).growPosseViewController = self;
			
			[keys release];
			[titles release];
		} else if ([title isEqualToString:INVITE_HELP]) {
			newActiveViewController = [[PosseHelpViewController alloc] init];            
        }
	} else {
		cached = YES;
	}
	
	if (newActiveViewController != nil) {
		// remove the view controllers from the page
		_activeViewController.view.hidden = YES;
		_activeViewController = newActiveViewController; 
		
		if (cached) {
			_activeViewController.view.hidden = NO;
		} else {
			[_cachedViewControllers setObject:_activeViewController forKey:title];
            [_activeViewController release];            
			[self attachAndDisplayActiveView];			
		}
	}
}

#pragma mark TwitterOAuthLinkerViewControllerDelegate Methods
- (void)didFinishAttemptedLink:(BOOL)wasSuccessful {
	[self dismissTopMostModalViewControllerWithAnimation];	
	if (wasSuccessful) {
		_overrideButtonCheck = YES;
		[_tabBar setSelectedIndex:[_titles indexOfObject:INVITE_TWITTER]];
	}
}

#pragma mark FBSessionDelegate Methods
- (void)session:(FBSession*)_session didLogin:(FBUID)uid {
	_overrideButtonCheck = YES;
	[_tabBar setSelectedIndex:[_titles indexOfObject:INVITE_FACEBOOK]];		
}

#pragma mark UIAlertViewDelegate Methods
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
	if (buttonIndex == 1) { // selected yes for the could see contacts
		_overrideButtonCheck = YES;
		[_tabBar setSelectedIndex:[_titles indexOfObject:INVITE_EMAIL]];
	}
}


@end
