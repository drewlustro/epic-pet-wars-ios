//
//  main.m
//  battleroyale
//
//  Created by Amit Matani on 1/13/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Mega/MegaURLCache.h"


int main(int argc, char *argv[]) {
    
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	//[[NSURLCache sharedURLCache] setMemoryCapacity:0];
	//[[NSURLCache sharedURLCache] setDiskCapacity:0];
    int retVal = UIApplicationMain(argc, argv, nil, nil);
    [pool release];
    return retVal;
}


