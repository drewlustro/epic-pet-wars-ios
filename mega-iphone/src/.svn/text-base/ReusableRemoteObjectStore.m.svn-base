/**
 * ReusableRemoteObjectStore.m
 * Copyright Miraphonic, Inc 2009. All rights reserved.
 *
 * ReuableRemoteObjectStore is an class that defines 
 * a set of methods which make it easy to request remote objects based on
 * a key.  In addition, this class handles methods to cache the items
 * that have been downloaded by it.  The class cannot work until a subclass
 * properly defines fetchObjectForKeys
 *
 * @author Amit Matani
 * @created 1/13/09
 */

#import "ReusableRemoteObjectStore.h"
#import "LRUCache.h"
#import "Consts.h"
#import "DelayedAction.h"

@implementation ReusableRemoteObjectStore
@synthesize cache, storeLock, requests;

/**
 * initWithCacheSize will create a ReusableRemoteObjectStore with cacheSize size
 * @param NSInteger size - size of cache
 * @return id - instantiated ReusableRemoteObjectStore
 */
- (id)initWithCacheSize:(NSInteger)size {
    if (self = [super init]) {
        LRUCache *lru = [[LRUCache alloc] initCacheWithCapacity:size];
        self.cache = lru;
        [lru release];

        NSLock *lock = [[NSLock alloc] init];
        self.storeLock = lock;
        [lock release];
        
        NSMutableDictionary *requestDict = [[NSMutableDictionary alloc] initWithCapacity:10];
        self.requests = requestDict;
        [requestDict release];
    }
	return self;    
}

/**
 * cacheObject will take the object provided and cache it using the key
 * provided
 * @param id object - the object to cache
 * @param NSString *key - the key to cache the object with
 */
- (void)cacheObject:(id)object withKey:(NSString *)key {
    [storeLock lock];
    NSArray *requestsForKey = [[requests objectForKey:key] retain];
    [requests removeObjectForKey:key];
    if (object != nil && requestsForKey != nil) {
        debug_NSLog(@"saving object for key %@", key);
        [cache saveObject:object withKey:key];
    }
    if (requestsForKey != nil) {
        DelayedAction *delayedAction;
        for (delayedAction in requestsForKey) {			
            [delayedAction.target performSelector:delayedAction.selector withObject:object withObject:key];
        }
    }
    [storeLock unlock];    
    [requestsForKey release];
}

/**
 * cacheObjects will take the key/object pairs provided and cache objects
 * based on their keys
 * @param NSDictionary objects - key object pairs
 */
- (void)cacheObjects:(NSDictionary *)objects {
    NSString *key;
    for (key in objects) {
        [self cacheObject:[objects objectForKey:key] withKey:key];
    }
}



- (void)cancelDelayedActionOnTarget:(id)target {
    [storeLock lock];
    
    DelayedAction *action = [[DelayedAction alloc] init];
    action.target = target;
    for (NSMutableArray *request in [requests allValues]) {
        [request removeObject:action];
    }
    [action release];
    [storeLock unlock];
}


/**
 * getObjectWithKeys will first check the cache to see if the objects exists
 * in it.  If not it will attempt to request it from the remote server
 * using fetchRemoteObjectsForKeys. Once the object is found, it will be sent to the
 * target object using the selector
 * @param NSArray *keys - the keys that identifies the requested objects
 * @param id target - the target object to notify once the object is found
 * @param SEL selector - the selector to use to notify the target
 */
- (void)getObjectsWithKeys:(NSArray *)keys target:(id)target selector:(SEL)selector {
    NSString *key;
    NSMutableArray *necessaryKeys = [[NSMutableArray alloc] initWithCapacity:[keys count]];
    for (key in keys) {
        //NSLog(@"testing keys");
        if (key == nil || [key isEqualToString:@""]) {
            continue;
        }
        debug_NSLog(@"This key is %@", key);
        [storeLock lock];        
        id object = [self getObjectFromCacheWithKey:key];
        if (object != nil) {
            [storeLock unlock];			
            [target performSelector:selector withObject:object withObject:key];
        } else {
            NSMutableArray *requestsForKey = [requests objectForKey:key];
            DelayedAction *delayedAction = [[DelayedAction alloc] init];
            delayedAction.target = target;
            delayedAction.selector = selector;
            if (requestsForKey == nil) {
                [necessaryKeys addObject:key];                
                requestsForKey = [[NSMutableArray alloc] initWithCapacity:2];
                [requestsForKey addObject:delayedAction];
				[requests setObject:requestsForKey forKey:key];
				[requestsForKey release];
                [storeLock unlock];
            } else {
                [requestsForKey addObject:delayedAction];
                [storeLock unlock];            
            }
            [delayedAction release];
        }
    }
    [self fetchRemoteObjectsForKeys:necessaryKeys];
    [necessaryKeys release];
}

/**
 * getObjectWithKey does the same thing as getObjectsWithKeys, but just for one object
 * @param NSString *key - the key that identifies the object
 * @param id target - the target object to notify once the object is found
 * @param SEL selector - the selector to use to notify the target
 */
- (void)getObjectWithKey:(NSString *)key target:(id)target selector:(SEL)selector {
    if (key == nil || [key isEqualToString:@""]) {
        return;
    }
    NSArray *keys = [NSArray arrayWithObject:key];
    [self getObjectsWithKeys:keys target:target selector:selector];   
}

/**
 * getObjectFromCacheWithKey takes a key and returns the object
 * if it is in the cache, otherwise returns nil
 * @param NSString *key - key of object
 * @return id object - the object if it exists, nil otherwise
 */
- (id)getObjectFromCacheWithKey:(NSString *)key {
    return [cache getObjectForKey:key];
}


/**
 * fetchRemoteObjectsForKeys translates the keys into proper requests for remote content.
 * Subclasses will override this function to create their requests.
 * @param NSArray *keys - set of keys that have been requested
 */
- (void)fetchRemoteObjectsForKeys:(NSArray *)keys {
    [NSException raise:@"Method Not Defined Exception" 
				format:@"Error, attempting to call an undefined method."];    
}

/**
 * purgeCache will remove all objects from the cache. Useful for low memory situations
 */
- (void)purgeCache {
    [cache resetCache];
}

/**
 * purgeRequests will cancel all requests being made by the object store
 */
- (void)purgeRequests {
    [requests removeAllObjects];
}

- (void)dealloc {
    [cache release];
    [storeLock release];
    [requests release];
    [super dealloc];
}

@end
