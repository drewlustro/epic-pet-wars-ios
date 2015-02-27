/**
 * InviteOptionTableViewCell.m
 * Copyright Miraphonic, Inc 2009. All rights reserved.
 *
 * @author Amit Matani 
 * @created 2/6/09.
 */

#import "InviteOptionTableViewCell.h"


@implementation InviteOptionTableViewCell

#define PADDING 10
#define NAME_FONT_SIZE 16
#define NAME_HEIGHT 20
#define DESC_FONT_SIZE 10
#define DESC_HEIGHT 40

@synthesize name, desc, icon;

static UIFont *nameFont, *descFont;

// super common colors
static UIColor *whiteColor, *blackColor, *darkGrayColor, *clearColor;

/**
 * initialize in order to minimize the number of object allocations
 * in drawRect, we initialize common objects here.  They should be small
 * enough that they wont make a large memory footprint
 */
+ (void)initialize {
    if (self = [InviteOptionTableViewCell class]) {
        nameFont = [[UIFont boldSystemFontOfSize:NAME_FONT_SIZE] retain];
		descFont = [[UIFont boldSystemFontOfSize:DESC_FONT_SIZE] retain];
		
		// super-common colors for every custom table view cell class
		whiteColor = [[UIColor whiteColor] retain];
		blackColor = [[UIColor blackColor] retain];
		darkGrayColor = [[UIColor darkGrayColor] retain]; 
		clearColor = [[UIColor clearColor] retain];

    }
}

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) {
		
    }
    return self;
}

/*
 * setName should ALWAYS happen LAST because it has setNeedsDisplay in it.
 */
- (void)setName:(NSString *)_name {
	[name release];
	name = [_name copy];
    [self setNeedsDisplay];
}

- (void)setDesc:(NSString *)_value {
	[desc release];
	desc = [_value copy];
    //[self setNeedsDisplay];    
}

- (void)setIcon:(UIImage *)_value {
	[icon release];
	icon = [_value retain];
    //[self setNeedsDisplay];    
}

- (void)drawContentView:(CGRect)r {
    CGContextRef context = UIGraphicsGetCurrentContext();
	
	UIColor *backgroundColor = self.selected ? clearColor : whiteColor;
	UIColor *textColor = self.selected ? whiteColor : blackColor;
	
	[backgroundColor set];
	CGContextFillRect(context, r);
	
	CGPoint drawPoint;
	drawPoint.x = 0;
	drawPoint.y = 0;
	
	CGRect canvasRect;
	
	if (icon) {
		canvasRect = CGRectMake(3, 3, 80, 60);
		[icon drawInRect:canvasRect];
	}
	
	drawPoint.x += 5;
	drawPoint.y += 5;
	
	drawPoint.x += 80 + PADDING;	
	[textColor set];
	[name drawAtPoint:drawPoint withFont:nameFont];
	
	drawPoint.x += PADDING;
	drawPoint.y += NAME_HEIGHT;
	
	canvasRect = CGRectMake(drawPoint.x, drawPoint.y, 180, DESC_HEIGHT);
	[darkGrayColor set];
	[desc drawInRect:canvasRect withFont:descFont lineBreakMode:UILineBreakModeWordWrap alignment:UITextAlignmentLeft];
	
}

- (void)dealloc {
    [name release];
	[desc release];
	[icon release];
    [super dealloc];
}

@end
