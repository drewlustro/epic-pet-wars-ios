/**
 * RemoteImageView.m
 * Copyright Miraphonic, Inc 2009. All rights reserved.
 *
 * The RemoteImageView class extends UIImageView adding methods
 * that allow it to associate a URL with the UIImage it contains.
 * This is useful when the class is used with RemoteImageStores.
 *
 * @author Amit Matani
 * @created 1/15/09
 */

#import "RemoteImageView.h"

@implementation RemoteImageView

@synthesize requestedImageUrl, hasBorder, hasDrawnBorder, border, hasLoaded, initialLoadingIndicator, isDefaultImage;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {

        self.contentMode = UIViewContentModeCenter | UIViewContentModeTop; 
		hasBorder = NO;
		hasDrawnBorder = NO;
		hasLoaded = NO;
		isDefaultImage = NO;
		
		UIActivityIndicatorView *loadingIndicator;
		loadingIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
		loadingIndicator.contentMode = UIViewContentModeCenter;
		loadingIndicator.hidesWhenStopped = YES;
		self.initialLoadingIndicator = loadingIndicator;
		[loadingIndicator release];
		
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)inCoder {
    if (self = [super initWithCoder:inCoder]) {        
        self.contentMode = UIViewContentModeCenter | UIViewContentModeTop; 
		hasBorder = NO;
		hasDrawnBorder = NO;
		hasLoaded = NO;
		isDefaultImage = NO;
		
		UIActivityIndicatorView *loadingIndicator;
		loadingIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
		loadingIndicator.contentMode = UIViewContentModeCenter;
		loadingIndicator.hidesWhenStopped = YES;
		self.initialLoadingIndicator = loadingIndicator;
		[loadingIndicator release];
    }
    return self;
}

/**
 * draws a 1px border around a DEFINED image.
 * if the image is the default image or 
 * self.image is nil, then nothing will happen
 * this function is called automatically by
 * setImage: withUrl: and can be disabled by
 * setting the instance variable hasBorder = NO
 */
-(void)drawBorder {
	if (isDefaultImage || self.image == nil) {
		return;
	}
	
	if (hasBorder) {	
		CGFloat imagewidth = self.image.size.width;
		CGFloat imageheight = self.image.size.height;
		CGFloat rectwidth = CGRectGetWidth(self.frame);
		CGFloat start = (rectwidth - imagewidth) / 2;
		
		if (!hasDrawnBorder) {
			border = [[BorderView alloc] initWithFrame:CGRectMake(start,0,imagewidth, imageheight)];
			[self addSubview:border];			
			hasDrawnBorder = YES;
		} else {
			border.frame = CGRectMake(start,0,imagewidth, imageheight);
			border.hidden = NO;	
		}
	} 
}

/**
 * Creates a UIActivityIndicatorView object to show
 * the user that something is loading. For the
 * indicator to even show up, the image should not
 * have loaded yet
 */
- (void)showLoadingIndicatorWithFrame:(CGRect)rect {
		initialLoadingIndicator.frame = rect;
		[initialLoadingIndicator startAnimating];
		[self addSubview:initialLoadingIndicator];	
}

/**
 * The default loading indicator for most table views.
 * the one that specifies a frame can be used for views
 * with larger image sizes or other requirements
 */
- (void)showLoadingIndicator {
    self.image = nil;
	CGRect rect = CGRectMake(self.frame.size.width / 2 - 15, self.frame.size.height / 2 - 15, 30.0, 30.0);
	[self showLoadingIndicatorWithFrame:rect];
}

/**
 * Hides the loading indicator if it exists and
 * removes it from the parent UIImageView
 */
- (void)hideLoadingIndicator {
	[initialLoadingIndicator stopAnimating];
	[initialLoadingIndicator removeFromSuperview];
}

/**
 * replaces the typically used default image with just a blank one
 * and removes the border. This method is usually followed by 
 * a call to showLoadingIndicator and then an attempt to load
 * the image w/  a provided callback method
 */
- (void)setImageToDefaultBlank {
	self.image = [UIImage imageNamed:@"default_square.png"];
    self.requestedImageUrl = @"";
	isDefaultImage = YES;
	[self removeBorder];
}

- (void)setImageToDeleted35x35 {
	self.image = [UIImage imageNamed:@"x_35.png"];
    self.requestedImageUrl = @"";	
	isDefaultImage = YES;
	[self removeBorder];
}

- (void)setImageToPending35x35 {
	self.image = [UIImage imageNamed:@"pending_35x35.png"];
    self.requestedImageUrl = @"";	
	isDefaultImage = YES;
	[self removeBorder];
}

/**
 * this object is reused, so there must be a single border and 
 * its gotta be able to be redrawn or abandoned
 */
- (void)removeBorder {
	if(hasDrawnBorder) {
		border.hidden = YES;
		//[border removeFromSuperview];
	}
}
	
/**
 * setImage verifies that the url provided is the same url as in the
 * requestedImageUrl string.  If so, it sets the image, otherwise
 * it does nothing.
 * @param UIImage *image
 * @param NSString *url
 */
- (void)setImage:(UIImage *)image withUrl:(NSString *)url {
    if ([requestedImageUrl isEqualToString:url]) {
		
		// destroy the old border from the view if we've already drawn one
		//[self removeBorder];
		
		// disabled for performance reasons [self fadeIn];		
		hasLoaded = YES;		
		
		// set the new image
		//self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, image.size.width, image.size.height);
        self.image = image;		
		isDefaultImage = NO;

		// after drawing the new image, we're OK to draw the border
		[self drawBorder];
		[self hideLoadingIndicator];
		
    }
}

/**
 * this destroys performance hahahhahaha
 * just disable it for now.
 */
- (void)fadeIn {
	
	self.alpha = 0.0;
	[UIView beginAnimations:@"FadeIn" context:nil];
	[UIView setAnimationDuration:0.5];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
	self.alpha = 1.0;
	[UIView commitAnimations];
	
}

- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
	self.alpha = 1.0;
	
}


- (void)dealloc {
    [requestedImageUrl release];
	[initialLoadingIndicator release];
	[border release];		
    [super dealloc];
}


@end
