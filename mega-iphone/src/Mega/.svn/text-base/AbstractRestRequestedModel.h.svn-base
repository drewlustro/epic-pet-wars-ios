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

#import <Foundation/Foundation.h>


@interface AbstractRestRequestedModel : NSObject {
}

/**
 * GetFieldMap returns the static fieldmap, initializing it if
 * neccesary
 * @return NSDictionary mapping api variables to their appropriate 
 * setter selector
 */
+ (NSDictionary *)GetFieldMap;

/**
 * GetFieldMapHelper returns the static fieldmap or nil if it does not
 * exist. This method should be subclassed.
 * @return NSDictionary mapping api variables to their appropriate 
 * or nil if it has not yet been intialized
 */ 
+ (NSDictionary *)GetFieldMapHelper;

/**
 * initWithApiResponse takes the response from the api and instantiates an
 * object with the correct data set
 * @param a dictionary containing the json response from
 * the api
 * @return the id of the created object
 */
- (id)initWithApiResponse:(NSDictionary *)apiResponse;

@end
