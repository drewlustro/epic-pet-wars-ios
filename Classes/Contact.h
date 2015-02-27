/**
 * Contact.h
 * Copyright Miraphonic, Inc 2009. All rights reserved.
 *
 * @author Amit Matani 
 * @created 2/9/09.
 */

#import <Foundation/Foundation.h>


@interface Contact : NSObject {
	NSString *firstName, *lastName, *email, *phoneNumber;
	BOOL checked, sortByFirstName;
}

@property (nonatomic, copy) NSString *firstName, *lastName, *email, *phoneNumber;
@property (nonatomic, assign) BOOL checked, sortByFirstName;

- (NSComparisonResult)compareContact:(Contact *)contact;

@end
