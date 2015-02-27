//
//  BRWebViewController.h
//  battleroyale
//
//  Created by Amit Matani on 12/22/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "BRGlobal.h"
#import "LoadingUIWebViewWithLocalRequest.h"
#import "TwitterOAuthLinkerViewController.h"
#import "FBConnect/FBConnect.h"
#import "ProtagonistAnimalItemManager.h"

@interface BRWebViewController : UIViewController <LoadingUIWebViewWithLocalRequestDelegate, UIWebViewDelegate, TwitterOAuthLinkerDelegate, RestResponseDelegate, FBDialogDelegate, ProtagonistAnimalItemManagerDelegate> {
	CGRect _initialFrame;
	UIViewController *_container;
	BOOL _hasStartedInitialLoad, _hasPendingDelegate;
}

@property (readonly) BOOL hasStartedInitialLoad;
@property (assign) BOOL hasPendingDelegate;
@property (assign) UIViewController *container;

- (void)setContainer:(UIViewController *)container;
- (void)loadDataWithRequest:(NSURLRequest *)request;

@end
