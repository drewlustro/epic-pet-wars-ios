/*
 *  RemoteCollection.h
 *  battleroyale
 *
 *  Created by Amit Matani on 5/18/09.
 *  Copyright 2009 Miraphonic, Inc. All rights reserved.
 *
 */

@protocol RemoteCollection <NSObject>

/**
 * restCollection will purge all loaded objects and get the collection store
 * in an empty state
 */
- (void)resetCollection;

/**
 * loadRemoteCollectionWithTarget will attempt to load the remote collection starting 
 * from the last place it left off. Once the load has completed the method will
 * send the selector message to the target object
 * @param id target - the object that is notified when the collection loaded
 * @param SEL selector - the message to send to the target object, should accept 
 * an object with the number of the response
 */
- (void)loadRemoteCollectionWithTarget:(id)target selector:(SEL)selector;

/**
 * getNumObjectsLoaded safely gets the number of objects loaded by
 * locking the variable with a loadingLock first
 * @return NSInteger - number of loaded objects
 */
- (NSInteger)getNumObjectsLoaded;

/**
 * getNumObjectsAvailable safely gets the number of objects loaded by
 * locking the variable with a loadingLock first
 * @return NSInteger - number of available objects
 */
- (NSInteger)getNumObjectsAvailable;

/**
 * getNumObjectsLoadedAndAvailable safely gets the number of objects loaded
 * and the number of objects available in an array
 * @return NSArray * - array(numberOfObjectsLoaded, numberOfObjectsAvailable)
 */
- (NSArray *)getNumObjectsLoadedAndAvailable;

/**
 * objectAtIndex: returns the object at the index if it exists.
 * Otherwise, return nil.
 * @param NSInteger - index of the object to return
 * @return id - object if index is not out of bounds, nil otherwise
 */
- (id)objectAtIndex:(NSInteger)index;

- (NSInteger)indexOfObject:(id)object;

/**
 * insertObject:atIndex inserts an object in the collection at the index
 * provided and increases the count of objects available and loaded. 
 * All objects at index are shifted to the right by one
 * @param id object - object that is added
 * @param index that the object is added at
 */
- (BOOL)insertObject:(id)object atIndex:(NSInteger)index;

/**
 * removeObjectAtIndex: removes the object at the index provided and shifts
 * all objects with index + 1 to the left.  Also, this method calls
 * callRemoteCollectionRemoveAtIndex to instruct the remote collection
 * to remove the object as well
 * @param NSInteger index - the index to remove
 */
- (void)removeObjectAtIndex:(NSInteger)index;


- (void)cancelDelayedActionOnTarget:(id)target;

- (NSDictionary *)extraData;

- (BOOL)completedInitialLoad;

@end
