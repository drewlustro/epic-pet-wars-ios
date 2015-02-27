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

#import <Foundation/Foundation.h>
#import "RestOperation.h"

typedef enum {
    BRRestResponseCodeRequiresFBPermissions = 801,
} BRRestResponseCode;

@interface BRRestOperation : RestOperation {

}

@end
