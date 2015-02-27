//
//  ShopItemTableViewCell.m
//  battleroyale
//
//  Created by Drew Lustro on 3/10/09.
//  Copyright 2009 Miraphonic, Inc. All rights reserved.
//

#import "ShopItemTableViewCell.h"
#import "Item.h"
#import "BRAppDelegate.h"
#import "Utility.h"

#define PADDING 10
#define ITEM_WIDTH 50
#define NAME_FONT_SIZE 14
#define NAME_HEIGHT 20
#define NAME_WIDTH 150
#define DETAILS_FONT_SIZE 12
#define DETAILS_WIDTH 220
#define DETAILS_HEIGHT 80
#define REQUIRES_LEVEL_FONT_SIZE 10
#define REQUIRES_LEVEL_WIDTH 70

// shop item customs
#define COST_FONT_SIZE 10
#define COST_HEIGHT 30

@implementation ShopItemTableViewCell

static UIFont *costFont;
static UIColor *costColor;

static NSNumberFormatter *format;

/**
 * initialize in order to minimize the number of object allocations
 * in drawRect, we initialize common objects here.  They should be small
 * enough that they wont make a large memory footprint
 */
+ (void)initialize {
	[super initialize];
    if (self = [ShopItemTableViewCell class]) {
		costFont = [[UIFont boldSystemFontOfSize:COST_FONT_SIZE] retain];		
		costColor = WEBCOLOR(0x007E04FF);
		[costColor retain];
		
		format = [[NSNumberFormatter alloc] init];
		[format setNumberStyle:NSNumberFormatterDecimalStyle];		
    }
}

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) {
		
    }
    return self;
}


- (void)drawContentView:(CGRect)r {
	[super drawContentView:r];
	
	CGPoint p;
	p.x = 15;
	p.y = 15 + ITEM_WIDTH;

	[costColor set];
	NSNumber *buyPrice = [[NSNumber alloc] initWithUnsignedInt:item.cost];
	NSString *buyPriceString = [[NSString alloc] initWithString:[format stringFromNumber:buyPrice]];
    NSString *buyFor = [[NSString alloc] initWithFormat:@"Buy For\n¥%@", buyPriceString];
	[buyFor drawInRect:CGRectMake(p.x, p.y, ITEM_WIDTH * 3, COST_HEIGHT) withFont:costFont lineBreakMode:UILineBreakModeTailTruncation alignment:UITextAlignmentLeft];
    [buyFor release];
	[buyPriceString release];
	[buyPrice release];
	
}

- (void)dealloc {
    [super dealloc];
}
@end
