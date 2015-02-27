/**
 * BattleItemTableViewCell.m
 * Copyright Miraphonic, Inc 2009. All rights reserved.
 *
 * @author Amit Matani 
 * @created 2/10/09.
 */

#import "BattleItemTableViewCell.h"
#import "BRAppDelegate.h"
#import "Item.h"
#import "Consts.h"
#import "BattleViewController.h"
#import "Utility.h"

#define NAME_FONT_SIZE 15
#define NAME_HEIGHT 18

#define DETAILS_FONT_SIZE 11
#define DETAILS_WIDTH 170
#define DETAILS_HEIGHT 70

#define OWNED_FONT_SIZE 11


#define PADDING 10
#define PADDING_TEXT 5
#define ITEM_WIDTH 50

@implementation BattleItemTableViewCell
@synthesize item, itemDelegate;

static UIFont *nameFont, *detailsFont, *ownedFont;
static UIImage *useItemImage;
static CGRect useItemImageRect;

// super common colors
static UIColor *whiteColor, *blackColor, *darkGrayColor, *clearColor;

static UIColor *ownedColor;

/**
 * initialize in order to minimize the number of object allocations
 * in drawRect, we initialize common objects here.  They should be small
 * enough that they wont make a large memory footprint
 */
+ (void)initialize {
    if (self = [BattleItemTableViewCell class]) {
        nameFont = [[UIFont boldSystemFontOfSize:NAME_FONT_SIZE] retain];
		detailsFont = [[UIFont systemFontOfSize:DETAILS_FONT_SIZE] retain];
		ownedFont = [[UIFont boldSystemFontOfSize:OWNED_FONT_SIZE] retain];
        useItemImage = [[UIImage imageNamed:@"use_item_battle_button.png"] retain];
        useItemImageRect = CGRectZero;
		
		// super-common colors for every custom table view cell class
		whiteColor = [[UIColor whiteColor] retain];
		blackColor = [[UIColor blackColor] retain];
		darkGrayColor = [[UIColor darkGrayColor] retain]; 
		clearColor = [[UIColor clearColor] retain];
		
		ownedColor = WEBCOLOR(0x004997FF);
		[ownedColor retain];
    }
}


- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) {
		
    }
    return self;
}

- (void)setItem:(Item *)_value {
    [item release];
    item = [_value retain];
    [self setNeedsDisplay];
    [self loadImageWithUrl:item.imageSquare50];
}

- (void)drawContentView:(CGRect)r {
    CGContextRef context = UIGraphicsGetCurrentContext();
	
	UIColor *backgroundColor = self.selected ? clearColor : whiteColor;
	UIColor *textColor = self.selected ? whiteColor : blackColor;	
	
	[backgroundColor set];
	CGContextFillRect(context, r);	
	
	CGPoint p;
	p.x = 12;
	p.y = 9;
    [image drawAtPoint:p];
	
	// name
    p.x += ITEM_WIDTH + PADDING;
	[textColor set];
	[item.name drawAtPoint:p withFont:nameFont];
	
	// description
    CGFloat useItemImageX = FRAME_WIDTH - PADDING - useItemImage.size.width;    
	p.x += PADDING_TEXT;
	p.y += NAME_HEIGHT + PADDING_TEXT;
	[darkGrayColor set];
	[item.details drawInRect:CGRectMake(p.x, p.y, useItemImageX - PADDING * 2 - p.x, DETAILS_HEIGHT) withFont:detailsFont];
	
	// num owned.
	p.x = 12;
	p.y = 9 + ITEM_WIDTH + PADDING;
	[ownedColor set];
	NSString *ownedString = [[NSString alloc] initWithFormat:@"%d left", item.numOwned];
	[ownedString drawInRect:CGRectMake(p.x, p.y, ITEM_WIDTH, OWNED_FONT_SIZE) withFont:ownedFont lineBreakMode:UILineBreakModeTailTruncation alignment:UITextAlignmentCenter];	
	[ownedString release];
	
	if (useItemImageRect.size.height == 0) {
        useItemImageRect = CGRectMake(useItemImageX,
                                    (self.frame.size.height - useItemImage.size.height) / 2,
                                    useItemImage.size.width,
                                    useItemImage.size.height);
    }
    
    [useItemImage drawInRect:useItemImageRect];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (CGRectContainsPoint(useItemImageRect, [[touches anyObject] locationInView:self])) {
        // notify the doJobDelegate that we are attempting to do the job
        [itemDelegate useItemInBattle:item];
    }
    debug_NSLog(@"here2");
    [super touchesEnded:touches withEvent:event];
}


- (void)dealloc {
	[item release];
    [super dealloc];
}


@end
