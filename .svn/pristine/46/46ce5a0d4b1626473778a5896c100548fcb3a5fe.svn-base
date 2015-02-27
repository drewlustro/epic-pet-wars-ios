/**
 * InviteTableViewCell.m
 * Copyright Miraphonic, Inc 2009. All rights reserved.
 *
 * @author Amit Matani 
 * @created 2/7/09.
 */

#import "InviteTableViewCell.h"
#import "Invite.h"
#import "Consts.h"
#import "InvitesTableViewController.h"
#import "Animal.h"
#import "BRAppDelegate.h"

static UIFont *nameFont;
static UIImage *acceptImage;
static UIImage *rejectImage;
static CGRect acceptImageRect;
static CGRect rejectImageRect;

// super common colors
static UIColor *whiteColor, *blackColor, *darkGrayColor, *clearColor;

@implementation InviteTableViewCell
@synthesize invite, inviteDelegate;

/**
 * initialize in order to minimize the number of object allocations
 * in drawRect, we initialize common objects here.  They should be small
 * enough that they wont make a large memory footprint
 */
+ (void)initialize {
    if (self = [InviteTableViewCell class]) {
        nameFont = [[UIFont boldSystemFontOfSize:14] retain];		
		acceptImage = [[UIImage imageNamed:@"accept.png"] retain];
		rejectImage = [[UIImage imageNamed:@"reject.png"] retain];
        acceptImageRect = CGRectZero;		
        rejectImageRect = CGRectZero;
		
		// super-common colors for every custom table view cell class
		whiteColor = [[UIColor whiteColor] retain];
		blackColor = [[UIColor blackColor] retain];
		darkGrayColor = [[UIColor darkGrayColor] retain]; 
		clearColor = [[UIColor clearColor] retain];
		
    }
}

- (void)setInvite:(Invite *)newInvite {
	[invite release];
	invite = [newInvite retain];
	
    [self loadImageWithUrl:invite.inviterAnimal.imageSquare50];
	
	
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
	p.y = 9;
    [image drawAtPoint:p];
	
    p.x += IMAGE_WIDTH + PADDING;
	
	[textColor set];
	[invite.inviterAnimal.name drawAtPoint:p withFont:nameFont];
	
	p.x = 160;
	if (rejectImageRect.size.height == 0) {
        rejectImageRect = CGRectMake(FRAME_WIDTH - PADDING - rejectImage.size.width,
                                    (self.frame.size.height - rejectImage.size.height) / 2,
                                    rejectImage.size.width,
                                    rejectImage.size.height);
    }
	
	if (acceptImageRect.size.height == 0) {
        acceptImageRect = CGRectMake(rejectImageRect.origin.x - acceptImage.size.width - PADDING,
                                    (self.frame.size.height - acceptImage.size.height) / 2,
                                    acceptImage.size.width,
                                    acceptImage.size.height);
    }

	[acceptImage drawInRect:acceptImageRect];
	[rejectImage drawInRect:rejectImageRect];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (CGRectContainsPoint(acceptImageRect, [[touches anyObject] locationInView:self])) {
        [inviteDelegate acceptInvite:invite];
    } else if (CGRectContainsPoint(rejectImageRect, [[touches anyObject] locationInView:self])) {
        [inviteDelegate rejectInvite:invite];
	}
    [super touchesEnded:touches withEvent:event];
}

- (void)dealloc {
    [invite release];
    [super dealloc];
}


@end
