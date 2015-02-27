/**
 * Session.h
 * Copyright Miraphonic, Inc 2009. All rights reserved.
 *
 * Session handles basic functions that would be required for
 * a session
 *
 * @author Amit Matani
 * @created 1/13/09
 */

#import <Foundation/Foundation.h>
#import "Consts.h"
#import "RestClient.h"

#define PK_USERNAME @"username"
#define PK_PASSWORD @"password"
#define PK_USER_ID @"user_id"
#define PK_SESSION_KEY @"session_key"
#define PK_SESSION_SECRET @"secret"
#define PK_CALL_ID @"call_id"

@interface Session : NSObject {
    BOOL isLoggedIn;
    BOOL hasSession;
	NSMutableDictionary *sessionPropertyList;
	NSString *userId;	
}

@property (nonatomic, retain) NSMutableDictionary *sessionPropertyList;
@property (nonatomic, copy) NSString *userId;

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
        extraProperties:(NSDictionary *)extraProperties;

/**
 * logout logs the user out of the current session
 */
- (void)logout;        

/**
 * saveSession takes all steps necessary to save this
 * session so it can be recreated later.
 */
- (void)saveSession;

/** 
 * @return YES if the user is logged in, false otherwise
 */
- (BOOL)isLoggedIn;

/** 
 * @return YES if the user has a session, false otherwise
 */
- (BOOL)hasSession;

/**
 * saveSessionPropertyList takes the data from the sessionPropertyList instance
 * variable and saves in in a file.
 * @return YES if the data was saved, NO otherwise
 */        
- (BOOL)saveSessionPropertyList;

/**
 * loadSessionPropertyList loads the session property list from the file it was
 * saved in and puts it in the sessionPropertyList instance variable.
 * @return YES if the load was successful, NO otherwise
 */
- (BOOL)loadSessionPropertyList;

/**
 * initializeSessionPropertyList creates an empty NSMutableDictionary
 * and saves it in the instance variable sessionPropertyList
 */
- (void)initializeSessionPropertyList;

/**
 * initializeSessionFromPropertyList takes the property list data
 * and initializes the userId, hasSession, and isLoggedIn variables.
 * It also tells the object to intiailize the rest client.
 */
- (void)initializeSessionFromPropertyList;

/**
 * initializeRestClient takes the session key, session secret, and call id
 * from the sessionPropertyList and uses those variables to initialize
 * the rest client
 * @return YES if the restClient was properly initialized, NO otherwise
 */
- (BOOL)initializeRestClient;

/**
 * propertyListFileName gets the name of the file that the property list 
 * should be saved to. The name includes the path
 * @return NSString * - the filename including the path of the propertylist file
 */
- (NSString *)propertyListFileName;

/**
 * getRestClient gets the rest client associated with the
 * session.
 * @return RestClient * - rest client
 */
- (RestClient *)getRestClient;

@end
