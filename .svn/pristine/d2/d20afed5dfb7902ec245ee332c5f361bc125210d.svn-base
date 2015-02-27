/**
 * CommentTableViewCell.m
 * Copyright Miraphonic, Inc 2009. All rights reserved.
 *
 * @author Amit Matani 
 * @created 2/13/09.
 */

#import "CommentTableViewCell.h"
#import "Post.h"
#import "Consts.h"

#define Y_OFFSET 10
#define PADDING 10

@implementation CommentTableViewCell
@synthesize post;

static UIFont *nameFont, *commentFont;

// super common colors
static UIColor *whiteColor, *blackColor, *darkGrayColor, *clearColor;

/**
 * initialize in order to minimize the number of object allocations
 * in drawRect, we initialize common objects here.  They should be small
 * enough that they wont make a large memory footprint
 */
+ (void)initialize {
    if (self = [CommentTableViewCell class]) {
        nameFont = [[UIFont boldSystemFontOfSize:13] retain];
        commentFont = [[UIFont systemFontOfSize:12] retain];
		
		// super-common colors for every custom table view cell class
		whiteColor = [[UIColor whiteColor] retain];
		blackColor = [[UIColor blackColor] retain];
		darkGrayColor = [[UIColor darkGrayColor] retain]; 
		clearColor = [[UIColor clearColor] retain];
    }
}

+ (CGFloat)getCellHeightForPost:(Post *)post {
	CGFloat height = PADDING;
	
	CGSize s = [post.senderName sizeWithFont:nameFont];
	
	height += s.height + PADDING;
	return height + [CommentTableViewCell getTextHeight:post.text] + PADDING;
}

+ (CGFloat)getTextHeight:(NSString *)text {
	CGFloat width = [self getTextWidth];
	CGSize s = [text sizeWithFont:commentFont constrainedToSize:CGSizeMake(width, 4000) 
				  lineBreakMode:UILineBreakModeWordWrap];
	return s.height;
}

+ (CGFloat)getTextWidth {
	return FRAME_WIDTH - 4 * PADDING;
}

- (void)setPost:(Post *)_value {
	[post release];
	post = [_value retain];
	
	[self setNeedsDisplay];
}

- (void)drawContentView:(CGRect)r {
    CGContextRef context = UIGraphicsGetCurrentContext();

	UIColor *backgroundColor = self.selected ? clearColor : whiteColor;
	UIColor *textColor = self.selected ? whiteColor : blackColor;
	
	[backgroundColor set];
	CGContextFillRect(context, r);
	
	CGPoint p;
	p.x = PADDING;
	p.y = Y_OFFSET;
	
	[textColor set];
	CGSize s = [post.senderName drawAtPoint:p withFont:nameFont];
	
	p.y += s.height + PADDING / 2;
	p.x += PADDING;
	
	CGFloat width = [CommentTableViewCell getTextWidth];
	CGFloat height = [CommentTableViewCell getTextHeight:post.text];
	
	[post.text drawInRect:CGRectMake(p.x, p.y, width, height) withFont:commentFont lineBreakMode:UILineBreakModeWordWrap alignment:UITextAlignmentLeft];
}

- (void)dealloc {
    [post release];
    [super dealloc];
}


@end
