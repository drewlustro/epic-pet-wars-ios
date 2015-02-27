/**
 * FacebookFriendTableViewCell.m
 * Copyright Miraphonic, Inc 2009. All rights reserved.
 *
 * @author Amit Matani 
 * @created 2/12/09.
 */

#import "FacebookFriendTableViewCell.h"
#import "FacebookUser.h"
#import "Animal.h"
#import "BRAppDelegate.h"
#import "Consts.h"

@implementation FacebookFriendTableViewCell
@synthesize facebookUser, facebookDelegate;
static UIFont *nameFont;
static UIImage *inviteImage, *acceptImage, *invitedImage, *inPosseImage;
static CGRect imageButtonRect;

// super common colors
static UIColor *whiteColor, *blackColor, *darkGrayColor, *clearColor;

/**
 * initialize in order to minimize the number of object allocations
 * in drawRect, we initialize common objects here.  They should be small
 * enough that they wont make a large memory footprint
 */
+ (void)initialize {
    if (self = [FacebookFriendTableViewCell class]) {
        nameFont = [[UIFont boldSystemFontOfSize:14] retain];		
		inviteImage = [[UIImage imageNamed:@"invite.png"] retain];
		acceptImage = [[UIImage imageNamed:@"accept.png"] retain];
		invitedImage = [[UIImage imageNamed:@"invited.png"] retain];
		inPosseImage = [[UIImage imageNamed:@"in_posse.png"] retain];
        imageButtonRect = CGRectZero;
		
		// super-common colors for every custom table view cell class
		whiteColor = [[UIColor whiteColor] retain];
		blackColor = [[UIColor blackColor] retain];
		darkGrayColor = [[UIColor darkGrayColor] retain]; 
		clearColor = [[UIColor clearColor] retain];
    }
}

- (void)setFacebookUser:(FacebookUser *)_value {
	[facebookUser release];
	facebookUser = [_value retain];
	
    [self loadImageWithUrl:facebookUser.animal.imageSquare75];
	
	
	[self setNeedsDisplay];
}

- (void)drawContentView:(CGRect)r {
    CGContextRef context = UIGraphicsGetCurrentContext();
	
	UIColor *backgroundColor = self.selected ? clearColor : whiteColor;
	UIColor *textColor = self.selected ? whiteColor : blackColor;
	
	[backgroundColor set];
	CGContextFillRect(context, r);
	
#define PADDING 10
#define IMAGE_WIDTH 75
	
	CGPoint p;
	p.x = 12;
	p.y = 10;
    [image drawAtPoint:p];
	
    p.x += IMAGE_WIDTH + PADDING;
	[textColor set];
	[facebookUser.name drawAtPoint:p withFont:nameFont];
	
	if (imageButtonRect.size.height == 0) {
        imageButtonRect = CGRectMake(FRAME_WIDTH - PADDING - inviteImage.size.width,
                                    (self.frame.size.height - inviteImage.size.height) / 2,
                                    inviteImage.size.width,
                                    inviteImage.size.height);
    }
    UIImage *staticImage;
	if (facebookUser.inPosse) {
		staticImage = inPosseImage;
	} else if (facebookUser.inviteReceived) {
		staticImage = acceptImage;		
	} else if (facebookUser.inviteSent) {
		staticImage = invitedImage;		
	} else {
		staticImage = inviteImage;		
	}
	
    [staticImage drawInRect:imageButtonRect];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (CGRectContainsPoint(imageButtonRect, [[touches anyObject] locationInView:self])) {
        // notify the doJobDelegate that we are attempting to do the job
        [facebookDelegate handleInviteAction:facebookUser];
    }
    [super touchesEnded:touches withEvent:event];
}

- (void)dealloc {
    [facebookUser release];
    [super dealloc];
}


@end
