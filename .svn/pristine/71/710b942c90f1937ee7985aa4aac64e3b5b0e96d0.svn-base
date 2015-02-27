/**
 * BRRestOperation.h
 * Copyright Miraphonic, Inc 2009. All rights reserved.
 *
 * RestOperation is a subclass of RestOperation. It is 
 * subclassed to handle preprocess differently
 *
 * @author Amit Matani
 * @created 1/13/09
 */

#import "BRRestOperation.h"
#import "Utility.h"
#import "BRAppDelegate.h"
#import "BRRestClient.h"

@implementation BRRestOperation

/**
 * preProcessResponse takes the responseInt and the parsedResponse and
 * checks if there is a response code that requires a new login.  If so
 * the method will return NO, otherwise it will return YES
 * @param NSNumber *responseInt - the response code from the server
 * @param NSDictionary *parsedResponse - the dictionary of the response
 * @return YES if the finished selector should be run, false otherwise
 */
- (BOOL)preProcessResponse:(NSNumber *)responseInt 
        parsedResponse:(NSDictionary *)parsedResponse {
    if ([Utility isNumber:responseInt sameAsInt:RESPONSE_BAD_SESSION] ||
        [Utility isNumber:responseInt sameAsInt:RESPONSE_BAD_CALL_ID] ||
        [Utility isNumber:responseInt sameAsInt:RESPONSE_BAD_SIG]) {
		// TODO put something here
        return NO;
    }
    return YES;
}

@end
