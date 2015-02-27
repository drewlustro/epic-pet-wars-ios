/**
 * NewsFeedViewController.h
 * Copyright Miraphonic, Inc 2009. All rights reserved.
 *
 * NewsFeedViewController shows the items in the user's newsfeed.  It
 * also has the HomeActionViewController as its table header view.
 * It is shown on the home screen
 *
 * @author Amit Matani
 * @created 1/19/09
 */

#import "NewsFeedViewController.h"
#import "NewsFeedRemoteCollection.h"
#import "HomeActionViewController.h"
#import "NewsFeedItemTableViewCell.h"
#import "NewsfeedItem.h"
#import "ProfileWebViewController.h"
#import "RDCContainerController.h"
#import "Consts.h"
#import "BRRestClient.h"
#import "LoadingUIWebViewWithLocalRequest.h"
#import "BRAppDelegate.h"
#import "BRTabManager.h"
#import "BRStoreKitPaymentManager.h"

@implementation NewsFeedViewController
@synthesize actionViewController, homeController;

- (id)init {
    NewsFeedRemoteCollection *data = [[NewsFeedRemoteCollection alloc] init];
    if (self = [super initWithDataSource:data]) {
        HomeActionViewController *havc = [[HomeActionViewController alloc] init];
        self.actionViewController = havc;
        [havc release];
    }
    [data release];
    return self;
}

- (UITableViewCell *)tableviewCellWithReuseIdentifier:(NSString *)identifier {
    return [[[NewsFeedItemTableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:identifier] autorelease];
}

- (void)configureCell:(UITableViewCell *)_cell forIndexPath:(NSIndexPath *)indexPath {
	NewsFeedItemTableViewCell *cell = (NewsFeedItemTableViewCell *)_cell;
	cell.newsfeedItem = [dataSource objectAtIndex:indexPath.row];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return [NewsFeedItemTableViewCell getCellHeightForNewsfeedItem:[dataSource objectAtIndex:indexPath.row]];
}

- (void)didSelectNormalRowAtIndexPath:(NSIndexPath *)indexPath {
    [myTableView deselectRowAtIndexPath:indexPath animated:YES];
	
	NewsfeedItem *ni = [dataSource objectAtIndex:indexPath.row];
    if (![ni hasAnimalActor]) { 
		return;
	}
	
	NSString *animalId = ni.actorAnimalId;
	
	ProfileWebViewController *pwhvc = [[ProfileWebViewController alloc] initWithAnimalId:animalId];
//	RDCContainerController *container = [[RDCContainerController alloc] initWithRemoteDataController:pwhvc];
	[[self.homeController navigationController] pushViewController:pwhvc animated:YES];
	
//	[container setViewFrame:CGRectMake(0, 0, FRAME_WIDTH, FRAME_HEIGHT_WITH_ALL_BARS)];
//	[pwhvc loadInitialData:NO showLoadingOverlay:NO];
	
	[pwhvc release];
///	[container release];
}

- (UITableViewCellAccessoryType)tableView:(UITableView *)aTableView accessoryTypeForNormalRowWithIndexPath:(NSIndexPath *)indexPath {
	NewsfeedItem *ni = [dataSource objectAtIndex:indexPath.row];
    if ([ni hasAnimalActor]) { 
		return UITableViewCellAccessoryDisclosureIndicator;
	} else {
		return UITableViewCellAccessoryNone;
	}
}

- (void)addNewsFeedItemToTop:(NewsfeedItem *)ni {
	BOOL inserted = [dataSource insertObject:ni atIndex:0];
    if (inserted) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];    
        [myTableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] 
                        withRowAnimation:UITableViewRowAnimationFade];
        [myTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    }
}

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
    debug_NSLog(@"load view");
    [super loadView];
    [offerView release];
    offerView = [[LoadingUIWebViewWithLocalRequest alloc] initWithFrame:CGRectMake(0, 0, FRAME_WIDTH, 100)];
    UIView *headerView = 
        [[UIView alloc] initWithFrame:CGRectMake(0, 0, FRAME_WIDTH, 
                                                 actionViewController.view.frame.size.height)];
    [headerView addSubview:actionViewController.view];
    myTableView.tableHeaderView = headerView;
    [headerView release];
    
    [self performSelector:@selector(getOffers) withObject:nil afterDelay:0];
}

- (void)getOffers {
    [[BRRestClient sharedManager] account_getOfferHtml:self 
                                      finishedSelector:@selector(offerLoaded:parsedResponse:) 
                                        failedSelector:@selector(offerLoadingFailed)];    
}

- (void)offerLoaded:(NSNumber *)responseInt parsedResponse:(NSDictionary *)parsedResponse {
    if ([BRRestClient isResponseSuccessful:responseInt]) {
        [offerView loadHTMLString:[parsedResponse objectForKey:@"offer_html"] baseURL:[NSURL URLWithString:@""]];
        offerView.localDelegate = self;
		//  UIButton *closeButton = [[UIButton alloc] initWithFrame:CGRectMake(290, 2, 30, 30)];
		//  [closeButton setBackgroundImage:[UIImage imageNamed:@"webview_x_button.png"] forState:UIControlStateNormal];
		//  [closeButton addTarget:self action:@selector(removeOffer) forControlEvents:UIControlEventTouchUpInside];
		//  [offerView addSubview:closeButton];
        
        UIView *headerView = [myTableView.tableHeaderView retain];
        myTableView.tableHeaderView = nil;
        headerView.frame = CGRectMake(0, 0, FRAME_WIDTH, 
                                      headerView.frame.size.height + 
                                      offerView.frame.size.height);
        actionViewController.view.frame = CGRectMake(0, offerView.frame.size.height, 
                                                     actionViewController.view.frame.size.width, 
                                                     actionViewController.view.frame.size.height);
        [headerView addSubview:offerView];
        myTableView.tableHeaderView = headerView;
        [headerView release];
    } else {
        [self offerLoadingFailed];
    }

}

- (void)removeOffer {
    [offerView removeFromSuperview];
    UIView *headerView = [myTableView.tableHeaderView retain];
    myTableView.tableHeaderView = nil;
    headerView.frame = CGRectMake(0, 0, FRAME_WIDTH, actionViewController.view.frame.size.height);
    actionViewController.view.frame = CGRectMake(0, 0,
                                                 actionViewController.view.frame.size.width, 
                                                 actionViewController.view.frame.size.height);
    myTableView.tableHeaderView = headerView;
    [headerView release];    
    [[BRRestClient sharedManager] account_offerRemoved];
}


- (void)webView:(LoadingUIWebViewWithLocalRequest *)webView handleLocalMethod:(NSString *)method params:(NSDictionary *)params {
    if ([method isEqualToString:@"showBattleMaster"]) {
		
		if (params) {
			NSString* product_id = [Utility stringIfNotEmpty:[params objectForKey:@"product_id"]];			
			if (product_id != nil && [BRStoreKitPaymentManager sharedManager].promoProduct == nil) {
				[BRStoreKitPaymentManager sharedManager].promoProduct = product_id;
			}
		}
        [[[BRAppDelegate sharedManager] tabManager] showBattleMaster];
    } else if ([method isEqualToString:@"closePromo"]) {
		[self removeOffer];
	}
}

- (void)offerLoadingFailed {
    
}



/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}


- (void)dealloc {
    [actionViewController cleanup];
    [actionViewController release];
    offerView.localDelegate = nil;
    offerView.delegate = nil;
    [offerView release];
    [homeController release];
    [super dealloc];
}


@end
