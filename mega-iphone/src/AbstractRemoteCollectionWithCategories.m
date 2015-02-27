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
#import "Mega/AbstractRemoteCollectionWithCategories.h"
#import "Mega/RestClient.h"
#import "Mega/DelayedAction.h"

@implementation AbstractRemoteCollectionWithCategories
@synthesize extraData;

- (id)init {
    if (self = [super init]) {
        loadingLock = [[NSLock alloc] init];
        isLoading = hasDataLoaded = NO;
        delayedActions = [[NSMutableArray alloc] initWithCapacity:1];
    }
    return self;
}

/**
 * getKeyMap returns a dictionary object mapping keys to their
 * pretty names
 */
- (NSDictionary *)getKeyMap {
    [NSException raise:@"Method Not Defined Exception" 
				format:@"Error, attempting to call an undefined method getCategoryKeys."];    
	return nil;
}

/**
 * getCategoryKeys is an abstract function that must be defined
 * by the subclass.  It returns the category keys as strings in 
 * an array
 * @return array containing NSString * of keys
 */
- (NSArray *)getCategoryKeys {
    return [[self getKeyMap] allKeys];
}

/**
 * return a human readable name for a category key
 */
- (NSString *)getPrettyNameForKey:(NSString *)key {
    return [[self getKeyMap] objectForKey:key];
}


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
     failedSelector:(SEL)_failedSelector forceReload:(BOOL)forceReload {
	[loadingLock lock];
    if (hasDataLoaded && !forceReload) {
        [loadingLock unlock];
        [target performSelector:_finishedSelector withObject:self];
		return;
    }
    if (forceReload) { hasDataLoaded = NO; }
    
    DelayedAction *action = [[DelayedAction alloc] init];
    action.target = target;
    action.selector = _finishedSelector;
    action.failedSelector = _failedSelector;
    [delayedActions addObject:action];
    [action release];
    if (!isLoading) {
        isLoading = YES;
        [self callRemoteLoadingMethodWithTarget:self 
              finishedSelector:@selector(packageResponseWithCode:parsedResponse:)
              failedSelector:@selector(failedLoading)];
    }
	[loadingLock unlock];
}

/** 
 * callRemoteLoading method is an abstract method that needs to be subclassed.
 * It is used by the class to call the method that loads up the remote json
 * @param id target the target that the method needs to be called on
 * @param SEL finishedSelector the finished selector to run
 * @param SEL failedSelector - the failed selector to run
 */
- (void)callRemoteLoadingMethodWithTarget:(id)target finishedSelector:(SEL)_finishedSelector
        failedSelector:(SEL)_failedSelector; {
    [NSException raise:@"Method Not Defined Exception" 
				format:@"Error, attempting to call an undefined method callRemoteLoadingMethod."];
}
        
/**
 * packageResponseWithCode:parsedResponse will take a properly
 * finished response and package the objects and put them into
 * the proper category
 * @param NSNumber *responseCode
 * @param NSDictionary *parsedResponse
 */
- (void)packageResponseWithCode:(NSNumber *)responseCode 
        parsedResponse:(NSDictionary *)parsedResponse {
	[loadingLock lock];            
    if (![RestClient isResponseSuccessful:responseCode]) {
	    [loadingLock unlock];        
        [self failedLoading];
        return;
    }      
    NSArray *keys = [self getCategoryKeys];
    NSMutableArray *categoryArrays = [[NSMutableArray alloc] initWithCapacity:[keys count]];    
    id categoryArray;
    // verification step first
    for (NSString *key in keys) {   
        categoryArray = [parsedResponse objectForKey:key];
        if (categoryArray == nil || ![categoryArray isKindOfClass:[NSArray class]]) {
            [categoryArrays release];
            [self failedLoading];
	        [loadingLock unlock];            
            return;
        }
        NSMutableArray *cArray = 
            [[NSMutableArray alloc] initWithCapacity:[(NSArray *)categoryArray count]];         
        [categoryArrays addObject:cArray];
        [cArray release];
    }
    
    NSMutableDictionary *newData = [[NSMutableDictionary alloc] initWithObjects:categoryArrays forKeys:keys]; 
    int count = 0;
    
    for (NSString *key in keys) {   
        categoryArray = [parsedResponse objectForKey:key];
        NSMutableArray *packagedCategoryArray = [categoryArrays objectAtIndex:count];
        for (NSDictionary *unparsedObject in (NSArray *)categoryArray) {
            id object = [self packageDictionaryObject:unparsedObject inCategory:key];
            [packagedCategoryArray addObject:object];
            [object release];
        }     
        count += 1;
    }
    [data release];
    data = newData;
    [categoryArrays release];
    
    NSDictionary *extraDataTemp = [parsedResponse objectForKey:@"extra_data"];
    if ((id)extraDataTemp == [NSNull null] ||
        ![extraDataTemp isKindOfClass:[NSDictionary class]]) {
        self.extraData = nil;
    } else {
		self.extraData = extraDataTemp;
    }
    
    isLoading = NO;
    hasDataLoaded = YES;
    [loadingLock unlock];
    for (DelayedAction *delayedAction in delayedActions) {
        [delayedAction.target performSelector:delayedAction.selector withObject:self];
    }
    [delayedActions removeAllObjects];            
}

/**
 * failedLoading is called when an item load was attempted but failed
 */
- (void)failedLoading {
    for (DelayedAction *delayedAction in delayedActions) {
        [delayedAction.target performSelector:delayedAction.failedSelector];
    }
    [delayedActions removeAllObjects];
}

/**
 * hasDataLoaded will return true if the data has actually been
 * loaded and packaged
 * @return YES if the data has loaded
 */
- (BOOL)hasDataLoaded {
    return hasDataLoaded;
}
   
/** 
 * getObjectsWithCategory takes the category key and an index and will 
 * return the object associated with it.  If no object exists, it returns
 * nil
 * @param NSString *category is the key of the category
 * @param NSINteger atIndex is the index that the object should be at
 * @return the object
 */ 
- (id)getObjectWithCategory:(NSString *)category atIndex:(NSInteger)index {
    [loadingLock lock];
    id object = nil;
    if (hasDataLoaded) {
        NSArray *objectsInCategory = [data objectForKey:category];
        if (index >= 0 && index < [(NSArray *)objectsInCategory count]) {
            object = [(NSArray *)objectsInCategory objectAtIndex:index];
        }
    }
    [loadingLock unlock];
    return object;    
}

/**
 * returns the objects in the specified category
 */
- (NSArray *)getObjectsInCategory:(NSString *)category {
    [loadingLock lock];
    NSArray *objectsInCategory = [data objectForKey:category];    
    [loadingLock unlock];
    return objectsInCategory;
}

/**
 *
 */
- (void)addObject:(NSObject *)object inCategory:(NSString *)category {
    [loadingLock lock];
    if (hasDataLoaded) {
        [[data objectForKey:category] addObject:object]; 
    }
    [loadingLock unlock];    
}

/** 
 * removeObject:inCategory takes the category key and remove the object if 
 * it is in the category
 * @param NSObject atIndex is the index that the object should be at 
 * @param NSString *category is the key of the category
 */ 
- (void)removeObject:(NSObject *)object {
    [loadingLock lock];
    if (hasDataLoaded) {
        for (NSMutableArray *objectsInCategory in [data allValues]) {
            [objectsInCategory removeObject:object];            
        }
    }
    [loadingLock unlock];    
}

/**
 * getNumObjectsInCategory returns the number of objects in a category
 * identified with category
 * @param NSString *category
 * @return NSInteger number of items in the category
 */
- (NSInteger)getNumObjectsInCategory:(NSString *)category {
    [loadingLock lock];
    int num = [self getNumObjectsInCategoryUnsafe:category];
    [loadingLock unlock];
    return num;
}

/**
 * getNumObjectsInCategoryUnsafe returns the number of objects in a category
 * identified with category but does so without a lock
 * @param NSString *category
 * @return NSInteger number of items in the category
 */
- (NSInteger)getNumObjectsInCategoryUnsafe:(NSString *)category {
    int num = 0;
    if (hasDataLoaded) {
        NSArray *objectsInCategory = [data objectForKey:category];
        num = [(NSArray *)objectsInCategory count];
    }
    return num;
}

/**
 * getTotalObjects returns the total number of objects loaded
 * @return int total number of objects
 */
- (NSInteger)getTotalObjects {
    NSArray *keys = [self getCategoryKeys];
    int num = 0;
    [loadingLock lock];
    for (NSString *key in keys) {
        num += [self getNumObjectsInCategoryUnsafe:key];
    }
    [loadingLock unlock];
    return num;
}

/**
 * packageDictionaryObject takes an unparsedobject and category key
 * and returns a packaged object with a retain count of 1.  It should
 * be alloced because the parent function will be running a release
 * on it.
 * @param NSDictionary *unparsedObject - json formated object
 * @param NSString *key - the category key
 * @return id object - a properly malloced object
 */
- (id)packageDictionaryObject:(NSDictionary *)unparsedObject inCategory:(NSString *)key {
    [NSException raise:@"Method Not Defined Exception" 
                 format:@"Error, attempting to call an undefined method packageDictionaryObject."];
	return nil;
}

- (void)cancelDelayedActionOnTarget:(id)target {
    int i = 0;
    [loadingLock lock];    
    while (i < [delayedActions count]) {
        DelayedAction *action = (DelayedAction *) [delayedActions objectAtIndex:i];
        if (action.target == target) {
            [delayedActions removeObject:action];
        } else {
            i += 1;
        }        
    }
    [loadingLock unlock];    
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


- (void)reset {
    [loadingLock lock];   
	if (hasDataLoaded) {
		hasDataLoaded = NO;
	}
	[loadingLock unlock];   
}

- (void)dealloc {
    [data release];
    [loadingLock release];
    [extraData release];
    [delayedActions release];
    [super dealloc];
}
@end
