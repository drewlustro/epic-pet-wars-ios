/**
 * ReusableRemoteImageStoreWithFileCache.m
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
#import "ReusableRemoteImageStoreWithFileCache.h"
#import "Utility.h"
#import "LRUCache.h"

@implementation ReusableRemoteImageStoreWithFileCache
@synthesize dataPath;

- (id)initWithCacheSize:(NSInteger)size {
    if (self = [super initWithCacheSize:size]) {
    	/* create path to cache directory inside the application's Documents directory */
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        self.dataPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"ImageFileCache"];
		
		NSError *error;
    	/* check for existence of cache directory */
    	if (![[NSFileManager defaultManager] fileExistsAtPath:dataPath]) {
			[[NSFileManager defaultManager] createDirectoryAtPath:dataPath 
											withIntermediateDirectories:NO
											attributes:nil 
											error:&error];
    	}
    }
    return self;
}

/**
* getHashOfImageUrl creates a unique (enough) hash of the imageUrl.
* @param NSString *imageUrl - the image url
* @return NSString - md5ed version of the image url
*/
+ (NSString *)getHashOfImageUrl:(NSString *)imageUrl {
    return [Utility md5:imageUrl];
}
/**
 * cacheObject is extended to save the object to the filesystem when
 * the object is cached
 * @param id object - the object to cache
 * @param NSString *key - key of object
 */
- (void)cacheObject:(id)object withKey:(NSString *)key {
    [super cacheObject:object withKey:key];
    NSString *filePath = 
        [dataPath stringByAppendingPathComponent:[[self class] getHashOfImageUrl:key]];    
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath] == NO) {
		/* file doesn't exist, so create it */
		[[NSFileManager defaultManager] createFileAtPath:filePath 
										contents:UIImagePNGRepresentation(object) 
										attributes:nil];
    }
}
 
/**
 * getObjectFromCacheWithKey takes a key checks if the parent method finds it, 
 * if not attempt to find it in the local filesystem.  If we find it in the local
 * filesystem we cache the object directly since we cannot use the caching method
 * provided to us
 * @param NSString *key - key of object
 * @return id object - the object if it exists, nil otherwise
 */
- (id)getObjectFromCacheWithKey:(NSString *)key {
    id object = [super getObjectFromCacheWithKey:key];
    if (object == nil) {
        NSString *filePath = 
            [dataPath stringByAppendingPathComponent:[[self class] getHashOfImageUrl:key]];
	    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        	UIImage *theImage = [[UIImage alloc] initWithContentsOfFile:filePath];
        	if (theImage) {
                [cache saveObject:theImage withKey:key];
                [theImage release];
                // we do this becuase we have to release the image, but we cannot be 100% sure that 
                // the cache actually held onto the file
                object = [cache getObjectForKey:key];
        	}	        
        }
    }
    return object;
}

- (void)dealloc {
    [dataPath release];
    [super dealloc];
}
@end
