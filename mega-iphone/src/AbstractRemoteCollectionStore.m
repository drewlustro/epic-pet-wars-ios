/**
 * AbstractRemoteCollectionStore.m
 * Copyright Miraphonic, Inc 2009. All rights reserved.
 *
 * AbstractRemoteCollectionStore has methods that handle the requesting
 * and management of sets of remote data.  This class expects the remote collection
 * to respond in a JSON format like so:
 * {'users':{{'user_id':1}, {'user_id':2}}, 'total':2}
 *
 * @author Amit Matani
 * @created 1/14/09
 */

#import "AbstractRemoteCollectionStore.h"
#import "RestClient.h"
#import "Consts.h"
#import "DelayedAction.h"

@implementation AbstractRemoteCollectionStore

@synthesize totalObjectsAvailable, numObjectsLoaded, completedInitialLoad, extraData;

/**
 * initWithCollectionName:numObjectsPerLoad: takes the name and the number objects
 * available per load and creates the initial environment.  The name of the collection
 * should correspond to the string that identifies the collection in the JSON
 * result
 * @param NSString *name - name of collection
 * @param NSInteger numObjectsPerLoad - the number of objects that can be loaded at each load data call
 * If 0, it will attempt to load all the items in the collection
 * @return id - instantiated remote collection store
 */
- (id)initWithCollectionName:(NSString *)name numObjectsPerLoad:(NSInteger)numObjectsPerLoad {
	if (self = [super init]) {
		numRequestedObjectsPerLoad = numObjectsPerLoad;
		loadingLock = [[NSLock alloc] init];
        actionLock = [[NSLock alloc] init];
		collectionName = [name retain];
        [self resetCollection];
        self.completedInitialLoad = NO;
        delayedActions = [[NSMutableArray alloc] initWithCapacity:1];
	}
	return self;
}

/**
 * restCollection will purge all loaded objects and get the collection store
 * in an empty state
 */
- (void)resetCollection {
    [loadingLock lock];
    start = 0;
    numObjectsLoaded = 0;
    totalObjectsAvailable = 0;
    completedInitialLoad = NO;
    
    [actionLock lock];
    [delayedActions removeAllObjects];
    [actionLock unlock];
    
    if (loadedObjects == nil) {
        NSInteger capacity = numRequestedObjectsPerLoad == 0 ? 10 : numRequestedObjectsPerLoad;
		loadedObjects = [[NSMutableArray alloc] initWithCapacity:capacity];        
    } else {
        [loadedObjects removeAllObjects];
    }
    [loadingLock unlock];    
}

/**
 * loadRemoteCollectionWithTarget will attempt to load the remote collection starting 
 * from the last place it left off. Once the load has completed the method will
 * send the selector message to the target object
 * @param id target - the object that is notified when the collection loaded
 * @param SEL selector - the message to send to the target object, should accept 
 * an object with the number of the response
 */
- (void)loadRemoteCollectionWithTarget:(id)target selector:(SEL)selector {
    [loadingLock lock];
//    self.finishedLoadingTarget = target;
//    finishedLoadingSelector = selector;
    DelayedAction *delayedAction = [[DelayedAction alloc] init];
    delayedAction.target = target;
    delayedAction.selector = selector;
    debug_NSLog(@"total objects %d", totalObjectsAvailable);
    if (!isLoading) {
        if (totalObjectsAvailable == 0 || numObjectsLoaded < totalObjectsAvailable) {
            isLoading = YES;
            [actionLock lock];            
            [delayedActions addObject:delayedAction];            
            [actionLock unlock];            
            [loadingLock unlock];
            debug_NSLog(@"calling remote collection loading method");
            [self callRemoteCollectionLoadingMethodWithTarget:self
                  finishedSelector:@selector(handleFinishedLoadingCollection:parsedResponse:)
				  failedSelector:@selector(handleFailedLoadingCollection)];
        } else {
            [loadingLock unlock];
            NSNumber *number = [[NSNumber alloc] initWithInteger:RESPONSE_SUCCESS];
            [target performSelector:selector withObject:number];
            [number release];
        }
    } else {
        [actionLock lock];        
        [delayedActions addObject:delayedAction];        
        [actionLock unlock];        
        [loadingLock unlock];
    }
    [delayedAction release];
}

/**
 * getNumObjectsLoaded safely gets the number of objects loaded by
 * locking the variable with a loadingLock first
 * @return NSInteger - number of loaded objects
 */
- (NSInteger)getNumObjectsLoaded {
    [loadingLock lock];
    int numLoaded = numObjectsLoaded;
    [loadingLock unlock];
    return numLoaded;
}

/**
 * getNumObjectsAvailable safely gets the number of objects loaded by
 * locking the variable with a loadingLock first
 * @return NSInteger - number of available objects
 */
- (NSInteger)getNumObjectsAvailable {
    [loadingLock lock];
    int numTotal = totalObjectsAvailable;
    [loadingLock unlock];
    return numTotal;
}

/**
 * getNumObjectsLoadedAndAvailable safely gets the number of objects loaded
 * and the number of objects available in an array
 * @return NSArray * - array(numberOfObjectsLoaded, numberOfObjectsAvailable)
 */
- (NSArray *)getNumObjectsLoadedAndAvailable {
    [loadingLock lock];
    NSNumber *loadedObjectsNumber = [[NSNumber alloc] initWithInteger:numObjectsLoaded];
    NSNumber *totalObjecsNumber = [[NSNumber alloc] initWithInteger:totalObjectsAvailable];
    NSArray *data = [NSArray arrayWithObjects:loadedObjectsNumber, totalObjecsNumber, nil];
    [loadedObjectsNumber release];
    [totalObjecsNumber release];
    [loadingLock unlock];
    return data;
}

/**
 * objectAtIndex: returns the object at the index if it exists.
 * Otherwise, return nil.
 * @param NSInteger - index of the object to return
 * @return id - object if index is not out of bounds, nil otherwise
 */
- (id)objectAtIndex:(NSInteger)index {
    [loadingLock lock];
    id object = nil;
    if (index < [loadedObjects count]) {
        object = [loadedObjects objectAtIndex:index];
    }
    [loadingLock unlock];
    return object;
}

- (NSInteger)indexOfObject:(id)object {
    [loadingLock lock];
	NSInteger index = [loadedObjects indexOfObject:object];
	[loadingLock unlock];
	return index;
}

/**
 * insertObject:atIndex inserts an object in the collection at the index
 * provided and increases the count of objects available and loaded. 
 * All objects at index are shifted to the right by one
 * @param id object - object that is added
 * @param index that the object is added at
 */
- (BOOL)insertObject:(id)object atIndex:(NSInteger)index {
    [loadingLock lock];
    // this is done because if you tried to insert something that is farther than 
    // the loaded data + 1 then there would be a gap
    BOOL inserted = NO;
    if (!isLoading && object != nil && index <= [loadedObjects count] && ![self isDuplicateOfStoredObject:object]) {
        [loadedObjects insertObject:object atIndex:index];
        numObjectsLoaded += 1;
        totalObjectsAvailable += 1;
        start += 1;
        inserted = YES;
    }
    
    [loadingLock unlock];    
    return inserted;
}

/**
 * removeObjectAtIndex: removes the object at the index provided and shifts
 * all objects with index + 1 to the left.  Also, this method calls
 * callRemoteCollectionRemoveAtIndex to instruct the remote collection
 * to remove the object as well
 * @param NSInteger index - the index to remove
 */
- (void)removeObjectAtIndex:(NSInteger)index {
    [loadingLock lock];
    if (index < [loadedObjects count]) {
        [self callRemoteCollectionRemoveAtIndex:[loadedObjects objectAtIndex:index]];
        if (numObjectsLoaded > 0) { numObjectsLoaded -= 1; }
        if (totalObjectsAvailable > 0) { totalObjectsAvailable -= 1; }
        [loadedObjects removeObjectAtIndex:index];
    }    
    [loadingLock unlock];    
}

/**
 * callRemoteCollectionRemoveAtIndex tells the server that houses 
 * the remote collection to remove the object from it
 * @param id object - the object to remove
 */
- (void)callRemoteCollectionRemoveAtIndex:(id)object { }


/**
 * objectRemovedResponse is the function that handles a sucessful
 * response from the removal api method
 * @param NSNumber *responseInt - the response code of the api method
 * @param parsedResponse - the parsed response from the api
 */
- (void)objectRemovedResponse:(NSNumber *)responseInt parsedResponse:(NSDictionary *)parsedResponse {
    if (start > 0) { start -= 1; }
}

/**
 * objectFailedRemoval is the function that handles a failed response from
 * the removal api method
 */
- (void)objectFailedRemoval { }

/**
 * callRemoteLoadingMethod calls the api method that will respond with the next set of
 * data for the collection and attempt to load the numRequestedObjectsPerLoad objects.
 * If numRequestedObjectsPerLoad is 0, than it will attempt to load them all
 */
- (void)callRemoteCollectionLoadingMethodWithTarget:(id)target 
		finishedSelector:(SEL)finishedSelector failedSelector:(SEL)failedSelector {
    [NSException raise:@"Method Not Defined Exception" 
				format:@"Error, attempting to call an undefined method."];
}

/**
 * handleFinishedLoadingCollection:parsedResponse handles a successful response
 * from the remote loading method.  It puts the data in the collection and updates
 * the internal counters
 * @param NSNumber *responseInt - the response code
 * @param NSDictionary *parsedResponse - the parsed response from the api
 */
- (void)handleFinishedLoadingCollection:(NSNumber *)responseInt 
        parsedResponse:(NSDictionary *)parsedResponse {
    debug_NSLog(@"here is where we are");
    [loadingLock lock];
    self.completedInitialLoad = YES;    
    NSInteger startingIndex = [loadedObjects count];
    debug_NSLog(@"startingIndex: %d", startingIndex);
    if (![RestClient isResponseSuccessful:responseInt]) {
        [loadingLock unlock];         
        [self handleFailedLoadingCollectionWithResponse:responseInt];
        return;
    }
    
    id total = [parsedResponse objectForKey:@"total"];
    id objects = [parsedResponse objectForKey:collectionName];
    debug_NSLog(@"here is where we are");  
    if (![objects isKindOfClass:[NSArray class]] || ![total isKindOfClass:[NSNumber class]]) {
        debug_NSLog(@"objects not an array or total nan");
	    [loadingLock unlock];
        [self handleFailedLoadingCollection];        
        return;
    }

    if (totalObjectsAvailable == 0) {
        totalObjectsAvailable = (int) [total doubleValue];
        debug_NSLog(@"app received %d", totalObjectsAvailable);
    }
    
    id object;
    for (object in objects) {
        id packagedObject = [self packageObjectForSaving:object];
        if (packagedObject != nil && ![self isDuplicateOfStoredObject:packagedObject]) {
            [loadedObjects addObject:packagedObject];
            [packagedObject release];            
        } else {
            totalObjectsAvailable -= 1;
        }
    }
    NSInteger newlyStoredObjectCount = [loadedObjects count] - startingIndex;
    // Since we requested all items, even if we did not get the total set in the total
    // we assume we did
    if (numRequestedObjectsPerLoad == 0) {
        totalObjectsAvailable = newlyStoredObjectCount;
        start = newlyStoredObjectCount;
    } else {
        start += numRequestedObjectsPerLoad;
    }
    
    debug_NSLog(@"About to call handleNewly");
    // save the extra response if there is one
    NSDictionary *extraDataTemp = [parsedResponse objectForKey:@"extra_data"];
    if ((id)extraDataTemp == [NSNull null] ||
        ![extraDataTemp isKindOfClass:[NSDictionary class]]) {
        self.extraData = nil;
    } else {
		self.extraData = extraDataTemp;
    }
    
    [self handleNewlyStoredObjects:startingIndex count:newlyStoredObjectCount]; 
    debug_NSLog(@"Done calling handleNewly");
    if (isLoading) {
        debug_NSLog(@"isLoading is true");
    }
}

/**
 * isDuplicateOfStoredObject: returns true if the object sepcified is 
 * a duplicate of any of the objects already loaded in the collection
 * @param id object - the object being compared agains
 * @return YES if it is a duplicate, NO otherwise
 */
- (BOOL)isDuplicateOfStoredObject:(id)object {
    return NO;
}


/**
 * handleFailedLoadingCollection handles a failed response
 * from the remote loading method.
 */
- (void)handleFailedLoadingCollection {
    // OVERRIDE THIS IN THE SUBCLASS
	isLoading = NO;
    [actionLock lock];    
    [delayedActions removeAllObjects];
    [actionLock unlock];    
}

/**
 * handleFailedLoadingCollection handles a failed response with a specific
 * response code
 * @param NSNumber *response - the response code that it failed with
 */
- (void)handleFailedLoadingCollectionWithResponse:(NSNumber *)response {
    // TODO this is not thread safe
    [actionLock lock];    
    for (DelayedAction *delayedAction in delayedActions) {
        [delayedAction.target performSelector:delayedAction.selector withObject:response];
    }
    
    [delayedActions removeAllObjects];    
    [actionLock unlock];    
    [self handleFailedLoadingCollection];
}

/**
 * handleNewlyStoredObjects:count is called by the handleFinishedLoadingCollection method
 * after it has finished parsing and saving all of the objects it received from the
 * API. It updates the internal counts of number of objects loaded and tells the
 * finished selector to run on the target object
 * @param NSInteger startingIndex - the index in the collection that the new objects start
 * @param NSInteger count - the number of objects newly stored
 */
- (void)handleNewlyStoredObjects:(NSInteger)startingIndex count:(NSInteger)count {	
	isLoading = NO;
    [loadingLock unlock];
    numObjectsLoaded = [loadedObjects count];
    NSNumber *number = [[NSNumber alloc] initWithInteger:RESPONSE_SUCCESS];
    [actionLock lock];
    for (DelayedAction *delayedAction in delayedActions) {
        [delayedAction.target performSelector:delayedAction.selector withObject:number];
    }
    [delayedActions removeAllObjects];    
    [actionLock unlock];    
}

/**
 * packageObjectForSaving: translates the object from the dictionary format in JSON
 * to the format that the collection store wants it to be
 * @return id - packaged object
 */
- (id)packageObjectForSaving:(id)object {
    [object retain];
    return object;
}

- (void)setExtraData:(NSDictionary *)_value {
	[extraData release];
    if (_value == nil) {
        extraData = nil;
        return;
    }
	NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:[[_value allKeys] count]];
	for (NSString *item in [_value allKeys]) {
		id object = [[_value objectForKey:item] copy];
		[dict setObject:object forKey:item];
        [object release];
	}
	extraData = dict;
}


- (void)cancelDelayedActionOnTarget:(id)target {
    [actionLock lock];
    
    DelayedAction *da = [[DelayedAction alloc] init];
    da.target = target;
    [delayedActions removeObject:da];
    [da release];

    [actionLock unlock];
}

- (void)dealloc {
    [loadingLock release];
	[extraData release];
    [loadedObjects release];
    [collectionName release];
    [delayedActions release];
    [actionLock release];
	[super dealloc];
}
@end