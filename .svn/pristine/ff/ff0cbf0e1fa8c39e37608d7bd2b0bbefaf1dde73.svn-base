//
//  SettingsViewController.m
//  battleroyale
//
//  Created by Amit Matani on 4/19/09.
//  Copyright 2009 Miraphonic, Inc. All rights reserved.
//

#import "SettingsViewController.h"
#import "BRRestClient.h"
#import "BRSession.h"
#import "BRGlobal.h"

@implementation SettingsViewController

- (id)init {
    if (self = [super init]) {
        self.title = @"Settings";
        didUpdateSettings = NO;
    }
    return self;
}

- (void)loadView {
    LoadingUIWebView *webView = [[LoadingUIWebView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[[BRRestClient sharedManager] getSettingsUrl]]]];
    webView.delegate = self;
    self.view = webView;
    [webView release];
    
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    if (navigationType == UIWebViewNavigationTypeFormSubmitted) {
        [self showLoadingOverlayWithText:@"Updating Settings"];
        didUpdateSettings = YES;
    }
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    if (didUpdateSettings) {
        [[BRRestClient sharedManager] callRemoteMethod:@"account.getSettings" params:nil delegate:self];
    }
    didUpdateSettings = NO;
}

- (void)remoteMethodDidLoad:(NSString *)method 
               responseCode:(RestResponseCode)responseCode 
             parsedResponse:(NSDictionary *)parsedResponse {
    if (responseCode == RestResponseCodeSuccess) {
        BRSession *session = [BRSession sharedManager];
        
        session.email = [Utility stringIfNotEmpty:[parsedResponse objectForKey:@"email"]];
        session.canPlaySounds = [Utility isStringTrue:[parsedResponse objectForKey:@"settings_sound_effects"]];
        session.canPlayVibration = [Utility isStringTrue:[parsedResponse objectForKey:@"settings_vibration"]];
    }
    
    [self hideLoadingOverlay];
}

- (void)remoteMethodDidFail:(NSString *)method {
    [self hideLoadingOverlay];
}

- (void)dealloc {
    [super dealloc];
}


@end
