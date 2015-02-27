/**
 * TabManager.h
 * Copyright Miraphonic, Inc 2009. All rights reserved.
 *
 * The TabManager manages the UITabBarController associated
 * with the application and the specific ViewControllers
 * that are the tabs.
 *
 * @author Amit Matani
 * @created 1/13/09
 */

#import "Mega/TabManager.h"
#import "Mega/MegaGlobal.h"
#import "Mega/TopLevelController.h"

@interface TabManager : NSObject <UITabBarControllerDelegate> {
    UITabBarController *tabBarController;
    NSArray *viewControllerList;
    NSArray *navigationControllerList;
}

@property (nonatomic, retain) NSArray *viewControllerList;
@property (nonatomic, retain) NSArray *navigationControllerList;
@property (nonatomic, readonly) UITabBarController *tabBarController;

/**
 * setViewControllers: saves the viewControllers, puts each in a UINavigationController
 * and sets up the tabBarController with the viewControllers.
 * @param NSArray viewControllers - set of UIViewController <TopLevelController>
 * @throws NSException if the view controllers do not conform to theTopLevelController protocol
 */
- (void)setViewControllers:(NSArray *)viewControllers;

/**
 * selectedController is called when a tab is selected.  The view controller sent to this function
 * is the root view controller of the navigation controller who's tab was selected
 * @param UIViewController <TopLevelController> *viewController
 */
- (void)selectedController:(UIViewController <TopLevelController> *)viewController;

- (UIViewController *)getSelectedViewController;

/**
 * login is called when the user logs in.  Any actions that need to be forwarded
 * to the individual controllers, happens here
 */
- (void)login;

/**
 * logout is called when the user logs in.  Any actions that need to be forwarded
 * to the individual controllers, happens here
 */
- (void)logout;

/**
 * getTabBarView gets the view associated with the UITabBarController managed
 * by this application 
 * @return UIView a UITabBar view
 */
- (UIView *)getTabBarView;

@end
