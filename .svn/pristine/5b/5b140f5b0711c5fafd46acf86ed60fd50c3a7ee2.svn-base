/**
 * PosseTableViewController.m
 * Copyright Miraphonic, Inc 2009. All rights reserved.
 *
 * @author Amit Matani 
 * @created 2/9/09.
 */

#import "PosseTableViewController.h"
#import "ProtagonistAnimal.h"
#import "BRSession.h"
#import "PosseAnimalTableViewCell.h"
#import "Animal.h"
#import "RDCContainerController.h"
#import "Consts.h"
#import "NewMassCommentViewController.h"
#import "Utility.h"
#import "ProfileWebViewController.h"

@implementation PosseTableViewController

#define CELL_HEIGHT 100


- (id)init {
    if (self = [super initWithDataSource:(id)[[[BRSession sharedManager] protagonistAnimal] posse]]) {
        self.title = @"Posse";
    }
    return self;
}


- (UITableViewCell *)tableviewCellWithReuseIdentifier:(NSString *)identifier {
    return [[[PosseAnimalTableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:identifier] autorelease];
}

- (void)setEditButton {
    UIBarButtonItem *rightButton;
    if (!myTableView.editing) {
        rightButton = [[UIBarButtonItem alloc] initWithTitle:@"Edit Posse" 
                                                       style:UIBarButtonItemStyleBordered
                                                      target:self 
                                                      action:@selector(toggleEditing)];
        
    } else {
        rightButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" 
                                                       style:UIBarButtonItemStyleDone
                                                      target:self 
                                                      action:@selector(toggleEditing)];        
    }
    self.containerController.navigationItem.rightBarButtonItem = rightButton;       
}

- (void)toggleEditing {
    myTableView.editing = !myTableView.editing;

    [self setEditButton];
}

- (void)loadView {
    [super loadView];
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, FRAME_WIDTH, 54)];
    UIButton *postMassCommentButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 4, 280, 46)];
	UIColor *shadowColor = WEBCOLOR(0x254500FF);
	postMassCommentButton.showsTouchWhenHighlighted = YES;
	postMassCommentButton.font = [UIFont boldSystemFontOfSize:14];
	postMassCommentButton.titleShadowOffset = CGSizeMake(0, -1);	
    [postMassCommentButton setBackgroundImage:[UIImage imageNamed:@"new_account_button.png"] forState:UIControlStateNormal];
	[postMassCommentButton setTitleShadowColor:shadowColor forState:UIControlStateNormal];
	[postMassCommentButton setTitleShadowColor:[UIColor clearColor] forState:UIControlStateDisabled];
    [postMassCommentButton setTitle:@"Send Bulletin to Posse" forState:UIControlStateNormal];
    [postMassCommentButton addTarget:self action:@selector(postMassComment) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:postMassCommentButton];
    
    self.myTableView.tableHeaderView = headerView;
    [headerView release];
    [postMassCommentButton release];
    
    [self setEditButton];
}

- (void)postMassComment {
	NewMassCommentViewController *ncvc = [[NewMassCommentViewController alloc] init];
	UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:ncvc];    
	[[containerController navigationController] presentModalViewController:nav animated:YES];
	[ncvc release];
    [nav release];
}

- (void)configureCell:(UITableViewCell *)_cell forIndexPath:(NSIndexPath *)indexPath {
	PosseAnimalTableViewCell *cell = (PosseAnimalTableViewCell *)_cell;
	cell.animal = (Animal *)[dataSource objectAtIndex:indexPath.row];
}

- (void)didSelectNormalRowAtIndexPath:(NSIndexPath *)indexPath {
    [myTableView deselectRowAtIndexPath:indexPath animated:YES];
	
	Animal *animal = [dataSource objectAtIndex:indexPath.row];
	ProfileWebViewController *pwhvc = [[ProfileWebViewController alloc] initWithAnimalId:animal.animalId];
	[[self.containerController navigationController] pushViewController:pwhvc animated:YES];

	
	[pwhvc release];
}
    
    
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [dataSource removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self updateLoadingCellText];
    }
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
    return @"No posse members yet.\nMake your pet stronger by inviting people to your posse!";
}


- (void)dealloc {
    [super dealloc];
}


@end
