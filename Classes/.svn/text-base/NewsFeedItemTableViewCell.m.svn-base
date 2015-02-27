/**
 * NewsFeedItemTableViewCell.m
 * Copyright Miraphonic, Inc 2009. All rights reserved.
 *
 * @author Amit Matani 
 * @created 2/16/09.
 */

#import "NewsFeedItemTableViewCell.h"
#import "BRAppDelegate.h"
#import "BRRestClient.h"
#import "Consts.h"

@implementation NewsFeedItemTableViewCell
@synthesize newsfeedItem;

static UIFont *titleFont, *contentFont;

// super common colors
static UIColor *whiteColor, *blackColor, *darkGrayColor, *clearColor;

#define PADDING 10
#define IMAGE_WIDTH 50
#define MINIMUM_HEIGHT 60

/**
 * initialize in order to minimize the number of object allocations
 * in drawRect, we initialize common objects here.  They should be small
 * enough that they wont make a large memory footprint
 */
+ (void)initialize {
    if (self = [NewsFeedItemTableViewCell class]) {
        titleFont = [[UIFont boldSystemFontOfSize:12] retain];
        contentFont = [[UIFont systemFontOfSize:12] retain];
		
		// super-common colors for every custom table view cell class
		whiteColor = [[UIColor whiteColor] retain];
		blackColor = [[UIColor blackColor] retain];
		darkGrayColor = [[UIColor darkGrayColor] retain]; 
		clearColor = [[UIColor clearColor] retain];
    }
}

- (void)setNewsfeedItem:(NewsfeedItem *)_value {
	[newsfeedItem release];
	newsfeedItem = [_value retain];
	
	if ([newsfeedItem hasImage]) {
        [self loadImageWithUrl:newsfeedItem.pictureUrl];
	}
	
	[self setNeedsDisplay];
}

+ (CGFloat)getCellHeightForNewsfeedItem:(NewsfeedItem *)item {
	CGFloat width = [NewsFeedItemTableViewCell getTextWidth:item];
	CGFloat height = [NewsFeedItemTableViewCell getTextHeight:item.title withFont:titleFont width:width] + 2 * PADDING;
	height += [NewsFeedItemTableViewCell getTextHeight:item.content withFont:contentFont width:width] + PADDING;
	
	if ([item hasImage] && height < IMAGE_WIDTH + 2 * PADDING) {
		height = IMAGE_WIDTH + 2 * PADDING;
	}
	
	return height > MINIMUM_HEIGHT ? height : MINIMUM_HEIGHT;
}

+ (CGFloat)getTextHeight:(NSString *)text withFont:(UIFont *)font width:(CGFloat)width {
	CGSize s = [text sizeWithFont:font constrainedToSize:CGSizeMake(width, 4000) 
					lineBreakMode:UILineBreakModeWordWrap];
	return s.height;
}

+ (CGFloat)getTextWidth:(NewsfeedItem *)newsfeedItem {
	CGFloat width = FRAME_WIDTH - 3 * PADDING;
	if ([newsfeedItem hasImage]) {
		width -= (IMAGE_WIDTH + PADDING);
	}
	return width;
}

- (void)drawContentView:(CGRect)r {
    CGContextRef context = UIGraphicsGetCurrentContext();

	UIColor *backgroundColor = self.selected ? clearColor : whiteColor;
	UIColor *textColor = self.selected ? whiteColor : blackColor;
	
	[backgroundColor set];
	CGContextFillRect(context, r);
	
	[textColor set];
	CGFloat width = [NewsFeedItemTableViewCell getTextWidth:newsfeedItem];
	CGFloat offset = PADDING;
	if ([newsfeedItem hasImage]) {
		[image drawAtPoint:CGPointMake(PADDING, PADDING)];
		
		offset += PADDING + IMAGE_WIDTH;
	}
	CGRect titleRect = CGRectMake(offset, PADDING, width, [NewsFeedItemTableViewCell getTextHeight:newsfeedItem.title withFont:titleFont width:width]);
	
	[newsfeedItem.title drawInRect:titleRect withFont:titleFont lineBreakMode:UILineBreakModeWordWrap alignment:UITextAlignmentLeft];	
	
	CGRect contentRect = CGRectMake(offset, 
									titleRect.size.height + titleRect.origin.y + PADDING, 
									width, 
									[NewsFeedItemTableViewCell getTextHeight:newsfeedItem.content withFont:contentFont width:width]);
	[newsfeedItem.content drawInRect:contentRect withFont:contentFont lineBreakMode:UILineBreakModeWordWrap alignment:UITextAlignmentLeft];		
}

- (void)dealloc {
    [newsfeedItem release];
    [super dealloc];
}


@end
