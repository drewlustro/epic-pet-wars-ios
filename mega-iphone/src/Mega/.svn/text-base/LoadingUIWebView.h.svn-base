//
//  LoadingUIWebView.h
//  mega framework
//
//  Created by Amit Matani on 3/21/09.
//  Copyright 2009 Miraphonic, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface LoadingUIWebView : UIWebView <UIWebViewDelegate> {
    UIActivityIndicatorView *loadingIndicator;
    id<UIWebViewDelegate> _forwardedDelegate;
    BOOL _shouldOverride;
}

@property (assign) BOOL shouldOverride;

- (void)setup;

@end
