//
//  ItemTableViewCell.m
//  battleroyale
//
//  Created by Drew Lustro on 3/10/09.
//  Copyright 2009 Miraphonic, Inc. All rights reserved.
//

#import "ItemTableViewCell.h"
#import "Item.h"
#import "BRAppDelegate.h"
#import "Utility.h"
#import "BRSession.h"

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

@implementation ItemTableViewCell
@synthesize item;

static UIFont *nameFont, *detailsFont, *requiresLevelFont, *numOwnedFont;

// super common colors
static UIColor *whiteColor, *blackColor, *darkGrayColor, *clearColor, *numOwnedColor;

static UIColor *requiresLevelColor;
static UIImage *weaponImagePlaceholder, *armorImagePlaceholder, *accessoryImagePlaceholder, *backgroundImagePlaceholder,
               *investmentImagePlaceholder, *useableImagePlaceholder;


/**
 * initialize in order to minimize the number of object allocations
 * in drawRect, we initialize common objects here.  They should be small
 * enough that they wont make a large memory footprint
 */
+ (void)initialize {
    if (self = [ItemTableViewCell class]) {
        nameFont = [[UIFont boldSystemFontOfSize:NAME_FONT_SIZE] retain];
		detailsFont = [[UIFont systemFontOfSize:DETAILS_FONT_SIZE] retain];
		requiresLevelFont = [[UIFont boldSystemFontOfSize:REQUIRES_LEVEL_FONT_SIZE] retain];
		numOwnedFont = [[UIFont boldSystemFontOfSize:REQUIRES_LEVEL_FONT_SIZE] retain];
		
		// super-common colors for every custom table view cell class
		whiteColor = [[UIColor whiteColor] retain];
		blackColor = [[UIColor blackColor] retain];
		darkGrayColor = [[UIColor darkGrayColor] retain]; 
		clearColor = [[UIColor clearColor] retain];
		numOwnedColor = WEBCOLOR(0x222222FF);
		[numOwnedColor retain];
		
		// class specific
		requiresLevelColor = [WEBCOLOR(0x2E519CFF) retain];
        
        weaponImagePlaceholder = [[UIImage imageNamed:@"weapon_icon_square50.png"] retain];
        armorImagePlaceholder = [[UIImage imageNamed:@"armor_icon_square50.png"] retain];
        accessoryImagePlaceholder = [[UIImage imageNamed:@"accessory_icon_square50.png"] retain];
        backgroundImagePlaceholder = [[UIImage imageNamed:@"background_icon_square50.png"] retain];
        investmentImagePlaceholder = [[UIImage imageNamed:@"investment_icon_square50.png"] retain];        
        useableImagePlaceholder = [[UIImage imageNamed:@"useable_icon_square50.png"] retain];                
		
		
    }
}

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) {
		
    }
    return self;
}

- (void)setItem:(Item *)_item {
    [item release];
    item = [_item retain];
    [self setNeedsDisplay];       

    [self loadImageWithUrl:item.imageSquare50];
}

- (void)drawContentView:(CGRect)r {
    CGContextRef context = UIGraphicsGetCurrentContext();
	
	UIColor *backgroundColor = self.selected ? clearColor : whiteColor;
	UIColor *textColor = self.selected ? whiteColor : blackColor;
	
	if (self.selected) {
		backgroundColor = clearColor;
	} else {
		backgroundColor = whiteColor;
	}

	
	[backgroundColor set];
	CGContextFillRect(context, r);
	
	CGPoint p;
	p.x = 10;
	p.y = 10;
    
    if (image != nil) {
        [image drawAtPoint:p];
    } else {
        UIImage *placeholder = nil;
        if ([item.categoryKey isEqualToString:@"weapon"]) {
            placeholder = weaponImagePlaceholder;
        } else if ([item.categoryKey isEqualToString:@"armor"]) {
            placeholder = armorImagePlaceholder;
        } else if ([item.categoryKey isEqualToString:@"accessory"]) {
            placeholder = accessoryImagePlaceholder;
        } else if ([item.categoryKey isEqualToString:@"background"]) {
            placeholder = backgroundImagePlaceholder;
        } else if ([item.categoryKey isEqualToString:@"investment"]) {
            placeholder = investmentImagePlaceholder;
        } else if ([item.categoryKey isEqualToString:@"useable"]) {
            placeholder = useableImagePlaceholder;
        }
        [placeholder drawAtPoint:p];
    }
	
    p.x += ITEM_WIDTH + PADDING;
	[textColor set];
	[item.name drawInRect:CGRectMake(p.x, p.y, NAME_WIDTH, NAME_HEIGHT) withFont:nameFont];
	
	[requiresLevelColor set];
	NSString *requiresString = [[NSString alloc] initWithFormat:@"Req. Level %@", item.requiresLevel];
	[requiresString drawInRect:CGRectMake(p.x + NAME_WIDTH + PADDING, p.y, REQUIRES_LEVEL_WIDTH, REQUIRES_LEVEL_HEIGHT) withFont:requiresLevelFont lineBreakMode:UILineBreakModeHeadTruncation alignment:UITextAlignmentRight];
	[requiresString release];
    	
	p.x += PADDING;
	p.y += NAME_HEIGHT + REQUIRES_LEVEL_FONT_SIZE;
	[textColor set];
	[item.details drawInRect:CGRectMake(p.x, p.y, DETAILS_WIDTH, DETAILS_HEIGHT) withFont:detailsFont];
	
	[numOwnedColor set];
	NSString *numOwnedString = [[NSString alloc] initWithFormat:@"Owned: %d", item.numOwned];
	[numOwnedString drawInRect:CGRectMake(10 + ITEM_WIDTH + PADDING + NAME_WIDTH + PADDING, 10 + REQUIRES_LEVEL_HEIGHT, REQUIRES_LEVEL_WIDTH, REQUIRES_LEVEL_HEIGHT) withFont:numOwnedFont lineBreakMode:UILineBreakModeHeadTruncation alignment:UITextAlignmentRight]; 
	[numOwnedString release];
}

- (void)dealloc {
    [item release];
    [super dealloc];
}
@end
