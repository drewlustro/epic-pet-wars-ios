/**
 * AbstractRemoteDataTableControllerWithTabs.m
 * Copyright Miraphonic, Inc 2009. All rights reserved.
 *
 * @author Amit Matani 
 * @created 4/13/09.
 */

#import "AbstractRemoteDataTableControllerWithTabs.h"
#import "Consts.h"
#import "Utility.h"
#import "TableViewWithInnerScrollView.h"
#import "AbstractRemoteCollectionStore.h"


@implementation AbstractRemoteDataTableControllerWithTabs
@synthesize tabBar = _tabBar;

- (id)initWithDataSources:(NSArray *)dataSources titles:(NSArray *)titles initialIndex:(NSInteger)index {
    id<RemoteCollection> initialDataSource = [dataSources objectAtIndex:index];
    if (self = [super initWithDataSource:initialDataSource]) {
        _dataSources = [dataSources retain];
        _titles = [titles retain];
        _selectedIndex = index;
        _hideNoObjectRow = NO;
        
        self.hideWhenNoObjects = NO;
        
        _tabBar = [[ScrollableTabBar alloc] initWithFrame:CGRectZero];
        _tabBar.delegate = self;
        [_tabBar setTabs:_titles];
        _tabBar.selectedIndex = _selectedIndex;
    }
    return self;
}

- (UIView *)customHeaderView {
    UIView *headerView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, FRAME_WIDTH, 0)] autorelease];
    return headerView;
}

- (void)loadView {
    debug_NSLog(@"loading the ardtc");
    UITableView *tableView = [[TableViewWithInnerScrollView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame] 
                                                                           style:UITableViewStylePlain];
    self.myTableView = tableView;
    [tableView release];
    
    myTableView.rowHeight = [self getDefaultRowHeight];
    myTableView.delegate = self;
    myTableView.dataSource = self;
    
    self.view = myTableView;
    
    UIView *headerView = [self customHeaderView];//[[UIView alloc] initWithFrame:CGRectMake(0, 0, FRAME_WIDTH, 40)];
    CGFloat initialY = headerView.frame.origin.y + headerView.frame.size.height;
    headerView.frame = CGRectMake(headerView.frame.origin.x, headerView.frame.origin.y,
                                  headerView.frame.size.width, headerView.frame.size.height + 40);
    
    _tabBar.frame = CGRectMake(0, initialY, FRAME_WIDTH, 40);
    [headerView addSubview:_tabBar];
    
    self.myTableView.tableHeaderView = headerView;

}

- (id<RemoteCollection>)getDataSourceAtIndex:(NSInteger)index {
    return [_dataSources objectAtIndex:index];
}

- (void)scrollableTabBar:(ScrollableTabBar *)scrollableTabBar didSelectIndex:(NSInteger)index {
    id<RemoteCollection> ds = [self getDataSourceAtIndex:index];
    if (dataSource == ds) { return; }
    
    [dataSource cancelDelayedActionOnTarget:self];
    self.dataSource = ds;
    
    if ([dataSource completedInitialLoad]) {
        [self softReload];
    } else {
        [self loadInitialData:NO showLoadingOverlay:NO];
    }
    _selectedIndex = index;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (![dataSource completedInitialLoad] || ([dataSource getNumObjectsLoaded] <= 0 && !_hideNoObjectRow)) {
        return 1;
    }
    return [super tableView:tableView numberOfRowsInSection:section];
}


- (void)dealloc {
    [_dataSources release];
    [_titles release];
    [_tabBar release];
    
    [super dealloc];
}


@end
