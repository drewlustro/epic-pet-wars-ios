/**
 * CreateAccountViewController.m
 * Copyright Miraphonic, Inc 2009. All rights reserved.
 *
 * @author Amit Matani 
 * @created 2/10/09.
 */

#import "CreateAccountViewController.h"
#import "InitialLoginViewController.h"

@implementation CreateAccountViewController
@synthesize newAccountButton, facebookQuestionLabel, fbLoginButton, twitterLoginButton;

- (id)initWithInitalLoginViewController:(InitialLoginViewController *)ilvc {
    if (self = [super initWithNibName:@"CreateAccountView" bundle:[NSBundle mainBundle]]) {
        initialLoginViewController = ilvc;
    }
    return self;
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
    FBSession *session = [FBSession sessionForApplication:FB_API_KEY secret:FB_APP_SECRET delegate:self];
    fbLoginButton.session = session;
    fbLoginButton.style = FBLoginButtonStyleWide;
        
	[newAccountButton addTarget:self action:@selector(newAccountButtonClicked) 
	   forControlEvents:UIControlEventTouchUpInside];
	
	[twitterLoginButton addTarget:self action:@selector(twitterLoginButtonClicked) 
			   forControlEvents:UIControlEventTouchUpInside];	
}

- (void)newAccountButtonClicked {
	[[BRAppDelegate sharedManager] showLoadingOverlayWithText:@"Creating Account"];
	[[BRRestClient sharedManager] auth_getSessionWithDeviceId:YES target:self 
											 finishedSelector:@selector(finishedCreatingUser:parsedResponse:) 
											   failedSelector:@selector(failedCreatingUser)];
}

- (void)twitterLoginButtonClicked {
	TwitterOAuthLinkerViewController *twitterLinker = [[TwitterOAuthLinkerViewController alloc] init];
	twitterLinker.delegate = self;
	[self presentModalViewControllerWithNavigationBar:twitterLinker];
	[twitterLinker release];
}

- (void)failedCreatingUser {
	[[BRAppDelegate sharedManager] hideLoadingOverlay];
    [self alertWithTitle:@"Account Creation Failed" message:@"Unknown Error"];    
}

- (void)finishedCreatingUser:(NSNumber *)responseInt parsedResponse:(NSDictionary *)parsedResponse {
    [[BRAppDelegate sharedManager] hideLoadingOverlay];    
	if ([BRRestClient isResponseSuccessful:responseInt]) {
		[initialLoginViewController handleSuccessfulLogin:parsedResponse];
	} else {
        [self alertWithTitle:@"Account Creation Failed" message:[parsedResponse objectForKey:@"response_message"]];
	}
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}

#pragma mark FBSessionDelegate methods
- (void)session:(FBSession*)_session didLogin:(FBUID)uid {
    debug_NSLog(@"User with id %lld logged in.", uid);
	[[BRAppDelegate sharedManager] showLoadingOverlayWithText:@"Linking Account"];
	[[BRRestClient sharedManager] auth_getSessionWithFBUID:uid fbSessionKey:_session.sessionKey 
                                           fbSessionSecret:_session.sessionSecret target:self 
											 finishedSelector:@selector(finishedCreatingUser:parsedResponse:) 
											   failedSelector:@selector(failedCreatingUser)];    
}

#pragma mark TwitterOAuthLinkerDelegate
- (void)didFinishAttemptedLink:(BOOL)wasSuccessful {
	if (wasSuccessful) {
		[[BRAppDelegate sharedManager] showLoadingOverlayWithText:@"Logging In"];		
		[[BRRestClient sharedManager] auth_getSessionWithDeviceId:NO target:self 
												 finishedSelector:@selector(finishedCreatingUser:parsedResponse:) 
												   failedSelector:@selector(failedCreatingUser)];		
	} else {
		[self dismissTopMostModalViewControllerWithAnimation];
	}
}


- (void)dealloc {
    [facebookQuestionLabel release];
    [newAccountButton release];
	[fbLoginButton release];
	[twitterLoginButton release];
    [super dealloc];
}


@end
