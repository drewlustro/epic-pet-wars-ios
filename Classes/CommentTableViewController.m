/**
 * CommentTableViewController.m
 * Copyright Miraphonic, Inc 2009. All rights reserved.
 *
 * @author Amit Matani 
 * @created 2/13/09.
 */

#import "CommentTableViewController.h"
#import "CommentTableViewCell.h"
#import "Post.h"
#import "RDCContainerController.h"
#import "Consts.h"
#import "Utility.h"
#import "CommentTableViewContainerController.h"
#import "BRSession.h"
#import "Animal.h"
#import "ProfileWebViewController.h"

@implementation CommentTableViewController

#define CELL_HEIGHT 100
#define BULLETIN_INDEX 1
#define COMMENT_INDEX 0

/*
- (id)init {
    if (self = [super initWithDataSource:]) {
        
    }
    return self;
}

*/
- (UITableViewCell *)tableviewCellWithReuseIdentifier:(NSString *)identifier {
    return [[[CommentTableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:identifier] autorelease];
}


- (void)configureCell:(UITableViewCell *)_cell forIndexPath:(NSIndexPath *)indexPath {
	CommentTableViewCell *cell = (CommentTableViewCell *)_cell;
	cell.post = [dataSource objectAtIndex:indexPath.row];
}

- (CGFloat)getDefaultRowHeight {
    return CELL_HEIGHT;
}

- (CGFloat)tableView:(UITableView *)tableView heightForNormalRowAtIndexPath:(NSIndexPath *)indexPath {
	return [CommentTableViewCell getCellHeightForPost:[dataSource objectAtIndex:indexPath.row]];
}

- (void)didSelectNormalRowAtIndexPath:(NSIndexPath *)indexPath {
    [myTableView deselectRowAtIndexPath:indexPath animated:YES];
	
	Post *comment = [dataSource objectAtIndex:indexPath.row];
	NSString *animalId = comment.senderAnimalId;
	
	ProfileWebViewController *pwhvc = [[ProfileWebViewController alloc] initWithAnimalId:animalId];
	[[self.containerController navigationController] pushViewController:pwhvc animated:YES];
	
//	[container setViewFrame:CGRectMake(0, 0, FRAME_WIDTH, self.view.frame.size.height)];
	
	[pwhvc release];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *userId = ((CommentTableViewContainerController *)self.containerController).userId;
    if (![userId isEqualToString:[[BRSession sharedManager] userId]] ||
        _selectedIndex == 1) { // do not show on bulletins
        return UITableViewCellEditingStyleNone;
    }
    return [super tableView:tableView editingStyleForRowAtIndexPath:indexPath];
}

- (UITableViewCellAccessoryType)tableView:(UITableView *)aTableView accessoryTypeForNormalRowWithIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellAccessoryDisclosureIndicator;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}

- (UIView *)customHeaderView {
    UIView *headerView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, FRAME_WIDTH, 54)] autorelease];
    [postCommentButton release];
    postCommentButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 4, 280, 46)];
	UIColor *shadowColor = WEBCOLOR(0x254500FF);
	postCommentButton.showsTouchWhenHighlighted = YES;
	postCommentButton.font = [UIFont boldSystemFontOfSize:14];
	postCommentButton.titleShadowOffset = CGSizeMake(0, -1);	
    [postCommentButton setBackgroundImage:[UIImage imageNamed:@"new_account_button.png"] forState:UIControlStateNormal];
	[postCommentButton setTitleShadowColor:shadowColor forState:UIControlStateNormal];
	[postCommentButton setTitleShadowColor:[UIColor clearColor] forState:UIControlStateDisabled];
    [postCommentButton setTitle:@"Post Comment" forState:UIControlStateNormal];
    [postCommentButton addTarget:containerController action:@selector(newComment) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:postCommentButton];
    
    return headerView;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [dataSource removeObjectAtIndex:indexPath.row];
        _hideNoObjectRow = YES; // we need to make sure that if its 0, we show 0
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self updateLoadingCellText];                   
    }
}

#pragma mark AbstractRemoteDataTableControllerWithTabs
- (void)scrollableTabBar:(ScrollableTabBar *)scrollableTabBar didSelectIndex:(NSInteger)index {
    [super scrollableTabBar:scrollableTabBar didSelectIndex:index];
    postCommentButton.enabled = 
        self.containerController.navigationItem.rightBarButtonItem.enabled =  
            _selectedIndex == COMMENT_INDEX;
}

/** 
 * getLoadMoreString returns the string that should be displayed
 * by the loading cell that tells the user that there are more objects 
 * available
 * @return NSString *
 */
- (NSString *)getLoadMoreString {
    if (_selectedIndex == BULLETIN_INDEX) {    
        return @"Load More Bulletins";        
    }
    return @"Load More Comments";
}

/**
 * itemTypeString returns the name of the objects that are being loaded
 * it is a helper for the getNumLoadedString
 * @return NSString *
 */
- (NSString *)itemTypeString {
    if (_selectedIndex == BULLETIN_INDEX) {
        return @"Bulletins";        
    }
    return @"Comments";
}

/**
 * noneAvailableString returns the string to display when there are no
 * objects in the remote collection
 * @return NSString *
 */
- (NSString *)noneAvailableString {
    if (_selectedIndex == BULLETIN_INDEX) {
        return @"No bulletins yet";        
    }
    return @"No comments yet.  Why not post one?";
}


- (void)dealloc {
    [postCommentButton release];
    [super dealloc];
}


@end
