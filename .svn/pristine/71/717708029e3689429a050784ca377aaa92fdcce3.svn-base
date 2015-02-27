/**
 * InvitesTableViewController.h
 * Copyright Miraphonic, Inc 2009. All rights reserved.
 *
 * @author Amit Matani 
 * @created 2/7/09.
 */


#import <UIKit/UIKit.h>
#import "AbstractRemoteDataTableController.h"
@class Invite, InviteOptionsViewController;
@protocol InviteDelegate

- (void)acceptInvite:(Invite *)invite;
- (void)rejectInvite:(Invite *)invite;

@end

@interface InvitesTableViewController : AbstractRemoteDataTableController <InviteDelegate> {
	Invite *currentInvite;
    InviteOptionsViewController *inviteOptionsViewController;
}

@property (nonatomic, retain) InviteOptionsViewController *inviteOptionsViewController;

- (void)failedAccepting;
- (void)failedRejecting;

@end
