/**
 * BRRestClient.h
 * Copyright Miraphonic, Inc 2009. All rights reserved.
 *
 * RestClient is the client that handles all calls to the 
 * REST API. It is a singleton and has to be used through 
 * a shared manager.
 *
 * @author Amit Matani
 * @created 1/13/09
 */

#import "BRRestClient.h"
#import "BRRestOperation.h"
#import "BRGlobal.h"
#import "Utility.h"
#import "Invite.h"
#import "Contact.h"
#import "Consts.h"
#import "BRStoreKitPaymentManager.h"

static BRRestClient *sharedRestClient = nil;

@implementation BRRestClient

+ (BRRestClient *)sharedManager {
    @synchronized(self) {
        if (sharedRestClient == nil) {
            [[self alloc] init]; // assignment not done here
        }
    }
    return sharedRestClient;
}

+ (id)allocWithZone:(NSZone *)zone {
    @synchronized(self) {
        if (sharedRestClient == nil) {
            sharedRestClient = [super allocWithZone:zone];
            return sharedRestClient;  // assignment and return on first allocation
        }
    }
    return nil; //on subsequent allocation attempts return nil
}

+ (NSString *)getApiUrl {
#ifdef AMIT_DEV
	return @"http://redbull1.miraphonic.com:60011/api";
#else
	
#ifdef DREW_DEV
	return @"http://redbull1.miraphonic.com:60009/api";
#else
	return @"http://www.epicpetwars.com/api";
#endif
#endif	
}


+ (NSString *)getURLWithApiKeyAndParams:(NSDictionary *)params baseURL:(NSString *)baseURL {
    NSString *paramsString = [NSString stringWithFormat:@"api_key=%@", [self getApiKey]];
    for (NSString *key in params) {
        paramsString = [paramsString stringByAppendingFormat:@"&%@=%@", key, [params valueForKey:key]];
    }
    return [[NSString stringWithFormat:@"%@?%@", baseURL, paramsString] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

+ (NSURLRequest *)getOfferRequestWithParams:(NSDictionary *)params {
#ifdef AMIT_DEV
	NSString *baseUrl = @"http://redbull1.miraphonic.com:60011/rewards/iphoneRewards";
#else
	
#ifdef DREW_DEV
    NSString *baseUrl = @"http://redbull1.miraphonic.com:60009/rewards/iphoneRewards";    
#else
    NSString *baseUrl = @"http://www.epicpetwars.com/rewards/iphoneRewards";
#endif
#endif
    return [self generateStandaloneRequest:[self getURLWithApiKeyAndParams:nil baseURL:baseUrl] params:params];	
}

+ (NSString *)getOfferUrlWithParams:(NSDictionary *)params {
#ifdef AMIT_DEV
	NSString *baseUrl = @"http://redbull1.miraphonic.com:60011/rewards/iphoneRewards";
#else
	
#ifdef DREW_DEV
    NSString *baseUrl = @"http://redbull1.miraphonic.com:60009/rewards/iphoneRewards";    
#else
    NSString *baseUrl = @"http://www.epicpetwars.com/rewards/iphoneRewards";
#endif
#endif
    return [self getURLWithApiKeyAndParams:params baseURL:baseUrl];
}

+ (NSURLRequest *)getExtraOfferRequestWithParams:(NSDictionary *)params {
#ifdef AMIT_DEV
	NSString *baseUrl = @"http://redbull1.miraphonic.com:60011/rewards/extraIphoneRewards";
#else
	
#ifdef DREW_DEV
    NSString *baseUrl = @"http://redbull1.miraphonic.com:60009/rewards/extraIphoneRewards";    
#else
    NSString *baseUrl = @"http://www.epicpetwars.com/rewards/extraIphoneRewards";	
#endif	
#endif
    return [self generateStandaloneRequest:[self getURLWithApiKeyAndParams:nil baseURL:baseUrl] params:params];	
}


+ (NSString *)getExtraOfferUrlWithParams:(NSDictionary *)params {
#ifdef AMIT_DEV
	NSString *baseUrl = @"http://redbull1.miraphonic.com:60011/rewards/extraIphoneRewards";
#else
	
#ifdef DREW_DEV
    NSString *baseUrl = @"http://redbull1.miraphonic.com:60009/rewards/extraIphoneRewards";    
#else
    NSString *baseUrl = @"http://www.epicpetwars.com/rewards/extraIphoneRewards";	
#endif
#endif
    return [self getURLWithApiKeyAndParams:params baseURL:baseUrl];
}

+ (NSString *)getGameUpdatesUrlWithParams:(NSDictionary *)params {
#ifdef AMIT_DEV
	NSString *baseUrl = @"http://redbull1.miraphonic.com:60011/iphone/gameUpdates";
#else
	
#ifdef DREW_DEV
    NSString *baseUrl = @"http://redbull1.miraphonic.com:60009/iphone/gameUpdates";    
#else
    NSString *baseUrl = @"http://www.epicpetwars.com/iphone/gameUpdates";	
#endif
#endif
    return [self getURLWithApiKeyAndParams:params baseURL:baseUrl];
}

+ (NSString *)getHelpUrlWithTypeString:(NSString *)type params:(NSDictionary *)params {
#ifdef AMIT_DEV
	NSString *baseUrl = @"http://redbull1.miraphonic.com:60011/iphoneHelp";
#else
	
#ifdef DREW_DEV
    NSString *baseUrl = @"http://redbull1.miraphonic.com:60009/iphoneHelp";
#else
    NSString *baseUrl = @"http://www.epicpetwars.com/iphoneHelp";
#endif
#endif
    
	if ([type isEqualToString:@"item"]) {
		baseUrl = [baseUrl stringByAppendingString:@"/item"];
	} else if ([type isEqualToString:@"howToPlay"]) {
        baseUrl = [baseUrl stringByAppendingString:@"/howToPlay"];
	} else if ([type isEqualToString:@"quickShopHelp"]) {
		baseUrl = [baseUrl stringByAppendingString:@"/quickShopHelp"];
    }
    
    return [self getURLWithApiKeyAndParams:params baseURL:baseUrl];    
}

+ (NSString *)getFBLoginUrl {
#ifdef AMIT_DEV
	return [NSString stringWithFormat:@"http://redbull1.miraphonic.com:60011/facebookIphoneConnect/attemptFacebookAuthorization?udid=%@", 
					 [Utility getUDID]]; 

#else
	return [NSString stringWithFormat:@"http://www.epicpetwars.com/facebookIphoneConnect/attemptFacebookAuthorization?udid=%@", [Utility getUDID]]; 	
#endif
	
}

+ (NSString *)getAppSecret {
    return APP_SECRET;
}

+ (NSString *)getApiKey {
    return API_KEY;
}

+ (NSString *)getApiVersion {
    return @"1.71";
}

/**
 * getRestOperationClass returns the subclass of rest operation
 * this rest client will be using
 * @return Class - class object of rest operation
 */
- (Class)getRestOperationClass {
    return [BRRestOperation class];
}


#pragma mark Authentication methods

- (void)auth_getSessionWithFBUID:(FBUID)_uid fbSessionKey:(NSString *)fbSessionKey 
                 fbSessionSecret:(NSString *)fbSessionSecret 
                          target:(id)target 
                finishedSelector:(SEL)finishedSelector failedSelector:(SEL)failedSelector {
    NSString *fbuid = [NSString stringWithFormat:@"%qu", _uid];
    
    // protection
    if (fbSessionKey == nil) {
        fbSessionKey = @"";
    } 
    if (fbSessionSecret == nil) {
        fbSessionSecret = @"";
    }
    NSDictionary *params =     
		[[NSDictionary alloc] initWithObjectsAndKeys:[Utility getUDID], @"udid",
                                                    fbuid, @"fb_uid",
                                                    fbSessionKey, @"fb_session_key",
                                                    fbSessionSecret, @"fb_session_secret",
                                                    nil];
    [self callRemoteMethod:@"auth.getSessionWithFBUID" params:params 
					target:target finishedSelector:finishedSelector failedSelector:failedSelector];
    [params release];
}

- (void)auth_getSessionWithDeviceId:(BOOL)shouldCreate target:(id)target 
				   finishedSelector:(SEL)finishedSelector failedSelector:(SEL)failedSelector {
	NSString *shouldCreateString = shouldCreate ? @"1" : @"0";
    NSDictionary *params =     
		[[NSDictionary alloc] initWithObjectsAndKeys:[Utility getUDID], @"udid",    
		shouldCreateString, @"should_create_user",
         nil];
    [self callRemoteMethod:@"auth.getSessionWithDeviceId" params:params 
					target:target finishedSelector:finishedSelector failedSelector:failedSelector];
    [params release];
}

- (void)auth_getSessionWithDeviceId:(id<RestResponseDelegate>)delegate {
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:[Utility getUDID], @"udid", nil];
    [self callRemoteMethod:@"auth.getSessionWithDeviceId" params:params delegate:delegate];
    [params release];
}

#pragma mark Account methods
/**
 * account_getAvailablePlayerTypes takes a start and limit and attempts
 * to load a set of animal types
 * @param NSString *start - the starting point
 * @param NSString *limit - the limit, if 0 will load all
 * @param id target - the object that will get run the failed or finished selectors
 * @param SEL finishedSelector - the selector that will be run if the request goes correctly
 * @param SEL failedSelector - the selector that will be run if the request fails
 */
- (void)account_getAvailablePlayerTypes:(NSInteger)start limit:(NSInteger)limit
        target:(id)target finishedSelector:(SEL)finishedSelector 
        failedSelector:(SEL)failedSelector {
    NSString *startNum = [[NSString alloc] initWithFormat:@"%d", start];
    NSString *limitNum = [[NSString alloc] initWithFormat:@"%d", limit];
    NSDictionary *params = 
        [[NSDictionary alloc] initWithObjectsAndKeys:startNum, @"start", 
                                                     limitNum, @"limit", 
                                                     nil];
    [self callRemoteMethod:@"account.getAvailablePlayerTypes" params:params 
          target:target finishedSelector:finishedSelector failedSelector:failedSelector];
    [startNum release];
    [limitNum release];
    [params release];
}

- (void)account_createNewAnimal:(NSString *)animalTypeId name:(NSString *)name 
					      email:(NSString *)email phoneNumber:(NSString *)phoneNumber
						 target:(id)target finishedSelector:(SEL)finishedSelector 
				 failedSelector:(SEL)failedSelector {
    NSDictionary *params = 
	[[NSDictionary alloc] initWithObjectsAndKeys:name, @"name", 
												 email, @"email",
												 phoneNumber, @"phone_number",
												 animalTypeId, @"animal_type_id",
												  nil];
    [self callRemoteMethod:@"account.createNewAnimal" params:params 
					target:target finishedSelector:finishedSelector failedSelector:failedSelector];
    [params release];
}

- (void)account_linkToFacebook:(FBUID)_uid fbSessionKey:(NSString *)fbSessionKey 
               fbSessionSecret:(NSString *)fbSessionSecret target:(id)target 
              finishedSelector:(SEL)finishedSelector failedSelector:(SEL)failedSelector {
    NSString *fbuid = [NSString stringWithFormat:@"%%qu", _uid];
    
    // protection
    if (fbSessionKey == nil) {
        fbSessionKey = @"";
    }
    if (fbSessionSecret == nil) {
        fbSessionSecret = @"";
    }
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:[Utility getUDID], @"udid",
                                                     fbuid, @"fb_uid",
                                                     fbSessionKey, @"fb_session_key",
                                                     fbSessionSecret, @"fb_session_secret",
                                                     nil];
    [self callRemoteMethod:@"account.linkToFacebook" params:params target:target 
          finishedSelector:finishedSelector
			failedSelector:failedSelector];
	[params release];
}

- (void)account_linkToFacebook:(FBUID)_uid session:(FBSession *)session delegate:(id<RestResponseDelegate>)delegate {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:4];
    
    [params setObject:[NSString stringWithFormat:@"%qu", _uid] forKey:@"fb_uid"];        
    [params setObject:[Utility getUDID] forKey:@"udid"];        
    if (session.sessionKey != nil) {
        [params setObject:session.sessionKey forKey:@"fb_session_key"];
    }
    if (session.sessionSecret != nil) {
        [params setObject:session.sessionSecret forKey:@"fb_session_secret"];
    }
    
    [self callRemoteMethod:@"account.linkToFacebook" params:params delegate:delegate];
    
	[params release];
}

- (void)account_updateIphoneFBSession:(FBSession *)session delegate:(id<RestResponseDelegate>)delegate {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:2];    
    if (session.sessionKey != nil) {
        [params setObject:session.sessionKey forKey:@"fb_session_key"];
    }
    if (session.sessionSecret != nil) {
        [params setObject:session.sessionSecret forKey:@"fb_session_secret"];
    }
    
    [self callRemoteMethod:@"account.updateIphoneFBSession" params:params delegate:delegate];    
	[params release];    
}


- (void)account_getUserAnimals:(NSInteger)start limit:(NSInteger)limit 
                                     target:(id)target finishedSelector:(SEL)finishedSelector
                             failedSelector:(SEL)failedSelector {
    NSString *startNum = [[NSString alloc] initWithFormat:@"%d", start];
    NSString *limitNum = [[NSString alloc] initWithFormat:@"%d", limit];
    NSDictionary *params = 
	[[NSDictionary alloc] initWithObjectsAndKeys:startNum, @"start", 
     limitNum, @"limit", 
     nil];
	
    [self callRemoteMethod:@"account.getUserAnimals" params:params target:target 
		  finishedSelector:finishedSelector
			failedSelector:failedSelector];	
	[startNum release];
	[limitNum release];
	[params release];
}


- (void)account_switchToAnimal:(NSString *)animalId 
						target:(id)target 
			  finishedSelector:(SEL)finishedSelector 
				failedSelector:(SEL)failedSelector {
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:animalId, @"animal_id", nil];	
    [self callRemoteMethod:@"account.switchToAnimal" params:params target:target 
          finishedSelector:finishedSelector
			failedSelector:failedSelector];
	[params release];	
}

- (void)account_deactivateAnimal:(NSString *)animalId 
                          target:(id)target 
                finishedSelector:(SEL)finishedSelector 
                  failedSelector:(SEL)failedSelector {
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:animalId, @"animal_id", nil];
    [self callRemoteMethod:@"account.deactivateAnimal" params:params target:target 
          finishedSelector:finishedSelector
			failedSelector:failedSelector];
	[params release];	
}
- (void)account_getOfferHtml:(id)target 
            finishedSelector:(SEL)finishedSelector 
              failedSelector:(SEL)failedSelector {
    [self callRemoteMethod:@"account.getOfferHtml" params:nil target:target 
          finishedSelector:finishedSelector
			failedSelector:failedSelector];
}

- (void)account_offerRemoved {
    [self callRemoteMethod:@"account.offerRemoved" params:nil delegate:nil];
}

- (void)account_sendFeedback:(NSString *)feedBack email:(NSString *)email target:(id)target 
            finishedSelector:(SEL)finishedSelector
              failedSelector:(SEL)failedSelector {
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:feedBack, @"feedback", email, @"email", nil];
    [self callRemoteMethod:@"account.sendFeedback" params:params
                    target:target finishedSelector:finishedSelector failedSelector:failedSelector];
    [params release];
}

- (void)account_setNotificationDeviceToken:(NSData *)deviceToken {
	NSString *token = [[[deviceToken description] 
								stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]] 
								stringByReplacingOccurrencesOfString:@" " withString:@""];
	
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:token, @"device_token", nil];
    [self callRemoteMethod:@"account.setNotificationDeviceToken" params:params
                    target:nil finishedSelector:nil failedSelector:nil];
    [params release];
}

#pragma mark Animal methods
/**
 * account_createNewAccount attempts to create an account. If successful, the new
 * session information will be passed to the finished selector
 * @param NSString *user_id
 * @param id target - the object that will get run the failed or finished selectors
 * @param SEL finishedSelector - the selector that will be run if the request goes correctly
 * @param SEL failedSelector - the selector that will be run if the request fails
 */
- (void)animal_getPrimaryAnimal:(NSString *)user_id
        target:(id)target finishedSelector:(SEL)finishedSelector failedSelector:(SEL)failedSelector {
    NSDictionary *params = nil;
    if (user_id != nil) {
        params = [[NSDictionary alloc] initWithObjectsAndKeys:user_id, @"user_id", 
                                                     nil];
    }
    [self callRemoteMethod:@"animal.getPrimaryAnimal" params:params 
          target:target finishedSelector:finishedSelector failedSelector:failedSelector];
    [params release];
}
// TODO check for blank IDS
- (void)animal_loadAnimal:(NSString *)animalId
						 target:(id)target finishedSelector:(SEL)finishedSelector failedSelector:(SEL)failedSelector {
	NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:animalId, @"animal_id", 
			  nil];
    [self callRemoteMethod:@"animal.loadAnimal" params:params 
					target:target finishedSelector:finishedSelector failedSelector:failedSelector];
    [params release];
}

- (void)animal_updateEnergy:(id)target finishedSelector:(SEL)finishedSelector 
        failedSelector:(SEL)failedSelector {
    [self callRemoteMethod:@"animal.updateEnergy" params:nil
          target:target finishedSelector:finishedSelector failedSelector:failedSelector];
}

- (void)animal_updateHp:(id)target finishedSelector:(SEL)finishedSelector 
             failedSelector:(SEL)failedSelector {
    [self callRemoteMethod:@"animal.updateHp" params:nil
                    target:target finishedSelector:finishedSelector failedSelector:failedSelector];
}

- (void)animal_updateMoney:(id)target finishedSelector:(SEL)finishedSelector 
         failedSelector:(SEL)failedSelector {
    [self callRemoteMethod:@"animal.updateMoney" params:nil
                    target:target finishedSelector:finishedSelector failedSelector:failedSelector];
}


- (void)animal_petAnimal:(id)target finishedSelector:(SEL)finishedSelector 
        failedSelector:(SEL)failedSelector {
    [self callRemoteMethod:@"animal.petAnimal" params:nil
          target:target finishedSelector:finishedSelector failedSelector:failedSelector];
}

- (void)animal_forage:(id)target finishedSelector:(SEL)finishedSelector
			 failedSelector:(SEL)failedSelector {
    [self callRemoteMethod:@"animal.forage" params:nil
		  target:target finishedSelector:finishedSelector failedSelector:failedSelector];	
}

- (void)animal_getExternalActions:(id)target finishedSelector:(SEL)finishedSelector
				   failedSelector:(SEL)failedSelector {
    [self callRemoteMethod:@"animal.getExternalActions" params:nil
		  target:target finishedSelector:finishedSelector failedSelector:failedSelector];		
}

- (void)animal_autoRevive:(id)target finishedSelector:(SEL)finishedSelector
		failedSelector:(SEL)failedSelector {
    [self callRemoteMethod:@"animal.autoRevive" params:nil
		  target:target finishedSelector:finishedSelector failedSelector:failedSelector];		
}

- (void)animal_useHosptial:(id)target finishedSelector:(SEL)finishedSelector
			failedSelector:(SEL)failedSelector {
    [self callRemoteMethod:@"animal.useHospital" params:nil
		  target:target finishedSelector:finishedSelector failedSelector:failedSelector];			
}

- (void)animal_withdrawFunds:(unsigned long long)amount delegate:(id<RestResponseDelegate>)delegate {
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithUnsignedLongLong:amount], @"amount", nil];
    [self callRemoteMethod:@"animal.withdrawFunds" params:params delegate:delegate];
    [params release];
}

- (void)animal_depositFunds:(unsigned long long)amount delegate:(id<RestResponseDelegate>)delegate {
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithUnsignedLongLong:amount], @"amount", nil];
    [self callRemoteMethod:@"animal.depositFunds" params:params delegate:delegate];
    [params release];
}


- (void)animal_streamPublishAttempted:(FBUID)_uid callback:(NSString *)callback {
    NSString *fbuid = [NSString stringWithFormat:@"%qu", _uid];
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:callback, @"callback", fbuid, @"fb_uid", nil];
    [self callRemoteMethod:@"animal.streamPublishAttempted" params:params target:nil finishedSelector:nil failedSelector:nil];
    [params release];
}

#pragma mark Item methods
- (void)item_getItemsForAnimal:(id)target finishedSelector:(SEL)finishedSelector 
        failedSelector:(SEL)failedSelector {
    [self callRemoteMethod:@"item.getItemsForAnimal" params:nil
          target:target finishedSelector:finishedSelector failedSelector:failedSelector];
}

- (void)item_buyItem:(NSString *)itemId amount:(NSInteger)amount target:(id)target 
        finishedSelector:(SEL)finishedSelector failedSelector:(SEL)failedSelector {
    NSString *amountString = [[NSString alloc] initWithFormat:@"%d", amount];
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:itemId, @"item_id",
                                                                        amountString, @"amount",
                                                                        nil];
    [amountString release];
    [self callRemoteMethod:@"item.buyItem" params:params
          target:target finishedSelector:finishedSelector failedSelector:failedSelector];
    [params release];
}

- (void)item_sellItem:(NSString *)itemId amount:(NSInteger)amount target:(id)target 
     finishedSelector:(SEL)finishedSelector failedSelector:(SEL)failedSelector {
    NSString *amountString = [[NSString alloc] initWithFormat:@"%d", amount];
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:itemId, @"item_id",
                            amountString, @"amount",
                            nil];
    [amountString release];
    
    [self callRemoteMethod:@"item.sellItem" params:params
          target:target finishedSelector:finishedSelector failedSelector:failedSelector];
    [params release];
}

- (void)item_equipItem:(NSString *)itemId slot:(NSInteger)slot target:(id)target 
    finishedSelector:(SEL)finishedSelector failedSelector:(SEL)failedSelector {
    NSString *slotString = 
        [NSString stringWithFormat:@"%d", slot + 1];
    NSDictionary *params = 
        [[NSDictionary alloc] initWithObjectsAndKeys:itemId, @"item_id", 
                                                     slotString, @"slot", nil];
    [self callRemoteMethod:@"item.equipItem" params:params
          target:target finishedSelector:finishedSelector failedSelector:failedSelector];
    [params release];            
}
    
- (void)item_unequipItem:(NSString *)itemId slot:(NSInteger)slot target:(id)target 
        finishedSelector:(SEL)finishedSelector failedSelector:(SEL)failedSelector {
    NSString *slotString = [NSString stringWithFormat:@"%d", slot + 1];            
    NSDictionary *params = 
        [[NSDictionary alloc] initWithObjectsAndKeys:itemId, @"item_id", 
                                                     slotString, @"slot", nil];
    [self callRemoteMethod:@"item.unequipItem" params:params
          target:target finishedSelector:finishedSelector failedSelector:failedSelector];
    [params release];            
}

- (void)item_useItem:(NSString *)itemId target:(id)target 
    finishedSelector:(SEL)finishedSelector failedSelector:(SEL)failedSelector {
    NSDictionary *params = 
        [[NSDictionary alloc] initWithObjectsAndKeys:itemId, @"item_id", nil];
    [self callRemoteMethod:@"item.useItem" params:params
          target:target finishedSelector:finishedSelector failedSelector:failedSelector];
    [params release];
}

- (void)item_getItemsInShop:(id)target finishedSelector:(SEL)finishedSelector 
		failedSelector:(SEL)failedSelector {
	[self callRemoteMethod:@"item.getItemsInShop" params:nil
		  target:target finishedSelector:finishedSelector failedSelector:failedSelector];
}

- (void)item_getItemsInShopWithCategory:(NSString *)category 
                                  start:(NSInteger)start 
                                  limit:(NSInteger)limit 
                                 target:(id)target 
                       finishedSelector:(SEL)finishedSelector 
                         failedSelector:(SEL)failedSelector {
    
    NSString *startNum = [[NSString alloc] initWithFormat:@"%d", start];
    NSString *limitNum = [[NSString alloc] initWithFormat:@"%d", limit];
    
    NSDictionary *params = 
        [[NSDictionary alloc] initWithObjectsAndKeys:startNum, @"start", 
                                                    limitNum, @"limit",
                                                    category, @"category", nil];
	
	[self callRemoteMethod:@"item.getItemsInShopWithCategory" params:params
                    target:target finishedSelector:finishedSelector failedSelector:failedSelector];	
    
	[startNum release];
	[limitNum release];
	[params release];
}

- (void)item_getItemsForAnimalWithCategory:(NSString *)category 
                                  start:(NSInteger)start 
                                  limit:(NSInteger)limit 
                                 target:(id)target 
                       finishedSelector:(SEL)finishedSelector 
                         failedSelector:(SEL)failedSelector {
    
    NSString *startNum = [[NSString alloc] initWithFormat:@"%d", start];
    NSString *limitNum = [[NSString alloc] initWithFormat:@"%d", limit];
    
    NSDictionary *params = 
    [[NSDictionary alloc] initWithObjectsAndKeys:startNum, @"start", 
     limitNum, @"limit",
     category, @"category", nil];
	
	[self callRemoteMethod:@"item.getItemsForAnimalWithCategory" params:params
                    target:target finishedSelector:finishedSelector failedSelector:failedSelector];	
    
	[startNum release];
	[limitNum release];
	[params release];
}

#pragma mark Job methods
- (void)job_getJobs:(id)target finishedSelector:(SEL)finishedSelector 
        failedSelector:(SEL)failedSelector {
    [self callRemoteMethod:@"job.getJobs" params:nil
          target:target finishedSelector:finishedSelector failedSelector:failedSelector];            
}

- (void)job_doJob:(NSString *)jobId target:(id)target 
        finishedSelector:(SEL)finishedSelector failedSelector:(SEL)failedSelector {
    NSDictionary *params = 
        [[NSDictionary alloc] initWithObjectsAndKeys:jobId, @"job_id", nil];
    [self callRemoteMethod:@"job.doJob" params:params
          target:target finishedSelector:finishedSelector failedSelector:failedSelector];
    [params release];            
}

#pragma mark Battle methods
- (void)battle_getAvailableChallengers:(id)target 
		finishedSelector:(SEL)finishedSelector failedSelector:(SEL)failedSelector {
    [self callRemoteMethod:@"battle.getAvailableChallengers" params:nil
		  target:target finishedSelector:finishedSelector failedSelector:failedSelector];	
}

- (void)battle_startBattle:(NSString *)opponentAnimalId isBot:(NSString *)isBot fromView:(NSString *)fromView
                        target:(id)target finishedSelector:(SEL)finishedSelector failedSelector:(SEL)failedSelector {
    NSDictionary *params = 
		[[NSDictionary alloc] initWithObjectsAndKeys:opponentAnimalId, @"animal_id", 
                                                fromView, @"from_view",
												 isBot, @"is_bot", nil];	
    [self callRemoteMethod:@"battle.startBattle" params:params
					target:target finishedSelector:finishedSelector failedSelector:failedSelector];	
	[params release];
}

- (void)battle_attack:(NSString *)battleId target:(id)target 
	 finishedSelector:(SEL)finishedSelector failedSelector:(SEL)failedSelector {
    NSDictionary *params = 
		[[NSDictionary alloc] initWithObjectsAndKeys:battleId, @"battle_id", nil];
    [self callRemoteMethod:@"battle.attack" params:params
					target:target finishedSelector:finishedSelector failedSelector:failedSelector];	
	[params release];
}

- (void)battle_run:(NSString *)battleId target:(id)target 
	 finishedSelector:(SEL)finishedSelector failedSelector:(SEL)failedSelector {
    NSDictionary *params = 
	[[NSDictionary alloc] initWithObjectsAndKeys:battleId, @"battle_id", nil];
    [self callRemoteMethod:@"battle.run" params:params
					target:target finishedSelector:finishedSelector failedSelector:failedSelector];	
	[params release];
}

- (void)battle_useItem:(NSString *)battleId itemId:(NSString *)itemId target:(id)target 
	  finishedSelector:(SEL)finishedSelector failedSelector:(SEL)failedSelector {
    NSDictionary *params = 
		[[NSDictionary alloc] initWithObjectsAndKeys:battleId, @"battle_id", 
													 itemId, @"item_id",
													 nil];	
    [self callRemoteMethod:@"battle.useItem" params:params
					target:target finishedSelector:finishedSelector failedSelector:failedSelector];	
	[params release];	
}
#pragma mark Reward methods
- (void)reward_getOffersForToday:(id)target finishedSelector:(SEL)finishedSelector
		failedSelector:(SEL)failedSelector {
    [self callRemoteMethod:@"reward.getOffersForToday" params:nil
		  target:target finishedSelector:finishedSelector failedSelector:failedSelector];		
}

- (void)reward_redeemOffer:(NSString *)offerId target:(id)target 
          finishedSelector:(SEL)finishedSelector failedSelector:(SEL)failedSelector {
    NSDictionary *params = 
    [[NSDictionary alloc] initWithObjectsAndKeys:offerId, @"offer_id", nil];
    [self callRemoteMethod:@"reward.redeemOffer" params:params
					target:target finishedSelector:finishedSelector failedSelector:failedSelector];	
	[params release];	
}

- (void)reward_redeemStoreKitOfferWithTransaction:(SKPaymentTransaction *)transaction
										 delegate:(id<RestResponseDelegate>)delegate {
	NSString *jsonObjectString = [BRStoreKitPaymentManager encode:(uint8_t *)transaction.transactionReceipt.bytes length:transaction.transactionReceipt.length];
		
    NSDictionary *params = 	
		[[NSDictionary alloc] initWithObjectsAndKeys:transaction.transactionIdentifier, @"identifier", 
													 jsonObjectString, @"receipt", nil];
    [self callRemoteMethod:@"reward.redeemStoreKitOfferWithTransaction" params:params delegate:delegate];
	[params release];
}

- (void)reward_sendOfferLinkWithEmail:(NSString *)email link:(NSString *)link name:(NSString *)name
                             currency:(NSString *)currency target:(id)target 
          finishedSelector:(SEL)finishedSelector failedSelector:(SEL)failedSelector {
    NSDictionary *params = 
    [[NSDictionary alloc] initWithObjectsAndKeys:email, @"email", 
                                                 link, @"link", 
                                                 name, @"name", 
                                                 currency, @"currency", 
                                                 nil];
    [self callRemoteMethod:@"reward.sendOfferLinkWithEmail" params:params
					target:target finishedSelector:finishedSelector failedSelector:failedSelector];	
	[params release];	
}

#pragma mark Achievement methods
- (void)achievement_getAvailableAcievements:(NSInteger)start limit:(NSInteger)limit 
	    target:(id)target finishedSelector:(SEL)finishedSelector
		failedSelector:(SEL)failedSelector {
    NSString *startNum = [[NSString alloc] initWithFormat:@"%d", start];
    NSString *limitNum = [[NSString alloc] initWithFormat:@"%d", limit];
    NSDictionary *params = 
	[[NSDictionary alloc] initWithObjectsAndKeys:startNum, @"start", 
												 limitNum, @"limit", 
												 nil];
	
    [self callRemoteMethod:@"achievement.getAvailableAchievements" params:params
		  target:target finishedSelector:finishedSelector failedSelector:failedSelector];
	
	[startNum release];
	[limitNum release];
	[params release];
}

- (void)achievement_getEarnedAcievements:(NSString *)animalId start:(NSInteger)start limit:(NSInteger)limit 
		target:(id)target finishedSelector:(SEL)finishedSelector
		failedSelector:(SEL)failedSelector {
    NSString *startNum = [[NSString alloc] initWithFormat:@"%d", start];
    NSString *limitNum = [[NSString alloc] initWithFormat:@"%d", limit];
    NSDictionary *params = 
	[[NSDictionary alloc] initWithObjectsAndKeys:startNum, @"start", 
	 limitNum, @"limit",
	 animalId, @"animal_id",
	 nil];
	
    [self callRemoteMethod:@"achievement.getEarnedAchievements" params:params
					target:target finishedSelector:finishedSelector failedSelector:failedSelector];
	
	[startNum release];
	[limitNum release];
	[params release];
}

#pragma mark Posse methods
- (void)posse_inviteUserWithFriendCode:(NSString *)friendCode target:(id)target 
		finishedSelector:(SEL)finishedSelector failedSelector:(SEL)failedSelector {
	NSDictionary *params = 
		[[NSDictionary alloc] initWithObjectsAndKeys:friendCode, @"friend_code", nil];
    [self callRemoteMethod:@"posse.inviteUserWithFriendCode" params:params
					target:target finishedSelector:finishedSelector failedSelector:failedSelector];	
	[params release];
}

- (void)posse_inviteUserWithUserId:(NSString *)userId target:(id)target 
					  finishedSelector:(SEL)finishedSelector failedSelector:(SEL)failedSelector {
	NSDictionary *params = 
	[[NSDictionary alloc] initWithObjectsAndKeys:userId, @"user_id", nil];
    [self callRemoteMethod:@"posse.inviteUserWithUserId" params:params
					target:target finishedSelector:finishedSelector failedSelector:failedSelector];	
	[params release];
}

- (void)posse_getInvites:(NSInteger)start limit:(NSInteger)limit 
		target:(id)target finishedSelector:(SEL)finishedSelector
		failedSelector:(SEL)failedSelector {
    NSString *startNum = [[NSString alloc] initWithFormat:@"%d", start];
    NSString *limitNum = [[NSString alloc] initWithFormat:@"%d", limit];
    NSDictionary *params = 
	[[NSDictionary alloc] initWithObjectsAndKeys:startNum, @"start", limitNum, @"limit", nil];
	
    [self callRemoteMethod:@"posse.getInvites" params:params
		  target:target finishedSelector:finishedSelector failedSelector:failedSelector];
	
	[startNum release];
	[limitNum release];
	[params release];
}

- (void)posse_getInviteCount:(id)target finishedSelector:(SEL)finishedSelector
              failedSelector:(SEL)failedSelector {
    [self callRemoteMethod:@"posse.getInviteCount" params:nil
                    target:target finishedSelector:finishedSelector failedSelector:failedSelector];
}

- (void)posse_acceptInvite:(NSString *)inviterUid
					target:(id)target finishedSelector:(SEL)finishedSelector
			failedSelector:(SEL)failedSelector {
	NSDictionary *params = 
		[[NSDictionary alloc] initWithObjectsAndKeys:inviterUid, @"inviter_uid", nil];
    [self callRemoteMethod:@"posse.acceptInvite" params:params
					target:target finishedSelector:finishedSelector 
			failedSelector:failedSelector];	
	[params release];	
}

- (void)posse_rejectInvite:(Invite *)invite
					target:(id)target finishedSelector:(SEL)finishedSelector
			failedSelector:(SEL)failedSelector {
	NSDictionary *params = 
	[[NSDictionary alloc] initWithObjectsAndKeys:invite.inviterUid, @"inviter_uid", nil];
    [self callRemoteMethod:@"posse.rejectInvite" params:params
					target:target finishedSelector:finishedSelector 
			failedSelector:failedSelector];	
	[params release];	
}

- (void)posse_deleteLink:(NSString *)targetId
                  target:(id)target finishedSelector:(SEL)finishedSelector
          failedSelector:(SEL)failedSelector {
	NSDictionary *params = 
	[[NSDictionary alloc] initWithObjectsAndKeys:targetId, @"target_id", nil];
    [self callRemoteMethod:@"posse.deleteLink" params:params
					target:target finishedSelector:finishedSelector 
			failedSelector:failedSelector];	
	[params release];
}

- (void)posse_sendInvites:(NSArray *)contacts name:(NSString *)name target:(id)target 
			  finishedSelector:(SEL)finishedSelector failedSelector:(SEL)failedSelector {
	NSMutableArray *expandedContacts = [[NSMutableArray alloc] initWithCapacity:[contacts count]];
	Contact *contact;
	for (contact in contacts) {
		if (contact.firstName == nil) { contact.firstName = @""; }
		if (contact.lastName == nil) { contact.lastName = @""; }
		if (contact.phoneNumber == nil) { contact.phoneNumber = @""; }
		if (contact.email == nil) { contact.email = @""; }	
		NSString *contactString = 
			[[NSString alloc] initWithFormat:@"%@,%@,%@,%@", contact.firstName, 
			 contact.lastName, contact.email, 
			 [contact.phoneNumber stringByReplacingOccurrencesOfString:@" " withString:@""]];
		[expandedContacts addObject:contactString];
		[contactString release];
	}
    
    if (name == nil) {
        name = @"";
    }
	
	NSString *invite_string = [expandedContacts componentsJoinedByString:@";"];
	NSDictionary *params = 
		[[NSDictionary alloc] initWithObjectsAndKeys:invite_string, @"invites", name, @"name", nil];
    [self callRemoteMethod:@"posse.sendInvites" params:params
					target:target finishedSelector:finishedSelector 
			failedSelector:failedSelector];	
	[params release];		
	[expandedContacts release];
}

- (void)posse_redeemCode:(NSString *)code target:(id)target 
		finishedSelector:(SEL)finishedSelector failedSelector:(SEL)failedSelector {
	NSDictionary *params = 
	[[NSDictionary alloc] initWithObjectsAndKeys:code, @"redeem_code", nil];
    [self callRemoteMethod:@"posse.redeemCode" params:params
					target:target finishedSelector:finishedSelector 
			failedSelector:failedSelector];	
	[params release];		
}

- (void)posse_getPosseAnimals:(NSInteger)start limit:(NSInteger)limit 
				  target:(id)target finishedSelector:(SEL)finishedSelector
		  failedSelector:(SEL)failedSelector {
    NSString *startNum = [[NSString alloc] initWithFormat:@"%d", start];
    NSString *limitNum = [[NSString alloc] initWithFormat:@"%d", limit];
    NSDictionary *params = 
	[[NSDictionary alloc] initWithObjectsAndKeys:startNum, @"start", limitNum, @"limit", nil];
	
    [self callRemoteMethod:@"posse.getPosseAnimals" params:params
					target:target finishedSelector:finishedSelector failedSelector:failedSelector];
	
	[startNum release];
	[limitNum release];
	[params release];
}

- (void)posse_getFacebookFriends:(id)target finishedSelector:(SEL)finishedSelector
			   failedSelector:(SEL)failedSelector {
    [self callRemoteMethod:@"posse.getFacebookFriends" params:nil
					target:target finishedSelector:finishedSelector failedSelector:failedSelector];	
}

- (void)posse_getInviteOptionHTML:(id<RestResponseDelegate>)delegate {
    [self callRemoteMethod:@"posse.getInviteOptionHTML" params:nil delegate:delegate];
}

- (void)posse_getFacebookBroadcastAction:(id<RestResponseDelegate>)delegate {
    [self callRemoteMethod:@"posse.getFacebookBroadcastAction" params:nil delegate:delegate];
}


#pragma mark Comment methods
- (void)comment_getComments:(NSString *)userId start:(NSInteger)start limit:(NSInteger)limit 
								  target:(id)target finishedSelector:(SEL)finishedSelector
						  failedSelector:(SEL)failedSelector {
    NSString *startNum = [[NSString alloc] initWithFormat:@"%d", start];
    NSString *limitNum = [[NSString alloc] initWithFormat:@"%d", limit];
    NSDictionary *params = 
	[[NSDictionary alloc] initWithObjectsAndKeys:startNum, @"start", 
	 limitNum, @"limit",
	 userId, @"user_id",
	 nil];
	
    [self callRemoteMethod:@"comment.getReceivedComments" params:params
					target:target finishedSelector:finishedSelector failedSelector:failedSelector];
	
	[startNum release];
	[limitNum release];
	[params release];
}

- (void)comment_sendComment:(NSString *)userId comment:(NSString *)comment 
					 target:(id)target finishedSelector:(SEL)finishedSelector
			 failedSelector:(SEL)failedSelector {
    NSDictionary *params = 
	[[NSDictionary alloc] initWithObjectsAndKeys:comment, @"text",
												 userId, @"user_id",
												 nil];
    [self callRemoteMethod:@"comment.sendComment" params:params
					target:target finishedSelector:finishedSelector failedSelector:failedSelector];
	[params release];
}

- (void)comment_removeComment:(NSString *)commentId
					 target:(id)target finishedSelector:(SEL)finishedSelector
			 failedSelector:(SEL)failedSelector {
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:commentId, @"comment_id", nil];
    [self callRemoteMethod:@"comment.removeComment" params:params
					target:target finishedSelector:finishedSelector failedSelector:failedSelector];
	[params release];
}

- (void)comment_sendBulletin:(NSString *)comment 
					 target:(id)target finishedSelector:(SEL)finishedSelector
			 failedSelector:(SEL)failedSelector {
    NSDictionary *params = 
        [[NSDictionary alloc] initWithObjectsAndKeys:comment, @"text",
         nil];
    [self callRemoteMethod:@"comment.sendBulletin" params:params
					target:target finishedSelector:finishedSelector failedSelector:failedSelector];
	[params release];
}

- (void)comment_getBulletins:(NSString *)userId start:(NSInteger)start limit:(NSInteger)limit 
                     target:(id)target finishedSelector:(SEL)finishedSelector
             failedSelector:(SEL)failedSelector {
    NSString *startNum = [[NSString alloc] initWithFormat:@"%d", start];
    NSString *limitNum = [[NSString alloc] initWithFormat:@"%d", limit];
    NSDictionary *params = 
	[[NSDictionary alloc] initWithObjectsAndKeys:startNum, @"start", 
	 limitNum, @"limit",
	 userId, @"user_id",
	 nil];
	
    [self callRemoteMethod:@"comment.getBulletins" params:params
					target:target finishedSelector:finishedSelector failedSelector:failedSelector];
	
	[startNum release];
	[limitNum release];
	[params release];
}


#pragma mark Newsfeed 
- (void)newsfeed_getNewsfeedItems:(NSInteger)start limit:(NSInteger)limit 
						   target:(id)target finishedSelector:(SEL)finishedSelector
				   failedSelector:(SEL)failedSelector {
    NSString *startNum = [[NSString alloc] initWithFormat:@"%d", start];
    NSString *limitNum = [[NSString alloc] initWithFormat:@"%d", limit];
    NSDictionary *params = 
	[[NSDictionary alloc] initWithObjectsAndKeys:startNum, @"start", 
	 limitNum, @"limit", 
	 nil];
	
    [self callRemoteMethod:@"newsfeed.getNewsFeedItems" params:params
					target:target finishedSelector:finishedSelector failedSelector:failedSelector];
	
	[startNum release];
	[limitNum release];
	[params release];
}

#pragma mark Top Animals

- (void)topAnimals_getTopListFor:(NSString *)field start:(NSInteger)start limit:(NSInteger)limit 
                    target:(id)target finishedSelector:(SEL)finishedSelector
             failedSelector:(SEL)failedSelector {
    NSString *startNum = [[NSString alloc] initWithFormat:@"%d", start];
    NSString *limitNum = [[NSString alloc] initWithFormat:@"%d", limit];
    NSDictionary *params = 
    [[NSDictionary alloc] initWithObjectsAndKeys:field, @"field", startNum, @"start", limitNum, @"limit", nil];
	
    [self callRemoteMethod:@"topAnimals.getTopListFor" params:params
					target:target finishedSelector:finishedSelector failedSelector:failedSelector];
	
	[startNum release];
	[limitNum release];
	[params release];    
}

- (NSString *)getSettingsUrl {
    NSString *paramString = [self generateRequestString:@"settings" params:nil];
#ifdef AMIT_DEV
	NSString *baseUrl = @"http://redbull1.miraphonic.com:60011/iphone/settings";
#else
	
#ifdef DREW_DEV
    NSString *baseUrl = @"http://redbull1.miraphonic.com:60009/iphone/settings";    
#else
    NSString *baseUrl = @"http://www.epicpetwars.com/iphone/settings";	
#endif
#endif	

    NSString *url = [NSString stringWithFormat:@"%@?%@", baseUrl, paramString];
    [paramString release];
	
	return url;
}

- (NSString *)getTwitterLinkUrl {
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:[Utility getUDID], @"udid", nil];
	NSString *paramString = [self generateRequestString:@"iphoneLink" params:params];
	[params release];
#ifdef AMIT_DEV
	NSString *baseUrl = @"http://redbull1.miraphonic.com:60011/twitter/iphoneLink";	
#else
	
#ifdef DREW_DEV
    NSString *baseUrl = @"http://redbull1.miraphonic.com:60009/twitter/iphoneLink";	
#else
    NSString *baseUrl = @"http://www.epicpetwars.com/twitter/iphoneLink";	
#endif
#endif	
	
    NSString *url = [NSString stringWithFormat:@"%@?%@", baseUrl, paramString];
    [paramString release];
	
	return url;
}

- (NSString *)getTwitterFriendUrl {
	NSString *paramString = [self generateRequestString:@"iphoneInvite" params:nil];
#ifdef AMIT_DEV
	NSString *baseUrl = @"http://redbull1.miraphonic.com:60011/twitter/iphoneInvite";	
#else
	
#ifdef DREW_DEV
    NSString *baseUrl = @"http://redbull1.miraphonic.com:60009/twitter/iphoneInvite";	
#else
    NSString *baseUrl = @"http://www.epicpetwars.com/twitter/iphoneInvite";	
#endif
#endif	
	
    NSString *url = [NSString stringWithFormat:@"%@?%@", baseUrl, paramString];
    [paramString release];
	
	return url;
}

- (NSString *)getPosseHelpUrl {
	NSString *paramString = [self generateRequestString:@"posseHelp" params:nil];
#ifdef AMIT_DEV
	NSString *baseUrl = @"http://redbull1.miraphonic.com:60011/iphone/posseHelp";
#else
	
#ifdef DREW_DEV
    NSString *baseUrl = @"http://redbull1.miraphonic.com:60009/iphone/posseHelp";
#else
    NSString *baseUrl = @"http://www.epicpetwars.com/iphone/posseHelp";
#endif
#endif	
	
    NSString *url = [NSString stringWithFormat:@"%@?%@", baseUrl, paramString];
    [paramString release];
	
	return url;
}

- (NSString *)getJobsUrl:(NSString *)userId {
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:userId, @"user_id", nil];
    NSString *paramString = [self generateRequestString:@"jobs" params:params];
	[params release];
	
#ifdef AMIT_DEV
	NSString *baseUrl = @"http://redbull1.miraphonic.com:60011/iphoneJobs/jobs";
//	NSString *baseUrl = @"http://redbull1.miraphonic.com:60011/iphoneBattle";
#else
	
#ifdef DREW_DEV
    NSString *baseUrl = @"http://redbull1.miraphonic.com:60009/iphoneJobs/jobs";    
#else
    NSString *baseUrl = @"http://www.epicpetwars.com/iphoneJobs/jobs";
#endif
#endif
	
    NSString *response = [NSString stringWithFormat:@"%@?%@", baseUrl, paramString];
    [paramString release];
	
	return response;
}

- (NSString *)getBattleUrl:(NSString *)userId {
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:userId, @"user_id", nil];
    NSString *paramString = [self generateRequestString:@"battle" params:params];
	[params release];
	
#ifdef AMIT_DEV
	NSString *baseUrl = @"http://redbull1.miraphonic.com:60011/iphoneBattle/index";
	//	NSString *baseUrl = @"http://redbull1.miraphonic.com:60011/iphoneBattle";
#else
	
#ifdef DREW_DEV
    NSString *baseUrl = @"http://redbull1.miraphonic.com:60009/iphoneBattle/index";    
#else
    NSString *baseUrl = @"http://www.epicpetwars.com/iphoneBattle/index";
#endif
#endif
	
    NSString *response = [NSString stringWithFormat:@"%@?%@", baseUrl, paramString];
    [paramString release];
	
	return response;
}

- (NSString *)getProfileUrl:(NSString *)userId animalId:(NSString *)animalId isBot:(NSString *)isBot {
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:userId, @"user_id", animalId, @"target_animal_id", isBot, @"is_bot", nil];
    NSString *paramString = [self generateRequestString:@"jobs" params:params];
	[params release];
	
#ifdef AMIT_DEV
	NSString *baseUrl = @"http://redbull1.miraphonic.com:60011/iphoneProfile/profile";
	//	NSString *baseUrl = @"http://redbull1.miraphonic.com:60011/iphoneBattle";
#else
	
#ifdef DREW_DEV
    NSString *baseUrl = @"http://redbull1.miraphonic.com:60009/iphoneProfile/profile";    
#else
    NSString *baseUrl = @"http://www.epicpetwars.com/iphoneProfile/profile";
#endif
#endif
	
    NSString *response = [NSString stringWithFormat:@"%@?%@", baseUrl, paramString];
    [paramString release];
	
	return response;
}

- (NSString *)getTopPlayerseUrl:(NSString *)userId {
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:userId, @"user_id", nil];
    NSString *paramString = [self generateRequestString:@"topPlayers" params:params];
	[params release];
	
#ifdef AMIT_DEV
	NSString *baseUrl = @"http://redbull1.miraphonic.com:60011/iphoneTopPlayers/index";
#else
	
#ifdef DREW_DEV
    NSString *baseUrl = @"http://redbull1.miraphonic.com:60009/iphoneTopPlayers/index";
#else
    NSString *baseUrl = @"http://www.epicpetwars.com/iphoneTopPlayers/index";
#endif
#endif
	
    NSString *response = [NSString stringWithFormat:@"%@?%@", baseUrl, paramString];
    [paramString release];
	
	return response;
}


- (id)copyWithZone:(NSZone *)zone {
    return self;
}

- (id)retain {
    return self;
}

- (unsigned)retainCount {
    return UINT_MAX;  //denotes an object that cannot be released
}

- (void)release {
    //do nothing
}

- (id)autorelease {   
    return self;
}

@end
