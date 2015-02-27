/**
 * BulletinRemoteCollection.m
 * Copyright Miraphonic, Inc 2009. All rights reserved.
 *
 * @author Amit Matani 
 * @created 04/29/09.
 */

#import "BulletinRemoteCollection.h"
#import "BRRestClient.h"
#import "Bulletin.h"

@implementation BulletinRemoteCollection 

- (id)initWithUserId:(NSString *)userId {
    if (self = [super initWithCollectionName:@"bulletins" numObjectsPerLoad:30]) {
        _userId = [userId copy];
    }
    return self;
}

- (void)callRemoteCollectionLoadingMethodWithTarget:(id)target 
		finishedSelector:(SEL)finishedSelector failedSelector:(SEL)failedSelector  {
    [[BRRestClient sharedManager] comment_getBulletins:_userId start:start 
                                  limit:numRequestedObjectsPerLoad
                                  target:self
                                  finishedSelector:finishedSelector
                                  failedSelector:failedSelector];
}

- (id)packageObjectForSaving:(id)object {
    Bulletin *bulletin = [[Bulletin alloc] initWithApiResponse:object];
    return bulletin;
}

- (void)dealloc {
    [_userId release];
    [super dealloc];
}

@end
