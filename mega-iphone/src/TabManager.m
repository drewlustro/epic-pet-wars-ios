//
//  TabManager.m
//  mega framework
//
//  Created by Amit Matani on 1/13/09.
//  Copyright 2009 Miraphonic, Inc. All rights reserved.
//

#import "Mega/MegaGlobal.h"
#import "Mega/TabManager.h"

@implementation TabManager
@synthesize viewControllerList, navigationControllerList, tabBarController;

/**
 * init instantiates the object, the tabBarController and the
 * associated navigation and view controllers
 * @return BRTabManager instance
 */
- (id)init {
    if (self = [super init]) {
        tabBarController = [[UITabBarController alloc] init];
        tabBarController.delegate = self;
    }
    return self;
}

/**
 * setViewControllers: saves the viewControllers, puts each in a UINavigationController
 * and sets up the tabBarController with the viewControllers.
 * @param NSArray viewControllers - set of UIViewController <TopLevelController>
 * @throws NSException if the view controllers do not conform to theTopLevelController protocol
 */
- (void)setViewControllers:(NSArray *)viewControllers {
    UIViewController *controller;
    UINavigationController *navigationController;
    NSMutableArray *navigationControllers = [[NSMutableArray alloc] initWithCapacity:[viewControllers count]];
    for (controller in viewControllers) {
        if (![controller conformsToProtocol:@protocol(TopLevelController)]) {
            [NSException raise:NSInternalInconsistencyException 
                         format:@"ViewControllers in TabManager must conform to theTopLevelController protocol"];
        }   
        navigationController = [[UINavigationController alloc] initWithRootViewController:controller];
        [navigationControllers addObject:navigationController];
        [navigationController release];
    }
    
    self.viewControllerList = viewControllers;
    self.navigationControllerList = navigationControllers;
    
    tabBarController.viewControllers = navigationControllers;
    
    [navigationControllers release];
}

/**
 * getTabBarView gets the view associated with the UITabBarController managed
 * by this application 
 * @return UIView a UITabBar view
 */
- (UIView *)getTabBarView {
    return tabBarController.view;
}

/**
 * tabBarController:didSelectViewController conforms to the protocl for TabBarDelegates.
 * Our implementation sends viewcontroller that is at the root of the selected viewcontroller's
 * list to the selectedController method.
 * @param UITabBarController currentTabBarController - the tab bar controller that was in use
 * @param UIViewController viewController - the navigationcontroller that was selected
 */
- (void)tabBarController:(UITabBarController *)currentTabBarController
        didSelectViewController:(UIViewController *)viewController {
    debug_NSLog(@"current index %d", tabBarController.selectedIndex);
    [self selectedController:[self.viewControllerList objectAtIndex:tabBarController.selectedIndex]];
}

/**
 * selectedController is called when a tab is selected.  The view controller sent to this function
 * is the root view controller of the navigation controller who's tab was selected
 * @param UIViewController <TopLevelController> *viewController
 */
- (void)selectedController:(UIViewController <TopLevelController> *)viewController {
    [viewController handleSelected];
}

- (UIViewController *)getSelectedViewController {
	return tabBarController.selectedViewController;
}

/**
 * login is called when the user logs in.  Any actions that need to be forwarded
 * to the individual controllers, happens here
 */
- (void)login {
    debug_NSLog(@"calling handle login");
    UIViewController <TopLevelController> *controller;
    for (controller in viewControllerList) {
        [controller handleLogin];
    }
}

/**
 * logout is called when the user logs in.  Any actions that need to be forwarded
 * to the individual controllers, happens here
 */
- (void)logout {
    UIViewController <TopLevelController> *controller;
    for (controller in viewControllerList) {
        [controller handleLogout];
    }
}

- (void)dealloc {
    [tabBarController release];
    [viewControllerList release];
    [navigationControllerList release];
    [super dealloc];
}



@end
