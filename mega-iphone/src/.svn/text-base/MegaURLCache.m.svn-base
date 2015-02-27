//
//  MegaURLCache.m
//  Mega
//
//  Created by Amit Matani on 1/13/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MegaURLCache.h"
#import "Consts.h"
#import <UIKit/UIKit.h>

@implementation MegaURLCache

@synthesize localCache = _localCache;

- (id)initWithMemoryCapacity:(NSUInteger)memoryCapacity diskCapacity:(NSUInteger)diskCapacity diskPath:(NSString *)path {
	if (self = [super initWithMemoryCapacity:memoryCapacity diskCapacity:diskCapacity diskPath:path]) {
		debug_NSLog(@"Initialize Memory Size: %d, Usage: %d", [self memoryCapacity], [self currentMemoryUsage]);
	}
	return self;
}

- (BOOL)isPNG:(NSString *)url {
	// TODO case insensitive
	return [url hasSuffix:@"png"];
}

- (void)setMemoryCapacity:(NSUInteger)memoryCapacity {
	if (memoryCapacity > 0) {
		debug_NSLog(@"SETTING MEMORY CAPACITY");
		debug_NSLog(@"Memory Size: %d, Usage: %d", [self memoryCapacity], [self currentMemoryUsage]);
		[super setMemoryCapacity:memoryCapacity];
	}

}

- (NSCachedURLResponse *)cachedResponseForRequest:(NSURLRequest *)request {
	NSCachedURLResponse *returnedResponse = [super cachedResponseForRequest:request];
	
	@synchronized(self) {	
		debug_NSLog(@"Searching For: %@", [[request URL] absoluteString]);
		debug_NSLog(@"Memory Size: %d, Usage: %d", [self memoryCapacity], [self currentMemoryUsage]);
		NSString *requestUrl = [[request URL] absoluteString];

		if ([self isPNG:requestUrl] && _localCache && returnedResponse == nil) {
			
			UIImage *image = [_localCache getObjectFromCacheWithKey:requestUrl];
			if (image != nil) {
				NSData *imageData = UIImagePNGRepresentation((UIImage *)image);
				if (imageData != nil) {
					NSURLResponse *response = [[NSURLResponse alloc] initWithURL:[request URL] MIMEType:@"image/png" expectedContentLength:[imageData length] textEncodingName:nil];
					NSCachedURLResponse *cachedResponse = [[NSCachedURLResponse alloc] initWithResponse:response data:imageData];
					[super storeCachedResponse:cachedResponse forRequest:request];
					[cachedResponse release];
					NSCachedURLResponse *getResponse = [super cachedResponseForRequest:request];
					debug_NSLog(@"Memory Size: %d, Usage: %d", [self memoryCapacity], [self currentMemoryUsage]);
					if (getResponse != nil) {
						debug_NSLog(@"--- not nil ---");
					} else {
						debug_NSLog(@"--- nil ---");
					}

					
//					return cachedResponse;
					return getResponse;
				}
				
			} else {
				[_localCache getObjectWithKey:requestUrl target:nil selector:nil];
			}
		}
	}
	
	return returnedResponse;
}



@end
