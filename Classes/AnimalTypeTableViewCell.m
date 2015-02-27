/**
 * AnimalTypeTableViewCell.m
 * Copyright Miraphonic, Inc 2009. All rights reserved.
 *
 * The AnimalTypeTableViewCell is the class of cells that are displayed
 * in AnimalTypeSelectionController table. It includes images and descriptions.
 *
 * @author Amit Matani
 * @created 1/15/09
 */

#import "AnimalTypeTableViewCell.h"
#import "AnimalType.h"
#import "BRAppDelegate.h"
#import "Utility.h"

@implementation AnimalTypeTableViewCell

@synthesize animalType;
 
static UIFont *nameFont, *detailsFont;

// super common colors
static UIColor *whiteColor, *blackColor, *darkGrayColor, *clearColor;

static UIColor *redColor;

#define NAME_FONT_SIZE 16
#define NAME_HEIGHT 22
#define DETAIL_FONT_SIZE 11
#define DETAIL_WIDTH 190
#define DETAIL_HEIGHT 60
#define ANIMAL_WIDTH 75
#define PADDING 10
#define IMAGE_WIDTH 75


/**
 * initialize in order to minimize the number of object allocations
 * in drawRect, we initialize common objects here.  They should be small
 * enough that they wont make a large memory footprint
 */
+ (void)initialize {
    if (self = [AnimalTypeTableViewCell class]) {
        nameFont = [[UIFont boldSystemFontOfSize:NAME_FONT_SIZE] retain];
		detailsFont = [[UIFont boldSystemFontOfSize:DETAIL_FONT_SIZE] retain];
		
		// super-common colors for every custom table view cell class
		whiteColor = [[UIColor whiteColor] retain];
		blackColor = [[UIColor blackColor] retain];
		darkGrayColor = [[UIColor darkGrayColor] retain]; 
		clearColor = [[UIColor clearColor] retain];
		
		// this class specific ones
		redColor = WEBCOLOR(0x8D0000FF);
		[redColor retain];
    }
}

- (void)setAnimalType:(AnimalType *)_value {
    [animalType release];
    animalType = [_value retain];
    [self setNeedsDisplay];
    [self loadImageWithUrl:animalType.imageSquare75];
    
}

- (void)drawContentView:(CGRect)r {
    CGContextRef context = UIGraphicsGetCurrentContext();

	UIColor *backgroundColor = self.selected ? clearColor : whiteColor;
	UIColor *textColor = self.selected ? whiteColor : blackColor;
	
	[backgroundColor set];
	CGContextFillRect(context, r);

	CGPoint p;
	p.x = PADDING;
	p.y = PADDING;
    [image drawAtPoint:p];
	
    p.x += ANIMAL_WIDTH + PADDING;
	[textColor set];
	CGSize size = [animalType.name drawAtPoint:p withFont:nameFont];

    if (animalType.locked) {
        [redColor set];
        [@"(Locked)" drawAtPoint:CGPointMake(p.x + size.width + 5, p.y) withFont:nameFont];
    }
	
	p.y += NAME_HEIGHT;
	[darkGrayColor set];
	[animalType.details drawInRect:CGRectMake(p.x, p.y, DETAIL_WIDTH, DETAIL_HEIGHT) withFont:detailsFont];
	
}

- (void)dealloc {
    [animalType release];
    [super dealloc];
}

@end
