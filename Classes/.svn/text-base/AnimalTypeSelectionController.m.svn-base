/**
 * AnimalTypeSelectionController.h
 * Copyright Miraphonic, Inc 2009. All rights reserved.
 *
 * The AnimalTypeSelectionController is a subclass of AbstractRemoteDataTableController.
 * It displays all available playable animal types for the user to choose from 
 * when he is creating an account. It uses a AnimalTypeCollection as its data source
 *
 * @author Amit Matani
 * @created 1/15/09
 */

#import "AnimalTypeSelectionController.h"
#import "AnimalTypeRemoteCollection.h"
#import "AnimalTypeTableViewCell.h"
#import "AnimalType.h"
#import "BRAppDelegate.h"
#import "AnimalTypeDetailViewController.h"
#import "BRSession.h"

#define CELL_HEIGHT 100.0;

@implementation AnimalTypeSelectionController

- (id)init {
    AnimalTypeRemoteCollection *data = [[AnimalTypeRemoteCollection alloc] init];
    if (self = [super initWithDataSource:data]) {
        self.title = @"Choose Character";
    }
    [data release];
    return self;
}

- (UITableViewCell *)tableviewCellWithReuseIdentifier:(NSString *)identifier {
    return [[[AnimalTypeTableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:identifier] autorelease];
}

- (void)configureCell:(UITableViewCell *)_cell forIndexPath:(NSIndexPath *)indexPath {
    // for convenience
    AnimalTypeTableViewCell *cell = (AnimalTypeTableViewCell *)_cell;
    AnimalType *animalType = (AnimalType *) [dataSource objectAtIndex:indexPath.row];
    cell.animalType = animalType;
}

/**
 * tableView:didSelectNormalRowAtIndexPath: method creates a AnimalTypeDetailViewController
 * and sends the animaltype selected to this view controller.  Then it pushes it on top of the
 * navigation stack.
 * @param NSIndexPath *indexPath - the path of the selected item
 */
- (void)didSelectNormalRowAtIndexPath:(NSIndexPath *)indexPath {
    AnimalType *animalType = (AnimalType *) [dataSource objectAtIndex:indexPath.row];
    if (animalType.locked) {
        UIAlertView *animalLocked = 
		[[UIAlertView alloc] initWithTitle:@"Animal Locked" 
								   message:animalType.lockedReason
								  delegate:self
						 cancelButtonTitle:@"OK" 
						 otherButtonTitles:nil];
        [animalLocked show];
        [animalLocked release];        
    } else {
        AnimalTypeDetailViewController *detailVC = 
            [[AnimalTypeDetailViewController alloc] initWithAnimalType:animalType];

        [[containerController navigationController] pushViewController:detailVC animated:YES];
        
        [detailVC release];
    }        
    [myTableView deselectRowAtIndexPath:indexPath animated:YES];    

}

- (UITableViewCellAccessoryType)tableView:(UITableView *)aTableView accessoryTypeForNormalRowWithIndexPath:(NSIndexPath *)indexPath {
    AnimalType *animalType = (AnimalType *) [dataSource objectAtIndex:indexPath.row];
    if (animalType.locked) {
        return UITableViewCellAccessoryNone;        
    }
    return UITableViewCellAccessoryDetailDisclosureButton;
}

- (CGFloat)getDefaultRowHeight {
    return CELL_HEIGHT;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}


- (void)dealloc {
    debug_NSLog(@"deallocing");
    [super dealloc];
}


@end
