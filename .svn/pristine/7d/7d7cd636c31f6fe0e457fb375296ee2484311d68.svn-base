/**
 * TopAnimalsRemoteCollection.m
 * Copyright Miraphonic, Inc 2009. All rights reserved.
 *
 * @author Amit Matani 
 * @created 4/22/09.
 */

#import "TopAnimalsRemoteCollection.h"
#import "BRRestClient.h"

@implementation TopAnimalsRemoteCollection

- (id)initWithField:(NSString *)field {
    if (self = [super init]) {
        _field = [field copy];
    }
    return self;
}

- (void)callRemoteCollectionLoadingMethodWithTarget:(id)target 
		finishedSelector:(SEL)finishedSelector failedSelector:(SEL)failedSelector  {
    [[BRRestClient sharedManager] topAnimals_getTopListFor:_field start:start limit:numRequestedObjectsPerLoad
                                                target:target finishedSelector:finishedSelector
                                        failedSelector:failedSelector];    
}

- (void)dealloc {
    [_field release];
    [super dealloc];
}


@end
