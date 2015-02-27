//
//  GrowPosseViewController.h
//  battleroyale
//
//  Created by Amit Matani on 8/24/09.
//  Copyright 2009 Miraphonic, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BRGlobal.h"
#import "TwitterOAuthLinkerViewController.h"
#import "FBConnect/FBConnect.h"

#define INVITE_EMAIL @"E-mail"
#define INVITE_FACEBOOK @"Facebook"
#define INVITE_TWITTER @"Twitter"
#define INVITE_FRIEND_CODE @"Friend Code"
#define INVITE_HELP @"Help"

@class TwitterFriendInviteViewController, FriendCodeViewController, InviteContactsViewController;
@interface GrowPosseViewController : MegaViewController <ScrollableTabBarDelegate, TwitterOAuthLinkerDelegate, FBSessionDelegate> {
	NSMutableArray *_titles;
	UIViewController *_activeViewController;
	ScrollableTabBar *_tabBar;
	NSMutableDictionary *_cachedViewControllers;
	BOOL _overrideButtonCheck;
	BOOL _hideFriendCode;
	NSString *_initialTab;
}

@property (nonatomic, assign) BOOL hideFriendCode;
@property (nonatomic, copy) NSString *initialTab;

- (void)selectTab:(NSString *)title;

@end
