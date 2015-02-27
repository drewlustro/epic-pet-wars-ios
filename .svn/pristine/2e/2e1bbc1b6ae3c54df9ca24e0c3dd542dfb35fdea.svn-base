//
//  RemoteImageViewWithFileStore.m
//  battleroyale
//
//  Created by Amit Matani on 3/22/09.
//  Copyright 2009 Miraphonic, Inc. All rights reserved.
//

#import "RemoteImageViewWithFileStore.h"
#import "BRAppDelegate.h"
#import "ReusableRemoteImageStoreWithFileCache.h"
#import "Consts.h"

@implementation RemoteImageViewWithFileStore


- (void)loadImageWithUrl:(NSString *)url {   
    if (url != nil) {
        [self showLoadingIndicator];
    }
    ReusableRemoteImageStoreWithFileCache *imageStore = [[BRAppDelegate sharedManager] imageStoreWithFileCache];
    self.requestedImageUrl = url;
    [imageStore getObjectWithKey:url 
                          target:self
                        selector:@selector(setImage:withUrl:)];
}

- (void)dealloc {
    debug_NSLog(@"deallocing RemoteImageViewWithFileStore view");
    ReusableRemoteImageStoreWithFileCache *imageStore = [[BRAppDelegate sharedManager] imageStoreWithFileCache];
    [imageStore cancelDelayedActionOnTarget:self];
    [super dealloc];
}

@end
