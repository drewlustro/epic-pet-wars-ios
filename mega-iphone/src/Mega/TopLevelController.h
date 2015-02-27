/**
 * TopLevelController.h
 * Copyright Miraphonic, Inc 2009. All rights reserved.
 *
 * TheTopLevelController defines the set of methods that
 * all top level controllers must define. Top level controllers
 * are the ones that are managed by the applications tab bar.
 *
 * @author Amit Matani
 * @created 1/13/09
 */
 
@protocol TopLevelController

/**
 * selected is called when the controller in the tab
 * bar is selected
 */
- (void)handleSelected;

/**
 * login is called when there is a new login
 */
- (void)handleLogin;

/**
 * logout is called when the logout action is requested
 */
- (void)handleLogout;

/**
 * Handle death is sent to the controllers when the user 
 * has died usually this means to lock out the screens
 */
- (void)handleDeath;

- (void)handleRevive;

@end 