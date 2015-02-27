/**
 * NewsFeedItemTableViewCell.h
 * Copyright Miraphonic, Inc 2009. All rights reserved.
 *
 * @author Amit Matani 
 * @created 2/16/09.
 */


#import <UIKit/UIKit.h>
#import "ABTableViewCellWithFileImageStore.h"
#import "NewsfeedItem.h"

@interface NewsFeedItemTableViewCell : ABTableViewCellWithFileImageStore {
	NewsfeedItem *newsfeedItem;
}

@property (nonatomic, retain) NewsfeedItem *newsfeedItem;

+ (CGFloat)getCellHeightForNewsfeedItem:(NewsfeedItem *)item;
+ (CGFloat)getTextHeight:(NSString *)text withFont:(UIFont *)font width:(CGFloat)width;
+ (CGFloat)getTextWidth:(NewsfeedItem *)newsfeedItem;

@end
