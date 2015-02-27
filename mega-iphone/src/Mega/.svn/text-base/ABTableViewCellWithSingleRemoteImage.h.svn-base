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

#import <UIKit/UIKit.h>
#import "ABTableViewCell.h"

@interface ABTableViewCellWithSingleRemoteImage : ABTableViewCell {
    NSString *imageUrl;
    UIImage *image;
}
@property (nonatomic, copy) NSString *imageUrl;
@property (nonatomic, retain) UIImage *image;

/**
 * setImage:withUrl is called by the object store when the image
 * is loaded. This method checks the url against the url that was
 * set in imageUrl. If they are the same, the image is updated to the
 * new value.  Otherwise no action.
 */
- (void)setImage:(UIImage *)_value withUrl:(NSString *)url;

@end
