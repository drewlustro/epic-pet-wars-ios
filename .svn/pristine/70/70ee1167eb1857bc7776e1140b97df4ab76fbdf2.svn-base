//
//  NewsFeedRemoteCollection.m
//  battleroyale
//
//  Created by Amit Matani on 1/19/09.
//  Copyright 2009 Miraphonic, Inc. All rights reserved.
//

#import "NewsFeedRemoteCollection.h"
#import "BRRestClient.h"
#import "NewsfeedItem.h"

@implementation NewsFeedRemoteCollection

- (id)init {
    if (self = [super initWithCollectionName:@"newsfeed_items" numObjectsPerLoad:0]) {
        
    }
    return self;
}

- (void)callRemoteCollectionLoadingMethodWithTarget:(id)target 
		finishedSelector:(SEL)finishedSelector failedSelector:(SEL)failedSelector  {
    [[BRRestClient sharedManager] newsfeed_getNewsfeedItems:start limit:numRequestedObjectsPerLoad 
													 target:target
                                           finishedSelector:finishedSelector
                                             failedSelector:failedSelector];
}

- (id)packageObjectForSaving:(id)object {
    NewsfeedItem *newsFeedItem = [[NewsfeedItem alloc] initWithApiResponse:object];
    return newsFeedItem;
}

@end
