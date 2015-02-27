/**
 * LRUCache.h
 * Copyright Miraphonic, Inc 2009. All rights reserved.
 *
 * LRUCache is a Least Recently Used Cache. It handles storing
 * any kind of object.  Once it the cache starts filling up, it will
 * throw out the object that hasnt not been used in the longest time
 *
 * @author Amit Matani
 * @created 1/13/09
 */

#import <Foundation/Foundation.h>

@interface LRUCache : NSObject {
    NSInteger cacheSize, currentCount;
    NSMutableDictionary *cache;
}

/**
 * initCacheWithCapacity will create an empty cache with size
 * size.
 * @param NSInteger size - the size of the cache
 * @return id - newly instantiated LRUCache object
 */
- (id)initCacheWithCapacity:(NSInteger)size;

/**
 * getObjectForKey will look in the cache for the object saved with
 * the key.  If it finds it, it will set its count to the current count
 * and return the object.  Otherwise, it will return nil
 * @param NSString *key - the key that identifies the object we are looking for
 * @return id - either the object if it is found or nil otherwise
 */
- (id)getObjectForKey:(NSString *)key;

/**
 * saveObject will save the object in the cache with the key.  If the cache 
 * is full, the object with the smallest count will be thrown out to make 
 * room
 * @param id object - the object to save
 * @param NSString *key - the key to save the object under 
 */
- (void)saveObject:(id)object withKey:(NSString *)key;

/**
 * resetCache will remove all objects from the cache
 */
- (void)resetCache;

/**
 * cacheCacheSizeTo: will change the capacity of cache to the new size.
 * If the size is smaller than the number objects in the cache, the objects
 * with the smallest counts will be thrown out.
 * @param NSInteger newSize - the new size of the cache
 */
- (void)changeCacheSizeTo:(NSInteger)newSize;

/**
 * removeLeastRecentlyUsed will remove the object with the smallest count
 */
- (void)removeLeastRecentlyUsed;

@end

