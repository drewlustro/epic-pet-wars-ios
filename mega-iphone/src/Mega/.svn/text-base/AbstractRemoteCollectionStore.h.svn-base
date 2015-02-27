/**
 * AbstractRemoteCollectionStore.h
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

#import <Foundation/Foundation.h>
#import "RemoteCollection.h"

@interface AbstractRemoteCollectionStore : NSObject <RemoteCollection> {
    // A lock that is used when requesting more data from the remote server
    NSLock *loadingLock, *actionLock;
    
    // A check to see if the collection store is attempting to load more data
    BOOL isLoading;
    
    // Array of objects that are already loaded
    NSMutableArray *loadedObjects;
    
    // The number of objects to request when doing asking for more data
    NSInteger numRequestedObjectsPerLoad;
    
    // The target object and selector that is called when the loading is done
//    id finishedLoadingTarget;
//    SEL finishedLoadingSelector;
    
    // The number of objects already loaded
    NSInteger numObjectsLoaded;
    
    // The total number of objects that the remote collection holds
    NSInteger totalObjectsAvailable;
    
    // the current offset in the collection that has been loaded
    NSInteger start;    
    
    // the name of the collection
    NSString *collectionName;
    
    // a boolean to check if the initial loaded of remote data has completed
    BOOL completedInitialLoad;
    
    // extra data received from the parsed response
    NSDictionary *extraData;
    
    NSMutableArray *delayedActions;
}
@property (nonatomic, assign) NSInteger totalObjectsAvailable;
@property (readonly) NSInteger numObjectsLoaded;
@property (nonatomic, assign) BOOL completedInitialLoad;
@property (nonatomic, retain) NSDictionary *extraData;


/**
 * initWithCollectionName:numObjectsPerLoad: takes the name and the number objects
 * available per load and creates the initial environment.  The name of the collection
 * should correspond to the string that identifies the collection in the JSON
 * result
 * @param NSString *name - name of collection
 * @param NSInteger numObjectsPerLoad - the number of objects that can be loaded at each load data call.
 * If 0, it will attempt to load all the items in the collection
 * @return id - instantiated remote collection store
 */
- (id)initWithCollectionName:(NSString *)name numObjectsPerLoad:(NSInteger)numObjectsPerLoad;


/**
 * callRemoteCollectionRemoveAtIndex tells the server that houses 
 * the remote collection to remove the object from it
 * @param id object - the object to remove
 */
- (void)callRemoteCollectionRemoveAtIndex:(id)object;


/**
 * objectRemovedResponse is the function that handles a sucessful
 * response from the removal api method
 * @param NSNumber *responseInt - the response code of the api method
 * @param parsedResponse - the parsed response from the api
 */
- (void)objectRemovedResponse:(NSNumber *)responseInt parsedResponse:(NSDictionary *)parsedResponse;

/**
 * objectFailedRemoval is the function that handles a failed response from
 * the removal api method
 */
- (void)objectFailedRemoval;

/**
 * callRemoteCollectionLoadingMethodWithTarget calls the api method that will respond with the next set of
 * data for the collection
 */
- (void)callRemoteCollectionLoadingMethodWithTarget:(id)target 
								   finishedSelector:(SEL)finishedSelector failedSelector:(SEL)failedSelector;

/**
 * handleFinishedLoadingCollection:parsedResponse handles a successful response
 * from the remote loading method.  It puts the data in the collection and updates
 * the internal counters
 * @param NSNumber *responseInt - the response code
 * @param NSDictionary *parsedResponse - the parsed response from the api
 */
- (void)handleFinishedLoadingCollection:(NSNumber *)responseInt 
        parsedResponse:(NSDictionary *)parsedResponse;

/**
 * isDuplicateOfStoredObject: returns true if the object sepcified is 
 * a duplicate of any of the objects already loaded in the collection
 * @param id object - the object being compared agains
 * @return YES if it is a duplicate, NO otherwise
 */
- (BOOL)isDuplicateOfStoredObject:(id)object;


/**
 * handleFailedLoadingCollection handles a failed response
 * from the remote loading method.
 */
- (void)handleFailedLoadingCollection;

/**
 * handleFailedLoadingCollection handles a failed response with a specific
 * response code
 * @param NSNumber *response - the response code that it failed with
 */
- (void)handleFailedLoadingCollectionWithResponse:(NSNumber *)response;

/**
 * handleNewlyStoredObjects:count is called by the handleFinishedLoadingCollection method
 * after it has finished parsing and saving all of the objects it received from the
 * API. It updates the internal counts of number of objects loaded and tells the
 * finished selector to run on the target object
 * @param NSInteger startingIndex - the index in the collection that the new objects start
 * @param NSInteger count - the number of objects newly stored
 */
- (void)handleNewlyStoredObjects:(NSInteger)startingIndex count:(NSInteger)count;

/**
 * packageObjectForSaving: translates the object from the dictionary format in JSON
 * to the format that the collection store wants it to be
 * @return id - packaged object
 */
- (id)packageObjectForSaving:(id)object;

@end
