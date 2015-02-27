/**
 * AbstractRemoteCollectionWithCategories.h
 * Copyright Miraphonic, Inc 2009. All rights reserved.
 *
 * The AbstractRemoteCollectionWithCategories handles the
 * management of remote collections that are broken up into 
 * categories.  The JSON of these categories should look like
 * {'category_name' => [{'variable1' : 1}, {'variable1' : 2}]}
 * Unlike the AbstractRemoteCollectionStore this object cannot handle
 * just partial loading of collections.  It is an all or nothing
 * system
 *
 * @author Amit Matani
 * @created 1/27/09
 */

#import "Mega/MegaGlobal.h"


@interface AbstractRemoteCollectionWithCategories : NSObject {
    BOOL hasDataLoaded, isLoading;
    NSMutableDictionary *data;
    NSLock *loadingLock;
    NSMutableArray *delayedActions;
    NSDictionary *extraData;    
}

@property(nonatomic, retain) NSDictionary *extraData;

/**
 * loadItemsWithTarget:finishedSelector:failedSelector:forceReload tells the EquipmentSet
 * to load the equipment data. When the data is loaded the target is called with the
 * finishedselector.  If there was an error loading the failedselector is called.
 * If the data has already been loaded the finishedSelector is called right away
 * unless force reload is set to true
 * @param id target the target to run the responses on
 * @param SEL _finishedSelector - is called with the current object as an attachment 
 * with a proper load
 * @param SEL _failedSelector - is called when loading fails
 * @param BOOL forceReload - forces a reload
 */
- (void)loadItemsWithTarget:(id)target finishedSelector:(SEL)_finishedSelector
        failedSelector:(SEL)_failedSelector forceReload:(BOOL)forceReload;
        
/**
 * packageResponseWithCode:parsedResponse will take a properly
 * finished response and package the objects and put them into
 * the proper category
 * @param NSNumber *responseCode
 * @param NSDictionary *parsedResponse
 */
- (void)packageResponseWithCode:(NSNumber *)responseCode 
        parsedResponse:(NSDictionary *)parsedResponse;

/**
 * failedLoading is called when an item load was attempted but failed
 */
- (void)failedLoading;

/**
 * hasDataLoaded will return true if the data has actually been
 * loaded and packaged
 * @return YES if the data has loaded
 */
- (BOOL)hasDataLoaded;
   
/** 
 * getObjectsWithCategory takes the category key and an index and will 
 * return the object associated with it.  If no object exists, it returns
 * nil
 * @param NSString *category is the key of the category
 * @param NSINteger atIndex is the index that the object should be at
 * @return the object
 */ 
- (id)getObjectWithCategory:(NSString *)category atIndex:(NSInteger)index;

- (NSArray *)getObjectsInCategory:(NSString *)category;

/** 
 * removeObject:inCategory takes the category key and remove the object if 
 * it is in the category
 * @param NSObject atIndex is the index that the object should be at 
 * @param NSString *category is the key of the category
 */ 
- (void)removeObject:(NSObject *)object;

- (void)addObject:(NSObject *)object inCategory:(NSString *)category;

/**
 * getNumObjectsInCategory returns the number of objects in a category
 * identified with category
 * @param NSString *category
 * @return NSInteger number of items in the category
 */
- (NSInteger)getNumObjectsInCategory:(NSString *)category;

/**
 * getKeyMap returns a dictionary object mapping keys to their
 * pretty names
 */
- (NSDictionary *)getKeyMap;

/**
 * getCategoryKeys is an abstract function that must be defined
 * by the subclass.  It returns the category keys as strings in 
 * an array
 * @return array containing NSString * of keys
 */
- (NSArray *)getCategoryKeys;

/**
 * return a human readable name for a category key
 */
- (NSString *)getPrettyNameForKey:(NSString *)key;

/** 
 * callRemoteLoading method is an abstract method that needs to be subclassed.
 * It is used by the class to call the method that loads up the remote json
 * @param id target the target that the method needs to be called on
 * @param SEL finishedSelector the finished selector to run
 * @param SEL failedSelector - the failed selector to run
 */
- (void)callRemoteLoadingMethodWithTarget:(id)target finishedSelector:(SEL)_finishedSelector
        failedSelector:(SEL)_failedSelector;
        
/**
 * packageDictionaryObject takes an unparsedobject and category key
 * and returns a packaged object with a retain count of 1.  It should
 * be alloced because the parent function will be running a release
 * on it.
 * @param NSDictionary *unparsedObject - json formated object
 * @param NSString *key - the category key
 * @return id object - a properly malloced object
 */
- (id)packageDictionaryObject:(NSDictionary *)unparsedObject inCategory:(NSString *)key;

/**
 * getNumObjectsInCategoryUnsafe returns the number of objects in a category
 * identified with category but does so without a lock
 * @param NSString *category
 * @return NSInteger number of items in the category
 */
- (NSInteger)getNumObjectsInCategoryUnsafe:(NSString *)category;
 
/**
 * getTotalObjects returns the total number of objects loaded
 * @return int total number of objects
 */
- (NSInteger)getTotalObjects;

- (void)cancelDelayedActionOnTarget:(id)target;

- (void)reset;

@end
