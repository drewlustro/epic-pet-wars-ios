/**
 * ABTableViewCellWithFileImageStore.m
 * Copyright Miraphonic, Inc 2009. All rights reserved.
 *
 * @author Amit Matani 
 * @created 3/22/09.
 */

#import "ABTableViewCellWithFileImageStore.h"
#import "BRSession.h"
#import "ReusableRemoteImageStoreWithFileCache.h"
#import "BRAppDelegate.h"

@implementation ABTableViewCellWithFileImageStore


- (void)loadImageWithUrl:(NSString *)url {    
    ReusableRemoteImageStoreWithFileCache *imageStore = [[BRAppDelegate sharedManager] imageStoreWithFileCache];
    self.imageUrl = url;
    [imageStore getObjectWithKey:url 
                          target:self
                        selector:@selector(setImage:withUrl:)];
}

- (void)dealloc {
    ReusableRemoteImageStoreWithFileCache *imageStore = [[BRAppDelegate sharedManager] imageStoreWithFileCache];
    [imageStore cancelDelayedActionOnTarget:self];
    [super dealloc];
}


@end
