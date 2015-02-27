/**
 * NewCommentViewController.h
 * Copyright Miraphonic, Inc 2009. All rights reserved.
 *
 * @author Amit Matani 
 * @created 2/13/09.
 */


#import "BRGlobal.h"

@class CommentTableViewController;
@interface NewCommentViewController : MegaViewController <UITextViewDelegate> {
	IBOutlet UITextView *commentText;
	IBOutlet UILabel *charactersLeft;
	NSString *userId;
	NSInteger numCharactersUsed;
	CommentTableViewController *commentTableViewController;
}

@property (nonatomic, assign) CommentTableViewController *commentTableViewController;
@property (nonatomic, retain) UITextView *commentText;
@property (nonatomic, retain) UILabel *charactersLeft;

- (id)initWithUserId:(NSString *)_userId;
- (void)failedSendingComment;
@end
