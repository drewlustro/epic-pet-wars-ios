//
//  FilteredRemoteCollection.m
//  battleroyale
//
//  Created by Amit Matani on 5/18/09.
//  Copyright 2009 Miraphonic, Inc. All rights reserved.
//

#import "FilteredRemoteCollection.h"
#import "AbstractRemoteCollectionStore.h"

#define NO_TARGET_INDEX -2
@implementation FilteredRemoteCollection
@synthesize delegate = _delegate;

- (id)initWithRemoteCollectionStore:(AbstractRemoteCollectionStore *)remoteCollectionStore 
                           delegate:(id<FilteredRemoteCollectionDelegate>)delegate {
    if (self = [super init]) {
        _remoteCollectionStore = [remoteCollectionStore retain];
        _delegate = delegate;
    }
    return self;
}

- (id)translateIndex:(int)targetIndex targetObject:(id)targetObject 
          localIndex:(int *)localIndex counter:(int *)counter {
    int _localIndex = -1, _counter = 0;
    id object = nil;
    do {
        object = [_remoteCollectionStore objectAtIndex:_counter];
        if ([_delegate shouldIncludeObject:object]) {
            _localIndex += 1;
        }
        _counter += 1;
    } while (object != nil && object != targetObject && _localIndex != targetIndex);
    
    (* localIndex) = _localIndex;
    (* counter) = _counter;
    
    return object;
}

- (NSInteger)getNumObjectsLoaded {
    int count = 0, counter = 0;
    [self translateIndex:NO_TARGET_INDEX targetObject:nil localIndex:&count counter:&counter];
    
    return count + 1;
}

- (NSInteger)getNumObjectsAvailable {
    return [_remoteCollectionStore getNumObjectsLoaded];
}

- (NSArray *)getNumObjectsLoadedAndAvailable {
    NSNumber *numLoaded = [NSNumber numberWithInt:[self getNumObjectsLoaded]];
    return [NSArray arrayWithObjects:numLoaded, numLoaded, nil];
}


- (id)objectAtIndex:(NSInteger)index {
    int localIndex = 0, counter = 0;
    return [self translateIndex:index targetObject:nil localIndex:&localIndex counter:&counter];
}

- (NSInteger)indexOfObject:(id)object {
    int localIndex = 0, counter = 0;
    id localObject = [self translateIndex:NO_TARGET_INDEX targetObject:nil localIndex:&localIndex counter:&counter];
    
    if (localObject != nil) {
        return localIndex;
    }
    
    return -1;
}

- (BOOL)insertObject:(id)object atIndex:(NSInteger)index {
    int localIndex = 0, counter = 0;
    [self translateIndex:index targetObject:nil localIndex:&localIndex counter:&counter];
    
    return [_remoteCollectionStore insertObject:object atIndex:counter];
}

- (void)removeObjectAtIndex:(NSInteger)index {
    int localIndex = 0, counter = 0;
    [self translateIndex:index targetObject:nil localIndex:&localIndex counter:&counter];
    
    [_remoteCollectionStore removeObjectAtIndex:counter];
}

- (void)resetCollection {
    [_remoteCollectionStore resetCollection];
}

- (void)loadRemoteCollectionWithTarget:(id)target selector:(SEL)selector {
    [_remoteCollectionStore loadRemoteCollectionWithTarget:target selector:selector];
}

- (void)cancelDelayedActionOnTarget:(id)target {
    [_remoteCollectionStore cancelDelayedActionOnTarget:target];
}

- (NSDictionary *)extraData {
    return [_remoteCollectionStore extraData];
}

- (BOOL)completedInitialLoad {
    return [_remoteCollectionStore completedInitialLoad];
}

@end
