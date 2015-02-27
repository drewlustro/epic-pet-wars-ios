/**
 * CheckableContactTableViewCell.m
 * Copyright Miraphonic, Inc 2009. All rights reserved.
 *
 * @author Amit Matani 
 * @created 2/8/09.
 */

#import "CheckableContactTableViewCell.h"
#import "Contact.h"
#import <AddressBook/AddressBook.h>

@implementation CheckableContactTableViewCell
@synthesize contact;

static UIFont *firstNameFont = nil;
static UIFont *lastNameFont = nil;
static UIFont *emailFont = nil;
static UIImage *checkbox_unclicked;
static UIImage *checkbox_clicked;
static int nameFormat;

// super common colors
static UIColor *whiteColor, *blackColor, *darkGrayColor, *clearColor;


/**
 * initialize in order to minimize the number of object allocations
 * in drawRect, we initialize common objects here.  They should be small
 * enough that they wont make a large memory footprint
 */
+ (void)initialize {
    if (self = [CheckableContactTableViewCell class]) {
		checkbox_unclicked = [[UIImage imageNamed:@"checkbox_unclicked.png"] retain];
		checkbox_clicked = [[UIImage imageNamed:@"checkbox_clicked.png"] retain];	

		if (ABPersonGetSortOrdering() == kABPersonSortByFirstName) {
			lastNameFont = [[UIFont systemFontOfSize:20] retain];
			firstNameFont = [[UIFont boldSystemFontOfSize:20] retain];			
		} else {
			lastNameFont = [[UIFont boldSystemFontOfSize:20] retain];
			firstNameFont = [[UIFont systemFontOfSize:20] retain];						
		}
		
		emailFont = [[UIFont systemFontOfSize:16] retain];					
		
		nameFormat = ABPersonGetCompositeNameFormat();
		
		// super-common colors for every custom table view cell class
		whiteColor = [[UIColor whiteColor] retain];
		blackColor = [[UIColor blackColor] retain];
		darkGrayColor = [[UIColor darkGrayColor] retain]; 
		clearColor = [[UIColor clearColor] retain];
    }
}

- (void)setContact:(Contact *)_value {
	[contact release];
	contact = [_value retain];
	[self setNeedsDisplay];
}

- (void)drawContentView:(CGRect)r {
    CGContextRef context = UIGraphicsGetCurrentContext();

	UIColor *backgroundColor = self.selected ? clearColor : whiteColor;
	UIColor *textColor = self.selected ? whiteColor : blackColor;
	
	[backgroundColor set];
	CGContextFillRect(context, r);
	
	CGPoint p;
	p.x = 10;
	p.y = 10;
	
	if (contact.checked) {
		[checkbox_clicked drawAtPoint:p];		
	} else {
		[checkbox_unclicked drawAtPoint:p];
	}
	
	p.x += checkbox_clicked.size.width + 10;
	p.y += 3;
	
	[textColor set];
	CGSize s;
	if (nameFormat == kABPersonCompositeNameFormatFirstNameFirst) {
		s = [contact.firstName drawAtPoint:p withFont:firstNameFont];
		p.x += s.width + 6;
		[contact.lastName drawAtPoint:p withFont:lastNameFont];		
	} else {
		s = [contact.lastName drawAtPoint:p withFont:lastNameFont];
		p.x += s.width + 6;
		[contact.firstName drawAtPoint:p withFont:firstNameFont];
	}
	
	p.x = checkbox_clicked.size.width + 20;
	p.y += 20;
	[contact.email drawAtPoint:p withFont:emailFont];
}

- (void)dealloc {
    [contact release];
    [super dealloc];
}


@end
