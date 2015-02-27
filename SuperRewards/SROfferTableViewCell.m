/*
 * Copyright 2009 Miraphonic
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 *    http://www.apache.org/licenses/LICENSE-2.0
 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#import "SuperRewards/SRGlobal.h"
#import "SuperRewards/SROffer.h"
#import "SROfferTableViewCell.h"


#define NAME_FONT_SIZE 13
#define DESCRIPTION_FONT_SIZE 12
#define POINTS_FONT_SIZE 20
#define CURRENCY_FONT_SIZE 12.0
#define	CURRENCY_MIN_FONT_SIZE 8.0

@implementation SROfferTableViewCell
@synthesize offer, currency;

static UIFont *nameFont, *descriptionFont, *pointsFont, *currencyFont;
static UIColor *whiteColor, *blackColor, *darkGrayColor, *clearColor, *greenColor;

/**
 * initialize in order to minimize the number of object allocations
 * in drawRect, we initialize common objects here.  They should be small
 * enough that they wont make a large memory footprint
 */
+ (void)initialize {
    if (self = [SROfferTableViewCell class]) {
        nameFont = [[UIFont boldSystemFontOfSize:NAME_FONT_SIZE] retain];        
        descriptionFont = [[UIFont systemFontOfSize:DESCRIPTION_FONT_SIZE] retain];                
        pointsFont = [[UIFont boldSystemFontOfSize:POINTS_FONT_SIZE] retain];   
		currencyFont = [[UIFont boldSystemFontOfSize:CURRENCY_FONT_SIZE] retain];
        
		// super-common colors for every custom table view cell class
		whiteColor = [[UIColor whiteColor] retain];
		blackColor = [[UIColor blackColor] retain];
		darkGrayColor = [[UIColor darkGrayColor] retain]; 
		clearColor = [[UIColor clearColor] retain];
		greenColor = WEBCOLOR(0x2B6300FF);
		[greenColor retain];
    }
}

- (void)setOffer:(SROffer *)_offer {
    [offer release];
    offer = [_offer retain];
    [self setNeedsDisplay];
}

- (void)drawContentView:(CGRect)r {
    CGContextRef context = UIGraphicsGetCurrentContext();

	UIColor *backgroundColor = whiteColor;
	UIColor *textColor = blackColor;
	
	if (self.selected) {
		backgroundColor = clearColor;
		textColor = whiteColor;
	}
	
	[backgroundColor set];
	CGContextFillRect(context, r);
	
    [textColor set];
#define PADDING 10
#define RESEPCT_WIDTH 60
    float xOffset = PADDING;
    float yOffset = PADDING;
    
    CGSize s = [offer.name drawInRect:CGRectMake(xOffset, yOffset, self.frame.size.width - 2 * xOffset, NAME_FONT_SIZE * 2) withFont:nameFont lineBreakMode:UILineBreakModeWordWrap alignment:UITextAlignmentLeft];
    
    yOffset += s.height + PADDING / 2;
    s = [offer.description drawInRect:CGRectMake(xOffset, yOffset, self.frame.size.width - xOffset - PADDING * 2 - RESEPCT_WIDTH, 
                                                 self.frame.size.height - yOffset - PADDING / 2) withFont:descriptionFont lineBreakMode:UILineBreakModeWordWrap alignment:UITextAlignmentLeft];
    xOffset = self.frame.size.width - xOffset - RESEPCT_WIDTH;
    
	[greenColor set];
    s = [[NSString stringWithFormat:@"%d", offer.payout] drawInRect:CGRectMake(xOffset, yOffset, self.frame.size.width - xOffset - PADDING, 
                                                                               POINTS_FONT_SIZE + PADDING) withFont:pointsFont
                                                      lineBreakMode:UILineBreakModeWordWrap alignment:UITextAlignmentCenter];
	yOffset += s.height;
	
	s = [currency drawInRect:CGRectMake(xOffset, yOffset, self.frame.size.width - xOffset - PADDING, 
										CURRENCY_FONT_SIZE * 3) withFont:currencyFont
			   lineBreakMode:UILineBreakModeWordWrap alignment:UITextAlignmentCenter];
	/*
	CGFloat actual = 0.0;
	CGFloat *actualPtr = &actual;
	
	s = [currency drawAtPoint:CGPointMake(xOffset, yOffset) forWidth:(self.frame.size.width - xOffset - PADDING) 
					withFont:currencyFont minFontSize:CURRENCY_MIN_FONT_SIZE actualFontSize:actualPtr lineBreakMode:UILineBreakModeWordWrap 
					baselineAdjustment:UIBaselineAdjustmentAlignCenters];
	*/
	
}

- (void)dealloc {
    [currency release];
    [offer release];
    [super dealloc];
}


@end
