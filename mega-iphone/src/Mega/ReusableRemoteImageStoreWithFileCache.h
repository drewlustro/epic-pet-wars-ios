/**
 * ReusableRemoteImageStoreWithFileCache.h
 * Copyright Miraphonic, Inc 2009. All rights reserved.
 *
 * Adds to the ReusableRemoteImageStore by including a file cache.
 * When images are downloaded, they are saved to the file system. 
 * Before going to the web, this class will check the local filesystem
 * if the image is stored there.
 *
 * @author Amit Matani
 * @created 1/13/09
 */

#import <Foundation/Foundation.h>
#import "ReusableRemoteImageStore.h"

@interface ReusableRemoteImageStoreWithFileCache : ReusableRemoteImageStore {
    NSString *dataPath;
}
@property (nonatomic, copy) NSString *dataPath;

/**
 * getHashOfImageUrl creates a unique (enough) hash of the imageUrl.
 * @param NSString *imageUrl - the image url
 * @return NSString - md5ed version of the image url
 */
+ (NSString *)getHashOfImageUrl:(NSString *)imageUrl;

@end
