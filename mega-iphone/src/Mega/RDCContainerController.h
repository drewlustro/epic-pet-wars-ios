/**
 * RDCContainerController.h
 * Copyright Miraphonic, Inc 2009. All rights reserved.
 *
 * RDCContainerController holds a AbstractRemoteDataController and
 * displays a loading overlay over it until it is ready to be shown
 *
 * @author Amit Matani
 * @created 1/15/09
 */

#import "Mega/MegaGlobal.h"
#import "Mega/MegaViewController.h"
#import "BRGlobal.h"

@class AbstractRemoteDataController;
@interface RDCContainerController : MegaViewController <UINavigationControllerDelegate> {
    AbstractRemoteDataController *containedRDC;
	UIActivityIndicatorView *initialLoadingIndicator;
    UILabel *initialLoadingLabel, *specialMessageLabel;	    
}

@property (nonatomic, retain) AbstractRemoteDataController *containedRDC;
@property (nonatomic, retain) UIActivityIndicatorView *initialLoadingIndicator;
@property (nonatomic, retain) UILabel *initialLoadingLabel, *specialMessageLabel;

- (id)initWithRemoteDataController:(AbstractRemoteDataController *)controller;

/**
 * showLoadingScreen will show the loading overlay
 * and hide the contained view controller
 */
- (void)showLoadingScreen;

/**
 * showContainedViewController will hide the loading overlay
 * and show the contained view controller
 */
- (void)showContainedViewController;

/**
 * setContainedAndLoadingVisibility is a helper for showContainedViewController
 * and showLoadingScreen and will show and hide the views based on the
 * isLoading variable
 * 0 to show loading
 * 1 to show the containedRDC
 * 2 to show the special message
 */
- (void)setContainedAndLoadingVisibility:(NSInteger)status;

/**
 * loadingText returns the string that is diplayed next to the loading
 * indicator when it is loading
 */
- (NSString *)loadingText;

/**
 * displayMessageOverlay: takes a string and displays it on the loading screen
 * in place of the loading indicator and text
 * @param NSString *text
 */
- (void)displayMessageOverlay:(NSString *)text;

/**
 * getLeftMargin returns the lef margin for the loading indicator
 * @return NSInteger left margin
 */
- (CGFloat)getLeftMargin;

/**
 * getLeftMargin returns the top margin for the loading indicator
 * @return NSInteger top margin
 */
- (CGFloat)getTopMargin;

/**
 * setViewFrame: sets the frame of the controller and also sets the frame
 * of the contained controller to be the same size and at 0,0 of the container
 * controller
 * @param CGRect frame - the frame
 */
- (void)setViewFrame:(CGRect)frame;

/**
 * getInitalLoadFontSize returns the font size of the loading indicator
 * @return CGFloat font size
 */
- (CGFloat)getInitalLoadFontSize;


@end
