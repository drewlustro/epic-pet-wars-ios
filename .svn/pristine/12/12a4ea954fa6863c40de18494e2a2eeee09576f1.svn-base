/**
 * AnimalTableViewCell.m
 * Copyright Miraphonic, Inc 2009. All rights reserved.
 *
 * @author Amit Matani 
 * @created 2/11/09.
 */

#import "AnimalTableViewCell.h"
#import "Animal.h"
#import "BRAppDelegate.h"
#import "Item.h"
#import "ReusableRemoteImageStoreWithFileCache.h"

#define PADDING 10
#define PADDING_TEXT 5

#define PET_NAME_FONT_SIZE 11
#define PET_NAME_WIDTH 75.0
#define PET_IMAGE_WIDTH 50.0
#define PET_KEY_WIDTH 40.0
#define PET_KEY_FONT_SIZE 11
#define PET_VALUE_WIDTH 30.0
#define EQUIPMENT_IMAGE_SIZE 35.0

@implementation AnimalTableViewCell

static NSString *levelKey, *posseSizeKey, *winsKey, *lossesKey;
static UIFont *nameFont, *keyFont, *valueFont;

// super common colors
static UIColor *whiteColor, *blackColor, *darkGrayColor, *clearColor;
static UIImage *weaponImagePlaceholder, *armorImagePlaceholder, *accessoryImagePlaceholder;

@synthesize animal;
/**
 * initialize in order to minimize the number of object allocations
 * in drawRect, we initialize common objects here.  They should be small
 * enough that they wont make a large memory footprint
 */
+ (void)initialize {
    if (self = [AnimalTableViewCell class]) {
        // standard keys
		levelKey = [@"Level" retain];
		posseSizeKey = [@"Posse" retain];
		winsKey = [@"Wins" retain];
		lossesKey = [@"Losses" retain];
        
        // fonts
        nameFont = [[UIFont boldSystemFontOfSize:PET_NAME_FONT_SIZE] retain];
		keyFont = [[UIFont boldSystemFontOfSize:PET_KEY_FONT_SIZE] retain];
		valueFont = [[UIFont boldSystemFontOfSize:PET_KEY_FONT_SIZE] retain];
		
		// super-common colors for every custom table view cell class
		whiteColor = [[UIColor whiteColor] retain];
		blackColor = [[UIColor blackColor] retain];
		darkGrayColor = [[UIColor darkGrayColor] retain]; 
		clearColor = [[UIColor clearColor] retain];

        
        weaponImagePlaceholder = [[UIImage imageNamed:@"weapon_icon.png"] retain];
        armorImagePlaceholder = [[UIImage imageNamed:@"armor_icon.png"] retain];
        accessoryImagePlaceholder = [[UIImage imageNamed:@"accessory_icon.png"] retain];
    }
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    [self setNeedsDisplay];
}


- (void)drawContentView:(CGRect)r {
    CGContextRef context = UIGraphicsGetCurrentContext();

	UIColor *backgroundColor = self.selected ? clearColor : whiteColor;
	UIColor *textColor = self.selected ? whiteColor : blackColor;
	UIColor *valueColor = blackColor;
    UIColor *keyColor = darkGrayColor;
	
	[backgroundColor set];
	CGContextFillRect(context, r);
    
    // starting point for all drawing
	CGPoint drawPoint;
	CGFloat xStart = [self getStartX];
	CGFloat yStart = 9;	    
    
    drawPoint.x = xStart;
	drawPoint.y = yStart;
    
    // draw the challenger image
	if (animalImage) {
		[animalImage drawAtPoint:drawPoint];
    }
	
	// draw the name.
	drawPoint.y += PET_IMAGE_WIDTH + PADDING_TEXT;
	[textColor set];
	CGRect nameRect = CGRectMake(drawPoint.x, drawPoint.y, PET_IMAGE_WIDTH, PET_NAME_FONT_SIZE * 3);
	[animal.name drawInRect:nameRect withFont:nameFont lineBreakMode:UILineBreakModeCharacterWrap alignment:UITextAlignmentCenter];
	
	/**
	 ** Draw Keys
	 ** This area draws all the key names for the values about the target animal
	 ** and aligns them into appropriate rectangles. UILabel conveniences not abound.
	 */
	drawPoint.x = xStart;
	drawPoint.y = yStart;
	drawPoint.x += PET_IMAGE_WIDTH + PADDING;
	[keyColor set];
	CGRect keyRect;
	
	// setup intiial drawing position for Level key label
	keyRect = CGRectMake(drawPoint.x, drawPoint.y, PET_KEY_WIDTH, PET_KEY_FONT_SIZE);
	[levelKey drawInRect:keyRect withFont:keyFont lineBreakMode:UILineBreakModeTailTruncation alignment:UITextAlignmentLeft];
	
	// adjust Y for Posse Key label
	keyRect.origin.y += PET_KEY_FONT_SIZE + PADDING_TEXT; 
	[posseSizeKey drawInRect:keyRect withFont:keyFont lineBreakMode:UILineBreakModeTailTruncation alignment:UITextAlignmentLeft];
    
	// adjust XY for Wins Key label
	keyRect.origin.y -= PET_KEY_FONT_SIZE + PADDING_TEXT;
	keyRect.origin.x += PET_KEY_WIDTH + PET_VALUE_WIDTH + (PADDING_TEXT * 2);
	[winsKey drawInRect:keyRect withFont:keyFont lineBreakMode:UILineBreakModeTailTruncation alignment:UITextAlignmentLeft];
	
	// adjust Y for Losses Key label
	keyRect.origin.y += PET_KEY_FONT_SIZE + PADDING_TEXT; 
	[lossesKey drawInRect:keyRect withFont:keyFont lineBreakMode:UILineBreakModeTailTruncation alignment:UITextAlignmentLeft];
	
	
	/**
	 ** Draw Values
	 ** After Drawing the keys, we need the values for each table cell, so this
	 ** set of commands sets all the appropriate values in the correct colors, alignment, etc.
	 **/
	
	[valueColor set];
	CGRect valueRect;
	
	// setup intial drawing position for Level value
	valueRect = CGRectMake(drawPoint.x, drawPoint.y, PET_VALUE_WIDTH, PET_KEY_FONT_SIZE);
	valueRect.origin.x += PET_KEY_WIDTH;
	
    NSString *level = [[NSString alloc] initWithFormat:@"%d", animal.level];
	[level drawInRect:valueRect withFont:valueFont lineBreakMode:UILineBreakModeTailTruncation alignment:UITextAlignmentRight];
    [level release];
	// adjust Y for Posse value
	valueRect.origin.y += PET_KEY_FONT_SIZE + PADDING_TEXT;
    
    NSString *posseSize = [[NSString alloc] initWithFormat:@"%d", animal.posseSize];
	[posseSize drawInRect:valueRect withFont:valueFont lineBreakMode:UILineBreakModeTailTruncation alignment:UITextAlignmentRight];
    [posseSize release];
	
	// adjust XY for wins value
	valueRect.origin.y -= PET_KEY_FONT_SIZE + PADDING_TEXT;
	valueRect.origin.x += (PET_KEY_WIDTH + PADDING_TEXT) * 2;
	[animal.wins drawInRect:valueRect withFont:valueFont lineBreakMode:UILineBreakModeTailTruncation alignment:UITextAlignmentRight];
	
	// adjust Y for losses value
	valueRect.origin.y += PET_KEY_FONT_SIZE + PADDING_TEXT;
	[animal.losses drawInRect:valueRect withFont:valueFont lineBreakMode:UILineBreakModeTailTruncation alignment:UITextAlignmentRight];
    
	
	/**
	 ** Equipment Display
	 ** If the target animal has some equipment, we need to display it here
	 */
	
	// setup initial position for equipment row
	drawPoint.x = xStart + PET_IMAGE_WIDTH + PADDING;
	drawPoint.y = yStart + PADDING + (PET_KEY_FONT_SIZE + PADDING_TEXT) * 2;
	
    CGRect weaponImageRect = CGRectMake(drawPoint.x, drawPoint.y, EQUIPMENT_IMAGE_SIZE, EQUIPMENT_IMAGE_SIZE);
	if (weaponImage) {
		[weaponImage drawInRect:weaponImageRect];
	} else if (animal.weapon != nil) {
		// need to somehow get rid of the weapon image here
        [weaponImagePlaceholder drawInRect:weaponImageRect];
	}
	
	drawPoint.x += EQUIPMENT_IMAGE_SIZE + PADDING_TEXT;
	
    CGRect armorImageRect = CGRectMake(drawPoint.x, drawPoint.y, EQUIPMENT_IMAGE_SIZE, EQUIPMENT_IMAGE_SIZE);
	if (armorImage) {
		[armorImage drawInRect:armorImageRect];
	} else if (animal.armor != nil) {
		// need to somehow get rid of the armor image here
		[armorImagePlaceholder drawInRect:armorImageRect];        
	}
	
	drawPoint.x += EQUIPMENT_IMAGE_SIZE + PADDING_TEXT;
	
    CGRect accessory1ImageRect = CGRectMake(drawPoint.x, drawPoint.y, EQUIPMENT_IMAGE_SIZE, EQUIPMENT_IMAGE_SIZE);
	if (accessory1Image) {
		[accessory1Image drawInRect:accessory1ImageRect];
	} else if (animal.accessory1 != nil) {
        [accessoryImagePlaceholder drawInRect:accessory1ImageRect];
	}
	
	drawPoint.x += EQUIPMENT_IMAGE_SIZE + PADDING_TEXT;

    CGRect accessory2ImageRect = CGRectMake(drawPoint.x, drawPoint.y, EQUIPMENT_IMAGE_SIZE, EQUIPMENT_IMAGE_SIZE);
	if (accessory2Image) {
		[accessory2Image drawInRect:accessory2ImageRect];
	} else if (animal.accessory2 != nil) {
        [accessoryImagePlaceholder drawInRect:accessory2ImageRect];
	}
    
}

- (void)setAnimal:(Animal *)_animal {
    if (animal == _animal) { return; }
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    
    [animalImage release];
    animalImage = nil;
    [weaponImage release];
    weaponImage = nil;
    [armorImage release];
    armorImage = nil;
    [accessory1Image release];
    accessory1Image = nil;
    [accessory2Image release];
    accessory2Image = nil;
    
	[animal release];
	animal = [_animal retain];
	
	ReusableRemoteImageStoreWithFileCache *imageStore = [[BRAppDelegate sharedManager] imageStoreWithFileCache];
	
	[imageStore getObjectWithKey:animal.imageSquare50
						  target:self
						selector:@selector(setAnimalImage:withUrl:)];
    [self setNeedsDisplay];    
	[self performSelector:@selector(loadItemImages) withObject:nil afterDelay:0];
}

- (void)loadItemImages {
	ReusableRemoteImageStoreWithFileCache *imageStore = [[BRAppDelegate sharedManager] imageStoreWithFileCache];    
    [imageStore getObjectWithKey:animal.weapon.imageSquare35
						  target:self
						selector:@selector(setWeaponImage:withUrl:)];
	
	[imageStore getObjectWithKey:animal.armor.imageSquare35
						  target:self
						selector:@selector(setArmorImage:withUrl:)];
	
	[imageStore getObjectWithKey:animal.accessory1.imageSquare35
						  target:self
						selector:@selector(setAccessory1Image:withUrl:)];
	
	[imageStore getObjectWithKey:animal.accessory2.imageSquare35
						  target:self
						selector:@selector(setAccessory2Image:withUrl:)];
}

// tell the cell to redisplay after all images have been loaded
- (void)postImageLoad {
    if (((animal.imageSquare50 == nil || [animal.imageSquare50 isEqualToString:@""]) || animalImage != nil) &&
        ((animal.weapon.imageSquare35 == nil || [animal.weapon.imageSquare35 isEqualToString:@""]) || weaponImage != nil) &&
        ((animal.armor.imageSquare35 == nil || [animal.armor.imageSquare35 isEqualToString:@""]) || armorImage != nil) &&
        ((animal.accessory1.imageSquare35 == nil || [animal.accessory1.imageSquare35 isEqualToString:@""]) || accessory1Image != nil) &&
        ((animal.accessory2.imageSquare35 == nil || [animal.accessory2.imageSquare35 isEqualToString:@""]) || accessory2Image != nil)) {
        //        [self performSelector:@selector(setNeedsDisplay) withObject:nil afterDelay:1];
        [self setNeedsDisplay];
    }
}

- (void)setAnimalImage:(UIImage *)_value withUrl:(NSString *)url {
	if ([animal.imageSquare50 isEqualToString:url]) {
		[animalImage release];
		animalImage = [_value retain];
		[self postImageLoad]; 
	}
}

- (void)setWeaponImage:(UIImage *)_value withUrl:(NSString *)url {
	if ([animal.weapon.imageSquare35 isEqualToString:url]) {	
		[weaponImage release];
		weaponImage = [_value retain];
		[self postImageLoad];    
	}
}

- (void)setArmorImage:(UIImage *)_value withUrl:(NSString *)url {
	if ([animal.armor.imageSquare35 isEqualToString:url]) {	
		[armorImage release];
		armorImage = [_value retain];
		[self postImageLoad];
	}
}

- (void)setAccessory1Image:(UIImage *)_value withUrl:(NSString *)url {
	if ([animal.accessory1.imageSquare35 isEqualToString:url]) {	
		[accessory1Image release];
		accessory1Image = [_value retain];
		[self postImageLoad];    
	}
}

- (void)setAccessory2Image:(UIImage *)_value withUrl:(NSString *)url {
	if ([animal.accessory2.imageSquare35 isEqualToString:url]) {	
		[accessory2Image release];
		accessory2Image = [_value retain];
		[self postImageLoad];    
	}
}

- (CGFloat)getStartX {
    if (self.editing) {
        return 40;
    }
    return 12;
}

- (void)dealloc {
    ReusableRemoteImageStoreWithFileCache *imageStore = [[BRAppDelegate sharedManager] imageStoreWithFileCache];        
    [imageStore cancelDelayedActionOnTarget:self];
    
    
    [accessory1Image release];
    [accessory2Image release];
    [weaponImage release];
    [armorImage release];
    [animalImage release];
    [animal release];
    [super dealloc];
}


@end
