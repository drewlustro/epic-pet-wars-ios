/**
 * BattleItemsTableViewController.m
 * Copyright Miraphonic, Inc 2009. All rights reserved.
 *
 * @author Amit Matani 
 * @created 2/10/09.
 */

#import "BattleItemsTableViewController.h"
#import "BRSession.h"
#import "ProtagonistAnimal.h"
#import "BattleItemTableViewContainerViewController.h"
#import "BattleItemTableViewCell.h"
#import "OwnedEquipmentSet.h"
#import "Item.h"
#import "ItemRemoteCollection.h"

@implementation BattleItemsTableViewController

#define PADDING 10
#define CELL_HEIGHT 100

- (id)initWithIndexSelected:(NSInteger)index {
    OwnedEquipmentSet *_equipmentSet = [[[BRSession sharedManager] protagonistAnimal] equipment];
    FilteredRemoteCollection *useables = [[FilteredRemoteCollection alloc] initWithRemoteCollectionStore:[_equipmentSet useable] delegate:self];
    FilteredRemoteCollection *spells = [[FilteredRemoteCollection alloc] initWithRemoteCollectionStore:[_equipmentSet spell] delegate:self];    
    NSArray *dataSources = 
        [[NSArray alloc] initWithObjects:useables, spells, nil];
    
    NSArray *titles = [[NSArray alloc] initWithObjects:@"Useable Items", @"Offensive Spells", nil];
    if (self = [super initWithDataSources:dataSources titles:titles initialIndex:index]) {
        self.hideWhenNoObjects = NO;
    }
    
    [useables release];
    [spells release];
    [dataSources release];
    [titles release];
    return self;
}

- (UITableViewCell *)tableviewCellWithReuseIdentifier:(NSString *)identifier {
    return [[[BattleItemTableViewCell alloc] initWithFrame:CGRectMake(0, 0, 0, 0) reuseIdentifier:identifier] autorelease];
}

- (void)configureCell:(UITableViewCell *)_cell forIndexPath:(NSIndexPath *)indexPath {
	BattleItemTableViewCell *cell = (BattleItemTableViewCell *)_cell;
	Item *item = [dataSource objectAtIndex:indexPath.row];
	cell.item = item;
	cell.itemDelegate = (BattleItemTableViewContainerViewController *)containerController;
	
}


- (void)didSelectNormalRowAtIndexPath:(NSIndexPath *)indexPath {
    [myTableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (CGFloat)getDefaultRowHeight {
    return CELL_HEIGHT;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}

/** 
 * getLoadMoreString returns the string that should be displayed
 * by the loading cell that tells the user that there are more objects 
 * available
 * @return NSString *fa
 */
- (NSString *)getLoadMoreString {
    return @"Load More Items";
}

/**
 * itemTypeString returns the name of the objects that are being loaded
 * it is a helper for the getNumLoadedString
 * @return NSString *
 */
- (NSString *)itemTypeString {
    return @"Items";
}

- (void)dealloc {
    [super dealloc];
}

#pragma mark FilteredRemoteCollectionDelegate methods

- (BOOL)shouldIncludeObject:(id)object {
    Item *item = (Item *)object;
    ProtagonistAnimal *protag = [[BRSession sharedManager] protagonistAnimal];
    return item.isUseableInBattle && [item.requiresLevel intValue] <= protag.level;
}

@end
