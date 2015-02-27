//
//  JobTableViewCell.m
//  battleroyale
//
//  Created by Amit Matani on 1/30/09.
//  Copyright 2009 Miraphonic, Inc. All rights reserved.
//

#import "JobTableViewCell.h"
#import "Consts.h"
#import "Job.h"
#import "Item.h"
#import "ReusableRemoteImageStoreWithFileCache.h"
#import "Utility.h"
#import "BRAppDelegate.h"

@implementation JobTableViewCell

// padding declarations
#define PADDING 10
#define PADDING_TEXT 5

// job title
#define JOB_TITLE_FONT_SIZE 15
#define JOB_TITLE_WIDTH 230

// section headers
#define SECTION_FONT_SIZE 10
#define SECTION_WIDTH 90

// value sizes
#define	VALUE_FONT_SIZE 11
#define VALUE_WIDTH 90
#define VALUE_ITEM_WIDTH 25


@synthesize job, doJobDelegate;
 
static UIFont *jobNameFont, *valueFont, *sectionFont;
static UIColor *clearColor, *whiteColor, *blackColor, *subtitleColor;
static UIImage *doJobImage;
static CGRect doJobImageRect;
static NSString *requires, *rewards;

static UIColor *expColor, *energyColor, *moneyColor, *posseColor, *bossBgColor, *bossTitleColor;

/**
 * initialize in order to minimize the number of object allocations
 * in drawRect, we initialize common objects here.  They should be small
 * enough that they wont make a large memory footprint
 */
+ (void)initialize {
    if (self = [JobTableViewCell class]) {
        jobNameFont = [[UIFont boldSystemFontOfSize:JOB_TITLE_FONT_SIZE] retain];
		sectionFont = [[UIFont boldSystemFontOfSize:SECTION_FONT_SIZE] retain];
		valueFont = [[UIFont boldSystemFontOfSize:VALUE_FONT_SIZE] retain];
        doJobImage = [[UIImage imageNamed:@"do_job_button.png"] retain];
        doJobImageRect = CGRectZero;
		
		// color settings for static vars
		clearColor = [[UIColor clearColor] retain];
		whiteColor = [[UIColor whiteColor] retain];
		blackColor = [[UIColor blackColor] retain];
		subtitleColor = [[UIColor darkGrayColor] retain];	
		
		// this class specific static colors
		expColor =		(UIColor *) WEBCOLOR(0x0E4D91FF); // blueish
		moneyColor =	(UIColor *)	WEBCOLOR(0x217400FF); // greenish
		energyColor =	(UIColor *) WEBCOLOR(0xBE7500FF); // orangeish
		posseColor =	(UIColor *) WEBCOLOR(0x960000FF); // redish
		bossBgColor =	(UIColor *) WEBCOLOR(0xE2CDCDFF);
		bossTitleColor = (UIColor *) WEBCOLOR(0x6B0000FF); 
		
		[expColor retain];
		[moneyColor retain];
		[energyColor retain];
		[posseColor retain];
		[bossBgColor retain];
		[bossTitleColor retain];
		
		// static strings
		requires = [@"Requires" retain];
		rewards = [@"Rewards" retain];
		
		
    }
}

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) {
        itemImages = [[NSMutableArray alloc] initWithCapacity:3];
    }
    return self;
}

- (void)setJob:(Job *)_job {
    [job release];
    job = [_job retain];
	
	// requires items 
    
    // reset the arrays
    for (int i = 0; i < [itemImages count] || i < [job.requiresItems count]; i += 1) {
        if (i < [itemImages count]) {
            [itemImages replaceObjectAtIndex:i withObject:[NSNull null]];
        } else {
            [itemImages addObject:[NSNull null]];
        }
    } 
	if ([job.requiresItems count] > 0) {        
        ReusableRemoteImageStoreWithFileCache *imageStore = [[BRAppDelegate sharedManager] imageStoreWithFileCache];        
		for (int i = 0; i < [job.requiresItems count]; i++) {
			Item *item = (Item *) [job.requiresItems objectAtIndex:i];
			[imageStore getObjectWithKey:item.imageSquare25
								  target:self
								selector:@selector(setRequiredItemImage:withUrl:)];
		}
	}
	
    [self setNeedsDisplay];    
}

- (void)drawContentView:(CGRect)r {
    CGContextRef context = UIGraphicsGetCurrentContext();

	UIColor *backgroundColor = self.selected ? clearColor : whiteColor;
	UIColor *textColor = self.selected ? whiteColor : blackColor;	
	
	if (job.bossBotAnimalId && ![job.bossBotAnimalId isEqualToString:@"0"]) {
		[bossBgColor set];
	} else {
		[backgroundColor set];
	}
	
	CGContextFillRect(context, r);

	// starting point for all drawing
	NSString *string;
	CGPoint drawPoint;
	CGRect canvasRect;
	CGSize size;
	CGFloat xStart = 12;
	CGFloat yStart = 9;	
	
    drawPoint.x = xStart;
	drawPoint.y = yStart;
	
	// draw job title
	if (job.bossBotAnimalId && ![job.bossBotAnimalId isEqualToString:@"0"]) {
		[bossTitleColor set];
	} else {
		[textColor set];
	}
	canvasRect = CGRectMake(drawPoint.x, drawPoint.y, JOB_TITLE_WIDTH, JOB_TITLE_FONT_SIZE);
	[job.name drawInRect:canvasRect withFont:jobNameFont lineBreakMode:UILineBreakModeTailTruncation alignment:UITextAlignmentLeft];
	
	/*** DRAW SECTION TITLES - REWARDS / REQUIREMENTS ***/
	// setup intiial drawing position for Level key label
	canvasRect.origin.y += JOB_TITLE_FONT_SIZE + PADDING_TEXT;
	[subtitleColor set];
	[rewards drawInRect:canvasRect withFont:sectionFont lineBreakMode:UILineBreakModeTailTruncation alignment:UITextAlignmentLeft];
	
	canvasRect.origin.x += SECTION_WIDTH;
	[requires drawInRect:canvasRect withFont:sectionFont lineBreakMode:UILineBreakModeTailTruncation alignment:UITextAlignmentLeft];
	
	/*** DRAW REWARDS ***/
	// reset to intial drawing position and move down for rewards
	drawPoint.y = yStart + JOB_TITLE_FONT_SIZE + SECTION_FONT_SIZE +  PADDING_TEXT * 2;
	canvasRect = CGRectMake(drawPoint.x, drawPoint.y, VALUE_WIDTH, VALUE_FONT_SIZE);
	
	// draw EXP reward range
	if (![job.rewardExpFloor isEqualToString:job.rewardExpCeil]) {
		[expColor set];
		string = [[NSString alloc] initWithFormat:@"%@ - %@ EXP", job.rewardExpFloor, job.rewardExpCeil];
		size = [string drawInRect:canvasRect withFont:valueFont lineBreakMode:UILineBreakModeTailTruncation alignment:UITextAlignmentLeft];
		[string release];
	}
	canvasRect.origin.y += VALUE_FONT_SIZE + PADDING_TEXT;	
	
	// draw money reward range
	if (![job.rewardMoneyFloor isEqualToString:job.rewardMoneyCeil]) {
		[moneyColor set];
		string = [[NSString alloc] initWithFormat:@"¥%@ - ¥%@", job.rewardMoneyFloor, job.rewardMoneyCeil];
		size = [string drawInRect:canvasRect withFont:valueFont lineBreakMode:UILineBreakModeTailTruncation alignment:UITextAlignmentLeft];
		[string release];
	}
	
	canvasRect.origin.y += VALUE_FONT_SIZE + PADDING_TEXT;
	if ([job doesJobHaveRewardItem]) {
		[moneyColor set];
		CGRect tempRect = canvasRect;
		tempRect.size.width = tempRect.size.width * 2;
		string = @"Item Chance";
		size = [string drawInRect:tempRect withFont:valueFont lineBreakMode:UILineBreakModeTailTruncation alignment:UITextAlignmentLeft];
	}
	
	
	/*** DRAW JOB REQUIREMENTS ***/
	// reset to intial drawing position and move down for rewards
	drawPoint.y = yStart + JOB_TITLE_FONT_SIZE + SECTION_FONT_SIZE + PADDING_TEXT * 2;
	drawPoint.x = xStart + VALUE_WIDTH;
	canvasRect = CGRectMake(drawPoint.x, drawPoint.y, VALUE_WIDTH, VALUE_FONT_SIZE);
	
	if (job.requiresEnergy) {
		[energyColor set];
		string = [[NSString alloc] initWithFormat:@"%d Energy", job.requiresEnergy];
		size = [string drawInRect:canvasRect withFont:valueFont lineBreakMode:UILineBreakModeTailTruncation alignment:UITextAlignmentLeft];
		[string release];
	}
	canvasRect.origin.y += VALUE_FONT_SIZE + PADDING_TEXT;
	
	if (job.requiresMoney) {
		[moneyColor set];
		string = [[NSString	alloc] initWithFormat:@"¥%d", job.requiresMoney];
		size = [string drawInRect:canvasRect withFont:valueFont lineBreakMode:UILineBreakModeTailTruncation alignment:UITextAlignmentLeft];
		[string release];
	}
	
	canvasRect.origin.y += VALUE_FONT_SIZE + PADDING_TEXT;
	
	// enter posse size requirements here.
	if (job.requiresPosse) {
		[posseColor set];
		string = [[NSString alloc] initWithFormat:@"%d in Posse", job.requiresPosse];
		size = [string drawInRect:canvasRect withFont:valueFont lineBreakMode:UILineBreakModeTailTruncation alignment:UITextAlignmentLeft];
		[string release];
	}
	
	// SPECIAL CASE for required items.
	// reset to intial drawing position and move down for rewards
	drawPoint.y = yStart + JOB_TITLE_FONT_SIZE + SECTION_FONT_SIZE + PADDING_TEXT * 2;
	drawPoint.x = xStart + VALUE_WIDTH * 2 + PADDING_TEXT - VALUE_ITEM_WIDTH;
	canvasRect = CGRectMake(drawPoint.x, drawPoint.y, VALUE_ITEM_WIDTH, VALUE_ITEM_WIDTH);
	[subtitleColor set];
    for (int i = 0; i < [itemImages count]; i += 1) {  
        UIImage *image = [itemImages objectAtIndex:i];
        if ((id)image != [NSNull null]) {
            [image drawInRect:canvasRect];
            // here is the number
            NSString *numRequired = [[NSString alloc] initWithFormat:@"%@x req.", [job.requiredItemCounts objectForKey:[[job.requiresItems objectAtIndex:i] itemId]]];
			[numRequired drawInRect:CGRectMake(canvasRect.origin.x, drawPoint.y + VALUE_ITEM_WIDTH, VALUE_ITEM_WIDTH, VALUE_FONT_SIZE * 3)
                         withFont:valueFont lineBreakMode:UILineBreakModeTailTruncation alignment:UITextAlignmentCenter];
			[numRequired release];
        }
        canvasRect.origin.x += PADDING_TEXT + VALUE_ITEM_WIDTH;     
    }
	
	
	// the job's image
	if (doJobImageRect.size.height == 0) {
        doJobImageRect = CGRectMake(FRAME_WIDTH - PADDING - doJobImage.size.width,
                                    (self.frame.size.height - doJobImage.size.height) / 2,
                                    doJobImage.size.width,
                                    doJobImage.size.height);
    }
    
    [doJobImage drawInRect:doJobImageRect];
}


- (void)setRequiredItemImage:(UIImage *)_value withUrl:(NSString *)url {
    int i;
	for (i = 0; i < [job.requiresItems count]; i++) {
		Item *item = (Item *) [job.requiresItems objectAtIndex:i];
		if ([item.imageSquare25 isEqualToString:url]) {
            [itemImages replaceObjectAtIndex:i withObject:_value];
            break;
		}
	}
    
    // check to see if all the images are loaded and if so tell the table to redisplay
    for (i = 0; i < [job.requiresItems count]; i++) {
        if ([itemImages objectAtIndex:i] == [NSNull null]) {
            break;
        }
    }
    
    if (i == [job.requiresItems count]) {
        [self setNeedsDisplay];
    }
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (CGRectContainsPoint(doJobImageRect, [[touches anyObject] locationInView:self])) {
        // notify the doJobDelegate that we are attempting to do the job
        [doJobDelegate attemptToDoJob:job];
    }
    debug_NSLog(@"here2");
    [super touchesEnded:touches withEvent:event];
}

- (void)dealloc {
    ReusableRemoteImageStoreWithFileCache *imageStore = [[BRAppDelegate sharedManager] imageStoreWithFileCache];        
    [imageStore cancelDelayedActionOnTarget:self];
    
    [job release];
    [itemImages release];
    [super dealloc];
}


@end
