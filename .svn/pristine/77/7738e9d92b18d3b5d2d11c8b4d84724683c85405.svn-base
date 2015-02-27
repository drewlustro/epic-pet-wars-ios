/**
 * ChallengerTableViewCell.m
 * Copyright Miraphonic, Inc 2009. All rights reserved.
 *
 * @author Amit Matani 
 * @created 2/1/09.
 */

#import "ChallengerTableViewCell.h"
#import "Challenger.h"
#import "BRAppDelegate.h"
#import "Consts.h"
#import "ReusableRemoteImageStoreWithFileCache.h"


@implementation ChallengerTableViewCell

// padding declarations
#define PADDING 10
#define PADDING_TEXT 5

// challenger
#define PET_NAME_FONT_SIZE 11
#define PET_NAME_WIDTH 75.0
#define PET_IMAGE_WIDTH 50.0
#define PET_KEY_WIDTH 40.0
#define PET_KEY_FONT_SIZE 11
#define PET_VALUE_WIDTH 30.0
#define EQUIPMENT_IMAGE_SIZE 35.0

@synthesize challenger, animalImage, weaponImage,
			armorImage, accessory1Image, accessory2Image,
			battleDelegate;

static NSString *levelKey, *posseSizeKey, *winsKey, *lossesKey;
static UIFont *nameFont, *keyFont, *valueFont;
static UIImage *startBattleImage;
static CGRect startBattleImageRect;
static UIImage *weaponImagePlaceholder, *armorImagePlaceholder, *accessoryImagePlaceholder;

// super common colors
static UIColor *whiteColor, *blackColor, *darkGrayColor, *clearColor;

/**
 * initialize in order to minimize the number of object allocations
 * in drawRect, we initialize common objects here.  They should be small
 * enough that they wont make a large memory footprint
 */
+ (void)initialize {
    if (self = [Challenger class]) {
		// standard keys
		levelKey = [@"Level" retain];
		posseSizeKey = [@"Posse" retain];
		winsKey = [@"Wins" retain];  
		lossesKey = [@"Losses" retain];
		
		// fonts
        nameFont = [[UIFont boldSystemFontOfSize:PET_NAME_FONT_SIZE] retain];
		keyFont = [[UIFont boldSystemFontOfSize:PET_KEY_FONT_SIZE] retain];
		valueFont = [[UIFont boldSystemFontOfSize:PET_KEY_FONT_SIZE] retain];
		
		// start battle button
        startBattleImage = [[UIImage imageNamed:@"fight_button.png"] retain];
        startBattleImageRect = CGRectZero;
		
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

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) {
		
    }
    return self;
}

- (void)setChallenger:(Challenger *)_challenger {
    if (challenger == _challenger) { return; }
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    
    // reset the other stuff
    self.animalImage = nil;
    self.weaponImage = nil;
    self.armorImage = nil;
    self.accessory1Image = nil;
    self.accessory2Image = nil;
    
    
    [challenger release];
    challenger = [_challenger retain];
	
	ReusableRemoteImageStoreWithFileCache *imageStore = [[BRAppDelegate sharedManager] imageStoreWithFileCache];
	
	[imageStore getObjectWithKey:challenger.image
				target:self
				selector:@selector(setAnimalImage:withUrl:)];
    [self setNeedsDisplay];
	[self performSelector:@selector(loadItemImages) withObject:nil afterDelay:0];    
}

- (void)loadItemImages {
    ReusableRemoteImageStoreWithFileCache *imageStore = [[BRAppDelegate sharedManager] imageStoreWithFileCache];    
    [imageStore getObjectWithKey:challenger.weaponImage
                          target:self
                        selector:@selector(setWeaponImage:withUrl:)];
	
	[imageStore getObjectWithKey:challenger.armorImage
                          target:self
                        selector:@selector(setArmorImage:withUrl:)];
	
	[imageStore getObjectWithKey:challenger.accessory1Image
                          target:self
                        selector:@selector(setAccessory1Image:withUrl:)];
    
	[imageStore getObjectWithKey:challenger.accessory2Image
                          target:self
                        selector:@selector(setAccessory2Image:withUrl:)];
}

- (void)setAnimalImage:(UIImage *)_value withUrl:(NSString *)url {
	if ([challenger.image isEqualToString:url]) {
        self.animalImage = _value;
		[self postImageLoad]; 
	} 
}

- (void)setWeaponImage:(UIImage *)_value withUrl:(NSString *)url {
	if ([challenger.weaponImage isEqualToString:url]) {	
        self.weaponImage = _value;
		[self postImageLoad]; 
	}
}

- (void)setArmorImage:(UIImage *)_value withUrl:(NSString *)url {
	if ([challenger.armorImage isEqualToString:url]) {	
        self.armorImage = _value;
		[self postImageLoad]; 
	}
}

- (void)setAccessory1Image:(UIImage *)_value withUrl:(NSString *)url {
	if ([challenger.accessory1Image isEqualToString:url]) {
        self.accessory1Image = _value;
		[self postImageLoad]; 
	}
}

- (void)setAccessory2Image:(UIImage *)_value withUrl:(NSString *)url {
	if ([challenger.accessory2Image isEqualToString:url]) {	
        self.accessory2Image = _value;
		[self postImageLoad]; 
	}
}

// tell the cell to redisplay after all images have been loaded
- (void)postImageLoad {
    if (((challenger.image == nil || [challenger.image isEqualToString:@""]) || animalImage != nil) &&
        ((challenger.weaponImage == nil || [challenger.weaponImage isEqualToString:@""]) || weaponImage != nil) &&
        ((challenger.armorImage == nil || [challenger.armorImage isEqualToString:@""]) || armorImage != nil) &&
        ((challenger.accessory1Image == nil || [challenger.accessory1Image isEqualToString:@""]) || accessory1Image != nil) &&
        ((challenger.accessory2Image == nil || [challenger.accessory2Image isEqualToString:@""]) || accessory2Image != nil)) {
        [self setNeedsDisplay];
    }
}


- (void)drawContentView:(CGRect)r {
    CGContextRef context = UIGraphicsGetCurrentContext();
	
	// text colors / background colors for selection
	UIColor *backgroundColor = self.selected ? clearColor : whiteColor;
	UIColor *textColor = self.selected ? whiteColor : blackColor;
	UIColor *keyColor = darkGrayColor;
	UIColor *valueColor = blackColor;
	
	[backgroundColor set];
	CGContextFillRect(context, r);
	
	// starting point for all drawing
	CGPoint drawPoint;
	CGFloat xStart = 12;
	CGFloat yStart = 9;	

    drawPoint.x = xStart;
	drawPoint.y = yStart;

	// draw the challenger image
	if (animalImage) {
		[animalImage drawAtPoint:drawPoint];
    }
	
	// draw the challenger name.
	drawPoint.y += PET_IMAGE_WIDTH + PADDING_TEXT;
	[textColor set];
	CGRect nameRect = CGRectMake(drawPoint.x, drawPoint.y, PET_IMAGE_WIDTH, PET_NAME_FONT_SIZE * 3);
	[challenger.name drawInRect:nameRect withFont:nameFont lineBreakMode:UILineBreakModeCharacterWrap alignment:UITextAlignmentCenter];
	
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
	
	[challenger.level drawInRect:valueRect withFont:valueFont lineBreakMode:UILineBreakModeTailTruncation alignment:UITextAlignmentRight];
	// adjust Y for Posse value
	valueRect.origin.y += PET_KEY_FONT_SIZE + PADDING_TEXT;
	[challenger.posseSize drawInRect:valueRect withFont:valueFont lineBreakMode:UILineBreakModeTailTruncation alignment:UITextAlignmentRight];
	
	// adjust XY for wins value
	valueRect.origin.y -= PET_KEY_FONT_SIZE + PADDING_TEXT;
	valueRect.origin.x += (PET_KEY_WIDTH + PADDING_TEXT) * 2;
	[challenger.wins drawInRect:valueRect withFont:valueFont lineBreakMode:UILineBreakModeTailTruncation alignment:UITextAlignmentRight];
	
	// adjust Y for losses value
	valueRect.origin.y += PET_KEY_FONT_SIZE + PADDING_TEXT;
	[challenger.losses drawInRect:valueRect withFont:valueFont lineBreakMode:UILineBreakModeTailTruncation alignment:UITextAlignmentRight];

	
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
	} else if (challenger.weaponImage != nil && ![challenger.weaponImage isEqualToString:@""]) {
		// need to somehow get rid of the weapon image here
        [weaponImagePlaceholder drawInRect:weaponImageRect];        
	}
	
	drawPoint.x += EQUIPMENT_IMAGE_SIZE + PADDING_TEXT;
	
    CGRect armorImageRect = CGRectMake(drawPoint.x, drawPoint.y, EQUIPMENT_IMAGE_SIZE, EQUIPMENT_IMAGE_SIZE);
	if (armorImage) {
		[armorImage drawInRect:armorImageRect];
	} else if (challenger.armorImage != nil && ![challenger.armorImage isEqualToString:@""]) {
		// need to somehow get rid of the weapon image here
        [armorImagePlaceholder drawInRect:armorImageRect];        
	}
	
	drawPoint.x += EQUIPMENT_IMAGE_SIZE + PADDING_TEXT;
    
    CGRect accessory1ImageRect = CGRectMake(drawPoint.x, drawPoint.y, EQUIPMENT_IMAGE_SIZE, EQUIPMENT_IMAGE_SIZE);
	if (accessory1Image) {
		[accessory1Image drawInRect:accessory1ImageRect];
	} else if (challenger.accessory1Image != nil && ![challenger.accessory1Image isEqualToString:@""]) {
		// need to somehow get rid of the weapon image here
        [accessoryImagePlaceholder drawInRect:accessory1ImageRect];        
	}
    
	drawPoint.x += EQUIPMENT_IMAGE_SIZE + PADDING_TEXT;
	
    CGRect accessory2ImageRect = CGRectMake(drawPoint.x, drawPoint.y, EQUIPMENT_IMAGE_SIZE, EQUIPMENT_IMAGE_SIZE);
	if (accessory2Image) {
		[accessory2Image drawInRect:accessory2ImageRect];
	} else if (challenger.accessory2Image != nil && ![challenger.accessory2Image isEqualToString:@""]) {
		// need to somehow get rid of the weapon image here
        [accessoryImagePlaceholder drawInRect:accessory2ImageRect];
	}
	
	
	// draw the FIGHT button
	if (startBattleImageRect.size.height == 0) {
        startBattleImageRect = CGRectMake(FRAME_WIDTH - PADDING - startBattleImage.size.width,
                                    (self.frame.size.height - startBattleImage.size.height) / 2,
                                    startBattleImage.size.width,
                                    startBattleImage.size.height);
    }
    
    [startBattleImage drawInRect:startBattleImageRect];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (CGRectContainsPoint(startBattleImageRect, [[touches anyObject] locationInView:self])) {
        // notify the doJobDelegate that we are attempting to do the job
        [battleDelegate startBattleWithChallenger:challenger];
    }
    debug_NSLog(@"here2");
    [super touchesEnded:touches withEvent:event];
}


- (void)dealloc {
    ReusableRemoteImageStoreWithFileCache *imageStore = [[BRAppDelegate sharedManager] imageStoreWithFileCache];        
    [imageStore cancelDelayedActionOnTarget:self];
    
    debug_NSLog(@"deallocing challenger table view cell");
    [challenger release];
	[animalImage release];
    [weaponImage release];
    [armorImage release];
    [accessory1Image release];
    [accessory2Image release];   
    [super dealloc];
}


@end
