//
//  AchievementTableViewController.m
//  battleroyale
//
//  Created by Amit Matani on 4/19/09.
//  Copyright 2009 Miraphonic, Inc. All rights reserved.
//

#import "AchievementTableViewController.h"
#import "AchievementTableViewCell.h"
#import "BattleRoyale.h"

@implementation AchievementTableViewController


- (id)init {
    NSArray *dataSources = 
        [[NSArray alloc] initWithObjects:[[[BRSession sharedManager] protagonistAnimal] earnedAchievements], 
                                         [[BRSession sharedManager] availableAchievements], nil];
    
    NSArray *titles = [[NSArray alloc] initWithObjects:@"Earned Achievements", @"All Achievements", nil];
    if (self = [super initWithDataSources:dataSources titles:titles initialIndex:0]) {
        self.hideWhenNoObjects = NO;
        self.title = @"Achievements";
    }
    
    [dataSources release];
    [titles release];
    return self;
}

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
    if (_selectedIndex == 0) {
        return @"No achievements earned yet.";        
    }
    return @"Acheivments are currently unavailable.";
}


/**
 * noneAvailableString returns the string to display when there are no
 * objects in the remote collection
 * @return NSString *
 */
//- (NSString *)noneAvailableString {
//    return @"You have not been awarded any achievements yet. You must battle and do more jobs to earn recognition!";
//}


- (void)dealloc {
    debug_NSLog(@"deallocing");
    [super dealloc];
}


@end
