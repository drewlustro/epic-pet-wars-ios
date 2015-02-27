/*
 * Copyright 2009 Miraphonic
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 *    http://www.apache.org/licenses/LICENSE-2.0
 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#import "SROfferWebViewController.h"


@implementation SROfferWebViewController
@synthesize toolBar, webView, refreshButton, backButton, forwardButton, stopButton;


// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithUrl:(NSString *)_url {
    if (self = [super initWithNibName:@"SROfferWebView" bundle:nil]) {
        url = [_url copy];
        loadingIndicator = 
            [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    }
    return self;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
    
    UIBarButtonItem *cancelButton = 
	[[UIBarButtonItem alloc] initWithTitle:@"Close"
                                     style:UIBarButtonItemStylePlain
                                    target:self
                                    action:@selector(dismissSelf)];
    self.navigationItem.leftBarButtonItem = cancelButton;
    [cancelButton release];
    
    webView.delegate = self;
    loadingIndicator.center = CGPointMake(webView.frame.size.width / 2, webView.frame.size.height / 2);
    
    refreshButton.target = webView;
    refreshButton.action = @selector(reload);
    
    backButton.target = webView;
    backButton.action = @selector(goBack);
    
    forwardButton.target = webView;
    forwardButton.action = @selector(goForward);
    
    stopButton.target = webView;    
    stopButton.action = @selector(stopLoading);
	
	self.title = @"Complete Offer";
	
}

- (void)dismissSelf {
    [self dismissModalViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}

- (void)webViewDidStartLoad:(UIWebView *)_webView {
    [webView addSubview:loadingIndicator];
    [loadingIndicator startAnimating];
    stopButton.enabled = YES;
    refreshButton.enabled = NO;
    
    backButton.enabled = webView.canGoBack;
    forwardButton.enabled = webView.canGoForward;
}

- (void)webViewDidFinishLoad:(UIWebView *)_webView {
    [loadingIndicator removeFromSuperview];
    stopButton.enabled = NO;
    refreshButton.enabled = YES;
    
    backButton.enabled = webView.canGoBack;
    forwardButton.enabled = webView.canGoForward;    
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [loadingIndicator removeFromSuperview];
    stopButton.enabled = NO;
    refreshButton.enabled = YES;    
}


- (void)dealloc {
    [toolBar release];
    webView.delegate = nil;
    [loadingIndicator release];
    [webView release];
    [url release];
    [super dealloc];
}


@end
