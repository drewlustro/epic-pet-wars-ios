/**
 * UserAnimalsTableViewController.m
 * Copyright Miraphonic, Inc 2009. All rights reserved.
 *
 * @author Amit Matani 
 * @created 2/10/09.
 */

#import "UserAnimalsTableViewController.h"
#import "UserAnimalsRemoteCollection.h"
#import "UserAnimalTableViewCell.h"
#import "UserAnimalsTableContainerViewController.h"
#import "Consts.h"
#import "Utility.h"
#import "ProtagonistAnimal.h"
#import "BRSession.h"

@implementation UserAnimalsTableViewController

#define CELL_HEIGHT 100


- (id)init {
	UserAnimalsRemoteCollection *uarc = [[UserAnimalsRemoteCollection alloc] init];
    if (self = [super initWithDataSource:uarc]) {
        
    }
	[uarc release];
    return self;
}


- (UITableViewCell *)tableviewCellWithReuseIdentifier:(NSString *)identifier {
    return [[[UserAnimalTableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:identifier] autorelease];
}


- (void)configureCell:(UITableViewCell *)_cell forIndexPath:(NSIndexPath *)indexPath {
	UserAnimalTableViewCell *cell = (UserAnimalTableViewCell *)_cell;
	cell.animal = [dataSource objectAtIndex:indexPath.row];
}

- (void)didSelectNormalRowAtIndexPath:(NSIndexPath *)indexPath {
	[(UserAnimalsTableContainerViewController *)containerController switchToAnimal:[dataSource objectAtIndex:indexPath.row]];
}

- (void)loadView {
    [super loadView];
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, FRAME_WIDTH, 54)];
    UIButton *newPetButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 4, 280, 46)];
	UIColor *shadowColor = WEBCOLOR(0x254500FF);
	newPetButton.showsTouchWhenHighlighted = YES;
	newPetButton.font = [UIFont boldSystemFontOfSize:14];
	newPetButton.titleShadowOffset = CGSizeMake(0, -1);	
    [newPetButton setBackgroundImage:[UIImage imageNamed:@"new_account_button.png"] forState:UIControlStateNormal];
	[newPetButton setTitleShadowColor:shadowColor forState:UIControlStateNormal];
	[newPetButton setTitleShadowColor:[UIColor clearColor] forState:UIControlStateDisabled];
    [newPetButton setTitle:@"Create New Pet" forState:UIControlStateNormal];
    [newPetButton addTarget:containerController action:@selector(newPet) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:newPetButton];
    
    self.myTableView.tableHeaderView = headerView;
    [headerView release];
    [newPetButton release];
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
 * @return NSString *
 */
- (NSString *)getLoadMoreString {
    return @"Load More Pets";
}

/**
 * itemTypeString returns the name of the objects that are being loaded
 * it is a helper for the getNumLoadedString
 * @return NSString *
 */
- (NSString *)itemTypeString {
    return @"Pets";
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCellEditingStyle style = [super tableView:tableView editingStyleForRowAtIndexPath:indexPath];
    if (style != UITableViewCellEditingStyleNone) {
        Animal *animal = (Animal *)[dataSource objectAtIndex:indexPath.row];
        if ([animal.animalId isEqualToString:[[BRSession sharedManager] protagonistAnimal].animalId]) {
            return UITableViewCellEditingStyleNone;
        }
    }
    return style;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [dataSource removeObjectAtIndex:_rowToDelete];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_rowToDelete inSection:0];
        [myTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] 
                         withRowAnimation:UITableViewRowAnimationFade];
        [self updateLoadingCellText];
    }
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle 
forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        _rowToDelete = indexPath.row;
        [self alertWithTitle:@"Delete Animal" message:@"Are you sure you want to delete? There is no undo." 
                    delegate:self
           cancelButtonTitle:@"No"
            otherButtonTitle:@"Yes"];
    }
}

- (void)dealloc {
    [super dealloc];
}




@end
