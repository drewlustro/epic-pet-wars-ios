/**
 * AbstractRemoteDataController.m
 * Copyright Miraphonic, Inc 2009. All rights reserved.
 *
 * The AbstractRemoteDataController defines a set of methods
 * extended the AbstractRemoteDataController to use a Table and
 * have as its data source an AbstractRemoteCollectionStore
 *
 * @author Amit Matani
 * @created 1/15/09
 */

#import "AbstractRemoteDataTableController.h"
#import "Utility.h"
#import "Consts.h"
#import "RDCContainerController.h"
#import "TableViewWithInnerScrollView.h"

#define LOADING_VIEW_TAG 1
#define LOADING_MORE_MESSAGES_TAG 2
#define LOADING_MORE_INDICATOR_TAG 3
#define LOADING_MORE_DETAIL_TAG 4
#define NONE_AVAILABLE_TAG 5

#define NONE_AVAILABLE_FONT_SIZE 16
#define LOADING_CELL_HEIGHT 80

@implementation AbstractRemoteDataTableController
@synthesize dataSource, requiresSoftReload, myTableView, hideWhenNoObjects;

/**
 * initWithDataSource initiailizes the object and sets up the row height
 * as well as saves the data source
 * @param data - an abstract remote collection store that the object
 * will use as a data source
 * @return id
 */
- (id)initWithDataSource:(id<RemoteCollection>)data {
    if (self = [super init]) {
        self.dataSource = data;
        self.requiresSoftReload = NO;
        self.hideWhenNoObjects = YES;
    }
    return self;
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
}



/**
 * getLoadingCell generates and configures a loading cell that
 * is used by the table to show that there is more data to load
 */
- (UITableViewCell *)getLoadingCell {
    static NSString *CellIdentifier = @"LoadCell";
    
    UITableViewCell *cell = [myTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, 0, 0) reuseIdentifier:CellIdentifier] autorelease];
		
		// setup "Loading more _______" string
        UILabel *loadMoreMessageText;
        CGRect rect = CGRectMake(40, 20, 280, 16);
        loadMoreMessageText = [[UILabel alloc] initWithFrame:rect];
        loadMoreMessageText.tag = LOADING_MORE_MESSAGES_TAG;
        loadMoreMessageText.font = [UIFont boldSystemFontOfSize:16];
		loadMoreMessageText.textColor = WEBCOLOR(0x0767baff);
        loadMoreMessageText.adjustsFontSizeToFitWidth = YES;
        loadMoreMessageText.highlightedTextColor = [UIColor whiteColor];
        loadMoreMessageText.text = [self getLoadMoreString];
		[cell.contentView addSubview:loadMoreMessageText];
		
		// detail disclosure of how many we've got left "1-10 of XX Stuff"
		UILabel *loadingDetail;
		rect = CGRectMake(40, loadMoreMessageText.frame.origin.y + loadMoreMessageText.frame.size.height, 280, 20);
		loadingDetail = [[UILabel alloc] initWithFrame:rect];
		loadingDetail.font = [UIFont systemFontOfSize:12];
		loadingDetail.textColor = [UIColor grayColor];
		loadingDetail.adjustsFontSizeToFitWidth = YES;
		loadingDetail.tag = LOADING_MORE_DETAIL_TAG;
		loadingDetail.highlightedTextColor = [UIColor lightGrayColor];
		loadingDetail.text = [self getNumLoadedString];
		[cell.contentView addSubview:loadingDetail];
		
		// setup loading indicator when someone taps on the load more ___ string
		UIActivityIndicatorView *loadMoreIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
		loadMoreIndicator.tag = LOADING_MORE_INDICATOR_TAG;
		loadMoreIndicator.hidesWhenStopped = YES;
		loadMoreIndicator.contentMode = UIViewContentModeCenter;
		loadMoreIndicator.frame = CGRectMake(0, 0, 320, LOADING_CELL_HEIGHT);
		loadMoreIndicator.hidden = YES;
		[cell.contentView addSubview:loadMoreIndicator];
		
		// release area just because I use the temp vars for layouts
		[loadMoreMessageText release];
		[loadingDetail release];
		[loadMoreIndicator release];
		
    }
    return cell;
}

#pragma mark table associated methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *data = [dataSource getNumObjectsLoadedAndAvailable];
    int numObjects = [[data objectAtIndex:0] intValue];
    int totalObjectsAvailable = [[data objectAtIndex:1] intValue];
    if (numObjects < totalObjectsAvailable) {
        numObjects += 1;
    }
    debug_NSLog(@"num objects to display: %d", numObjects);
    return numObjects;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    if (tableView.editing == YES) {
        debug_NSLog(@"this is in editing mode");
    }
    if ([dataSource getNumObjectsLoaded] == indexPath.row) {
        if (loadingCell == nil) {
            loadingCell = [self getLoadingCell];
        }
        if (indexPath.row == 0) {
            if (![dataSource completedInitialLoad]) {
                [self startLoadingCellAnimation];
            } else {
                [self showNoneAvailable];
            }
        }        
        return loadingCell;
    } else {
        NSString *cellIdentifier = [self getCellIdentifierAtIndexPath:indexPath];
        
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
    		cell = [self tableviewCellWithReuseIdentifier:cellIdentifier];
        }        
        [self configureCell:cell forIndexPath:indexPath];
    }
    return cell;
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([dataSource getNumObjectsLoaded] == indexPath.row) {
		[self startLoadingCellAnimation];
        [dataSource loadRemoteCollectionWithTarget:self selector:@selector(moreObjectsLoaded)];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    } else {
        [self didSelectNormalRowAtIndexPath:indexPath];
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [dataSource getNumObjectsLoaded] == indexPath.row ? UITableViewCellEditingStyleNone : UITableViewCellEditingStyleDelete;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([dataSource getNumObjectsLoaded] == indexPath.row) {
        return LOADING_CELL_HEIGHT;
    }
    return [self tableView:tableView heightForNormalRowAtIndexPath:indexPath];
}

- (CGFloat)tableView:(UITableView *)tableView heightForNormalRowAtIndexPath:(NSIndexPath *)indexPath {
	return [self getDefaultRowHeight];
}

- (UITableViewCellAccessoryType)tableView:(UITableView *)aTableView accessoryTypeForNormalRowWithIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellAccessoryNone;    
}

- (UITableViewCellAccessoryType)tableView:(UITableView *)aTableView accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath {
    if ([dataSource getNumObjectsLoaded] == indexPath.row) {
        return UITableViewCellAccessoryNone;
    }
    return [self tableView:aTableView accessoryTypeForNormalRowWithIndexPath:indexPath];
}

/**
 * tableView:didSelectNormalRowAtIndexPath: method notifies a non loading row
 * that it has been clicked
 * @param NSIndexPath *indexPath - the indexPath of the selected cell
 */
- (void)didSelectNormalRowAtIndexPath:(NSIndexPath *)indexPath {

}

/**
 * getDefaultRowHeight gets the default row height
 * @return CGFloat
 */
- (CGFloat)getDefaultRowHeight {
    return 80.0;
}

/**
 * softReload reloads the table's view.  Usually called after
 * a requiresSoftReload is set
 */
- (void)softReload {
    [self stopLoadingCellAnimation];
	if (hideWhenNoObjects && [dataSource getNumObjectsLoaded] <= 0) {
		[containerController displayMessageOverlay:[self noneAvailableString]];
	} else {
        [myTableView reloadData];
        [self updateLoadingCellText];
	}
    requiresSoftReload = NO;
}

#pragma mark loading cell helper methods
/**
 * moreObjectsLoaded is called by the dataSource's loadRemoteCollectionWithTarget 
 * method to inform this object that it has loaded more data and to stop animating
 * the loading cell
 */
- (void)moreObjectsLoaded {
	[self stopLoadingCellAnimation];
    [myTableView reloadData];    
}

/** 
 * getLoadMoreString returns the string that should be displayed
 * by the loading cell that tells the user that there are more objects 
 * available
 * @return NSString *
 */
- (NSString *)getLoadMoreString {
    return @"";
}


- (NSString *)getNumLoadedString {	
	return [NSString stringWithFormat:@"Viewing %d of %d %@", [dataSource getNumObjectsLoaded], 
            [dataSource getNumObjectsAvailable], [self itemTypeString]];
}


/**
 * itemTypeString returns the name of the objects that are being loaded
 * it is a helper for the getNumLoadedString
 * @return NSString *
 */
- (NSString *)itemTypeString {
    return @"";
}

/**
 * noneAvailableString returns the string to display when there are no
 * objects in the remote collection
 * @return NSString *
 */
- (NSString *)noneAvailableString {
    return @"";
}

/**
 * updateLoadingCellText updates the text for the loading
 * cell
 */
- (void)updateLoadingCellText {
	UILabel *loadDetail = (UILabel *) [loadingCell.contentView viewWithTag:LOADING_MORE_DETAIL_TAG];
    loadDetail.text = [self getNumLoadedString];
    
	UILabel *loadMoreMessageText = (UILabel *) [loadingCell.contentView viewWithTag:LOADING_MORE_MESSAGES_TAG];    
    loadMoreMessageText.text = [self getLoadMoreString];    
}

/**
 * startLoadingCellAnimation animates the loading cell
 */
- (void)startLoadingCellAnimation {
    UITableViewCell *cell = loadingCell;
	UIView *loadMoreLabel = [cell.contentView viewWithTag:LOADING_MORE_MESSAGES_TAG];
	UIView *loadDetail = [cell.contentView viewWithTag:LOADING_MORE_DETAIL_TAG];
	UILabel *noneAvailableLabel = (UILabel *) [cell.contentView viewWithTag:NONE_AVAILABLE_TAG];    
	UIActivityIndicatorView *loadMoreIndicator = (UIActivityIndicatorView *) [cell.contentView viewWithTag:LOADING_MORE_INDICATOR_TAG];
	
	// hide the loading message
	if (loadMoreLabel != nil && loadDetail != nil) {
		loadMoreLabel.hidden = YES;
		loadDetail.hidden = YES;
        noneAvailableLabel.hidden = YES;
	}
	
	// show loading indicator
	if (loadMoreIndicator != nil) {
		loadMoreIndicator.hidden = NO;
		[loadMoreIndicator startAnimating];
	}
}

- (void)showNoneAvailable {
    UITableViewCell *cell = loadingCell;
	UILabel *loadMoreLabel = (UILabel *)[cell.contentView viewWithTag:LOADING_MORE_MESSAGES_TAG];
	UILabel *noneAvailableLabel = (UILabel *) [cell.contentView viewWithTag:NONE_AVAILABLE_TAG];
	UIView *loadDetail = [cell.contentView viewWithTag:LOADING_MORE_DETAIL_TAG];
	UIActivityIndicatorView *loadMoreIndicator = (UIActivityIndicatorView *) [cell.contentView viewWithTag:LOADING_MORE_INDICATOR_TAG];
	
	// hide the loading message / load detail
	if (loadMoreLabel != nil && loadDetail != nil) {
		loadMoreLabel.hidden = YES;
        //loadMoreLabel.text = [self noneAvailableString];
		loadDetail.hidden = YES;
	}
	
	// hide loading indicator
	if (loadMoreIndicator != nil) {
		loadMoreIndicator.hidden = YES;
		[loadMoreIndicator stopAnimating];
	}    
	
	// create a new label that describtes how there is no X or Y available
	
	if (noneAvailableLabel == nil) {
		noneAvailableLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 280, LOADING_CELL_HEIGHT)];
		noneAvailableLabel.font = [UIFont systemFontOfSize:NONE_AVAILABLE_FONT_SIZE];
		noneAvailableLabel.textColor = WEBCOLOR(0x8F5A00FF);
		noneAvailableLabel.numberOfLines = 0;
		noneAvailableLabel.textAlignment = UITextAlignmentCenter;
		noneAvailableLabel.backgroundColor = [UIColor clearColor];
		noneAvailableLabel.tag = NONE_AVAILABLE_TAG;
		[cell.contentView addSubview:noneAvailableLabel];
		[noneAvailableLabel release];
	} else {
        noneAvailableLabel.hidden = NO;
    }
	
	noneAvailableLabel.text = [self noneAvailableString];
}

/**
 * stopLoadingCellAnimation stop the loading cell animation
 */
- (void)stopLoadingCellAnimation {
	UITableViewCell *cell = loadingCell;
	UIView *loadMoreLabel = [cell.contentView viewWithTag:LOADING_MORE_MESSAGES_TAG];
	UILabel *loadDetail = (UILabel *) [cell.contentView viewWithTag:LOADING_MORE_DETAIL_TAG];
	UIActivityIndicatorView *loadMoreIndicator = (UIActivityIndicatorView *) [cell.contentView viewWithTag:LOADING_MORE_INDICATOR_TAG];
	
	// hide the loading message
	if (loadMoreLabel != nil && loadDetail != nil) {
		// update the loading detail text
        [self updateLoadingCellText];
		
		loadMoreLabel.hidden = NO;
		loadDetail.hidden = NO;

	}
	
	// show loading indicator
	if (loadMoreIndicator != nil) {
		loadMoreIndicator.hidden = YES;
		[loadMoreIndicator stopAnimating];
	}    
}

#pragma mark RemoteDataController methods
/**
 * isInitialLoadRequired returns YES if the number of objects loaded is 0
 * @return BOOL - YES if the initial load is allowed, otherwise NO
 */
- (BOOL)isInitialLoadRequired {
    return [dataSource getNumObjectsLoaded] == 0;
}

/** 
 * performInitialLoadRemoteDataCall is a helper function for loadInitialData that tells
 * the object to attempt to load the data from the remote server
 * Should be overrided by the subclass
 */
- (void)performInitialLoadRemoteDataCall {
    [super performInitialLoadRemoteDataCall];
	[dataSource resetCollection];
    [myTableView reloadData];
    [dataSource loadRemoteCollectionWithTarget:self selector:@selector(showTableAfterInitialLoad:)];
}

/**
 * showTableAfterInitialLoad is called by the data source once the initial load 
 * has occured
 * @param responseInt is the response code
 */
- (void)showTableAfterInitialLoad:(NSDecimalNumber *)responseInt {
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



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}


- (void)dealloc {
    [myTableView release];
    [dataSource cancelDelayedActionOnTarget:self];
    [dataSource release];
    [super dealloc];
}


@end
