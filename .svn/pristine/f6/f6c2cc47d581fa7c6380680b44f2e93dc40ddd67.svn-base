/**
 * CommentTableViewCell.h
 * Copyright Miraphonic, Inc 2009. All rights reserved.
 *
 * @author Amit Matani 
 * @created 2/13/09.
 */


#import <UIKit/UIKit.h>
#import "ABTableViewCell.h"
#import "Post.h"

@class Post;
@interface CommentTableViewCell : ABTableViewCell {
	Post *post;
}

@property (nonatomic, retain) Post *post;

+ (CGFloat)getCellHeightForPost:(Post *)post;
+ (CGFloat)getTextWidth;
+ (CGFloat)getTextHeight:(NSString *)text;

@end
