/**
 * InvitesTableViewController.m
 * Copyright Miraphonic, Inc 2009. All rights reserved.
 *
 * @author Amit Matani 
 * @created 2/7/09.
 */

#import "InvitesTableViewController.h"
#import "InviteRemoteCollection.h"
#import "Invite.h"
#import "BRSession.h"
#import "InviteTableViewCell.h"
#import "BRRestClient.h"
#import "BRAppDelegate.h"
#import "ProtagonistAnimal.h"
#import "Animal.h"
#import "PosseAnimalRemoteCollection.h"
#import "InviteOptionsViewController.h"

@implementation InvitesTableViewController

@synthesize inviteOptionsViewController;

#define CELL_HEIGHT 100


- (id)init {
    if (self = [super initWithDataSource:[[BRSession sharedManager] pendingInvites]]) {
        self.title = @"Pending Invites";
    }
    return self;
}

- (UITableViewCell *)tableviewCellWithReuseIdentifier:(NSString *)identifier {
    return [[[InviteTableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:identifier] autorelease];
}


- (void)configureCell:(UITableViewCell *)_cell forIndexPath:(NSIndexPath *)indexPath {
    InviteTableViewCell *cell = (InviteTableViewCell *)_cell;
    cell.invite = (Invite *) [dataSource objectAtIndex:indexPath.row];
	cell.inviteDelegate = self;
}

- (void)didSelectNormalRowAtIndexPath:(NSIndexPath *)indexPath {
    [myTableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (CGFloat)getDefaultRowHeight {
    return CELL_HEIGHT;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}

- (void)acceptInvite:(Invite *)invite {
	[[BRRestClient sharedManager] posse_acceptInvite:invite.inviterUid target:self 
									finishedSelector:@selector(finishedAccepting:parsedResponse:) 
									  failedSelector:@selector(failedAccepting)];
	[[BRAppDelegate sharedManager] showLoadingOverlayWithText:@"Accepting"];
	[currentInvite release];
	currentInvite = [invite retain];
}

- (void)finishedAccepting:(NSNumber *)responseInt parsedResponse:(NSDictionary *)parsedResponse {
	if ([BRRestClient isResponseSuccessful:responseInt]) {
		[[BRAppDelegate sharedManager] hideLoadingOverlay];
		ProtagonistAnimal *protag = [[BRSession sharedManager] protagonistAnimal];
		Animal *animal = [[Animal alloc] initWithApiResponse:[parsedResponse objectForKey:@"posse_animal"]];
		
		[protag addAnimalToPosse:animal];
		
		[animal release];
		
		NSInteger index = [dataSource indexOfObject:currentInvite];
        [dataSource removeObjectAtIndex:index];
        [myTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:index inSection:0]] 
						 withRowAnimation:UITableViewRowAnimationLeft];
        protag.inviteCount -= 1;		
        [inviteOptionsViewController.myTableView reloadData];        
	} else {
		[self failedAccepting];
	}
}

- (void)failedAccepting {
	[[BRAppDelegate sharedManager] hideLoadingOverlay];	
}

- (void)rejectInvite:(Invite *)invite {
	[[BRRestClient sharedManager] posse_rejectInvite:invite target:self 
									finishedSelector:@selector(finishedRejecting:parsedResponse:) 
									  failedSelector:@selector(failedRejecting)];
	[[BRAppDelegate sharedManager] showLoadingOverlayWithText:@"Rejecting"];	
	[currentInvite release];
	currentInvite = [invite retain];		
}

- (void)finishedRejecting:(NSNumber *)responseInt parsedResponse:(NSDictionary *)parsedResponse {
	if ([BRRestClient isResponseSuccessful:responseInt]) {
		[[BRAppDelegate sharedManager] hideLoadingOverlay];
		NSInteger index = [dataSource indexOfObject:currentInvite];
        [dataSource removeObjectAtIndex:index];
        [myTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:index inSection:0]] 
						   withRowAnimation:UITableViewRowAnimationLeft];	
		ProtagonistAnimal *protag = [[BRSession sharedManager] protagonistAnimal];        
        protag.inviteCount -= 1;
        [inviteOptionsViewController.myTableView reloadData];        
	} else {
		[self failedRejecting];
	}	
}

- (void)failedRejecting {
	[[BRAppDelegate sharedManager] hideLoadingOverlay];		
}

/** 
 * getLoadMoreString returns the string that should be displayed
 * by the loading cell that tells the user that there are more objects 
 * available
 * @return NSString *
 */
- (NSString *)getLoadMoreString {
    return @"Load More Invites";
}

/**
 * itemTypeString returns the name of the objects that are being loaded
 * it is a helper for the getNumLoadedString
 * @return NSString *
 */
- (NSString *)itemTypeString {
    return @"Invites";
}

/**
 * noneAvailableString returns the string to display when there are no
 * objects in the remote collection
 * @return NSString *
 */
- (NSString *)noneAvailableString {
    return @"No Pending Invites.  Grow your posse by inviting people!";
}

- (void)dealloc {
	[currentInvite release];
    [super dealloc];
}


@end
