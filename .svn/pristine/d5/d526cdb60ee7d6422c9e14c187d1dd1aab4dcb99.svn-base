/**
 * BRAppDelegate.m
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
#import "BRAppDelegate.h"
#import "BRTabManager.h"
#import "BRSession.h"
#import "ReusableRemoteImageStoreWithFileCache.h"
#import "PostNewAccountViewController.h"
#import "LoadingOverlayViewController.h"
#import "BattleViewController.h"
#import "HomeViewController.h"
#import "InitialLoginViewController.h"
#import "BRStoreKitPaymentManager.h"
#import "ActionResult.h"



@implementation BRAppDelegate

@synthesize window, tabManager, loginController, imageStoreWithFileCache, savedDialog = _savedDialog, 
			currentlyActiveViewController = _currentlyActiveViewController;

static BRAppDelegate *sharedAppController;

/**
 * @return BRAppDelegate the delegate object in use
 */
+ (BRAppDelegate *)sharedManager {
    return sharedAppController;
}

- (void)applicationDidFinishLaunching:(UIApplication *)application {
	[application setStatusBarHidden:YES animated:NO];
    sharedAppController = self;    
    
    // set up the tab manager and add it to the window
    BRTabManager *brtm = [[BRTabManager alloc] init];
    self.tabManager = brtm;
    [brtm release];
    [self.window addSubview:[tabManager getTabBarView]];

    imageStoreWithFileCache = [[ReusableRemoteImageStoreWithFileCache alloc] initWithCacheSize:1];
	
	
	NSUInteger memoryCapacity = 512 * 1024;
	
	MegaURLCache *cache =
	[[MegaURLCache alloc] initWithMemoryCapacity: memoryCapacity
									diskCapacity: 0 diskPath:nil];
	cache.localCache = imageStoreWithFileCache;
	[NSURLCache setSharedURLCache:cache];
	
	[cache release];
    
    loadingOverlay = [[LoadingOverlayViewController alloc] init];
	
	InitialLoginViewController *initialLoginViewController = [[InitialLoginViewController alloc] init];
	[tabManager.homeController presentModalViewController:initialLoginViewController animated:NO];
	[initialLoginViewController release];
    
    notifier = [[Notifier alloc] init];
	
	[[BRStoreKitPaymentManager sharedManager] beginObserving];	
	 
	[window makeKeyAndVisible];
	
	[UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}


/**
 * showHomeScreen will remove any modal views that are on top of the home
 * screen
 */
- (void)showHomeScreen {
    [tabManager.homeController dismissModalViewControllerAnimated:YES];            
}

- (void)applicationWillTerminate:(UIApplication *)application {
    debug_NSLog(@"saving session");
    [[BRSession sharedManager] saveSession];
}

- (void)showLoadingOverlayWithText:(NSString *)text {
    loadingOverlay.loadingLabelText = text;
    [window addSubview:loadingOverlay.view];
}

- (void)hideLoadingOverlay {
    [loadingOverlay.view removeFromSuperview];
}

- (void)showNotification:(NSString *)newMessage withWidth:(CGFloat)width andHeight:(CGFloat)height {
    if ([notifier superview]) {
        [notifier removeFromSuperview];
    }
    debug_NSLog(@"show notification");
    [window addSubview:notifier];
    [notifier setMessage:newMessage withWidth:width andHeight:height];
}

- (void)showPlainTextNotification:(NSString *)newMessage {
    if ([notifier superview]) {
        [notifier removeFromSuperview];
    }
    debug_NSLog(@"show notification");
    [window addSubview:notifier];
    [notifier setPlainTextMessage:newMessage];
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    [imageStoreWithFileCache purgeCache];
}

- (void)dealloc {
    [window release];
    [notifier release];
    [tabManager release];
    [imageStoreWithFileCache release];
    [loadingOverlay release];
    [super dealloc];
}

#pragma mark Notification Delegate Methods
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
	// make a call to the server here
	debug_NSLog(@"Received Permission");
	
	[[BRRestClient sharedManager] account_setNotificationDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {

}

- (void)registerForRemoteNotifications {
	if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerForRemoteNotificationTypes:)]) {
		[[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
	}
}






@end
