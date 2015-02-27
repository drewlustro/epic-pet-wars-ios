/**
 * NewsFeedViewController.h
 * Copyright Miraphonic, Inc 2009. All rights reserved.
 *
 * NewsFeedViewController shows the items in the user's newsfeed.  It
 * also has the HomeActionViewController as its table header view.
 * It is shown on the home screen
 *
 * @author Amit Matani
 * @created 1/19/09
 */

#import <UIKit/UIKit.h>
#import "AbstractRemoteDataTableController.h"
#import "LoadingUIWebViewWithLocalRequest.h"

@class HomeActionViewController, NewsfeedItem;


@interface NewsFeedViewController : AbstractRemoteDataTableController <LoadingUIWebViewWithLocalRequestDelegate> {
    HomeActionViewController *actionViewController;
	UIViewController *homeController;
    LoadingUIWebViewWithLocalRequest *offerView;
}

@property (nonatomic, retain) HomeActionViewController *actionViewController;
@property (nonatomic, assign) UIViewController *homeController;

- (void)offerLoadingFailed;
- (void)addNewsFeedItemToTop:(NewsfeedItem *)ni;

@end
