/**
 * InviteTableViewCell.h
 * Copyright Miraphonic, Inc 2009. All rights reserved.
 *
 * @author Amit Matani 
 * @created 2/7/09.
 */


#import <UIKit/UIKit.h>
#import "ABTableViewCellWithFileImageStore.h"
#import "InvitesTableViewController.h"

@class Invite, InviteDelegate;
@interface InviteTableViewCell : ABTableViewCellWithFileImageStore {
	Invite *invite;
	id<InviteDelegate> inviteDelegate;
}

@property (nonatomic, retain) Invite *invite;
@property (nonatomic, assign) id<InviteDelegate> inviteDelegate;

@end
