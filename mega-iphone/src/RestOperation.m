/**
 * RestOperation.m
 * Copyright Miraphonic, Inc 2009. All rights reserved.
 *
 * RestOperation is a subclass of RemoteOperation. It is used 
 * by the RestClient to perform requests to the API.
 *
 * @author Amit Matani
 * @created 1/13/09
 */
 
#import "RestOperation.h"
#import "RestClient.h"
#import "Consts.h"
#import "Utility.h"

@implementation RestOperation
@synthesize delegate = _delegate;

- (void)finishedSelectorOverride:(NSNumber *)responseInt parsedResponse:(NSDictionary *)parsedResponse {
    [_delegate remoteMethodDidLoad:_method responseCode:[responseInt intValue] parsedResponse:parsedResponse];
}

- (void)failedSelectorOverride {
    [_delegate remoteMethodDidFail:_method];
}

- (id)initWithMethod:(NSString *)method request:(NSURLRequest *)req delegate:(id<RestResponseDelegate>)delegate {
	if (self = [self initWithMethod:method request:req nonRetainedDelegate:delegate]) {
        [_delegate retain];
        isDelegateRetained = YES;
	}
	return self;
}

// this is a hack because I did not build the app to take into account non retained delgates
// this is required so that we can tell the restoperation to cancel if nothing is referencing it
- (id)initWithMethod:(NSString *)method request:(NSURLRequest *)req nonRetainedDelegate:(id<RestResponseDelegate>)delegate {
    if (self = [super init]) {
		self.receivedData = [NSMutableData data];
        finishedSelector = @selector(finishedSelectorOverride:parsedResponse:);
        failedSelector = @selector(failedSelectorOverride);
        target = self;
        self.request = req;
        executing = NO;
        finished = NO;
        
        _delegate = delegate;
        _method = [method copy];
        isDelegateRetained = NO;        
	}
	return self;
}

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


/**
 * runFinishedSelector is run on sucessful completion of a request.
 * It gets the parsed response from the received data and then checks
 * the response code against special errors that would require 
 * a login. If it passes that test, the finishedSelector is run. 
 * If the response code is not a number, the failed selector is run. 
 */
- (void)runFinishedSelector {
    NSDictionary *parsedResponse = [RestClient parseResponse:receivedData];
	id responseCode = [parsedResponse objectForKey:@"response"];
	if ([responseCode isKindOfClass:[NSNumber class]]) {
        if ([self preProcessResponse:responseCode parsedResponse:parsedResponse]) {
            [target performSelector:finishedSelector withObject:responseCode withObject:parsedResponse];            
        }
    } else {
        [target performSelector:failedSelector];
    }
}

/**
 * preProcessResponse takes the responseInt and the parsedResponse and
 * does any actions required before control is handed to the the target
 * object.  If this method returns YES, the finishedSelector will be
 * run, otherwise it will not.
 * @param NSNumber *responseInt - the response code from the server
 * @param NSDictionary *parsedResponse - the dictionary of the response
 * @return YES if the finished selector should be run, false otherwise
 */
- (BOOL)preProcessResponse:(NSNumber *)responseInt 
        parsedResponse:(NSDictionary *)parsedResponse {
    return YES;    
}
        
- (void)dealloc {
    [_method release];
    if (isDelegateRetained) {
        [_delegate release];
    }
    [super dealloc];
}

@end
