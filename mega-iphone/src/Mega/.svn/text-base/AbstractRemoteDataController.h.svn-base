/**
 * AbstractRemoteDataController.h
 * Copyright Miraphonic, Inc 2009. All rights reserved.
 *
 * The AbstractRemoteDataController lists a set of methods that should 
 * be defined by classes that require the use of the RDCContainerController.
 *
 * @author Amit Matani
 * @created 1/15/09
 */

#import "Mega/MegaGlobal.h"
#import "Mega/MegaViewController.h"

@class RDCContainerController;
@interface AbstractRemoteDataController : MegaViewController {
    RDCContainerController *containerController;
    BOOL hasInitialLoadAttemptOccured;
}

@property (nonatomic, assign) RDCContainerController *containerController;

/**
 * loadInitialData: tells the object to load the initial data.
 * It should first check if a new load is allowed or if the forceReload
 * option is set. If so, it should put up a loading overlay
 * @param BOOL forceReload - forceReload even if it isnt necessary
 */
- (void)loadInitialData:(BOOL)forceReload showLoadingOverlay:(BOOL)showLoadingOverlay;

/**
 * isInitialLoadRequired checks to see if the initial load is allowed by the
 * class.  Subclasses should override this method.
 * @return BOOL - YES if the initial load is allowed, otherwise NO
 */
- (BOOL)isInitialLoadRequired;

/**
 * hasInitialLoadBeenAttempted checks to see if the initial load has
 * already been attempted
 * @return BOOL - YES if the initial load is allowed, otherwise NO
 */
- (BOOL)hasInitialLoadBeenAttempted;

/** 
 * performInitialLoadRemoteDataCall is a helper function for loadInitialData that tells
 * the object to attempt to load the data from the remote server
 * Should be overrided by the subclass
 */
- (void)performInitialLoadRemoteDataCall;

/**
 * showLoadingOverlay informs the container controller to show the loading 
 * overlay
 */
- (void)showLoadingOverlay;

/**
 * hideLoadingOverlay informs the container controller to hide the loading 
 * overlay
 */
- (void)hideLoadingOverlay;

/**
 * willDisplayFromNavigation is called by the container when it receives
 * an alert from its parent navigation controller that it is about to be displayed
 */
- (void)willDisplayFromNavigation;

- (void)cancelLoads;

@end
