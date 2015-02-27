/**
 * FacebookFriendsTableViewController.h
 * Copyright Miraphonic, Inc 2009. All rights reserved.
 *
 * @author Amit Matani 
 * @created 2/12/09.
 */


#import <UIKit/UIKit.h>
#import "AbstractRemoteDataTableController.h"
#import "BRRestClient.h"
#import "LoadingUIWebViewWithLocalRequest.h"

@class FacebookUser;

@protocol FacebookInviteDelegate

- (void)handleInviteAction:(FacebookUser *)facebookUser;

@end

@class BRRestOperation, FacebookBroadcastViewController;
@interface FacebookFriendsTableViewController : AbstractRemoteDataTableController <FacebookInviteDelegate, RestResponseDelegate> {
	FacebookUser *currentUser;
	BRRestOperation *_loadHeaderOperation;
	FacebookBroadcastViewController *_facebookBroadcastController;
}

- (void)failedSendingInvite;
- (void)failedAcceptingInvite;

@end
