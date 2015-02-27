/**
 * InviteRemoteCollection.m
 * Copyright Miraphonic, Inc 2009. All rights reserved.
 *
 * @author Amit Matani 
 * @created 02/07/09.
 */

#import "InviteRemoteCollection.h"
#import "BRRestClient.h"
#import "Invite.h"

@implementation InviteRemoteCollection 

- (id)init {
    if (self = [super initWithCollectionName:@"invites" numObjectsPerLoad:10]) {
        
    }
    return self;
}

- (void)callRemoteCollectionLoadingMethodWithTarget:(id)target 
		finishedSelector:(SEL)finishedSelector failedSelector:(SEL)failedSelector  {
    [[BRRestClient sharedManager] posse_getInvites:start 
                                  limit:numRequestedObjectsPerLoad
                                  target:self
                                  finishedSelector:finishedSelector
                                  failedSelector:failedSelector];
}

- (id)packageObjectForSaving:(id)object {
    Invite *invite = [[Invite alloc] initWithApiResponse:object];
    return invite;
}

@end
