/**
 * Achievement.m
 * Copyright Miraphonic, Inc 2009. All rights reserved.
 *
 * @author Amit Matani 
 * @created 2/4/09.
 */

#import "Achievement.h"


@implementation Achievement
@synthesize name, details, numAwarded, achievementId,
			// images
			image, imageSquare25, imageSquare50, imageSquare75;

static NSDictionary *fieldMap;

+ (void)initialize {
    if (self = [Achievement class]) {
		fieldMap = [[NSDictionary alloc] initWithObjectsAndKeys:
					@"setAchievementId:", @"id",
                    @"setName:", @"name",
                    @"setDetails:", @"details",
                    @"setImage:", @"image",
					@"setImageSquare25:", @"image_square_25",
					@"setImageSquare50:", @"image_square_50",
					@"setImageSquare75:", @"image_square_75",
                    @"setNumAwarded:", @"num_awarded",
					nil
					];
	}
}

+ (NSDictionary *)GetFieldMapHelper {
    return fieldMap;
}

- (void)dealloc {
	[achievementId release];
	[name release];
	[details release];
	[image release];
	[imageSquare25 release];
	[imageSquare50 release];
	[imageSquare75 release];
	[numAwarded release];	
	[super dealloc];
}
@end
