/**
 * AbstractRemoteDataTableControllerWithTabs.h
 * Copyright Miraphonic, Inc 2009. All rights reserved.
 *
 * @author Amit Matani 
 * @created 4/13/09.
 */


#import <UIKit/UIKit.h>
#import "AbstractRemoteDataTableController.h"
#import "ScrollableTabBar.h"

@interface AbstractRemoteDataTableControllerWithTabs : AbstractRemoteDataTableController <ScrollableTabBarDelegate> {
    NSArray *_dataSources;
    NSArray *_titles;
    NSInteger _selectedIndex;
    BOOL _hideNoObjectRow;
    ScrollableTabBar *_tabBar;
}

@property (nonatomic, readonly) ScrollableTabBar *tabBar;

- (id)initWithDataSources:(NSArray *)dataSources titles:(NSArray *)titles initialIndex:(NSInteger)index;

@end
