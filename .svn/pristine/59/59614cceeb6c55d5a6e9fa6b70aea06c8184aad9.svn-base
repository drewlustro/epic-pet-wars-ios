/**
 * ItemTableViewController.m
 * Copyright Miraphonic, Inc 2009. All rights reserved.
 *
 * @author Amit Matani 
 * @created 3/22/09.
 */

#import "ItemTableViewController.h"
#import "ItemTableViewCell.h"
#import "Item.h"
#import "Consts.h"
#import "TableViewWithInnerScrollView.h"
#import "EquipmentSet.h"
#import "AbstractRemoteCollectionStore.h"
#import "ItemDetailViewController.h"
#import "SingleUseItemDetailViewController.h"
#import "DoubleEquipItemDetailViewController.h"
#import "BackgroundItemDetailViewController.h"
#import "SingleEquipItemDetailViewController.h"
#import "InvestmentItemDetailViewController.h"
#import "SpellItemDetailViewController.h"
#import "ItemRemoteCollection.h"
#import "Utility.h"
#import "LoadingUIWebView.h"

#import "SingleEquipItemDetailWebViewController.h"
#import "SingleUseItemDetailWebViewController.h"
#import "DoubleEquipItemDetailWebViewController.h"

#import "ItemDetailWebViewController.h"

#import "MutableEquipmentSet.h"

@implementation ItemTableViewController
@synthesize itemTableContainerController;

#define CELL_HEIGHT 100


- (id)initWithEquipmentSet:(MutableEquipmentSet *)_equipmentSet withInitialSource:(ItemRemoteCollection *)initialDataSource {
    
//    NSArray *titles = [[NSArray alloc] initWithObjects:@"Useable", @"Weapons", @"Armor", @"Accessories", @"Spells", @"Investments", @"Backgrounds", nil];
    if (self = [super initWithDataSources:_equipmentSet.collections titles:_equipmentSet.categoryNames initialIndex:0]) {
        self.hideWhenNoObjects = NO;
    }

    return self;
}


- (void)configureCell:(UITableViewCell *)_cell forIndexPath:(NSIndexPath *)indexPath {
    ItemTableViewCell *cell = (ItemTableViewCell *)_cell;
    Item *item = (Item *) [dataSource objectAtIndex:indexPath.row];
    cell.item = item;
}

- (void)didSelectNormalRowAtIndexPath:(NSIndexPath *)indexPath {
    [myTableView deselectRowAtIndexPath:indexPath animated:YES];
    Item *item = (Item *) [dataSource objectAtIndex:indexPath.row];
    ItemDetailWebViewController *itemDetailController;
	
	if ([item.categoryKey isEqualToString:@"weapon"] || [item.categoryKey isEqualToString:@"armor"] || [item.categoryKey isEqualToString:@"background"]) {
		itemDetailController = [[SingleEquipItemDetailWebViewController alloc] initWithItem:item htmlTemplate:[[dataSource extraData] objectForKey:@"detail_template"]];		
	} else if ([item.categoryKey isEqualToString:@"accessory"]) {
		itemDetailController = [[DoubleEquipItemDetailWebViewController alloc] initWithItem:item htmlTemplate:[[dataSource extraData] objectForKey:@"detail_template"]];
    } else if ([item.categoryKey isEqualToString:@"useable"]) {
		itemDetailController = [[SingleUseItemDetailWebViewController alloc] initWithItem:item htmlTemplate:[[dataSource extraData] objectForKey:@"detail_template"]];
    } else {
		itemDetailController = [[ItemDetailWebViewController alloc] initWithItem:item htmlTemplate:[[dataSource extraData] objectForKey:@"detail_template"]];
    }
	
	itemDetailController.title = [_titles objectAtIndex:_selectedIndex];
	itemDetailController.containerTable = self;
    [[itemTableContainerController navigationController] pushViewController:itemDetailController animated:YES];    
    [itemDetailController release];    
}


- (CGFloat)getDefaultRowHeight {
    return CELL_HEIGHT;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}

- (void)showHeaderData {
    NSString *htmlString = nil;
    if ([dataSource extraData] != nil && [[dataSource extraData] objectForKey:@"explanation"]) {
        htmlString  = [[dataSource extraData] objectForKey:@"explanation"];
    } else {
        htmlString = @"<html>\
        <body style=\"padding:5px;background-color:#000000;margin:0px;text-align:center;font-family:helvetica;background-image:url(job_table_header_bg.png);background-repeat:no-repeat;background-position:bottom center\">\
        </body>\
        </html>";        
    }
    
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSURL *baseURL = [NSURL fileURLWithPath:path];    
    [_headerWebView loadHTMLString:htmlString baseURL:baseURL];    
}

- (UIView *)customHeaderView {
#define EXPLANATION_HEIGHT 60
    UIView *headerView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, FRAME_WIDTH, EXPLANATION_HEIGHT)] autorelease];

    [_headerWebView release];
    _headerWebView = [[LoadingUIWebView alloc] initWithFrame:headerView.frame];
    [headerView addSubview:_headerWebView];

    [self showHeaderData];

    return headerView;
}
                                                                  
- (void)showTableAfterInitialLoad:(NSDecimalNumber *)responseInt {
    [super showTableAfterInitialLoad:responseInt];
    
    [self showHeaderData];
}

- (void)loadView {
    [super loadView];
}


/** 
 * getLoadMoreString returns the string that should be displayed
 * by the loading cell that tells the user that there are more objects 
 * available
 * @return NSString *fa
 */
- (NSString *)getLoadMoreString {
    return @"Load More Items";
}

/**
 * itemTypeString returns the name of the objects that are being loaded
 * it is a helper for the getNumLoadedString
 * @return NSString *
 */
- (NSString *)itemTypeString {
    return @"Items";
}

- (void)dealloc {
	_headerWebView.delegate = nil;
	
    [_headerWebView release];
    [super dealloc];
}


@end
