/**
 * FacebookFriendsTableViewController.m
 * Copyright Miraphonic, Inc 2009. All rights reserved.
 *
 * @author Amit Matani 
 * @created 2/12/09.
 */

#import "FacebookFriendsTableViewController.h"
#import "BRSession.h"
#import "FacebookFriendTableViewCell.h"
#import "BRAppDelegate.h"
#import "BRRestClient.h"
#import "FacebookUser.h"
#import "Animal.h"
#import "ProtagonistAnimal.h"
#import "ActionResult.h"
#import "BRRestOperation.h"
#import "FacebookBroadcastViewController.h"

@implementation FacebookFriendsTableViewController

#define CELL_HEIGHT 100


- (id)init {
    if (self = [super initWithDataSource:(AbstractRemoteCollectionStore *)[[BRSession sharedManager] facebookFriends]]) {
        self.hideWhenNoObjects = NO;
    }
    return self;
}

- (void)loadView {
	[super loadView];
	_loadHeaderOperation = [[[BRRestClient sharedManager] callRemoteMethod:@"posse.getFacebookContactsHeader" params:nil nonRetainedDelegate:self] retain];
}

- (void)getHeader {

}

- (UITableViewCell *)tableviewCellWithReuseIdentifier:(NSString *)identifier {
    return [[[FacebookFriendTableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:identifier] autorelease];
}


- (void)configureCell:(UITableViewCell *)_cell forIndexPath:(NSIndexPath *)indexPath {
	FacebookFriendTableViewCell *cell = (FacebookFriendTableViewCell *)_cell;
	cell.facebookUser = [dataSource objectAtIndex:indexPath.row];
	cell.facebookDelegate = self;
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

- (void)handleInviteAction:(FacebookUser *)facebookUser {
	[currentUser release];
	currentUser = [facebookUser retain];
	if (facebookUser.inviteReceived) {
		// accept invite
		[[BRAppDelegate sharedManager] showLoadingOverlayWithText:@"Accepting Invite"];	
		[[BRRestClient sharedManager] posse_acceptInvite:facebookUser.animal.userId 
												  target:self 
										finishedSelector:@selector(finishedAcceptingInvite:parsedResponse:) 
										  failedSelector:@selector(failedAcceptingInvite)];
	} else if (!facebookUser.inPosse && !facebookUser.inviteSent) {
		// send invite
		[[BRAppDelegate sharedManager] showLoadingOverlayWithText:@"Inviting"];
		[[BRRestClient sharedManager] posse_inviteUserWithUserId:facebookUser.animal.userId 
														  target:self 
												finishedSelector:@selector(finishedSendingInvite:parsedResponse:) 
												  failedSelector:@selector(failedSendingInvite)];		
	}
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (![dataSource completedInitialLoad] || ([dataSource getNumObjectsLoaded] <= 0)) {
        return 1;
    }
    return [super tableView:tableView numberOfRowsInSection:section];
}

- (void)finishedSendingInvite:(NSNumber *)responseInt parsedResponse:(NSDictionary *)parsedResponse {
	if ([BRRestClient isResponseSuccessful:responseInt]) {
		[[BRAppDelegate sharedManager] hideLoadingOverlay];
		currentUser.inviteSent = YES;
		
		[self softReload];
	} else {
		[self failedSendingInvite];
	}
}

- (void)failedSendingInvite {
	[[BRAppDelegate sharedManager] hideLoadingOverlay];	
}

- (void)finishedAcceptingInvite:(NSNumber *)responseInt parsedResponse:(NSDictionary *)parsedResponse {
	if ([BRRestClient isResponseSuccessful:responseInt]) {
		[[BRAppDelegate sharedManager] hideLoadingOverlay];
		currentUser.inviteReceived = NO;
		currentUser.inPosse = YES;
		
		[[[BRSession sharedManager] protagonistAnimal] addAnimalToPosse:currentUser.animal];
		
		[self softReload];		
	} else {
		[self failedAcceptingInvite];
	}	
}

- (void)failedAcceptingInvite {
	[[BRAppDelegate sharedManager] hideLoadingOverlay];	
}


- (void)dealloc {
	[_loadHeaderOperation cancel];
	[_loadHeaderOperation release];
	[_facebookBroadcastController release];
	[currentUser release];	
    [super dealloc];
}

#pragma mark RestResponseDelegate


- (void)remoteMethodDidLoad:(NSString *)method responseCode:(RestResponseCode)responseCode parsedResponse:(NSDictionary *)parsedResponse {

    if ([method isEqualToString:@"posse.getFacebookContactsHeader"]) {
        if (responseCode == RestResponseCodeSuccess) {
            CGFloat height = [(NSString *)[parsedResponse objectForKey:@"height"] floatValue];
			
			_facebookBroadcastController = [[FacebookBroadcastViewController alloc] initWithHTML:[parsedResponse objectForKey:@"html"]];
			_facebookBroadcastController.view.frame = CGRectMake(0, 0, FRAME_WIDTH, height);

            self.myTableView.tableHeaderView = _facebookBroadcastController.view;
        }
    }
}

- (void)remoteMethodDidFail:(NSString *)method {

}

@end
