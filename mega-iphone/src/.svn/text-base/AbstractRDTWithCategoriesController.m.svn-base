/**
 * AbstractRDTWithCategoriesController.h
 * Copyright Miraphonic, Inc 2009. All rights reserved.
 *
 * The AbstractRDTWithCategoriesController defines a set of methods
 * extended the AbstractRemoteDataController to use a Table and
 * have as its data source an AbstractRemoteCollectionWithCategories
 *
 * @author Amit Matani
 * @created 1/28/09
 */

#import "AbstractRDTWithCategoriesController.h"
#import "AbstractRemoteCollectionWithCategories.h"
#import "RDCContainerController.h"
#import "Consts.h"

@implementation AbstractRDTWithCategoriesController
@synthesize dataSource, requiresSoftReload, myTableView, hideWhenNoObjects;

/**
 * initWithDataSource initiailizes the object and sets up the row height
 * as well as saves the data source
 * @param data - an abstract remote collection store that the object
 * will use as a data source
 * @return id
 */
- (id)initWithDataSource:(AbstractRemoteCollectionWithCategories *)data {
    if (self = [super init]) {
        self.dataSource = data;
        self.requiresSoftReload = NO;
        self.hideWhenNoObjects = YES;
    }
    return self;
}

- (void)loadView {
    debug_NSLog(@"loading the ardtwthc");
    UITableView *tableView = [[UITableView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame] 
	                                              style:UITableViewStylePlain];
    self.myTableView = tableView;
    [tableView release];
    
    myTableView.rowHeight = [self getDefaultRowHeight];
    myTableView.delegate = self;
    myTableView.dataSource = self;
    
    self.view = myTableView;
}

#pragma mark table associated methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[dataSource getCategoryKeys] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSString *category = [[dataSource getCategoryKeys] objectAtIndex:section];
    return [dataSource getNumObjectsInCategory:category];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [dataSource getPrettyNameForKey:[[dataSource getCategoryKeys] objectAtIndex:section]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier = [self getCellIdentifierAtIndexPath:indexPath];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
		cell = [self tableviewCellWithReuseIdentifier:cellIdentifier];
    }        
    [self configureCell:cell forIndexPath:indexPath];
    return cell;
}

/**
 * tableviewCellWithReuseIdentifier: returns a cell based on an identifier.
 * By default it will just use a normal cell, but when subclassed out
 * the implementing class can return custom UITableViewCell objects
 * based on the identifier
 * @param NSString *identifier - the identifier string
 * @return UITableViewCell * - the cell
 */
- (UITableViewCell *)tableviewCellWithReuseIdentifier:(NSString *)identifier {
    UITableViewCell *cell = [[[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, 0, 0) reuseIdentifier:identifier] autorelease];
    return cell;
}

/**
 * configureCell:forIndexPath configures the cell at the indexPath.
 * This should be subclassed out
 * @param UITableViewCell *cell - the cell to configure
 * @param NSIndexPath *indexPath - the index path that the cell will be located at
 */
- (void)configureCell:(UITableViewCell *)cell forIndexPath:(NSIndexPath *)indexPath {
    [NSException raise:@"Method Not Defined Exception" 
				format:@"Error, attempting to call an undefined method."];    
}

/**
 * getCellIdentifierAtIndexPath: returns a cellIdentifier based on the indexPath
 * @param NSIndexPath *indexPath
 * @return NSString *
 */
- (NSString *)getCellIdentifierAtIndexPath:(NSIndexPath *)indexPath {
    return @"NormalCell";
}

/**
 * getDefaultRowHeight gets the default row height
 * @return CGFloat
 */
- (CGFloat)getDefaultRowHeight {
    return 80.0;
}

#pragma mark RemoteDataController methods
/**
 * isInitialLoadRequired returns YES if the number of objects loaded is 0
 * @return BOOL - YES if the initial load is allowed, otherwise NO
 */
- (BOOL)isInitialLoadRequired {
    return [dataSource getTotalObjects] == 0;
}

/** 
 * performInitialLoadRemoteDataCall is a helper function for loadInitialData that tells
 * the object to attempt to load the data from the remote server
 * Should be overrided by the subclass
 */
- (void)performInitialLoadRemoteDataCall {
    [super performInitialLoadRemoteDataCall];
    [dataSource loadItemsWithTarget:self finishedSelector:@selector(showTableAfterInitialLoad)
					 failedSelector:nil forceReload:NO];
}

/**
 * showTableAfterInitialLoad is called by the data source once the initial load 
 * has occured
 * @param responseInt is the response code
 */
- (void)showTableAfterInitialLoad {
    [containerController showContainedViewController];
    debug_NSLog(@"showTableAfterInitialLoad");
    [self softReload];
}


/**
 * willDisplayFromNavigation is called by the container when it receives
 * an alert from its parent navigation controller that it is about to be displayed
 */
- (void)willDisplayFromNavigation {
    if (requiresSoftReload) {
        debug_NSLog(@"requires soft reload");
        [self softReload];
    }
    requiresSoftReload = NO;
}

/**
 * softReload reloads the table's view.  Usually called after
 * a requiresSoftReload is set
 */
- (void)softReload {
	if (hideWhenNoObjects && [dataSource getTotalObjects] <= 0) {
		[containerController displayMessageOverlay:[self noneAvailableString]];
	} else {
        [myTableView reloadData];
	}
    requiresSoftReload = NO;
}

- (void)cancelLoads {
    [dataSource cancelDelayedActionOnTarget:self];
}

/**
 * noneAvailableString returns the string to display when there are no
 * objects in the remote collection
 * @return NSString *
 */
- (NSString *)noneAvailableString {
    return @"";
}

- (void)dealloc {
    [dataSource release]; 
    [myTableView release];
    [super dealloc];
}
@end
