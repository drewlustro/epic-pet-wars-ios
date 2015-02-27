/**
 * CommentTableViewContainerController.m
 * Copyright Miraphonic, Inc 2009. All rights reserved.
 *
 * @author Amit Matani 
 * @created 2/13/09.
 */

#import "CommentTableViewContainerController.h"
#import "CommentRemoteCollection.h"
#import "BulletinRemoteCollection.h"
#import "CommentTableViewController.h"
#import "Consts.h"
#import "NewCommentViewController.h"
#import "Animal.h"
#import "BRGlobal.h"

@implementation CommentTableViewContainerController
@synthesize userId = _userId;

- (id)initWithUserId:(NSString *)userId {
	CommentRemoteCollection *crc = [[CommentRemoteCollection alloc] initWithUserId:userId];
    BulletinRemoteCollection *brc = [[BulletinRemoteCollection alloc] initWithUserId:userId];
    NSArray *dataSources = [[NSArray alloc] initWithObjects:crc, brc, nil];
    NSArray *titles = [[NSArray alloc] initWithObjects:@"Comments", @"Bulletins", nil];
    
	CommentTableViewController *ctvc = [[CommentTableViewController alloc] initWithDataSources:dataSources titles:titles initialIndex:0];
    
    [dataSources release];
    [titles release];
	[brc release];    
	[crc release];
    
	if (self = [super initWithRemoteDataController:ctvc]) {
		self.title = @"Messages";
		[ctvc loadInitialData:NO showLoadingOverlay:YES];		
		_userId = [userId copy];
	}
	
	[ctvc release];
	
	return self;
}

- (void)loadView {
	[super loadView];
	
	UIBarButtonItem *newButton = 
		[[UIBarButtonItem alloc] initWithTitle:@"New" style:UIBarButtonItemStyleDone
										target:self 
										action:@selector(newComment)];
    self.navigationItem.rightBarButtonItem = newButton;
    [newButton release];
}

- (void)newComment {
	[[SoundManager sharedManager] playSoundWithType:@"popup" vibrate:NO];
	NewCommentViewController *ncvc = [[NewCommentViewController alloc] initWithUserId:_userId];
	ncvc.commentTableViewController = (CommentTableViewController *)containedRDC;
	
	UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:ncvc];
	[self presentModalViewController:nav animated:YES];
	[nav release];
	[ncvc release];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}


- (void)dealloc {
	[_userId release];
    [super dealloc];
}


@end
