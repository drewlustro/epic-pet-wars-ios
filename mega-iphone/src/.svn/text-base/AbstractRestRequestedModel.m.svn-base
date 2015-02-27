/**
 * AbstractRestRequestedModel.h
 * Copyright Miraphonic, Inc 2009. All rights reserved.
 *
 * AbstractRestRequestedModel is the base model for objects that
 * are requested from an API.  It takes an NSDictionary of a parsed
 * API response and matches the keys in its field map to the keys in
 * the dictionary to set the instance variables of the object
 *
 * @author Amit Matani
 * @created 1/14/09
 */

#import "AbstractRestRequestedModel.h"
#import "Consts.h"


@implementation AbstractRestRequestedModel


/**
 * GetFieldMap returns the static fieldmap, initializing it if
 * neccesary
 * @return NSDictionary mapping api variables to their appropriate 
 * setter selector
 */

+ (NSDictionary *)GetFieldMap {
    return [self GetFieldMapHelper];
}

/**
 * GetFieldMapHelper returns the static fieldmap or nil if it does not
 * exist. This method should be subclassed.
 * @return NSDictionary mapping api variables to their appropriate 
 * or nil if it has not yet been intialized
 */
+ (NSDictionary *)GetFieldMapHelper {
    [NSException raise:@"Method Not Defined Exception" 
				format:@"Error, attempting to call an undefined method."];
	return nil;
}

/**
 * initWithApiResponse takes the response from the api and instantiates an
 * object with the correct data set
 * @param a dictionary containing the json response from
 * the api
 * @return the id of the created object
 */
- (id)initWithApiResponse:(NSDictionary *)apiResponse {
    if (self = [super init]) {    
        NSDictionary *map = [[self class] GetFieldMap];
        debug_NSLog(@"count %d", [map count]);
        if (map != nil && [apiResponse isKindOfClass:[NSDictionary class]])  {
            NSString *key;
            SEL setter;
            id response;
            for (key in map) {
                setter = NSSelectorFromString([map objectForKey:key]);
                response = [apiResponse objectForKey:key];
                if (response != nil && response != [NSNull null]) {
                    [self performSelector:setter withObject:response];
                }
            }
        }
    }
    return self;
}

@end
