/**
 * ImageDownloadOperation.m
 * Copyright Miraphonic, Inc 2009. All rights reserved.
 *
 * ImageDownloadOperation is a subclass of RemoteOperation. It is used 
 * to handle image download requests
 *
 * @author Amit Matani
 * @created 1/13/09
 */

#import "Mega/ImageDownloadOperation.h"


@implementation ImageDownloadOperation

/**
 * runFinishedSelector creates an image object with the receivedData and passes
 * it to the target object
 */
- (void)runFinishedSelector {
    UIImage *image = [[UIImage alloc] initWithData:receivedData];
    NSString *requestUrl = [[request URL] absoluteString];
    [target performSelector:finishedSelector withObject:image withObject:requestUrl];
    [image release];
}


@end
