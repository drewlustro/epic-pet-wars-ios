//
//  BRDialogWebViewController.m
//  battleroyale
//
//  Created by Amit Matani on 1/11/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "BRDialogWebViewController.h"
#import "BRDialog.h"
#import "BRAppDelegate.h"

@implementation BRDialogWebViewController
@synthesize containerDialog = _containerDialog;

- (id)initWithDialog:(BRDialog *)dialog {
	if (self = [super init]) {
		_containerDialog = dialog;
	}
	return self;
}

- (UIViewController *)container {
	if (_container != nil) {
		return _container;
	}
	return 	[BRAppDelegate sharedManager].currentlyActiveViewController;
}

- (void)setHasPendingDelegate:(BOOL)hasPendingDialog {
	_hasPendingDelegate = hasPendingDialog;
	if (_hasPendingDelegate) {
		[BRAppDelegate sharedManager].savedDialog = _containerDialog;
	} else {
		[BRAppDelegate sharedManager].savedDialog = nil;
	}
}

- (void)webView:(LoadingUIWebViewWithLocalRequest *)webView handleLocalMethod:(NSString *)method params:(NSDictionary *)params {
	[super webView:webView handleLocalMethod:method params:params];
	[_containerDialog dismiss:YES];
}

@end
