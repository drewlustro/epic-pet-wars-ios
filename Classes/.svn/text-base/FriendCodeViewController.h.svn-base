/**
 * FriendCodeViewController.h
 * Copyright Miraphonic, Inc 2009. All rights reserved.
 *
 * @author Amit Matani 
 * @created 2/6/09.
 */


#import "BRGlobal.h"

@class GrowPosseViewController;
@interface FriendCodeViewController : MegaViewController <UITextFieldDelegate> {
	IBOutlet UIButton *inviteButton, *_shareButton;
	IBOutlet UILabel *yourFriendCodeLabel;
	int _activeAlertView;
	GrowPosseViewController *_growPosseViewController;
	NSArray *_inviteMethodTitles; // we use this method because we need to force ordering
	NSArray *_inviteMethodKeys;
}

@property (nonatomic, retain) UIButton *inviteButton, *_shareButton;
@property (nonatomic, retain) UILabel *yourFriendCodeLabel;
@property (nonatomic, assign) GrowPosseViewController *growPosseViewController;

- (id)initWithTabTitles:(NSArray *)titles keys:(NSArray *)keys;
- (void)failedInvitingFriend;
- (void)displayActionFailedWithMessage:(NSString *)message;
- (void)inviteButtonClicked;

@end
