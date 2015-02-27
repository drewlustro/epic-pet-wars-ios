/**
 * ReusableRemoteImageStore.m
 * Copyright Miraphonic, Inc 2009. All rights reserved.
 *
 * Subclass of the ReusableRemoteObjectSTore, ReusableRemoteImageStore
 * handles the download and caching of images.  The keys for this
 * object store are the image's urls.
 *
 * @author Amit Matani
 * @created 1/13/09
 */

#import "ReusableRemoteImageStore.h"
#import "ImageDownloadOperation.h"
#import "Consts.h"

@implementation ReusableRemoteImageStore
@synthesize downloadOperationQueue;

- (id)initWithCacheSize:(NSInteger)size {
    if (self = [super initWithCacheSize:size]) {
        NSOperationQueue *operationQueue = [[NSOperationQueue alloc] init];
        self.downloadOperationQueue = operationQueue;
        [operationQueue release];
    }
	return self;
}

/**
 * fetchRemoteObjectsForKeys for keys calls requestimage on the keys themselves because
 * the keys are urls to images
 * @param NSArray *keys - an array of image urls
 */
- (void)fetchRemoteObjectsForKeys:(NSArray *)keys {
    NSString *url;
    for (url in keys) {
        [self requestImage:url];
    }
}

/**
 * requestImage takes an image url and creates an ImageDownloadOperation
 * to download it.
 * The ImageDownloadOperation is put onto the downloadOperationQueue.
 * @param imageUrl an NSString of the url of the image
 */
- (void)requestImage:(NSString *)imageUrl {
    debug_NSLog(@"Image Request String: %@", imageUrl);
    NSURL *requestUrl = [[NSURL alloc] initWithString:imageUrl];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:requestUrl 
										  cachePolicy:NSURLRequestUseProtocolCachePolicy 
										  timeoutInterval:60.0];
    [requestUrl release];
    ImageDownloadOperation *imageDownload = 
        [[ImageDownloadOperation alloc] initWithRequest:request target:self 
                                                          finishedSelector:@selector(cacheObject:withKey:)
                                                          failedSelector:@selector(handleFailedRequest)];
    [request release];
    [downloadOperationQueue addOperation:imageDownload];
    [imageDownload release];
}

/**
 * requestImage is a target action that is called when an ImageDownloadOperation
 * has a connection failure.
 */
- (void)handleFailedRequest {
    
}

- (void)dealloc {
    [downloadOperationQueue release];
    [super dealloc];
}

@end
