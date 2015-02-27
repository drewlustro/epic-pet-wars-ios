/**
 * FacebookFriendTableViewCell.h
 * Copyright Miraphonic, Inc 2009. All rights reserved.
 *
 * @author Amit Matani 
 * @created 2/12/09.
 */


#import <UIKit/UIKit.h>
#import "ABTableViewCell.h"
#import "ABTableViewCellWithFileImageStore.h"
#import "FacebookFriendsTableViewController.h"

@class FacebookUser;
@interface FacebookFriendTableViewCell : ABTableViewCellWithFileImageStore {
	FacebookUser *facebookUser;
	id<FacebookInviteDelegate> facebookDelegate;
}

@property (nonatomic, retain) FacebookUser *facebookUser;
@property (nonatomic, retain) id<FacebookInviteDelegate> facebookDelegate;

@end
