/**
 * PosseAnimalTableViewCell.m
 * Copyright Miraphonic, Inc 2009. All rights reserved.
 *
 * @author Amit Matani 
 * @created 2/9/09.
 */

#import "PosseAnimalTableViewCell.h"
#import "Item.h"
#import "Animal.h"
#import "BRAppDelegate.h"
#import "Consts.h"

@implementation PosseAnimalTableViewCell
static UIImage *viewProfileImage;
/**
 * initialize in order to minimize the number of object allocations
 * in drawRect, we initialize common objects here.  They should be small
 * enough that they wont make a large memory footprint
 */
+ (void)initialize {
    if (self = [PosseAnimalTableViewCell class]) {
		viewProfileImage = [[UIImage imageNamed:@"view_profile_button.png"] retain]; 
    }
}


- (void)drawContentView:(CGRect)r {
    
#define BUTTON_WIDTH 60
#define PADDING 5
    
    [super drawContentView:r];
    
    CGPoint p;
	p.x = FRAME_WIDTH - BUTTON_WIDTH - PADDING;
	p.y = PADDING * 3;
    if (!self.editing) {	
        [viewProfileImage drawAtPoint:p];
    }
}

- (void)dealloc {    
    [super dealloc];
}


@end
