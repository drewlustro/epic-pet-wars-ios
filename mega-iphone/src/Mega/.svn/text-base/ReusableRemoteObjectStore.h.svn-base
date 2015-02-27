/**
 * ReusableRemoteObjectStore.h
 * Copyright Miraphonic, Inc 2009. All rights reserved.
 *
 * ReuableRemoteObjectStore is a class that defines 
 * a set of methods which make it easy to request remote objects based on
 * a key.  In addition, this class handles methods to cache the items
 * that have been downloaded by it.  The class cannot work until a subclass
  * properly defines fetchObjectForKeys
 *
 * @author Amit Matani
 * @created 1/13/09
 */

#import <Foundation/Foundation.h>

@class LRUCache;
@interface ReusableRemoteObjectStore : NSObject {
    // the cache that stores the downloaded objects
    LRUCache *cache;
    
    // locks the object store so we do not have a race condition when trying to request or save objects
    NSLock *storeLock;
    
    // a dictionary of requests for objects
    NSMutableDictionary *requests;
}
@property (nonatomic, retain) LRUCache *cache;
@property (nonatomic, retain) NSLock *storeLock;
@property (nonatomic, retain) NSMutableDictionary *requests;

/**
 * initWithCacheSize will create a ReusableRemoteObjectStore with cacheSize size
 * @param NSInteger size - size of cache
 * @return id - instantiated ReusableRemoteObjectStore
 */
- (id)initWithCacheSize:(NSInteger)size;

/**
 * cacheObject will take the object provided and cache it using the key
 * provided
 * @param id object - the object to cache
 * @param NSString *key - the key to cache the object with
 */
- (void)cacheObject:(id)object withKey:(NSString *)key;

/**
 * cacheObjects will take the key/object pairs provided and cache objects
 * based on their keys
 * @param NSDictionary objects - key object pairs
 */
- (void)cacheObjects:(NSDictionary *)objects;


/**
 * getObjectWithKeys will first check the cache to see if the objects exists
 * in it.  If not it will attempt to request it from the remote server
 * using fetchRemoteObjectsForKeys. Once the object is found, it will be sent to the
 * target object using the selector
 * @param NSArray *keys - the keys that identifies the requested objects
 * @param id target - the target object to notify once the object is found
 * @param SEL selector - the selector to use to notify the target
 */
- (void)getObjectsWithKeys:(NSArray *)keys target:(id)target selector:(SEL)selector;

/**
 * getObjectWithKey does the same thing as getObjectsWithKeys, but just for one object
 * @param NSString *key - the key that identifies the object
 * @param id target - the target object to notify once the object is found
 * @param SEL selector - the selector to use to notify the target
 */
- (void)getObjectWithKey:(NSString *)key target:(id)target selector:(SEL)selector;

/**
 * getObjectFromCacheWithKey takes a key and returns the object
 * if it is in the cache, otherwise returns nil
 * @param NSString *key - key of object
 * @return id object - the object if it exists, nil otherwise
 */
- (id)getObjectFromCacheWithKey:(NSString *)key;

/**
 * fetchRemoteObjectsForKeys translates the keys into proper requests for remote content.
 * Subclasses will override this function to create their requests.
 * @param NSArray *keys - set of keys that have been requested
 */
- (void)fetchRemoteObjectsForKeys:(NSArray *)keys;

/**
 * purgeCache will remove all objects from the cache. Useful for low memory situations
 */
- (void)purgeCache;

/**
 * purgeRequests will cancel all requests being made by the object store
 */
- (void)purgeRequests;

- (void)cancelDelayedActionOnTarget:(id)target;

@end
