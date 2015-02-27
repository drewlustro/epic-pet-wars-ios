/**
 * TopAnimalsTableViewController.m
 * Copyright Miraphonic, Inc 2009. All rights reserved.
 *
 * @author Amit Matani 
 * @created 3/10/09.
 */

#import "TopAnimalsTableViewController.h"
#import "TopAnimalTableViewCell.h"
#import "AbstractAnimalRemoteCollectionStore.h"
#import "RDCContainerController.h"
#import "Consts.h"
#import "TopAnimalsRemoteCollection.h"
#import "BRSession.h"
#import "ProfileWebViewController.h"

@implementation TopAnimalsTableViewController

#define CELL_HEIGHT 100

- (id)init {
	NSMutableArray *dataSources = [[NSMutableArray alloc] initWithCapacity:6];
	BRSession *session = [BRSession sharedManager];
	for (NSString *toplist in session.topListValues) {
		TopAnimalsRemoteCollection *ranking = [[TopAnimalsRemoteCollection alloc] initWithField:toplist];
		[dataSources addObject:ranking];
		[ranking release];
	}
    
    if (self = [super initWithDataSources:dataSources titles:session.topListKeys initialIndex:0]) {
        self.title = @"Top Players";
    }
    
    [dataSources release];
    
    return self;
}

- (UITableViewCell *)tableviewCellWithReuseIdentifier:(NSString *)identifier {
    return [[[TopAnimalTableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:identifier] autorelease];
}

- (void)configureCell:(UITableViewCell *)_cell forIndexPath:(NSIndexPath *)indexPath {
	TopAnimalTableViewCell *cell = (TopAnimalTableViewCell *)_cell;
    cell.rank = indexPath.row + 1;
	cell.animal = (Animal *)[dataSource objectAtIndex:indexPath.row];
}

- (void)didSelectNormalRowAtIndexPath:(NSIndexPath *)indexPath {
    [myTableView deselectRowAtIndexPath:indexPath animated:YES];
	
	Animal *animal = [dataSource objectAtIndex:indexPath.row];
	ProfileWebViewController *pwhvc = [[ProfileWebViewController alloc] initWithAnimalId:animal.animalId];
	[[containerController navigationController] pushViewController:pwhvc animated:YES];
	
	[pwhvc release];
}

- (CGFloat)getDefaultRowHeight {
    return CELL_HEIGHT;
}

- (UITableViewCellAccessoryType)tableView:(UITableView *)aTableView accessoryTypeForNormalRowWithIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellAccessoryDisclosureIndicator;    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}

/** 
 * getLoadMoreString returns the string that should be displayed
 * by the loading cell that tells the user that there are more objects 
 * available
 * @return NSString *
 */
- (NSString *)getLoadMoreString {
    return @"Load More Animals";
}

/**
 * itemTypeString returns the name of the objects that are being loaded
 * it is a helper for the getNumLoadedString
 * @return NSString *
 */
- (NSString *)itemTypeString {
    return @"Animals";
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
    [super dealloc];
}


@end
