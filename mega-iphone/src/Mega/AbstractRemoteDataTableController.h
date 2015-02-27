/**
 * AbstractRemoteDataController.h
 * Copyright Miraphonic, Inc 2009. All rights reserved.
 *
 * The AbstractRemoteDataController defines a set of methods
 * extended the AbstractRemoteDataController to use a Table and
 * have as its data source an AbstractRemoteCollectionStore
 *
 * @author Amit Matani
 * @created 1/15/09
 */

#import <UIKit/UIKit.h>
#import "AbstractRemoteDataController.h"
#import "RemoteCollection.h"

@interface AbstractRemoteDataTableController : AbstractRemoteDataController <UITableViewDelegate, UITableViewDataSource> {
    id<RemoteCollection> dataSource;
    BOOL requiresSoftReload, hideWhenNoObjects;
    UITableView *myTableView;
    UITableViewCell *loadingCell;
}
@property (nonatomic, retain) id<RemoteCollection> dataSource;
@property (nonatomic, assign) BOOL requiresSoftReload, hideWhenNoObjects;
@property (nonatomic, retain) UITableView *myTableView;

/**
 * initWithDataSource initiailizes the object and sets up the row height
 * as well as saves the data source
 * @param data - an abstract remote collection store that the object
 * will use as a data source
 */
- (id)initWithDataSource:(id<RemoteCollection>)data;

/**
 * getLoadingCell generates and configures a loading cell that
 * is used by the table to show that there is more data to load
 */
- (UITableViewCell *)getLoadingCell;

#pragma mark table associated methods
/**
 * tableView:didSelectNormalRowAtIndexPath: method notifies a non loading row
 * that it has been clicked
 * @param NSIndexPath *indexPath - the indexPath of the selected cell
 */
- (void)didSelectNormalRowAtIndexPath:(NSIndexPath *)indexPath;
- (CGFloat)tableView:(UITableView *)tableView heightForNormalRowAtIndexPath:(NSIndexPath *)indexPath;
- (UITableViewCellAccessoryType)tableView:(UITableView *)aTableView accessoryTypeForNormalRowWithIndexPath:(NSIndexPath *)indexPath;

/**
 * getCellIdentifierAtIndexPath: returns a cellIdentifier based on the indexPath
 * @param NSIndexPath *indexPath
 * @return NSString *
 */
- (NSString *)getCellIdentifierAtIndexPath:(NSIndexPath *)indexPath;

/**
 * tableviewCellWithReuseIdentifier: returns a cell based on an identifier.
 * By default it will just use a normal cell, but when subclassed out
 * the implementing class can return custom UITableViewCell objects
 * based on the identifier
 * @param NSString *identifier - the identifier string
 * @return UITableViewCell * - the cell
 */
- (UITableViewCell *)tableviewCellWithReuseIdentifier:(NSString *)identifier;

/**
 * configureCell:forIndexPath configures the cell at the indexPath.
 * This should be subclassed out
 * @param UITableViewCell *cell - the cell to configure
 * @param NSIndexPath *indexPath - the index path that the cell will be located at
 */
- (void)configureCell:(UITableViewCell *)cell forIndexPath:(NSIndexPath *)indexPath;

/**
 * getDefaultRowHeight gets the default row height
 * @return CGFloat
 */
- (CGFloat)getDefaultRowHeight;

/**
 * showTableAfterInitialLoad is called by the data source once the initial load 
 * has occured
 * @param responseInt is the response code
 */
- (void)showTableAfterInitialLoad:(NSDecimalNumber *)responseInt;

/**
 * softReload reloads the table's view.  Usually called after
 * a requiresSoftReload is set
 */
- (void)softReload;

#pragma mark loading cell helper methods
/**
 * moreObjectsLoaded is called by the dataSource's loadRemoteCollectionWithTarget 
 * method to inform this object that it has loaded more data and to stop animating
 * the loading cell
 */
- (void)moreObjectsLoaded;

/** 
 * getLoadMoreString returns the string that should be displayed
 * by the loading cell that tells the user that there are more objects 
 * available
 * @return NSString *
 */
- (NSString *)getLoadMoreString;


/**
 * getNumLoadedString returns the string that displays the number of 
 * objects are left to be loaded
 * @return NSString *
 */
- (NSString *)getNumLoadedString;

/**
 * itemTypeString returns the name of the objects that are being loaded
 * it is a helper for the getNumLoadedString
 * @return NSString *
 */
- (NSString *)itemTypeString;

/**
 * noneAvailableString returns the string to display when there are no
 * objects in the remote collection
 * @return NSString *
 */
- (NSString *)noneAvailableString;

/**
 * updateLoadingCellText updates the text for the loading
 * cell
 */
- (void)updateLoadingCellText;
 
/**
 * startLoadingCellAnimation animates the loading cell
 */
- (void)startLoadingCellAnimation;

/**
 * stopLoadingCellAnimation stop the loading cell animation
 */
- (void)stopLoadingCellAnimation;

- (void)showNoneAvailable;

@end
