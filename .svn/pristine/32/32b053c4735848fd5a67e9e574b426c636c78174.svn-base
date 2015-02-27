/**
 * CommentRemoteCollection.m
 * Copyright Miraphonic, Inc 2009. All rights reserved.
 *
 * @author Amit Matani 
 * @created 02/13/09.
 */

#import "CommentRemoteCollection.h"
#import "BRRestClient.h"
#import "Post.h"

@implementation CommentRemoteCollection 

- (id)initWithUserId:(NSString *)_userId {
    if (self = [super initWithCollectionName:@"comments" numObjectsPerLoad:30]) {
        userId = [_userId retain];
    }
    return self;
}

- (void)callRemoteCollectionLoadingMethodWithTarget:(id)target 
		finishedSelector:(SEL)finishedSelector failedSelector:(SEL)failedSelector  {
    [[BRRestClient sharedManager] comment_getComments:userId
								  start:start 
                                  limit:numRequestedObjectsPerLoad
                                  target:self
                                  finishedSelector:finishedSelector
                                  failedSelector:failedSelector];
}

- (void)callRemoteCollectionRemoveAtIndex:(id)object { 
    Post *post = (Post *)object;
    [[BRRestClient sharedManager] comment_removeComment:post.commentId target:self 
                                  finishedSelector:@selector(objectRemovedResponse:parsedResponse:)
                                    failedSelector:@selector(objectFailedRemoval)];
}

- (id)packageObjectForSaving:(id)object {
    Post *post = [[Post alloc] initWithApiResponse:object];
    return post;
}

- (void)dealloc {
	[userId release];
	[super dealloc];
}

@end
