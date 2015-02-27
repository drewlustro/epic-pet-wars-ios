/**
 * ReusableRemoteImageStore.h
 * Copyright Miraphonic, Inc 2009. All rights reserved.
 *
 * Subclass of the ReusableRemoteObjectSTore, ReusableRemoteImageStore
 * handles the download and caching of images.  The keys for this
 * object store are the image's urls.
 *
 * @author Amit Matani
 * @created 1/13/09
 */

#import <Foundation/Foundation.h>
#import "ReusableRemoteObjectStore.h"

@interface ReusableRemoteImageStore : ReusableRemoteObjectStore {
    /**
     * downloadOperationQueue is an NSOperationQueue that stores
     * the image download operations.
     */
    NSOperationQueue *downloadOperationQueue;
}

@property (nonatomic, retain) NSOperationQueue *downloadOperationQueue;
/**
 * requestImage takes an image url and creates an ImageDownloadOperation
 * to download it.
 * The ImageDownloadOperation is put onto the downloadOperationQueue.
 * @param imageUrl an NSString of the url of the image
 */
- (void)requestImage:(NSString *)imageUrl;

/**
 * requestImage is a target action that is called when an ImageDownloadOperation
 * has a connection failure.
 */
- (void)handleFailedRequest;

@end
