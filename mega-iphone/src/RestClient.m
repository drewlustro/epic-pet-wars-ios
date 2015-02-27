/**
 * RestClient.m
 * Copyright Miraphonic, Inc 2009. All rights reserved.
 *
 * RestClient is the client that handles all calls to the 
 * REST API.
 *
 * @author Amit Matani
 * @created 1/13/09
 */
#import "RestClient.h"
#import "Utility.h"
#import "RestOperation.h"
#import <SBJson.h>
#import "Consts.h"

@implementation RestClient
@synthesize secret, sessionKey, callId, restOperationQueue;

/**
 * parseResponse takes the receivedData in JSON fomrat and parses
 * it into a NSDictionary object.
 * @param NSData receivedData - JSON formatted response from the server
 * @return NSDictionary of parsed data from the JSON
 */
+ (NSDictionary *)parseResponse:(NSData *)receivedData {
    NSString * receivedDataString = [[NSString alloc] initWithData:receivedData encoding:NSASCIIStringEncoding];
    debug_NSLog(receivedDataString);
    SBJsonParser *json = [SBJsonParser new];
    NSError *error;
	id parsedJsonResponse = [json objectWithString:receivedDataString error:&error];
//    id parsedJsonResponse = [json parse:receivedData];
	// TODO make this more robust
	if (![parsedJsonResponse isKindOfClass:[NSDictionary class]]) {
        debug_NSLog(@"ERROR - SHOULD NOT BE AN ARRAY");
        [json release];
        [receivedDataString release];
        [parsedJsonResponse release];
		return nil;
	} else if (parsedJsonResponse == nil && error != NULL) {
        debug_NSLog(@"ERROR - PARSING ERROR");
        [json release];
        [receivedDataString release];        
        [parsedJsonResponse release];        
		return nil;
	}
    debug_NSLog(@"parsed");
    [json release];
	[receivedDataString release];
	return parsedJsonResponse;
}

+ (NSString *)getApiUrl { return @""; }
+ (NSString *)getAppSecret { return @""; }
+ (NSString *)getApiKey { return @""; }
+ (NSString *)getApiVersion { return @""; }

/**
 * isResponseSuccessful returns YES if the responseInt 
 * matches the success code in the utility function
 * @param NSNumber *responseInt the response code
 * @return YES if successful, NO otherwise
 */

+ (BOOL)isResponseSuccessful:(NSNumber *)responseInt {
    return [Utility isNumber:responseInt sameAsInt:RESPONSE_SUCCESS];
}

- (id)init {
	if (self = [super init]) {
        NSOperationQueue *operationQueue = [[NSOperationQueue alloc] init];
        self.restOperationQueue = operationQueue;
        [operationQueue release];
		[self resetClient];
	}
	return self;
}

/**
 * resetClient will tell the current object to stop any operations in
 * progress and will clear out any associated instance variables
 */
- (void)resetClient {
    self.sessionKey = nil;
    self.secret = [[self class] getAppSecret];
	self.callId = [NSDecimalNumber zero];
    debug_NSLog(@"trying to cancel all operations");
    [restOperationQueue cancelAllOperations];
}

/**
 * getRestOperationClass returns the subclass of rest operation
 * this rest client will be using
 * @return Class - class object of rest operation
 */
- (Class)getRestOperationClass {
    return [RestOperation class];
}

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
/*- (void)callRemoteMethod:(NSString *)method params:(NSDictionary *)params 
        target:(id)target finishedSelector:(SEL)finishedSelector failedSelector:(SEL)failedSelector {
    NSString *paramString = [self generateRequestString:method params:params];
    NSString *urlString = [[NSString alloc] initWithFormat:@"%@?%@", [[self class] getApiUrl], paramString];
    [paramString release];    
    debug_NSLog(urlString);
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] 
												 cachePolicy:NSURLRequestUseProtocolCachePolicy 
                                                 timeoutInterval:60.0]; 
    [urlString release];
    RestOperation *restOperation = 
        [[[self getRestOperationClass] alloc] initWithRequest:request target:target 
                                  finishedSelector:finishedSelector 
                                  failedSelector:failedSelector];
    [request release];                                  
    [restOperationQueue addOperation:restOperation];
    [restOperation release];
}*/

- (NSURLRequest *)generateRequest:(NSString *)method params:(NSDictionary *)params {
    NSMutableDictionary *paramsAndSessionVars = [self setupParamAndSessionVars:method params:params];
    NSString *signature = [self generateSignature:paramsAndSessionVars];
	[paramsAndSessionVars setObject:signature forKey:@"sig"];    
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    NSURL *requestUrl = [[NSURL alloc] initWithString:[[self class] getApiUrl]];    
    [request setURL:requestUrl];
    [requestUrl release];
    [request setHTTPMethod:@"POST"];
    
    NSString *separator = @"---------------------------7d44e178b0434";
    NSString *headerfield = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", separator];
    
    [request addValue:headerfield forHTTPHeaderField:@"Content-Type"];
    
    NSMutableData *body = [NSMutableData data];
    [body appendData:[
                      [NSString stringWithFormat:@"\r\n--%@\r\n", separator] dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSString *key, *param;
    for (key in paramsAndSessionVars) {
        param = [paramsAndSessionVars valueForKey:key];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n%@", 
                           key,
                           param] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", 
                           separator] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    [request setHTTPBody:body];    
    [paramsAndSessionVars release];    
    return request;
}

+ (NSURLRequest *)generateStandaloneRequest:(NSString *)url params:(NSDictionary *)params {
	
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    NSURL *requestUrl = [[NSURL alloc] initWithString:url];    
    [request setURL:requestUrl];
    [requestUrl release];
    [request setHTTPMethod:@"POST"];
    
    NSString *separator = @"---------------------------7d44e178b0434";
    NSString *headerfield = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", separator];
    
    [request addValue:headerfield forHTTPHeaderField:@"Content-Type"];
    
    NSMutableData *body = [NSMutableData data];
    [body appendData:[
                      [NSString stringWithFormat:@"\r\n--%@\r\n", separator] dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSString *key, *param;
    for (key in params) {
        param = [params valueForKey:key];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n%@", 
                           key,
                           param] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", 
                           separator] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    [request setHTTPBody:body];
    return [request autorelease];
}

- (void)callRemoteMethod:(NSString *)method params:(NSDictionary *)params delegate:(id<RestResponseDelegate>)delegate {
    NSURLRequest *request = [self generateRequest:method params:params];
    
    RestOperation *restOperation = 
        [[[self getRestOperationClass] alloc] initWithMethod:method request:request delegate:delegate];

    [request release];
    [restOperationQueue addOperation:restOperation];
    [restOperation release];    
}

- (RestOperation *)callRemoteMethod:(NSString *)method params:(NSDictionary *)params nonRetainedDelegate:(id<RestResponseDelegate>)delegate {
    NSURLRequest *request = [self generateRequest:method params:params];
    
    RestOperation *restOperation = 
        [[[self getRestOperationClass] alloc] initWithMethod:method request:request nonRetainedDelegate:delegate];
    
    [request release];
    [restOperationQueue addOperation:restOperation];
    return [restOperation autorelease];
}

- (void)callRemoteMethod:(NSString *)method params:(NSDictionary *)params 
                  target:(id)target finishedSelector:(SEL)finishedSelector failedSelector:(SEL)failedSelector {
    NSURLRequest *request = [self generateRequest:method params:params];
    
    RestOperation *restOperation = 
        [[[self getRestOperationClass] alloc] initWithRequest:request target:target 
                                             finishedSelector:finishedSelector 
                                               failedSelector:failedSelector];
    [request release];
    [restOperationQueue addOperation:restOperation];
    [restOperation release];
}

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
        target:(id)target finishedSelector:(SEL)finishedSelector failedSelector:(SEL)failedSelector {
    NSMutableDictionary *paramsAndSessionVars = [self setupParamAndSessionVars:method params:params];
    NSString *signature = [self generateSignature:paramsAndSessionVars];
	[paramsAndSessionVars setObject:signature forKey:@"sig"];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    NSURL *requestUrl = [[NSURL alloc] initWithString:[[self class] getApiUrl]];    
    [request setURL:requestUrl];
    [requestUrl release];
    [request setHTTPMethod:@"POST"];
    
    NSString *separator = @"---------------------------7d44e178b0434";
    NSString *headerfield = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", separator];
    
    [request addValue:headerfield forHTTPHeaderField:@"Content-Type"];
    
    NSMutableData *body = [NSMutableData data];
    [body appendData:[
        [NSString stringWithFormat:@"\r\n--%@\r\n", separator] dataUsingEncoding:NSUTF8StringEncoding]];        
    
    NSString *key, *param;
    for (key in paramsAndSessionVars) {
        param = [paramsAndSessionVars valueForKey:key];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n%@", 
                                                    key,
                                                    param] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", 
                                                    separator] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"userfile\"; filename=\"%@\"\r\n", 
                                                filename] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Type: %@\r\n\r\n", 
                                                    contentType] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:data];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", separator] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [request setHTTPBody:body];
    
    RestOperation *restOperation = 
        [[[self getRestOperationClass] alloc] initWithRequest:request target:target 
                                                       finishedSelector:finishedSelector 
                                                       failedSelector:failedSelector];
    [request release];
    [restOperationQueue addOperation:restOperation];
    [restOperation release];
    [paramsAndSessionVars release];
}

/**
 * generateRequestString takes the method and params and creates the request
 * string
 * @param NSString *method - (ie auth.getSession)
 * @param NSDictionary *params - key/value pairs of parameters for the function
 * @return NSString * - string reprentation of the request url
 */
- (NSString *)generateRequestString:(NSString *)method params:(NSDictionary *)params {
    NSMutableDictionary *paramsAndSessionVars = [self setupParamAndSessionVars:method params:params];
    NSString *key;
    
    NSString *paramString = [[NSString alloc] initWithFormat:@"sig=%@", [self generateSignature:paramsAndSessionVars]];
    NSString *tempString;
	for (key in paramsAndSessionVars) {
        tempString = [[NSString alloc] initWithFormat:@"%@&%@=%@", paramString, key, [paramsAndSessionVars valueForKey:key]];
        [paramString release];
        paramString = tempString;
	}
    [paramsAndSessionVars release];	
    return paramString;
}

/**
 * generateSignature uses the parameters provided and the
 * client's secret key to generate a signature 
 * @param NSDictionary *params - key/value pairs of parameters for the function
 * @return NSString * - string representation of the signature
 */
- (NSString *)generateSignature:(NSDictionary *)params {
    NSArray *keys = [[params allKeys] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
    NSString *key = nil;
    NSString *unhashedSig = [[NSString alloc] initWithString:@""];
    NSString *tempString;
    for (key in keys) {
        tempString = [[NSString alloc] initWithFormat:@"%@%@=%@", unhashedSig, key, [params valueForKey:key]];
        [unhashedSig release];
        unhashedSig = tempString;
    }
    tempString = [[NSString alloc] initWithFormat:@"%@%@", unhashedSig, secret];
    NSString *md5 = [Utility md5:tempString];
    [tempString release];
    [unhashedSig release];
    return md5;
}

/**
 * setupParamAndSessionVars adds session specific variables to the key/value pairs
 * that were provided for use with a function.
 * @param NSString *method - (ie auth.getSession)
 * @param NSDictionary *params - key/value pairs of parameters for the function
 * @return NSDictionary * - a params dictionary with all required key/value pairs to make
 * a proper request
 */
- (NSMutableDictionary *)setupParamAndSessionVars:(NSString *)method params:(NSDictionary *)params {
    NSMutableDictionary *paramsAndSessionVars = [[NSMutableDictionary alloc] initWithDictionary:params];
    self.callId = [callId decimalNumberByAdding:[NSDecimalNumber one]];
    
    [paramsAndSessionVars setObject:method forKey:@"method"];
    if (sessionKey != nil) { 
        [paramsAndSessionVars setObject:sessionKey forKey:@"session_key"]; 
    }
    NSDate *current = [[NSDate alloc] init];
    NSString *currentTime = [[NSString alloc] initWithFormat:@"%.0f", [current timeIntervalSince1970]];
    [current release];
    [paramsAndSessionVars setObject:[[self class] getApiKey] forKey:@"api_key"];
    [paramsAndSessionVars setObject:currentTime forKey:@"call_id"];
    [paramsAndSessionVars setObject:[[self class] getApiVersion] forKey:@"version"];
    [currentTime release];
    return paramsAndSessionVars;
}

- (void)dealloc {
	[secret release];
	[sessionKey release];
	[callId release];
    [restOperationQueue release];
	[super dealloc];
}

@end
