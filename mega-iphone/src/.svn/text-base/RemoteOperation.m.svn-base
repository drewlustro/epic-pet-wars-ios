/**
 * RemoteOperation.m
 * Copyright Miraphonic, Inc 2009. All rights reserved.
 *
 * CurrentSession manages the user's session.  It holds user specific
 * data including user id and pet data.
 *
 * @author Amit Matani
 * @created 1/13/09
 */

#import "Mega/MegaGlobal.h"
#import "Mega/RemoteOperation.h"


@implementation RemoteOperation

@synthesize storedConnection, request, target, receivedData;

/**
 * initWithRequest:target:finishedSelector:failedSelector initializes
 * the object and its instance variables
 */
- (id)initWithRequest:(NSURLRequest *)req target:(id)tar
      finishedSelector:(SEL)finishedSel failedSelector:(SEL)failedSel {
	if (self = [super init]) {
		self.receivedData = [NSMutableData data];
        finishedSelector = finishedSel;
        failedSelector = failedSel;
        self.target = tar;
        self.request = req;
        executing = NO;
        finished = NO;
	}
	return self;    
}

#pragma mark NSOperation methods

/**
 * start sets up the NSOperation variables and begins the request
 */
- (void)start {
    debug_NSLog(@"%@", [[request URL] absoluteString]);
    debug_NSLog(@"getting abs url");
    [self willChangeValueForKey:@"isExecuting"];
    NSURLConnection *newConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    executing = YES;
    self.storedConnection = newConnection;
    [newConnection release];
    [self didChangeValueForKey:@"isExecuting"];
}

/**
 * isConcurrent tells the calling object that the operation is
 * concurrent
 * @return YES
 */
- (BOOL)isConcurrent {
    return YES;
}

/**
 * isExecuting determines if the operation is still in execution
 * @return YES if in operation, NO otherwise
 */
- (BOOL)isExecuting {
    return executing;
}

/**
 * isFinished determines if the operation is still in execution
 * @return YES if finished, NO otherwise
 */
- (BOOL)isFinished {
    if (finished) {
        debug_NSLog(@"%@ is finished", [[request URL] absoluteString]);        
    } else {
        debug_NSLog(@"%@ is not finished", [[request URL] absoluteString]); 
    }
    return finished;
}

/**
 * cancel tells the operation to cancel and cancels the stored connection
 */
- (void)cancel {
    [storedConnection cancel];
    [super cancel];
}

- (void)dealloc {
    if (target != self) {
        [target release];
    }
    [storedConnection release];
	[request release];
    [receivedData release];
	[super dealloc];
}

#pragma mark connection related methods
/**
 * connection:didReceiveResponse:
 */
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	if (![self isCancelled]) {
	    [receivedData setLength:0];
	}
}

/**
 * connection:didReceiveData: appends the data received from the connection
 * and appends it to the NSData object receivedData
 * @param NSURLConnection connection object that received the data
 * @param NSData data - the data that was received
 */
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	if (![self isCancelled]) {	
	    [receivedData appendData:data];
    }
}

/**
 * connection:didFailWithError: is called if the connection failed with an error.
 * The function will spawn an alert view instructing the user of the error
 * @param NSURLConnection connection object that received the data
 * @param NSError error - the error that occurred
 */
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	if (![self isCancelled]) {
        [Utility internetConnectionFailed];
	}
}

/**
 * alertView:clickedButtonAtIndex: is called after a user interacts with the
 * messsage alerting him about a failed connection. This method sets
 * the NSOPeration variables to not excuting and runs the failed selector
 * @param UIAlertView alertView the alertView that was interacted with
 * @param NSInteger buttonIndex - the index of the button clicked
 */
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [self willChangeValueForKey:@"isExecuting"];
    [self willChangeValueForKey:@"isFinished"];
    executing = NO;
    finished = YES;
    debug_NSLog(@"Failed");
    [target performSelector:failedSelector];    
    [self didChangeValueForKey:@"isExecuting"];
    [self didChangeValueForKey:@"isFinished"];        
}

/**
 * connection:didFinishLoading: is called if the connection finished loading
 * all data associated with the request without error.  It will set the
 * NSOperation variables to not excuting and finihsed and runs the
 * finishedSelector
 * @param NSURLConnection connection object that received the data
 */
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [self willChangeValueForKey:@"isExecuting"];
    [self willChangeValueForKey:@"isFinished"];	
    executing = NO;
    finished = YES;  
    if (![self isCancelled]) {
        [self runFinishedSelector];    
	}
    [self didChangeValueForKey:@"isExecuting"];
    [self didChangeValueForKey:@"isFinished"];    
}

/**
 * runFinishedSelector runs the finished selector. Subclasses of this class 
 * should override this function
 */
- (void)runFinishedSelector {
    [NSException raise:@"Method Not Defined Exception" 
				format:@"Error, attempting to call an undefined method."];
}

@end
