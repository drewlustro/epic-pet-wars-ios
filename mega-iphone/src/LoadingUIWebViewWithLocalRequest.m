//
//  LoadingUIWebViewWithLocalRequest.m
//  mega framework
//
//  Created by Amit Matani on 4/12/09.
//  Copyright 2009 Miraphonic, Inc. All rights reserved.
//

#import "LoadingUIWebViewWithLocalRequest.h"
#import "Utility.h"

@implementation LoadingUIWebViewWithLocalRequest
@synthesize localDelegate, launchExternalLinksInSafari = _launchExternalLinksInSafari;

- (void)setup {
	[super setup];
	_launchExternalLinksInSafari = YES;
}

- (BOOL)shouldLaunchExternalLinkJavascript {
	return [Utility isStringTrue:[self stringByEvaluatingJavaScriptFromString:@"shouldLaunchExternal()"]];
}

/**
 * will push any link that is website related to safari and 
 * send any link with the format local://method/?param1=value1... to 
 * the handlerequest function of the delegate if it is set
 */
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    if (navigationType == UIWebViewNavigationTypeLinkClicked ||
        navigationType == UIWebViewNavigationTypeFormSubmitted ||
        navigationType == UIWebViewNavigationTypeOther) {
        if ([[request.URL scheme] isEqualToString:@"local"]) {
            if ([localDelegate respondsToSelector:@selector(webView:handleLocalMethod:params:)]) {
                NSString *host = [request.URL host];
                NSString *paramString = [request.URL query];
                NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:1];
                if (paramString != nil) {
                    NSArray *splitQuery = [paramString componentsSeparatedByString:@"&"];
                    for (id value in splitQuery) {
                        NSArray *keyValue = [value componentsSeparatedByString:@"="];
                        if ([keyValue count] == 2) {
                            [params setObject:[[keyValue objectAtIndex:1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:[keyValue objectAtIndex:0]];
                        }
                    }
                }
                [localDelegate webView:self handleLocalMethod:host params:params];
            }
        } else if ((navigationType != UIWebViewNavigationTypeOther && _launchExternalLinksInSafari) || 
				   (navigationType == UIWebViewNavigationTypeOther && [self shouldLaunchExternalLinkJavascript])) {
            [[UIApplication sharedApplication] openURL:request.URL];
		} else {
			if ([localDelegate respondsToSelector:@selector(webView:willLoadRequest:navigationType:)]) {
				[localDelegate webView:self willLoadRequest:request navigationType:navigationType];
			}
            return true;
        }
        return false;
    }
	if ([localDelegate respondsToSelector:@selector(webView:willLoadRequest:navigationType:)]) {
		[localDelegate webView:self willLoadRequest:request navigationType:navigationType];
	}
	return true;
}

- (void)dealloc {
	localDelegate = nil;
	[super dealloc];
}

@end
