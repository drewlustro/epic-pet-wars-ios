/**
 * FacebookUserRemoteCollection.m
 * Copyright Miraphonic, Inc 2009. All rights reserved.
 *
 * @author Amit Matani 
 * @created 02/12/09.
 */

#import "FacebookUserRemoteCollection.h"
#import "BRRestClient.h"
#import "FacebookUser.h"

@implementation FacebookUserRemoteCollection 

- (id)init {
    if (self = [super initWithCollectionName:@"friends" numObjectsPerLoad:0]) {
        
    }
    return self;
}

- (void)callRemoteCollectionLoadingMethodWithTarget:(id)target 
		finishedSelector:(SEL)finishedSelector failedSelector:(SEL)failedSelector  {
    [[BRRestClient sharedManager] posse_getFacebookFriends:self
                                  finishedSelector:finishedSelector
                                  failedSelector:failedSelector];
}

- (id)packageObjectForSaving:(id)object {
    FacebookUser *facebookuser = [[FacebookUser alloc] initWithApiResponse:object];
    return facebookuser;
}

@end
