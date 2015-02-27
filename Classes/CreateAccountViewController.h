/**
 * CreateAccountViewController.h
 * Copyright Miraphonic, Inc 2009. All rights reserved.
 *
 * @author Amit Matani 
 * @created 2/10/09.
 */


#import "BattleRoyale.h"
#import "FBConnect/FBConnect.h"
#import "BRGlobal.h"
#import "TwitterOAuthLinkerViewController.h"

@class InitialLoginViewController, FBSession;

@interface CreateAccountViewController : MegaViewController <FBSessionDelegate, TwitterOAuthLinkerDelegate> {
	IBOutlet UIButton *newAccountButton, *twitterLoginButton;
    IBOutlet UILabel *facebookQuestionLabel;
	InitialLoginViewController *initialLoginViewController;
	IBOutlet FBLoginButton *fbLoginButton;
}

@property (nonatomic, retain) UIButton *newAccountButton, *twitterLoginButton;
@property (nonatomic, retain) UILabel *facebookQuestionLabel;
@property (nonatomic, retain) FBLoginButton *fbLoginButton;

- (id)initWithInitalLoginViewController:(InitialLoginViewController *)ilvc;
- (void)newAccountButtonClicked;

@end
