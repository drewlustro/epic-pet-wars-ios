//
//  LoadingUIWebView.m
//  mega framework
//
//  Created by Amit Matani on 3/21/09.
//  Copyright 2009 Miraphonic, Inc. All rights reserved.
//

#import "LoadingUIWebView.h"


@implementation LoadingUIWebView
@synthesize shouldOverride = _shouldOverride;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (id)init {
    if (self = [super init]) {
        [self setup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)inCoder {
    if (self = [super initWithCoder:inCoder]) {
        [self setup];        
    }
    return self;
}

- (void)setDelegate:(id<UIWebViewDelegate>)delegate {
    _forwardedDelegate = delegate;
    [super setDelegate:self];
}

- (void)setup {
    [super setDelegate:self];
	[loadingIndicator release];
    loadingIndicator = 
		[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];

}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    if ([_forwardedDelegate respondsToSelector:@selector(webView:shouldStartLoadWithRequest:navigationType:)]) {
        return [_forwardedDelegate webView:webView shouldStartLoadWithRequest:request navigationType:navigationType];
    }    
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    if ([_forwardedDelegate respondsToSelector:@selector(webViewDidStartLoad:)]) {
        [_forwardedDelegate webViewDidStartLoad:webView];
        if (_shouldOverride) { return; }
    }
    
    [self addSubview:loadingIndicator];
    [loadingIndicator startAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    if ([_forwardedDelegate respondsToSelector:@selector(webViewDidFinishLoad:)]) {
        [_forwardedDelegate webViewDidFinishLoad:webView];
        if (_shouldOverride) { return; }        
    }    
    [loadingIndicator removeFromSuperview];    
}
    
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    if ([_forwardedDelegate respondsToSelector:@selector(webView:didFailLoadWithError:)]) {
        [_forwardedDelegate webView:webView didFailLoadWithError:error];
        if (_shouldOverride) { return; }
    }
    [loadingIndicator removeFromSuperview];    
}

- (void)layoutSubviews {
	[super layoutSubviews];
    loadingIndicator.center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);	
}
- (void)dealloc {
    _forwardedDelegate = nil;
    [super setDelegate:nil];    
    [loadingIndicator release];
    [super dealloc];
}

@end
