/**
 * Contact.m
 * Copyright Miraphonic, Inc 2009. All rights reserved.
 *
 * @author Amit Matani 
 * @created 2/9/09.
 */

#import "Contact.h"


@implementation Contact
@synthesize firstName, lastName, email, checked, phoneNumber, sortByFirstName;


- (NSComparisonResult)compareContact:(Contact *)contact {
    NSString *compareString;
    NSString *compareToString;
    if (sortByFirstName) {
        compareString = firstName ? firstName : lastName;
        compareToString = contact.firstName ? contact.firstName : contact.lastName;
    } else {
        compareString = lastName ? lastName : firstName;
        compareToString = contact.lastName ? contact.lastName : contact.firstName;        
    }
    
    return [compareString caseInsensitiveCompare:compareToString];
}

- (void)dealloc {
    [firstName release];
    [lastName release];
    [email release];
    [phoneNumber release];
    [super dealloc];
}
    

@end