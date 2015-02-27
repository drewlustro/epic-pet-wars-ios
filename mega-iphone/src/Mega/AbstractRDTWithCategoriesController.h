/**
 * AbstractRDTWithCategories.h
 * Copyright Miraphonic, Inc 2009. All rights reserved.
 *
 * The AbstractRDTWithCategories defines a set of methods
 * extended the AbstractRemoteDataController to use a Table and
 * have as its data source an AbstractRemoteCollectionWithCategories
 *
 * @author Amit Matani
 * @created 1/28/09
 */

#import "Mega/MegaGlobal.h"
#import "AbstractRemoteDataController.h"

@class AbstractRemoteCollectionWithCategories;
@interface AbstractRDTWithCategoriesController : AbstractRemoteDataController <UITableViewDelegate, UITableViewDataSource> {
    AbstractRemoteCollectionWithCategories *dataSource;
    UITableView *myTableView;    
    BOOL requiresSoftReload, hideWhenNoObjects;    
}

@property (nonatomic, retain) AbstractRemoteCollectionWithCategories *dataSource;
@property (nonatomic, assign) BOOL requiresSoftReload, hideWhenNoObjects;
@property (nonatomic, retain) UITableView *myTableView;

/**
 * initWithDataSource initiailizes the object and sets up the row height
 * as well as saves the data source
 * @param data - an abstract remote collection store that the object
 * will use as a data source
 */
- (id)initWithDataSource:(AbstractRemoteCollectionWithCategories *)data;

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
 * getCellIdentifierAtIndexPath: returns a cellIdentifier based on the indexPath
 * @param NSIndexPath *indexPath
 * @return NSString *
 */
- (NSString *)getCellIdentifierAtIndexPath:(NSIndexPath *)indexPath;

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
- (void)showTableAfterInitialLoad;

/**
 * softReload reloads the table's view.  Usually called after
 * a requiresSoftReload is set
 */
- (void)softReload;

/**
 * noneAvailableString returns the string to display when there are no
 * objects in the remote collection
 * @return NSString *
 */
- (NSString *)noneAvailableString;

@end
