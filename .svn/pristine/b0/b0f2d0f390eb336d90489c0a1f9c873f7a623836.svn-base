/**
 * BRAppDelegate.h
 * Copyright Miraphonic, Inc 2009. All rights reserved.
 *
 * The BRAppDelegate is the main controller of the application.
 * It is in charge of handling launch protocols as well as creating the
 * initial instances used by the application.  Other classes will use this
 * controller to access shared objects stored by it including the tabManager
 * and loginController
 *
 * @author Amit Matani
 * @created 1/13/09
 */

#import "BRGlobal.h"

@class BRTabManager, ReusableRemoteImageStoreWithFileCache, InitialLoadingViewController, 
		LoginViewController, LoadingOverlayViewController, Animal, Notifier, BRDialog;

@interface BRAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    BRTabManager *tabManager;
	LoginViewController *loginController;
	
    ReusableRemoteImageStoreWithFileCache *imageStoreWithFileCache;
    LoadingOverlayViewController *loadingOverlay;
    
    Notifier *notifier;
	
	BRDialog *_savedDialog;
	
	UIViewController *_currentlyActiveViewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) BRTabManager *tabManager;
@property (nonatomic, retain) LoginViewController *loginController;
@property (nonatomic, readonly) ReusableRemoteImageStoreWithFileCache *imageStoreWithFileCache;
@property (nonatomic, retain) BRDialog *savedDialog;
@property (nonatomic, assign) UIViewController *currentlyActiveViewController;

/**
 * @return BRAppDelegate the delegate object in use
 */

+ (BRAppDelegate *)sharedManager;


/**
 * showHomeScreen will remove any modal views that are on top of the home
 * screen
 */
- (void)showHomeScreen;

- (void)showLoadingOverlayWithText:(NSString *)text;

- (void)hideLoadingOverlay;
- (void)showNotification:(NSString *)newMessage withWidth:(CGFloat)width andHeight:(CGFloat)height;
- (void)showPlainTextNotification:(NSString *)newMessage;
- (void)registerForRemoteNotifications;

@end
