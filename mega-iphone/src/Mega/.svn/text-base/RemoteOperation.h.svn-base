#import "Mega/MegaGlobal.h"
/**
 * RemoteOperation.h
 * Copyright Miraphonic, Inc 2009. All rights reserved.
 *
 * RemoteOperation is the base class for remote operations
 *
 * @author Amit Matani
 * @created 1/13/09
 */

@interface RemoteOperation : NSOperation {
    // Holds the data received from the remote operation
	NSMutableData *receivedData;
	
	// the selectors to run when the operation finishes or fails
    SEL finishedSelector, failedSelector;
    
    // the object to run the selectors on
    id target;
    
    // the connection that is associated with the remote operation
    NSURLConnection *storedConnection;
    
    // the request that is associated with the remote operation
    NSURLRequest *request;
    
    // bools to see if the operation is still ocurring
    BOOL executing;
    BOOL finished;
}

@property(retain) NSMutableData *receivedData;
@property(retain) NSURLConnection *storedConnection;
@property(retain) NSURLRequest *request;
@property(retain) id target;

/**
 * initWithRequest:target:finishedSelector:failedSelector initializes
 * the object and its instance variables
 */
- (id)initWithRequest:(NSURLRequest *)req target:(id)tar
	  finishedSelector:(SEL)finishedSel failedSelector:(SEL)failedSel;

/**
 * connection:didReceiveResponse:
 */
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response;

/**
 * connection:didReceiveData: appends the data received from the connection
 * and appends it to the NSData object receivedData
 * @param NSURLConnection connection object that received the data
 * @param NSData data - the data that was received
 */
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data;

/**
 * connection:didFailWithError: is called if the connection failed with an error.
 * The function will spawn an alert view instructing the user of the error
 * @param NSURLConnection connection object that received the data
 * @param NSError error - the error that occurred
 */
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error;

/**
 * connection:didFinishLoading: is called if the connection finished loading
 * all data associated with the request without error.  It will set the
 * NSOperation variables to not excuting and finihsed and runs the
 * finishedSelector
 * @param NSURLConnection connection object that received the data
 */
- (void)connectionDidFinishLoading:(NSURLConnection *)connection;

/**
 * runFinishedSelector runs the finished selector. Subclasses of this class 
 * should override this function
 */
- (void)runFinishedSelector;

@end