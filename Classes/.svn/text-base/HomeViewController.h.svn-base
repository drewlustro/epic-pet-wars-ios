/**
 * HomeViewController.h
 * Copyright Miraphonic, Inc 2009. All rights reserved.
 *
 * The HomeViewController is the controller in charge of handling the home
 * tab of the application. The home tab shows the user's pet as well
 * as some single player actions.
 *
 * @author Amit Matani
 * @created 1/13/09
 */

#import <UIKit/UIKit.h>
#import "BasicTopLevelViewController.h"

@class RDCContainerController, Animal, NewsFeedViewController;
@interface HomeViewController : BasicTopLevelViewController {
    RDCContainerController *newsFeedContainer;
	NewsFeedViewController *newsFeedViewController;
}

@property (nonatomic, readonly) NewsFeedViewController *newsFeedViewController;

- (void)increaseBadgeValue:(NSInteger)increment;

@end
