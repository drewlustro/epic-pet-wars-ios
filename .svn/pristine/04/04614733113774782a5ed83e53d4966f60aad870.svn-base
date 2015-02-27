/**
 * UserAnimalTableViewCell.m
 * Copyright Miraphonic, Inc 2009. All rights reserved.
 *
 * @author Amit Matani 
 * @created 2/11/09.
 */

#import "UserAnimalTableViewCell.h"
#import "Animal.h"
#import "Consts.h"

#define BUTTON_WIDTH 60
#define PADDING 5

@implementation UserAnimalTableViewCell

static UIImage *usePetButton;
/**
 * initialize in order to minimize the number of object allocations
 * in drawRect, we initialize common objects here.  They should be small
 * enough that they wont make a large memory footprint
 */
+ (void)initialize {
    if (self = [UserAnimalTableViewCell class]) {
        usePetButton = [[UIImage imageNamed:@"use_pet_button.png"] retain];
    }
}

- (void)drawContentView:(CGRect)r {
	[super drawContentView:r];
	
	CGPoint p;
	p.x = FRAME_WIDTH - BUTTON_WIDTH - PADDING * 2;
	p.y = PADDING * 3;
	
    if (!self.editing) {
        [usePetButton drawAtPoint:p];	
    }
}

- (void)dealloc {
    
    [super dealloc];
}


@end
