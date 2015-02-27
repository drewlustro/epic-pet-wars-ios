/**
 * TopAnimalTableViewCell.m
 * Copyright Miraphonic, Inc 2009. All rights reserved.
 *
 * @author Amit Matani 
 * @created 3/10/09.
 */

#import "TopAnimalTableViewCell.h"
#import "Consts.h"

#define PADDING 5
#define RANK_FONT_SIZE 40
#define RANK_WIDTH 60

@implementation TopAnimalTableViewCell
@synthesize rank = _rank;

static UIFont *rankFont;
static UIColor *grayColor;

/**
 * initialize in order to minimize the number of object allocations
 * in drawRect, we initialize common objects here.  They should be small
 * enough that they wont make a large memory footprint
 */
+ (void)initialize {
    if (self = [AnimalTableViewCell class]) {        
        // fonts
        rankFont = [[UIFont boldSystemFontOfSize:RANK_FONT_SIZE] retain];		
		// super-common colors for every custom table view cell class
		grayColor = [[UIColor grayColor] retain]; 
    }
}

- (void)drawContentView:(CGRect)r {
	[super drawContentView:r];	

	// starting point for all drawing
	CGPoint drawPoint;
	CGFloat xStart = 4;
	CGFloat yStart = 22;	    
    
    drawPoint.x = xStart;
	drawPoint.y = yStart;
	
	// setup string since rank is an integer
	NSString *rankString = [[NSString alloc] initWithFormat:@"%d", _rank];
	
	// draw the name.
	[grayColor set];
	CGRect rankRect = CGRectMake(drawPoint.x, drawPoint.y, RANK_WIDTH, RANK_FONT_SIZE * 2);
	[rankString drawInRect:rankRect withFont:rankFont lineBreakMode:UILineBreakModeCharacterWrap alignment:UITextAlignmentCenter];
	[rankString release];
}

- (void)setRank:(NSInteger)rank {
    _rank = rank;
    [self setNeedsDisplay];
}

- (CGFloat)getStartX {
    return 70;
}

- (void)dealloc {

    [super dealloc];
}


@end
