//
//  HelpWebViewController.m
//  battleroyale
//
//  Created by Drew Lustro on 3/13/09.
//  Copyright 2009 Miraphonic, Inc. All rights reserved.
//

#import "HelpWebViewController.h"
#import "BRRestClient.h"
#import "BRGlobal.h"
#import "BRSession.h"

@implementation HelpWebViewController
@synthesize url, webView;

- (id)initWithTypeString:(NSString *)_type {
	if (self = [super init]) {
		self.url = [[BRSession sharedManager] getHelpUrlWithTypeString:_type];
	}
	return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	self.title = @"Help";
    
    [self addLeftCloseButton];
	
	// load the page requested... url is defined by initWithTypeString
	[webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];	
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}


- (void)dealloc {
	[url release];
    [webView release];
    [super dealloc];
}


@end
