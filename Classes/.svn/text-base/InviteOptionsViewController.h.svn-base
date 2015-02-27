/**
 * InviteOptionsViewController.h
 * Copyright Miraphonic, Inc 2009. All rights reserved.
 *
 * @author Amit Matani 
 * @created 2/6/09.
 */



#import "BattleRoyale.h"
#import "TopLevelController.h"
#import "BRGlobal.h"


@interface InviteOptionsViewController : MegaViewController <TopLevelController, UITableViewDelegate, UITableViewDataSource, FBSessionDelegate, RestResponseDelegate> {
	UITableView *myTableView;
    NSMutableArray *_rows;
}

@property (nonatomic, retain) UITableView *myTableView;
- (UITableViewCell *)tableviewCellWithReuseIdentifier:(NSString *)identifier;
- (void)configureCell:(UITableViewCell *)cell forIndexPath:(NSIndexPath *)indexPath;
- (void)updateInviteCount:(NSInteger)newInviteCount;
@end
