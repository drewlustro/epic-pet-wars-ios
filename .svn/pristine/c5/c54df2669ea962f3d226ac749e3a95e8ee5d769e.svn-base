//
//  GameUpdatesViewController.m
//  battleroyale
//
//  Created by Amit Matani on 4/22/09.
//  Copyright 2009 Miraphonic, Inc. All rights reserved.
//

#import "GameUpdatesViewController.h"
#import "LoadingUIWebView.h"
#import "BRSession.h"

@implementation GameUpdatesViewController

- (id)init {
    if (self = [super init]) {
        self.title = @"Game Updates";
    }
    return self;
}

- (void)loadView {
    LoadingUIWebView *webView = [[LoadingUIWebView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[[BRSession sharedManager] getGameUpdatesUrl]]]];
    self.view = webView;
    [webView release];
}

- (void)dealloc {
    [super dealloc];
}


@end
