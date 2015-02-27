//
//  JobTableViewController.m
//  battleroyale
//
//  Created by Amit Matani on 1/30/09.
//  Copyright 2009 Miraphonic, Inc. All rights reserved.
//

#import "JobTableViewController.h"
#import "JobRemoteCollection.h"
#import "AbstractRemoteCollectionStore.h"
#import "Consts.h"
#import "JobTableViewController.h"
#import "JobTableViewCell.h"
#import "Job.h"
#import "Utility.h"
#import "LoadingUIWebView.h"

#define HEADER_HEIGHT 65.0
#define CELL_HEIGHT 100.0
#define EXPLANATION_HEIGHT 35.0
#define PADDING 5


@implementation JobTableViewController
@synthesize jobViewController;

- (id)init {
    JobRemoteCollection *data = [[JobRemoteCollection alloc] init];
    if (self = [super initWithDataSource:data]) {

    }
    [data release];
    return self;
}

- (UITableViewCell *)tableviewCellWithReuseIdentifier:(NSString *)identifier {
    return [[[JobTableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:identifier] autorelease];
}

- (void)configureCell:(UITableViewCell *)_cell forIndexPath:(NSIndexPath *)indexPath {
    // for convenience
    JobTableViewCell *cell = (JobTableViewCell *)_cell;
    cell.doJobDelegate = jobViewController;
    cell.job = (Job *) [dataSource objectAtIndex:indexPath.row];
}

- (void)loadView {
	[super loadView];
	self.view.backgroundColor = [UIColor blackColor];
}

/**
 * showTableAfterInitialLoad is called by the data source once the initial load 
 * has occured
 * @param responseInt is the response code
 */
- (void)showTableAfterInitialLoad:(NSDecimalNumber *)responseInt {
    [super showTableAfterInitialLoad:responseInt];
    if ([dataSource extraData] != nil && [dataSource extraData]) {
		
		// Explanation about what jobs are
		UIWebView *headerView = [[LoadingUIWebView alloc] initWithFrame:CGRectMake(0, 0, FRAME_WIDTH, HEADER_HEIGHT)];
        headerView.backgroundColor = [UIColor clearColor];        
        NSString *path = [[NSBundle mainBundle] bundlePath];
        NSURL *baseURL = [NSURL fileURLWithPath:path];
        
        [headerView loadHTMLString:[[dataSource extraData] objectForKey:@"explanation"] baseURL:baseURL];
        /*
		
		// "Newbie Jobs (Levels X-Y)"
		UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(PADDING, EXPLANATION_HEIGHT - 2, FRAME_WIDTH, HEADER_HEIGHT - EXPLANATION_HEIGHT)];
        nameLabel.textAlignment = UITextAlignmentLeft;
		nameLabel.adjustsFontSizeToFitWidth = YES;
        nameLabel.textColor = [UIColor whiteColor];
        nameLabel.backgroundColor = [UIColor clearColor];
		nameLabel.font = [UIFont boldSystemFontOfSize:14];
        [headerView addSubview:nameLabel];
        
		
		// "more jobs @ level XX"
        UILabel *moreLabel = [[UILabel alloc] initWithFrame:CGRectMake(185, EXPLANATION_HEIGHT + 2, FRAME_WIDTH - 190, HEADER_HEIGHT - EXPLANATION_HEIGHT)];
		moreLabel.adjustsFontSizeToFitWidth = YES;
        moreLabel.textAlignment = UITextAlignmentRight;
        moreLabel.textColor = WEBCOLOR(0xffff66ff);
        moreLabel.backgroundColor = [UIColor clearColor];
		moreLabel.font =  [UIFont boldSystemFontOfSize: 10];
        [headerView addSubview:moreLabel];
		
        
        NSString *name = [[dataSource extraData] objectForKey:@"tier_name"];
        if (name != nil && (id)name != [NSNull null]) {
            nameLabel.text = name;
        }
        [nameLabel release];                
        
        NSString *more = [[dataSource extraData] objectForKey:@"more_jobs_text"];        
        if (more != nil && (id)more != [NSNull null]) {
            moreLabel.text = more;
        }
        [moreLabel release];           */     

        myTableView.tableHeaderView = headerView;
        [headerView release];
    }
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
    return CELL_HEIGHT;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}


- (void)dealloc {
    debug_NSLog(@"deallocing");
    [super dealloc];
}

@end
