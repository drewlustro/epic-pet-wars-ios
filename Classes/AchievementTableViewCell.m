/**
 * AchievementTableViewCell.m
 * Copyright Miraphonic, Inc 2009. All rights reserved.
 *
 * @author Amit Matani 
 * @created 2/5/09.
 */

#import "AchievementTableViewCell.h"
#import "BRAppDelegate.h"
#import "Achievement.h"

#define PADDING 10
#define PADDING_TEXT 5
#define ACHIEVEMENT_IMAGE_WIDTH 75
#define NAME_FONT_SIZE 16
#define DETAILS_FONT_SIZE 11
#define DETAILS_WIDTH 210
#define DETAILS_HEIGHT 70

@implementation AchievementTableViewCell

@synthesize achievement;

static UIFont *nameFont, *detailsFont;

// super common colors
static UIColor *whiteColor, *blackColor, *darkGrayColor, *clearColor;

/**
 * initialize in order to minimize the number of object allocations
 * in drawRect, we initialize common objects here.  They should be small
 * enough that they wont make a large memory footprint
 */
+ (void)initialize {
    if (self = [AchievementTableViewCell class]) {
        nameFont = [[UIFont boldSystemFontOfSize:NAME_FONT_SIZE] retain];
		detailsFont = [[UIFont boldSystemFontOfSize:DETAILS_FONT_SIZE] retain];
		
		// super-common colors for every custom table view cell class
		whiteColor = [[UIColor whiteColor] retain];
		blackColor = [[UIColor blackColor] retain];
		darkGrayColor = [[UIColor darkGrayColor] retain]; 
		clearColor = [[UIColor clearColor] retain];
    }
}

- (void)setAchievement:(Achievement *)_value {
    [achievement release];
    achievement = [_value retain];	
	
    [self loadImageWithUrl:achievement.imageSquare75];
    [self setNeedsDisplay];
}

- (void)drawContentView:(CGRect)r {
    CGContextRef context = UIGraphicsGetCurrentContext();
	
	UIColor *backgroundColor = self.selected ? clearColor : whiteColor;
	UIColor *textColor = self.selected ? whiteColor : blackColor;
	
	[backgroundColor set];
	CGContextFillRect(context, r);
	
	CGPoint p;
	p.x = 10;
	p.y = 10;
    [image drawAtPoint:p];
	
    p.x = ACHIEVEMENT_IMAGE_WIDTH + PADDING + PADDING_TEXT;
	p.y = PADDING;
	
	[textColor set];
	[achievement.name drawAtPoint:p withFont:nameFont];

	p.x += PADDING_TEXT;
	p.y += NAME_FONT_SIZE + PADDING_TEXT;
	[darkGrayColor set];
	[achievement.details drawInRect:CGRectMake(p.x, p.y, DETAILS_WIDTH, DETAILS_HEIGHT) withFont:detailsFont];

	
}

- (void)dealloc {
    [achievement release];
    [super dealloc];
}


@end
