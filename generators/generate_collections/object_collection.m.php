/**
 * <?= $object_name ?>RemoteCollection.m
 * Copyright Miraphonic, Inc 2009. All rights reserved.
 *
 * @author Amit Matani 
 * @created <?= $date ?>.
 */

#import "<?= $object_name ?>RemoteCollection.h"
#import "BRRestClient.h"
#import "<?= $object_name ?>.h"

@implementation <?= $object_name ?>RemoteCollection 

- (id)init {
    if (self = [super initWithCollectionName:@"<?= strtolower($object_name)?>s" numObjectsPerLoad:<?= $num_per_load ?>]) {
        
    }
    return self;
}

- (void)callRemoteCollectionLoadingMethodWithTarget:(id)target 
		finishedSelector:(SEL)finishedSelector failedSelector:(SEL)failedSelector  {
    [[BRRestClient sharedManager] <?= $rest_call ?>:start 
                                  limit:numRequestedObjectsPerLoad
                                  target:self
                                  finishedSelector:finishedSelector
                                  failedSelector:failedSelector];
}

- (id)packageObjectForSaving:(id)object {
    <?= $object_name ?> *<?= strtolower($object_name) ?> = [[<?= $object_name ?> alloc] initWithApiResponse:object];
    return <?= strtolower($object_name) ?>;
}

@end
