//
//  LoadingUIWebViewWithLocalRequest.h
//  mega framework
//
//  Created by Amit Matani on 4/12/09.
//  Copyright 2009 Miraphonic, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoadingUIWebView.h"

@protocol LoadingUIWebViewWithLocalRequestDelegate;

@interface LoadingUIWebViewWithLocalRequest : LoadingUIWebView {
    id<LoadingUIWebViewWithLocalRequestDelegate> localDelegate;
	BOOL _launchExternalLinksInSafari;
}

@property (nonatomic, assign) id<LoadingUIWebViewWithLocalRequestDelegate> localDelegate;
@property (nonatomic, assign) BOOL launchExternalLinksInSafari;

@end

@protocol LoadingUIWebViewWithLocalRequestDelegate <NSObject>
- (void)webView:(LoadingUIWebViewWithLocalRequest *)webView handleLocalMethod:(NSString *)method params:(NSDictionary *)params;

@optional

- (void)webView:(LoadingUIWebViewWithLocalRequest *)webView willLoadRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType;

@end

