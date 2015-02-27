/**
 * ABTableViewCellWithSingleRemoteImage.h
 * Copyright Miraphonic, Inc 2009. All rights reserved.
 *
 * ABTableViewCellWithSingleRemoteImage is a base class for
 * table cells that have a single remote image.  This class is required
 * because an image may not load before the table cell containing it is 
 * scrolled off screen and used to load another image.  This protects against
 * late flickering of images or wrong images showing up.
 *
 * @author Amit Matani
 * @created 1/15/09
 */

#import "ABTableViewCellWithSingleRemoteImage.h"


@implementation ABTableViewCellWithSingleRemoteImage
@synthesize image, imageUrl;

- (void)setImage:(UIImage *)_value withUrl:(NSString *)url {
    if ([url isEqualToString:imageUrl]) {
        self.image = _value;        
	}
}

- (void)setImage:(UIImage *)_value {
    [image release];
    image = [_value retain];
    [self setNeedsDisplay];    
}

- (void)setImageUrl:(NSString *)_imageUrl {
    self.image = nil;
    [imageUrl release];
    imageUrl = [_imageUrl copy];
}

- (void)dealloc {
	[image release];
    [imageUrl release];
	[super dealloc];
}

@end
