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

#import "LRUCache.h"
#import "Consts.h"

/**
 * CachedItem is a private class that is used to store the object 
 * with a count representing its usage
 */
@interface CachedItem : NSObject {
    NSInteger count;
    id item;
}
@property (assign) NSInteger count;
@property (retain) id item;

@end

@implementation CachedItem
@synthesize item, count;

-(void)dealloc {
    [item release];
    [super dealloc];
}

@end

@implementation LRUCache

/**
 * initCacheWithCapacity will create an empty cache with size
 * size.
 * @param NSInteger size - the size of the cache
 * @return id - newly instantiated LRUCache object
 */
- (id)initCacheWithCapacity:(NSInteger)size {
    if (self = [super init]) {
        cache = [[NSMutableDictionary alloc] initWithCapacity:size];
        cacheSize = size;
        currentCount = 0;
    }
    return self;
}

/**
 * getObjectForKey will look in the cache for the object saved with
 * the key.  If it finds it, it will set its count to the current count
 * and return the object.  Otherwise, it will return nil
 * @param NSString *key - the key that identifies the object we are looking for
 * @return id - either the object if it is found or nil otherwise
 */
- (id)getObjectForKey:(NSString *)key {
    if (key == nil || [key isEqualToString:@""]) { return nil; }
    CachedItem *item = [cache objectForKey:key];
    if (item != nil) {
        item.count = currentCount;
        currentCount += 1;
        return item.item;
    }
    return nil;
}

/**
 * saveObject will save the object in the cache with the key.  If the cache 
 * is full, the object with the smallest count will be thrown out to make 
 * room
 * @param id object - the object to save
 * @param NSString *key - the key to save the object under 
 */
- (void)saveObject:(id)object withKey:(NSString *)key {
    if (cacheSize == 0) { return; }
    id item = [self getObjectForKey:key];
    if (item == nil && object != nil) {
        if ([cache count] >= cacheSize) {
            [self removeLeastRecentlyUsed];
            debug_NSLog(@"REMOVING OBJECT");
        }
        CachedItem *item = [[CachedItem alloc] init];
        item.item = object;
        item.count = currentCount;
        currentCount += 1;
        [cache setObject:item forKey:key];
		[item release];
    }
}

/**
 * resetCache will remove all objects from the cache
 */
- (void)resetCache {
    currentCount = 0;
    [cache removeAllObjects];
}

/**
 * cacheCacheSizeTo: will change the capacity of cache to the new size.
 * If the size is smaller than the number objects in the cache, the objects
 * with the smallest counts will be thrown out.
 * @param NSInteger newSize - the new size of the cache
 */
- (void)changeCacheSizeTo:(NSInteger)newSize {
    if (newSize > 0) {
        while ([cache count] > newSize) {
            [self removeLeastRecentlyUsed];
        }
        cacheSize = newSize;        
    }
}

/**
 * removeLeastRecentlyUsed will remove the object with the smallest count
 */
- (void)removeLeastRecentlyUsed {
    NSString *key, *minKey;
    NSInteger minCount = currentCount;
    CachedItem *item;
    for (key in cache) {
        item = [cache objectForKey:key];
        if (minCount > item.count) {
            minCount = item.count;
            minKey = key;
        }
    }
    if (minKey != nil) {
        [cache removeObjectForKey:minKey];
    }
}

- (void)dealloc {
    [cache release];
    [super dealloc];
}

@end
