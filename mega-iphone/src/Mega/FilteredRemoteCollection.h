//
//  FilteredRemoteCollection.h
//  battleroyale
//
//  Created by Amit Matani on 5/18/09.
//  Copyright 2009 Miraphonic, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RemoteCollection.h"

@protocol FilteredRemoteCollectionDelegate;

@class AbstractRemoteCollectionStore;
@interface FilteredRemoteCollection : NSObject <RemoteCollection> {
    id<FilteredRemoteCollectionDelegate> _delegate;
    AbstractRemoteCollectionStore *_remoteCollectionStore;
}

@property (nonatomic, assign) id<FilteredRemoteCollectionDelegate> delegate;

- (id)initWithRemoteCollectionStore:(AbstractRemoteCollectionStore *)remoteCollectionStore 
                           delegate:(id<FilteredRemoteCollectionDelegate>)delegate;

@end

@protocol FilteredRemoteCollectionDelegate <NSObject>

- (BOOL)shouldIncludeObject:(id)object;

@end
