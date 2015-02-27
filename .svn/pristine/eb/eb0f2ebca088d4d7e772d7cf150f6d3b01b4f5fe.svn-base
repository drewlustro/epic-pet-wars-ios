/**
 * InviteOptionsViewController.m
 * Copyright Miraphonic, Inc 2009. All rights reserved.
 *
 * @author Amit Matani 
 * @created 2/6/09.
 */

#import "BattleRoyale.h"
#import "BRGlobal.h"
#import "FBConnect/FBConnect.h"

#import "InviteOptionsViewController.h"
#import "InviteOptionTableViewCell.h"
#import "FriendCodeViewController.h"
#import "RDCContainerController.h"
#import "InvitesTableViewController.h"
#import "AbstractRemoteDataController.h"
#import "InviteContactsViewController.h"
#import "RedeemCodeViewController.h"
#import "PosseTableViewController.h"
#import "FacebookFriendsContainerViewController.h"
#import "TreasureChestViewController.h"
#import "TwitterOAuthLinkerViewController.h"
#import "TwitterFriendInviteViewController.h"
#import "GrowPosseViewController.h"

@implementation InviteOptionsViewController
@synthesize myTableView;

/*
#define PENDING_ROW 0
//#define INVITE_CONTACTS_ROW 1
//#define FRIEND_CODE_ROW 2
#define REDEEM_CODE_ROW 3
//#define FACEBOOK_ROW 4
#define POSSE_ROW 6
#define TREASURE_ROW 7
//#define TWITTER_ROW 5
*/

#define POSSE_ROW 2
#define PENDING_ROW 1
#define GROW_POSSE_ROW 0
#define REDEEM_CODE_ROW 3
#define TREASURE_ROW 4

#define INVITE_CONTACTS_ROW 8
#define FRIEND_CODE_ROW 7
#define FACEBOOK_ROW 6
#define TWITTER_ROW 5


#define HEADER_HEIGHT 70
#define PADDING 5

- (void)initRows {
/*    _rows = [[NSMutableArray alloc] initWithCapacity:8];
    [_rows addObject:[NSNumber numberWithInt:PENDING_ROW]];
    [_rows addObject:[NSNumber numberWithInt:INVITE_CONTACTS_ROW]];
    [_rows addObject:[NSNumber numberWithInt:FRIEND_CODE_ROW]];
    [_rows addObject:[NSNumber numberWithInt:REDEEM_CODE_ROW]];
    [_rows addObject:[NSNumber numberWithInt:FACEBOOK_ROW]];
    [_rows addObject:[NSNumber numberWithInt:TWITTER_ROW]];	
    [_rows addObject:[NSNumber numberWithInt:POSSE_ROW]];
    [_rows addObject:[NSNumber numberWithInt:TREASURE_ROW]];
 */
    _rows = [[NSMutableArray alloc] initWithCapacity:5]; 
    [_rows addObject:[NSNumber numberWithInt:GROW_POSSE_ROW]];    
    [_rows addObject:[NSNumber numberWithInt:PENDING_ROW]];
    [_rows addObject:[NSNumber numberWithInt:POSSE_ROW]];
    [_rows addObject:[NSNumber numberWithInt:REDEEM_CODE_ROW]];
    [_rows addObject:[NSNumber numberWithInt:TREASURE_ROW]];    
}

- (id)init {
	if (self = [super init]) {
		self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Invite" image:[UIImage imageNamed:@"tab_bar_invite.png"] tag:4];
		self.title = @"World";

        [self initRows];
	}
	return self;
}

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
	debug_NSLog(@"loading the ardtwthc");
	UITableView *tableView = [[UITableView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame] 
														  style:UITableViewStylePlain];
	
	self.myTableView = tableView;
	[tableView release];
	
	myTableView.rowHeight = 70;
	myTableView.delegate = self;
	myTableView.dataSource = self;
	
	self.view = myTableView;
    
    [[BRRestClient sharedManager] posse_getInviteOptionHTML:self];
}

#pragma mark table associated methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_rows count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier = @"InviteOptionCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
		cell = [self tableviewCellWithReuseIdentifier:cellIdentifier];
    }
    [self configureCell:cell forIndexPath:indexPath];
    return cell;
}

/**
 * tableviewCellWithReuseIdentifier: returns a cell based on an identifier.
 * By default it will just use a normal cell, but when subclassed out
 * the implementing class can return custom UITableViewCell objects
 * based on the identifier
 * @param NSString *identifier - the identifier string
 * @return UITableViewCell * - the cell
 */
- (UITableViewCell *)tableviewCellWithReuseIdentifier:(NSString *)identifier {
    return [[[InviteOptionTableViewCell alloc] initWithFrame:CGRectMake(0, 0, 0, 0) reuseIdentifier:identifier] autorelease];
}

- (NSInteger)indexToRow:(NSInteger)index {
    if (index < [_rows count]) {
        return [[_rows objectAtIndex:index] intValue];
    }
    return -1;
}

/**
 * configureCell:forIndexPath configures the cell at the indexPath.
 * This should be subclassed out
 * @param UITableViewCell *cell - the cell to configure
 * @param NSIndexPath *indexPath - the index path that the cell will be located at
 */
- (void)configureCell:(UITableViewCell *)cell forIndexPath:(NSIndexPath *)indexPath {
    ProtagonistAnimal *protagonist = [[BRSession sharedManager] protagonistAnimal];
	switch ([self indexToRow:indexPath.row]) {
		case FRIEND_CODE_ROW:
			((InviteOptionTableViewCell *)cell).icon = [UIImage imageNamed:@"invite_option_friend_code.png"];
			((InviteOptionTableViewCell *)cell).desc = @"Add friends to your posse via their friend code; see your friend code.";
			((InviteOptionTableViewCell *)cell).name = @"Friend Code";
			break;
		case PENDING_ROW:
			((InviteOptionTableViewCell *)cell).icon = [UIImage imageNamed:@"invite_option_pending_invites.png"];
			((InviteOptionTableViewCell *)cell).desc = @"Accept invites from other players who want to join your posse.";
            if (protagonist.inviteCount > 0) {
                ((InviteOptionTableViewCell *)cell).name = 
                    [NSString stringWithFormat:@"Pending Invites (%d)", protagonist.inviteCount];                                
            } else {
                ((InviteOptionTableViewCell *)cell).name = @"Pending Invites";
            }
			
			break;
		case INVITE_CONTACTS_ROW:
			((InviteOptionTableViewCell *)cell).icon = [UIImage imageNamed:@"invite_option_invite_contacts.png"];
			((InviteOptionTableViewCell *)cell).desc = @"Use your iPhone/iPod Touch address book to invite people to your posse. Get rewarded.";
			((InviteOptionTableViewCell *)cell).name = @"Invite Contacts";
			break;		
		case REDEEM_CODE_ROW:
			((InviteOptionTableViewCell *)cell).icon = [UIImage imageNamed:@"invite_option_friend_code.png"];
			((InviteOptionTableViewCell *)cell).desc = @"Cash-in a redemption code received via e-mail.";
			((InviteOptionTableViewCell *)cell).name = @"Use Redeem Code";
			break;
		case POSSE_ROW:
			((InviteOptionTableViewCell *)cell).icon = [UIImage imageNamed:@"invite_option_my_posse.png"];
			((InviteOptionTableViewCell *)cell).desc = @"Interact with current members of your posse.";
			((InviteOptionTableViewCell *)cell).name = @"My Posse";
			break;
		case FACEBOOK_ROW:
			((InviteOptionTableViewCell *)cell).icon = [UIImage imageNamed:@"invite_option_facebook_friends.png"];
			((InviteOptionTableViewCell *)cell).desc = @"Connect to Facebook and invite your friends.";
			((InviteOptionTableViewCell *)cell).name = @"Facebook Connect";
            break;
		case TWITTER_ROW: // TODO replace with proper image
			((InviteOptionTableViewCell *)cell).icon = [UIImage imageNamed:@"invite_option_facebook_friends.png"];
			((InviteOptionTableViewCell *)cell).desc = @"Connect to Twitter and invite your followers.";
			((InviteOptionTableViewCell *)cell).name = @"Twitter";			
			break;
		case TREASURE_ROW:
			((InviteOptionTableViewCell *)cell).icon = [UIImage imageNamed:@"invite_option_treasure.png"];
			((InviteOptionTableViewCell *)cell).desc = @"Enter a treasure code to redeem exclusive items.";
			((InviteOptionTableViewCell *)cell).name = @"Treasure Codes";
			break;
		case GROW_POSSE_ROW:
			((InviteOptionTableViewCell *)cell).icon = [UIImage imageNamed:@"invite_option_twitter.png"];
			((InviteOptionTableViewCell *)cell).desc = @"Invite friends to your posse. Having more posse members makes you more powerful!";
			((InviteOptionTableViewCell *)cell).name = @"Grow Your Posse";
			break;            
		default:
			break;
	}
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

	UIViewController *pushedViewController = nil;
	UIViewController *containedViewController = nil;
    FBSession *fbSession = nil;
    
	switch ([self indexToRow:indexPath.row]) {
		case FRIEND_CODE_ROW:
			pushedViewController = [[FriendCodeViewController alloc] init];
			break;
		case PENDING_ROW:
			containedViewController = [[InvitesTableViewController alloc] init];
			pushedViewController = [[RDCContainerController alloc] initWithRemoteDataController:(AbstractRemoteDataController *)containedViewController];
            ((InvitesTableViewController *)containedViewController).inviteOptionsViewController = self;
			[((RDCContainerController *)pushedViewController).containedRDC loadInitialData:YES showLoadingOverlay:YES];
			[(RDCContainerController *)pushedViewController setViewFrame:CGRectMake(0, 0, FRAME_WIDTH, FRAME_HEIGHT_WITH_ALL_BARS)];
			break;
		case INVITE_CONTACTS_ROW:
            [self alertWithTitle:@"Invite Contacts" message:@"Can we pull up your contacts? We will never store them." delegate:self
               cancelButtonTitle:@"Cancel" otherButtonTitle:@"Yes"];
            return;
		case REDEEM_CODE_ROW:
			pushedViewController = [[RedeemCodeViewController alloc] init];
			break;
		case POSSE_ROW:
			containedViewController = [[PosseTableViewController alloc] init];
			pushedViewController = [[RDCContainerController alloc] initWithRemoteDataController:(AbstractRemoteDataController *)containedViewController];
			[(PosseTableViewController *)containedViewController loadInitialData:YES showLoadingOverlay:YES];
			[(RDCContainerController *)pushedViewController setViewFrame:CGRectMake(0, 0, FRAME_WIDTH, FRAME_HEIGHT_WITH_ALL_BARS)];
			break;
		case FACEBOOK_ROW:
            fbSession = [FBSession sessionForApplication:FB_API_KEY secret:FB_APP_SECRET delegate:self];
            if (![[BRSession sharedManager] isFacebookUser]) {
                [fbSession logout];
            }
            if (![fbSession resume]) {
                FBLoginDialog* dialog = [[[FBLoginDialog alloc] initWithSession:fbSession] autorelease];
                [dialog show];
                return;
            }
            return;
		case TWITTER_ROW:
			if (![[BRSession sharedManager] isTwitterUser]) {
				TwitterOAuthLinkerViewController *twitterLinker = [[TwitterOAuthLinkerViewController alloc] init];
				[self presentModalViewControllerWithNavigationBar:twitterLinker];
				[twitterLinker release];
				return;
			}
			pushedViewController = [[TwitterFriendInviteViewController alloc] init];
			containedViewController = nil;
			break;
		case TREASURE_ROW:
			pushedViewController = [[TreasureChestViewController alloc] init];
			break;
		case GROW_POSSE_ROW:
			pushedViewController = [[GrowPosseViewController alloc] init];
			break;
	}
	[[self navigationController] pushViewController:pushedViewController animated:YES];
	[pushedViewController release];
	[containedViewController release];
}

- (void)updateInviteCount:(NSInteger)newInviteCount {
    if (newInviteCount > 0) {
        self.tabBarItem.badgeValue = [NSString stringWithFormat:@"%d", newInviteCount];        
    } else {
        self.tabBarItem.badgeValue = nil;
    }
}


- (UITableViewCellAccessoryType)tableView:(UITableView *)aTableView accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellAccessoryDisclosureIndicator;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        InviteContactsViewController *icvc = [[InviteContactsViewController alloc] init];
        [[self navigationController] pushViewController:icvc animated:YES];
        [icvc release];
    }
}

- (void)handleSelected {}

/**
 * login is called when there is a new login
 */
- (void)handleLogin {}

/**
 * logout is called when the logout action is requested
 */
- (void)handleLogout {}

/**
 * Handle death is sent to the controllers when the user 
 * has died usually this means to lock out the screens
 */
- (void)handleDeath {}

- (void)handleRevive {}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}

- (void)showFacebookFriendAnimals {
    FacebookFriendsContainerViewController *pushedViewController = [[FacebookFriendsContainerViewController alloc] init];                
    [[self navigationController] pushViewController:pushedViewController animated:YES];
    [pushedViewController release];    
}

#pragma mark FBSessionDelegate methods
- (void)session:(FBSession*)_session didLogin:(FBUID)uid {
    if ([[BRSession sharedManager] isFacebookUser]) {
        // check to see if we have a facebook user id for the user, if so just continue
        [self showFacebookFriendAnimals];
    } else { // otherwise we need to link accounts
        [[BRAppDelegate sharedManager] showLoadingOverlayWithText:@"Linking to Facebook"];
        [[BRRestClient sharedManager] account_linkToFacebook:uid session:_session delegate:self];
    }
}

- (void)remoteMethodDidLoad:(NSString *)method responseCode:(RestResponseCode)responseCode parsedResponse:(NSDictionary *)parsedResponse {
    if ([method isEqualToString:@"posse.getInviteOptionHTML"]) {
        if (responseCode == RestResponseCodeSuccess) {
            NSString *path = [[NSBundle mainBundle] bundlePath];
            NSURL *baseURL = [NSURL fileURLWithPath:path];
            
            UIWebView *titleWebView = [[LoadingUIWebView alloc] initWithFrame:CGRectMake(0, 0, FRAME_WIDTH, 60)];
            titleWebView.backgroundColor = [UIColor clearColor];
            
            [titleWebView loadHTMLString:[parsedResponse objectForKey:@"invite_html"] baseURL:baseURL];
            
            UIView *headerView = [[UIView alloc] initWithFrame:titleWebView.frame];
            headerView.backgroundColor = [UIColor blackColor];
            [headerView addSubview:titleWebView];
            
            [titleWebView release];
            
            myTableView.tableHeaderView = headerView;
            
            [headerView release];
        }
    } else {    
        [[BRAppDelegate sharedManager] hideLoadingOverlay];        
        if (responseCode == RestResponseCodeSuccess) {
            [[BRSession sharedManager] setFacebookUserId:[parsedResponse objectForKey:@"facebook_user_id"]];
            
            [self showFacebookFriendAnimals];
        } else {
            [self alertWithTitle:@"Unable To Link" message:[parsedResponse objectForKey:@"response_message"]];
        }
    }
}

- (void)remoteMethodDidFail:(NSString *)method {
    [[BRAppDelegate sharedManager] hideLoadingOverlay];    
    [self alertWithTitle:@"Unable To Link" message:@"Unknown Error"];
}

- (void)dealloc {
    [myTableView release];	
    [super dealloc];
}


@end
