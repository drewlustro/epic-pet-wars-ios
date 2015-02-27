/**
 * InviteContactsViewController.h
 * Copyright Miraphonic, Inc 2009. All rights reserved.
 *
 * @author Amit Matani 
 * @created 2/8/09.
 */


#import "BRGlobal.h"

@class Notifier, BRRestOperation;
@interface InviteContactsViewController : MegaViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, RestResponseDelegate> {
	UITableView *myTableView;
	NSMutableArray *contacts;
	int *offsets;
	int numSections;
	int numChecked;
	UIButton *sendButton;
    BRRestOperation *loadHeaderOperation;
    NSString *_name;
}

@property (nonatomic, retain) UITableView *myTableView;

- (UITableViewCell *)tableviewCellWithReuseIdentifier:(NSString *)identifier;
- (void)configureCell:(UITableViewCell *)cell forIndexPath:(NSIndexPath *)indexPath;
//- (int)sectionToIndex:(int)section;
//- (int)indexToSection:(int)index;
//- (void)setupOffsets;
- (void)failedSendingInvites;

@end
