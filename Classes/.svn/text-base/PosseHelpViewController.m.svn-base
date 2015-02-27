//
//  PosseHelpViewController.m
//  battleroyale
//
//  Created by Amit Matani on 8/26/09.
//  Copyright 2009 Miraphonic, Inc. All rights reserved.
//

#import "PosseHelpViewController.h"
#import "LoadingUIWebViewWithLocalRequest.h"
#import "BRRestClient.h"


@implementation PosseHelpViewController



// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
	LoadingUIWebViewWithLocalRequest *webView = [[LoadingUIWebViewWithLocalRequest alloc] initWithFrame:CGRectMake(0, 0, FRAME_WIDTH, FRAME_HEIGHT_WITH_ALL_BARS)];
//	webView.delegate = self;
//    webView.localDelegate = self;
    //    webView.shouldOverride = YES;
	webView.launchExternalLinksInSafari = NO;
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[[BRRestClient sharedManager] getPosseHelpUrl]]]];
    
    self.view = webView;
    
    [webView release];
}


/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
	((UIWebView *)self.view).delegate = nil;
	((LoadingUIWebViewWithLocalRequest *)self.view).localDelegate = nil;
	
	
    [super dealloc];
}


@end
