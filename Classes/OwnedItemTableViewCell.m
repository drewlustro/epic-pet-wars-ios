//
//  OwnedItemTableViewCell.m
//  battleroyale
//
//  Created by Amit Matani on 1/28/09.
//  Copyright 2009 Miraphonic, Inc. All rights reserved.
//

#import "OwnedItemTableViewCell.h"
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
#define REQUIRES_LEVEL_WIDTH 80
#define REQUIRES_LEVEL_HEIGHT 14

@implementation OwnedItemTableViewCell

// shop item customs
#define SELL_PRICE_FONT_SIZE 10
#define SELL_PRICE_HEIGHT 30

static UIFont *sellPriceFont;

// class specific
static UIColor *sellPriceColor;

static NSNumberFormatter *format;

/**
 * initialize in order to minimize the number of object allocations
 * in drawRect, we initialize common objects here.  They should be small
 * enough that they wont make a large memory footprint
 */
+ (void)initialize {
	[super initialize];
    if (self = [OwnedItemTableViewCell class]) {
		sellPriceFont = [[UIFont boldSystemFontOfSize:SELL_PRICE_FONT_SIZE] retain];
		
		// class specific
		sellPriceColor = WEBCOLOR(0xB16A00FF);
		[sellPriceColor retain];
		
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
	
    if (![item.categoryKey isEqualToString:@"background"]) {
        [sellPriceColor set];
		NSNumber *sellPrice = [[NSNumber alloc] initWithUnsignedInt:item.sellPrice];
		NSString *sellPriceString = [[NSString alloc] initWithString:[format stringFromNumber:sellPrice]];
        NSString *sellFor = [[NSString alloc] initWithFormat:@"Sell For\n¥%@", sellPriceString];
        [sellFor drawInRect:CGRectMake(p.x, p.y, ITEM_WIDTH * 2, SELL_PRICE_HEIGHT) withFont:sellPriceFont lineBreakMode:UILineBreakModeTailTruncation alignment:UITextAlignmentLeft];
        [sellFor release];
		[sellPriceString release];
		[sellPrice release];
    }
}

- (void)dealloc {
    [super dealloc];
}
@end
