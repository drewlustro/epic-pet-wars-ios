//
//  JobRemoteCollection.m
//  battleroyale
//
//  Created by Amit Matani on 1/30/09.
//  Copyright 2009 Miraphonic, Inc. All rights reserved.
//

#import "JobRemoteCollection.h"
#import "BRRestClient.h"
#import "Job.h"

@implementation JobRemoteCollection

- (id)init {
    if (self = [super initWithCollectionName:@"jobs" numObjectsPerLoad:0]) {
        
    }
    return self;
}

- (void)callRemoteCollectionLoadingMethodWithTarget:(id)target 
		finishedSelector:(SEL)finishedSelector failedSelector:(SEL)failedSelector  {
    [[BRRestClient sharedManager] job_getJobs:target finishedSelector:finishedSelector
								  failedSelector:failedSelector];
}

- (id)packageObjectForSaving:(id)object {
    Job *job = [[Job alloc] initWithApiResponse:object];
    return job;
}

@end
