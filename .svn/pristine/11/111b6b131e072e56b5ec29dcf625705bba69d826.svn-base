/**
 * ChallengerTableViewController.m
 * Copyright Miraphonic, Inc 2009. All rights reserved.
 *
 * @author Amit Matani 
 * @created 2/1/09.
 */

#import "ChallengerTableViewController.h"
#import "ChallengerRemoteCollection.h"
#import "ChallengerTableViewCell.h"
#import "Consts.h"
#import "LoadingUIWebView.h"

#define CELL_HEIGHT 100.0

@implementation ChallengerTableViewController
@synthesize battleListViewController;

- (id)init {
    ChallengerRemoteCollection *data = [[ChallengerRemoteCollection alloc] init];
    if (self = [super initWithDataSource:data]) {
		
    }
    [data release];
	
    return self;
}

- (UITableViewCell *)tableviewCellWithReuseIdentifier:(NSString *)identifier {
    //return [[[JobTableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:identifier] autorelease];
	return [[[ChallengerTableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:identifier] autorelease];
}

- (void)configureCell:(UITableViewCell *)_cell forIndexPath:(NSIndexPath *)indexPath {
    // for convenience
    ChallengerTableViewCell *cell = (ChallengerTableViewCell *)_cell;
    cell.challenger = (Challenger *) [dataSource objectAtIndex:indexPath.row];
	cell.battleDelegate = battleListViewController;
}

- (CGFloat)getDefaultRowHeight {
    return CELL_HEIGHT;
}

- (void)loadView {
#define HEADER_HEIGHT 60.0
#define PADDING 5
	[super loadView];
    
	self.view.backgroundColor = [UIColor blackColor];    
}

/**
 * showTableAfterInitialLoad is called by the data source once the initial load 
 * has occured
 * @param responseInt is the response code
 */
- (void)showTableAfterInitialLoad:(NSDecimalNumber *)responseInt {
    [super showTableAfterInitialLoad:responseInt];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, FRAME_WIDTH, HEADER_HEIGHT)];
    
    UIWebView *contentView = [[LoadingUIWebView alloc] initWithFrame:headerView.frame];
    contentView.backgroundColor = [UIColor clearColor];
    [headerView addSubview:contentView];
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSURL *baseURL = [NSURL fileURLWithPath:path];
    [contentView loadHTMLString:[[dataSource extraData] objectForKey:@"explanation"] baseURL:baseURL];
    [contentView release];
    
    self.myTableView.tableHeaderView = headerView;
    
    [headerView release];

}

/**
 * tableView:didSelectNormalRowAtIndexPath: method creates a AnimalTypeDetailViewController
 * and sends the animaltype selected to this view controller.  Then it pushes it on top of the
 * navigation stack.
 * @param NSIndexPath *indexPath - the path of the selected item
 */
- (void)didSelectNormalRowAtIndexPath:(NSIndexPath *)indexPath {
    [myTableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}


- (void)dealloc {
    [super dealloc];
}


@end
