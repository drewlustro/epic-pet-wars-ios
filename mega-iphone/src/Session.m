/**
 * Session.m
 * Copyright Miraphonic, Inc 2009. All rights reserved.
 *
 * Session handles basic functions that would be required for
 * a session
 *
 * @author Amit Matani
 * @created 1/13/09
 */
 
#import "Session.h"
#import "Consts.h"

@implementation Session
@synthesize userId, sessionPropertyList;

/**
 * init instantiates a Session object and loads the saved session property 
 * list if there is one.
 * @return id - newly allocated Session object
 */ 
- (id)init {
    if (self = [super init]) {
        hasSession = isLoggedIn = NO;
		[self loadSessionPropertyList];
        [self initializeSessionFromPropertyList];
    }
    return self;
}

/**
 * login takes the username, password, and extraProperties from a
 * SUCCESSFUL login attempt and saves them in the instance variable
 * sessionPropertyList.  It also initializes the rest client.
 * @param NSString *username
 * @param NSString *password
 * @param NSDictionary *extraProperties - any extra properties that should be saved
 * or are required in the session
 * @return YES if the save was successful, NO otherwise
 */
- (BOOL)login:(NSString *)username password:(NSString *)password 
		extraProperties:(NSDictionary *)extraProperties {
    NSDictionary *sessionProperties = [extraProperties objectForKey:@"session"];
	self.userId = [sessionProperties objectForKey:PK_USER_ID];	
    NSDecimalNumber *callId = [sessionProperties objectForKey:PK_CALL_ID];
	NSString *sessionKey = [sessionProperties objectForKey:PK_SESSION_KEY];
	NSString *sessionSecret = [sessionProperties objectForKey:PK_SESSION_SECRET];

	if (userId == nil || callId == nil || sessionKey == nil || sessionSecret == nil) {
		return NO;
	}
	if (username == nil) { username = @""; }
	if (password == nil) { password = @""; }
	
	@try {
		[sessionPropertyList setObject:username forKey:PK_USERNAME];
		[sessionPropertyList setObject:password forKey:PK_PASSWORD];
		[sessionPropertyList setObject:userId forKey:PK_USER_ID];
		[sessionPropertyList setObject:callId forKey:PK_CALL_ID];
		[sessionPropertyList setObject:sessionKey forKey:PK_SESSION_KEY];
		[sessionPropertyList setObject:sessionSecret forKey:PK_SESSION_SECRET];
		hasSession = isLoggedIn = [self initializeRestClient];
	} @catch (NSException *e) {
    debug_NSLog(@"ERROR WITH SETTING DICTIONARY ITEMS - SHOULD NEVER REACH HERE");
		return NO;
	}
	return YES;
}

/**
 * logout logs the user out of the current session
 */
- (void)logout {
    [[self getRestClient] resetClient];
    isLoggedIn = NO;
    hasSession = NO;
    self.userId = nil;
    [sessionPropertyList removeAllObjects];
    [self saveSession];
}

/**
 * saveSession takes all steps necessary to save this
 * session so it can be recreated later.
 */
- (void)saveSession {
    [self saveSessionPropertyList];
}

/** 
 * @return YES if the user is logged in, false otherwise
 */
- (BOOL)isLoggedIn {
    return isLoggedIn;
}

/** 
 * @return YES if the user has a session, false otherwise
 */
- (BOOL)hasSession {
    return hasSession;
}

/**
 * saveSessionPropertyList takes the data from the sessionPropertyList instance
 * variable and saves in in a file.
 * @return YES if the data was saved, NO otherwise
 */
- (BOOL)saveSessionPropertyList {
	NSString *fileName = [self propertyListFileName];
	NSString *error;
	NSData *pData = [NSPropertyListSerialization dataFromPropertyList:sessionPropertyList 
												 format:NSPropertyListBinaryFormat_v1_0 errorDescription:&error]; 
	if (!pData) {
		debug_NSLog(@"%@", error); 
		return NO; 
	}
	return ([pData writeToFile:fileName atomically:YES]);    
}

/**
 * loadSessionPropertyList loads the session property list from the file it was
 * saved in and puts it in the sessionPropertyList instance variable.
 * @return YES if the load was successful, NO otherwise
 */
- (BOOL)loadSessionPropertyList {
	NSString *fileName = [self propertyListFileName];
	NSData *retData; 
	NSString *error; 
	
	NSPropertyListFormat format; 
	id retPlist;
	retData = [[NSData alloc] initWithContentsOfFile:fileName];
	if (!retData) { 
    debug_NSLog(@"Data file not returned.");
		[self initializeSessionPropertyList];		
		return NO; 
	} 
	retPlist = [NSPropertyListSerialization propertyListFromData:retData 
												mutabilityOption:NSPropertyListImmutable format:&format errorDescription:&error];
	if (!retPlist || ![retPlist isKindOfClass:[NSDictionary class]]){ 
    debug_NSLog(@"Plist not returned, error: %@", error);
		[self initializeSessionPropertyList];
		return NO;
	}
    NSMutableDictionary *sessionPropertyListTemp = [[NSMutableDictionary alloc] initWithDictionary:retPlist];
    self.sessionPropertyList = sessionPropertyListTemp;
    [sessionPropertyListTemp release];
    [retData release];
	
	return YES;    
}

/**
 * initializeSessionPropertyList creates an empty NSMutableDictionary
 * and saves it in the instance variable sessionPropertyList
 */
- (void)initializeSessionPropertyList {
    NSMutableDictionary *sessionPropertyListTemp = [[NSMutableDictionary alloc] initWithCapacity:10];
    self.sessionPropertyList = sessionPropertyListTemp;
    [sessionPropertyListTemp release];    
}

/**
 * initializeSessionFromPropertyList takes the property list data
 * and initializes the userId, hasSession, and isLoggedIn variables.
 * It also tells the object to intiailize the rest client.
 */
- (void)initializeSessionFromPropertyList {
    userId = [[sessionPropertyList objectForKey:PK_USER_ID] retain];
    if (userId != nil) {
        debug_NSLog(@"initializing session");
        hasSession = isLoggedIn = [self initializeRestClient];
    }
}

/**
 * initializeRestClient takes the session key, session secret, and call id
 * from the sessionPropertyList and uses those variables to initialize
 * the rest client
 * @return YES if the restClient was properly initialized, NO otherwise
 */
- (BOOL)initializeRestClient {
	NSString *sessionKey = [sessionPropertyList objectForKey:PK_SESSION_KEY];
	NSString *sessionSecret = [sessionPropertyList objectForKey:PK_SESSION_SECRET];
    id tempCallId = [sessionPropertyList objectForKey:PK_CALL_ID];
    NSDecimalNumber *callId = [NSDecimalNumber zero];
    if ([tempCallId isKindOfClass:[NSNumber class]]) {
        callId = [NSDecimalNumber decimalNumberWithDecimal:[[sessionPropertyList objectForKey:PK_CALL_ID] decimalValue]];        
    }

    RestClient *restClient = [self getRestClient];
	if (sessionKey != nil && sessionSecret != nil && callId != nil) {
		restClient.sessionKey = sessionKey;
		restClient.secret = sessionSecret;
		restClient.callId = callId;
		return YES;
	} else {
		return NO;
	}
}

/**
 * propertyListFileName gets the name of the file that the property list 
 * should be saved to. The name includes the path
 * @return NSString * - the filename including the path of the propertylist file
 */
- (NSString *)propertyListFileName {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, 
														 NSUserDomainMask, YES); 
	NSString *documentsDirectory = [paths objectAtIndex:0];
    debug_NSLog(documentsDirectory);
	return [documentsDirectory stringByAppendingString:@"/session.plist"];    
}

/**
 * getRestClient gets the rest client associated with the
 * session.
 * @return RestClient * - rest client
 */
- (RestClient *)getRestClient {
    return nil;
}

- (void)dealloc {
    [sessionPropertyList release];
    [userId release];
    [super dealloc];
}

@end
