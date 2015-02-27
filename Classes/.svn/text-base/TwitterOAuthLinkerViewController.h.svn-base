//
//  TwitterOAuthLinkerViewController.h
//  battleroyale
//
//  Created by Amit Matani on 8/22/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BRGlobal.h"


@protocol TwitterOAuthLinkerDelegate;

@interface TwitterOAuthLinkerViewController : MegaViewController <UIWebViewDelegate, LoadingUIWebViewWithLocalRequestDelegate> {
    BOOL _success;
    id<TwitterOAuthLinkerDelegate> _delegate;
}

@property (nonatomic, assign) id<TwitterOAuthLinkerDelegate> delegate;

@end 

@protocol TwitterOAuthLinkerDelegate <NSObject>

- (void)didFinishAttemptedLink:(BOOL)wasSuccessful;

@end

