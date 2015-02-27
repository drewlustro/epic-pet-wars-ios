/**
 * Challenger.m
 * Copyright Miraphonic, Inc 2009. All rights reserved.
 *
 * @author Amit Matani 
 * @created 2/1/09.
 */

#import "Challenger.h"
#import "Consts.h"


@implementation Challenger
static NSDictionary *fieldMap;

@synthesize animalId, animalTypeId, animalTypeName, level, posseSize, wins, losses, weaponImage, 
			armorImage, accessory1Image, accessory2Image, name, image, isBot;


+ (void)initialize {
    if (self = [Challenger class]) {
        if (fieldMap == nil) {
			fieldMap = [[NSDictionary alloc] initWithObjectsAndKeys:
							@"setAnimalId:", @"animal_id",
							@"setAnimalTypeId:", @"animal_type_id",
							@"setAnimalTypeName:", @"animal_type_name",
							@"setWeaponImage:", @"weapon_image",
							@"setArmorImage:", @"armor_image",
							@"setAccessory1Image:", @"accessory_1_image",
							@"setAccessory2Image:", @"accessory_2_image",
							@"setName:", @"name",
							@"setLevel:", @"level",
							@"setWins:", @"total_wins",
							@"setLosses:", @"total_losses",
							@"setPosseSize:", @"posse_size",
							@"setImage:", @"image",							
							@"setIsBot:", @"is_bot",
							nil
						];
		}
	}
}

+ (NSDictionary *)GetFieldMapHelper {
    return fieldMap;
}

- (void)dealloc {
    debug_NSLog(@"deallocing challenger");
	[animalId release];
	[animalTypeId release];
	[animalTypeName release];
	[level release];
	[posseSize release];
	[wins release];
	[losses release];
	[weaponImage release];
	[armorImage release];
	[accessory1Image release];
	[accessory2Image release];
	[name release];
	[image release];
	[isBot release];
	[super dealloc];
}


@end
