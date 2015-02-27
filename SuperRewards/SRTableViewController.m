/*
 * Copyright 2009 Miraphonic
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 *    http://www.apache.org/licenses/LICENSE-2.0
 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#import "SuperRewards/SRTableViewController.h"
#import "SRTableViewDataSource.h"
#import "SRStatusTableViewCell.h"
#import "SROfferViewController.h"
#import "SRTableView.h"
#import "SROfferWebViewController.h"

#define FRAME_WIDTH 320
#define STATUS_TITLE @"Status/Help"
#define NUM_MODES 4

@implementation SRTableViewController
@synthesize myTableView;

- (id)initWithGameId:(NSString *)_gameId userId:(NSString *)_userId mode:(SRMode)_mode 
offersPerPage:(NSInteger)_offersPerPage {
    if (self = [super init]) {
        SRMode modes[NUM_MODES] = {SRModeAll, SRModePaid, SRModeFree, SRModeMobile};
        dataSources = [[NSMutableArray alloc] initWithCapacity:4];
        
        for (int i = 0; i < NUM_MODES; i += 1) {
            SRMode currentMode = modes[i];
            SRTableViewDataSource *temp = [[SRTableViewDataSource alloc] initWithGameId:_gameId userId:_userId mode:currentMode offersPerPage:_offersPerPage];
            [(NSMutableArray *)dataSources addObject:temp];
            
            if (_mode == currentMode) {
                dataSource = temp;
                selectedIndex = i;
            }
            
            [temp release];
        }
        
        titles = [[NSArray alloc] initWithObjects:@"All", @"Paid", @"Free", @"Mobile", STATUS_TITLE, nil];        
    }
    return self;
}

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
    UITableView *tableView = [[SRTableView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame] 
                                                          style:UITableViewStylePlain];
    self.myTableView = tableView;
    [tableView release];
    
    myTableView.delegate = self;
    myTableView.dataSource = dataSource;
    dataSource.delegate = self;
    
    self.view = myTableView;
    self.title = @"Offers";
	
    [dataSource loadNextPage];
}

- (void)loadHeader {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, FRAME_WIDTH, 40)];
    
    [tabsContainer release];
    tabsContainer = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, FRAME_WIDTH, 40)];
    
#define PADDING 5
#define BUTTON_Y_OFFSET 5
#define BUTTON_HEIGHT 30
    
    float xOffset = 10;
    float height = tabsContainer.frame.size.height;
    UIFont *font = [UIFont boldSystemFontOfSize:12];
	UIColor *unselectedColor = WEBCOLOR(0x222222FF);
	UIColor *selectedColor = [UIColor whiteColor];
	UIColor *shadowColor = [UIColor whiteColor];
	UIColor *shadowColorSelected = [UIColor blackColor];
	CGSize shadowOffset = CGSizeMake(0, -1);
    
    
    UIButton *switchButton;
    UIImage *tabBackground = [[UIImage imageNamed:@"sr_scroll_generic_button.png"] stretchableImageWithLeftCapWidth:14 topCapHeight:0];    
    for (int i = 0; i < [titles count]; i += 1) {
        switchButton = [UIButton buttonWithType:UIButtonTypeCustom];
        switchButton.font = font;
        [switchButton addTarget:self action:@selector(switchTab:) forControlEvents:UIControlEventTouchUpInside];
        if (selectedIndex == i) {
            switchButton.enabled = NO;
            selectedButton = switchButton;
        }
        
        NSString *title = [titles objectAtIndex:i];
        
        CGSize s = [title sizeWithFont:font constrainedToSize:CGSizeMake(4000, height) 
                         lineBreakMode:UILineBreakModeWordWrap];
        switchButton.frame = CGRectMake(xOffset, BUTTON_Y_OFFSET, s.width + 4 * PADDING, BUTTON_HEIGHT);
        switchButton.titleShadowOffset = shadowOffset;
        
        // unselected state
        [switchButton setTitle:title forState:UIControlStateNormal];
        [switchButton setTitleColor:unselectedColor forState:UIControlStateNormal];
        [switchButton setTitleShadowColor:shadowColor forState:UIControlStateNormal];
        // selected state
        [switchButton setTitleColor:selectedColor forState:UIControlStateDisabled];
        [switchButton setBackgroundImage:tabBackground forState:UIControlStateDisabled];
        [switchButton setTitleShadowColor:shadowColorSelected forState:UIControlStateDisabled];	
        
        xOffset += switchButton.frame.size.width + PADDING;    
        [tabsContainer addSubview:switchButton];
    }
    
#define OVERLAY_WIDTH 30
	tabsContainer.backgroundColor = WEBCOLOR(0xEEEEEEFF);
    tabsContainer.bounces = NO;
    tabsContainer.showsHorizontalScrollIndicator = NO;
    tabsContainer.contentSize = CGSizeMake(xOffset + 10, tabsContainer.frame.size.height);   
    tabsContainer.delegate = self;
    
    [headerView addSubview:tabsContainer];
    
    // the left and right overlays
    [leftScrollOverlay release];
    leftScrollOverlay = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sr_item_scroll_left_overlay.png"]];
	leftScrollOverlay.frame = CGRectMake(0, tabsContainer.frame.origin.y, OVERLAY_WIDTH, tabsContainer.frame.size.height);
	
    leftScrollOverlay.backgroundColor = [UIColor clearColor];
    [headerView addSubview:leftScrollOverlay];
    leftScrollOverlay.hidden = YES;
    
    [rightScrollOverlay release];
    rightScrollOverlay = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sr_item_scroll_right_overlay.png"]];
	rightScrollOverlay.frame = CGRectMake(FRAME_WIDTH - OVERLAY_WIDTH, tabsContainer.frame.origin.y, OVERLAY_WIDTH, tabsContainer.frame.size.height);
    rightScrollOverlay.backgroundColor = [UIColor clearColor];
    [headerView addSubview:rightScrollOverlay];
    
    if (tabsContainer.contentSize.width < tabsContainer.frame.size.width) {
        rightScrollOverlay.hidden = YES;
    }
    
    self.myTableView.tableHeaderView = headerView;
    
    [headerView release];
}    

- (void)switchTab:(UIButton *)sender {
    if ([[sender titleForState:UIControlStateNormal] isEqualToString:STATUS_TITLE] && problemsUrl != nil) {
        SROfferWebViewController *srowvc = [[SROfferWebViewController alloc] initWithUrl:problemsUrl];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:srowvc];
        nav.navigationBar.barStyle = [self navigationController].navigationBar.barStyle;
        
        [self presentModalViewController:nav animated:YES];        
        [nav release];
        [srowvc release];
        return;
    }
    
    selectedButton.enabled = YES;
    selectedButton = sender;
    selectedButton.enabled = NO;
    
    for (selectedIndex = 0; selectedIndex < [titles count] && selectedIndex < [dataSources count]; selectedIndex += 1) {
        if ([[sender titleForState:UIControlStateNormal] isEqualToString:[titles objectAtIndex:selectedIndex]]) {
            break;
        }
    }
    dataSource = [dataSources objectAtIndex:selectedIndex];
    myTableView.dataSource = dataSource;
    dataSource.delegate = self;    
  
    if (!dataSource.hasCompletedInitialLoad) {
        [dataSource loadNextPage];
    }
    [myTableView reloadData]; 
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == tabsContainer) {
        if ((scrollView.contentOffset.x == 0) != leftScrollOverlay.hidden) {
            leftScrollOverlay.hidden = !leftScrollOverlay.hidden;
        }
        
        if (((scrollView.contentSize.width - scrollView.frame.size.width) <= scrollView.contentOffset.x) !=
            rightScrollOverlay.hidden) {
            rightScrollOverlay.hidden = !rightScrollOverlay.hidden;
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}

- (void)dismissOfferDetailViewController {
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark UITableViewDelegate methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [dataSource tableView:tableView heightForRowAtIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row > 0 && indexPath.row == [dataSource.offers count]) {
        [dataSource loadNextPage];
        SRStatusTableViewCell *cell = (SRStatusTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
        cell.loading = YES;
    } else if ([dataSource.offers count] > 0) {
        SROfferViewController *srovc =         
            [self getOfferViewController:[dataSource.offers objectAtIndex:indexPath.row] currency:dataSource.currency];
        if ([self navigationController]) {
            [[self navigationController] pushViewController:srovc animated:YES];
        } else {
            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:srovc];            
            [self presentModalViewController:navigationController animated:YES];
            [navigationController release];
            
            UIBarButtonItem *cancelButton = 
            [[UIBarButtonItem alloc] initWithTitle:@"Close"
                                             style:UIBarButtonItemStylePlain
                                            target:self
                                            action:@selector(dismissOfferDetailViewController)];
            srovc.navigationItem.leftBarButtonItem = cancelButton;
            [cancelButton release];
        }
    }
}

- (SROfferViewController *)getOfferViewController:(SROffer *)offer currency:(NSString *)currency {
    SROfferViewController *srovc = [[[SROfferViewController alloc] initWithOffer:offer
                                                                   currencyName:currency] autorelease];
    return srovc;
}

#pragma mark SRDataSourceDelegate methods
- (void)offersFinishedLoadingFromDataSource:(SRDataSource *)_dataSource {
    if (dataSource != _dataSource) {
        return;
    }
    if (myTableView.tableHeaderView == nil) {
        [self loadHeader];
    }
    if (dataSource.problemsUrl != nil) {
        [problemsUrl release];
        problemsUrl = [dataSource.problemsUrl copy];
    }
    
    [myTableView reloadData];

}

- (void)dealloc {
    // walk through the datasources and nil it out
    for (dataSource in dataSources) {
        dataSource.delegate = nil;
    }
    
    [problemsUrl release];
    [dataSources release];
    [titles release];
    [myTableView release];
    [tabsContainer release];
    [leftScrollOverlay release];
    [rightScrollOverlay release];
    [super dealloc];
}


@end
