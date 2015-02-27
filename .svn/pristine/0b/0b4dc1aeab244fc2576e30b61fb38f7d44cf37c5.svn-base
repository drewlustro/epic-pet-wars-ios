/**
 * EarnedAchievementsTableViewController.m
 * Copyright Miraphonic, Inc 2009. All rights reserved.
 *
 * @author Amit Matani 
 * @created 2/5/09.
 */

#import "EarnedAchievementsTableViewController.h"
#import "EarnedAchievementRemoteCollection.h"
#import "ProtagonistAnimal.h"
#import "BRSession.h"
#import "AchievementTableViewCell.h"

@implementation EarnedAchievementsTableViewController

- (UITableViewCell *)tableviewCellWithReuseIdentifier:(NSString *)identifier {
    return [[[AchievementTableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:identifier] autorelease];
}

- (void)configureCell:(UITableViewCell *)_cell forIndexPath:(NSIndexPath *)indexPath {
    AchievementTableViewCell *cell = (AchievementTableViewCell *)_cell;
    cell.achievement = (Achievement *) [dataSource objectAtIndex:indexPath.row];	
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

- (CGFloat)getDefaultRowHeight {
    return 100;
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
    return @"Load More Achievements";
}

/**
 * itemTypeString returns the name of the objects that are being loaded
 * it is a helper for the getNumLoadedString
 * @return NSString *
 */
- (NSString *)itemTypeString {
    return @"Achievements";
}

/**
 * noneAvailableString returns the string to display when there are no
 * objects in the remote collection
 * @return NSString *
 */
- (NSString *)noneAvailableString {
    return @"You have not been awarded any achievements yet. You must battle and do more jobs to earn recognition!";
}


- (void)dealloc {
    [super dealloc];
}


@end
