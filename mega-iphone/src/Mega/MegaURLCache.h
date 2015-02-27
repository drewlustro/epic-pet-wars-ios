//
//  MegaURLCache.h
//  Mega
//
//  Created by Amit Matani on 1/13/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ReusableRemoteImageStore.h"

@interface MegaURLCache : NSURLCache {
	ReusableRemoteImageStore *_localCache;
}

@property (nonatomic, assign) ReusableRemoteImageStore *localCache;

@end
