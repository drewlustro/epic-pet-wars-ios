/**
 * RestClient.h
 * Copyright Miraphonic, Inc 2009. All rights reserved.
 *
 * RestClient is the client that handles all calls to the 
 * REST API.
 *
 * @author Amit Matani
 * @created 1/13/09
 */

#import <Foundation/Foundation.h>
#import "RestOperation.h"

// The key for the message in the response hash
#define RESPONSE_MESSAGE_KEY @"response_message"

// Specific response codes that are required site wide
#define RESPONSE_SUCCESS 1
#define RESPONSE_BAD_SESSION 5
#define RESPONSE_BAD_CALL_ID 6
#define RESPONSE_BAD_SIG 7


@interface RestClient : NSObject {
	/**
	 * The secret is used to sign our requests to the server, so the
	 * server knows it is this application that is sending the requests
	 */
	NSString *secret;
	
	// Session key is the key of the current session
	NSString *sessionKey;

	/**
	 * The callId maintains the current call number that we are on.
	 * This is to protect us against replay attacks
	 */
	NSDecimalNumber *callId;
	
	// the operation queue for all rest operations
    NSOperationQueue *restOperationQueue;
}

@property (nonatomic, copy) NSString *secret;
@property (nonatomic, copy) NSString *sessionKey;
@property (nonatomic, retain) NSOperationQueue *restOperationQueue;
/**
 * callId is atomic becuase when functions are messages are passed
 * to the HonRestClient object from different threads, the callId
 * needs to be thread safe
 **/
@property (retain) NSDecimalNumber *callId;

/**
 * parseResponse takes the receivedData in JSON fomrat and parses
 * it into a NSDictionary object.
 * @param NSData receivedData - JSON formatted response from the server
 * @return NSDictionary of parsed data from the JSON
 */
+ (NSDictionary *)parseResponse:(NSData *)receivedData;

/**
 * @return NSString api url
 */
+ (NSString *)getApiUrl;

/**
 * @return NSString app secret
 */
+ (NSString *)getAppSecret;

/**
 * @return NSString api key
 */
+ (NSString *)getApiKey;

/**
 * @return NSString api version
 */
+ (NSString *)getApiVersion;

/**
 * isResponseSuccessful returns YES if the responseInt 
 * matches the success code in the utility function
 * @param NSNumber *responseInt the response code
 * @return YES if successful, NO otherwise
 */
+ (BOOL)isResponseSuccessful:(NSNumber *)responseInt;

/**
 * resetClient will tell the current object to stop any operations in
 * progress and will clear out any associated instance variables
 */
- (void)resetClient;

/**
 * getRestOperationClass returns the subclass of rest operation
 * this rest client will be using
 * @return Class - class object of rest operation
 */
- (Class)getRestOperationClass;


- (void)callRemoteMethod:(NSString *)method params:(NSDictionary *)params delegate:(id<RestResponseDelegate>)delegate;
- (RestOperation *)callRemoteMethod:(NSString *)method params:(NSDictionary *)params nonRetainedDelegate:(id<RestResponseDelegate>)delegate;

/**
* callRemoteMethod takes the method name and the params and forms 
* a proper request string.  It then uses the request string to create a 
* request object which is then passed to a remoteoperation object and
* the request is made.  This method uses a GET to send the request.
 * @param NSString method - method name (ie auth.getSession)
 * @param NSDictionary params - key/value pairs of parameters for the method
 * @param id target - target that will receive the action of the selectors
 * @param finishedSelector - finishedSelector which will be able to accept two objects:
 * NSNumber *responseNumber, NSDictionary *parsedResponse
 * @param failedSelectorthe selector that gets called if the operation fails, no parameters
 * needed
 */
- (void)callRemoteMethod:(NSString *)method params:(NSDictionary *)params target:(id)target 
        finishedSelector:(SEL)finishedSelector failedSelector:(SEL)failedSelector;

/**
 * callRemoteMethodWithBinary data does the exact same thing as callRemoteMethod, but allows you 
 * to specify some binary data to send to the server as well. Instead of doing a GET request
 * like callRemoteMethod would do, this function does a POST.
 * @param NSString *method - method name (ie auth.getSession)
 * @param NSDictionary *params - key/value pairs of parameters for the method
 * @param NSString *filename - the name of the file to upload
 * @param NSString *contentType - the type of binary content being transmitted
 * @param NSData *data - the actual binary data
 * @param id target - target that will receive the action of the selectors
 * @param finishedSelector - finishedSelector which will be able to accept two objects:
 * NSNumber *responseNumber, NSDictionary *parsedResponse
 * @param failedSelectorthe selector that gets called if the operation fails, no parameters
 * needed
 */
- (void)callRemoteMethodWithBinaryData:(NSString *)method params:(NSDictionary *)params
        filename:(NSString *)filename contentType:(NSString *)contentType data:(NSData *)data 
        target:(id)target finishedSelector:(SEL)finishedSelector failedSelector:(SEL)failedSelector;

/**
 * generateRequestString takes the method and params and creates the request
 * string
 * @param NSString *method - (ie auth.getSession)
 * @param NSDictionary *params - key/value pairs of parameters for the function
 * @return NSString * - string reprentation of the request url
 */        
- (NSString *)generateRequestString:(NSString *)method params:(NSDictionary *)params;

/**
 * generateSignature uses the parameters provided and the
 * client's secret key to generate a signature 
 * @param NSDictionary *params - key/value pairs of parameters for the function
 * @return NSString * - string representation of the signature
 */
- (NSString *)generateSignature:(NSDictionary *)params;

+ (NSURLRequest *)generateStandaloneRequest:(NSString *)url params:(NSDictionary *)params;

/**
 * setupParamAndSessionVars adds session specific variables to the key/value pairs
 * that were provided for use with a function.
 * @param NSString *method - (ie auth.getSession)
 * @param NSDictionary *params - key/value pairs of parameters for the function
 * @return NSDictionary * - a params dictionary with all required key/value pairs to make
 * a proper request
 */
- (NSMutableDictionary *)setupParamAndSessionVars:(NSString *)method params:(NSDictionary *)params;


@end
