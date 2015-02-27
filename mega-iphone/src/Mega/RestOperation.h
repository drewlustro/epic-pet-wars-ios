/**
 * RestOperation.h
 * Copyright Miraphonic, Inc 2009. All rights reserved.
 *
 * RestOperation is a subclass of RemoteOperation. It is used 
 * by the RestClient to perform requests to the API.
 *
 * @author Amit Matani
 * @created 1/13/09
 */

#import <Foundation/Foundation.h>
#import "RemoteOperation.h"

typedef enum {
    RestResponseCodeSuccess = 1,
} RestResponseCode;

@protocol RestResponseDelegate <NSObject>

- (void)remoteMethodDidLoad:(NSString *)method responseCode:(RestResponseCode)responseCode parsedResponse:(NSDictionary *)parsedResponse;
- (void)remoteMethodDidFail:(NSString *)method;

@end

@interface RestOperation : RemoteOperation {
    id<RestResponseDelegate> _delegate;
    NSString *_method;
    BOOL isDelegateRetained;
}

@property (nonatomic, assign) id<RestResponseDelegate> delegate;

- (id)initWithMethod:(NSString *)method request:(NSURLRequest *)req delegate:(id<RestResponseDelegate>)delegate;
- (id)initWithMethod:(NSString *)method request:(NSURLRequest *)req nonRetainedDelegate:(id<RestResponseDelegate>)delegate;

/**
 * preProcessResponse takes the responseInt and the parsedResponse and
 * does any actions required before control is handed to the the target
 * object.  If this method returns YES, the finishedSelector will be
 * run, otherwise it will not.
 * @param NSNumber *responseInt - the response code from the server
 * @param NSDictionary *parsedResponse - the dictionary of the response
 * @return YES if the finished selector should be run, false otherwise
 */
- (BOOL)preProcessResponse:(NSNumber *)responseInt parsedResponse:(NSDictionary *)parsedResponse;

@end

