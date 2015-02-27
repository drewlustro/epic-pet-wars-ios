/**
 * RemoteImageView.h
 * Copyright Miraphonic, Inc 2009. All rights reserved.
 *
 * The RemoteImageView class extends UIImageView adding methods
 * that allow it to associate a URL with the UIImage it contains.
 * This is useful when the class is used with RemoteImageStores.
 *
 * @author Amit Matani
 * @created 1/15/09
 */

#import <UIKit/UIKit.h>
#import "BorderView.h"

@interface RemoteImageView : UIImageView {
	UIActivityIndicatorView *initialLoadingIndicator;
    NSString *requestedImageUrl;
	BorderView *border;
	BOOL hasBorder, hasDrawnBorder, hasLoaded, isDefaultImage;
}

@property (copy) NSString *requestedImageUrl;
@property (retain) BorderView *border;
@property (retain) UIActivityIndicatorView *initialLoadingIndicator;
@property (assign) BOOL hasBorder, hasDrawnBorder, hasLoaded, isDefaultImage;

/**
 * draws a 1px border around a DEFINED image.
 * if the image is the default image or 
 * self.image is nil, then nothing will happen
 * this function is called automatically by
 * setImage: withUrl: and can be disabled by
 * setting the instance variable hasBorder = NO
 */
- (void)drawBorder;

/**
 * this object is reused, so there must be a single border and 
 * its gotta be able to be redrawn or abandoned
 */
- (void)removeBorder;

/**
 * Creates a UIActivityIndicatorView object to show
 * the user that something is loading. For the
 * indicator to even show up, the image should not
 * have loaded yet
 */
- (void)showLoadingIndicatorWithFrame:(CGRect)rect;

/**
 * The default loading indicator for most table views.
 * the one that specifies a frame can be used for views
 * with larger image sizes or other requirements
 */
- (void)showLoadingIndicator;

/**
 * Hides the loading indicator if it exists and
 * removes it from the parent UIImageView
 */
- (void)hideLoadingIndicator;

/**
 * replaces the typically used default image with just a blank one
 * and removes the border. This method is usually followed by 
 * a call to showLoadingIndicator and then an attempt to load
 * the image w/  a provided callback method
 */
- (void)setImageToDefaultBlank;

- (void)fadeIn;

- (void)setImageToDeleted35x35;

- (void)setImageToPending35x35;

- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context;

/**
 * setImage verifies that the url provided is the same url as in the
 * requestedImageUrl string.  If so, it sets the image, otherwise
 * it does nothing.
 * @param UIImage *image
 * @param NSString *url
 */
- (void)setImage:(UIImage *)image withUrl:(NSString *)url;




	


@end
