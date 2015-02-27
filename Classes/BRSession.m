/**
 * BRSession.h
 * Copyright Miraphonic, Inc 2009. All rights reserved.
 *
 * CurrentSession manages the user's session.  It holds user specific
 * data including user id and pet data.
 *
 * @author Amit Matani
 * @created 1/13/09
 */

#import "BRSession.h"
#import "BRRestClient.h"
#import "ProtagonistAnimal.h"
#import "AchievementRemoteCollection.h"
#import "InviteRemoteCollection.h"
#import "FacebookUserRemoteCollection.h"
#import "ShopEquipmentSet.h"
#import "BRAppDelegate.h"
#import "BRGlobal.h"
#import "BRStoreKitPaymentManager.h"

#define SOUND_KEY @"sound"
#define VIBRATION_KEY @"vibration"

@implementation BRSession
@synthesize protagonistAnimal, shopItems, availableAchievements, pendingInvites, facebookUserId, facebookFriends,
            email, isEmailVerified, offerId, canPlaySounds = _canPlaySounds, canPlayVibration = _canPlayVibration,
			topListKeys = _topListKeys, topListValues = _topListValues, twitterUserId = _twitterUserId,
hideFacebookInvite = _hideFacebookInvite, hideTwitterInvite = _hideTwitterInvite, hideEmailInvite = _hideEmailInvite;

static BRSession *sharedManager = nil;

+ (BRSession *)sharedManager {
    @synchronized(self) {
        if (sharedManager == nil) {
            [[self alloc] init]; // assignment not done here
        }
    }
    return sharedManager;
}

+ (id)allocWithZone:(NSZone *)zone {				
    @synchronized(self) {
		if (sharedManager == nil) {
			sharedManager = [super allocWithZone:zone];
			return sharedManager;  // assignment and return on first allocation
		}
	}
    return nil; //on subsequent allocation attempts return nil
}

- (id)init {
	if (self = [super init]) {
        shopItems = [[ShopEquipmentSet alloc] init];
		availableAchievements = [[AchievementRemoteCollection alloc] init];
		pendingInvites = [[InviteRemoteCollection alloc] init];
		facebookFriends = [[FacebookUserRemoteCollection alloc] init];
	}
	return self;
}

- (BOOL)login:(NSString *)username password:(NSString *)password 
		extraProperties:(NSDictionary *)extraProperties {
	if ([super login:username password:password extraProperties:extraProperties]) {
		NSDictionary *animalDict = [extraProperties objectForKey:@"animal"];
        NSDictionary *sessionDict = [extraProperties objectForKey:@"session"];
        
		self.facebookUserId = [Utility stringIfNotEmpty:[sessionDict objectForKey:@"facebook_user_id"]];
		self.twitterUserId = [Utility stringIfNotEmpty:[sessionDict objectForKey:@"twitter_user_id"]];		
        self.email = [Utility stringIfNotEmpty:[sessionDict objectForKey:@"email"]];
        
        self.isEmailVerified = [Utility isStringTrue:[sessionDict objectForKey:@"email_verified"]];
        self.canPlaySounds = [Utility isStringTrue:[sessionDict objectForKey:@"settings_sound_effects"]];
		
		self.topListKeys = [sessionDict objectForKey:@"toplist_keys"];
		self.topListValues = [sessionDict objectForKey:@"toplist_values"];
        
        self.hideEmailInvite = [Utility isStringTrue:[sessionDict objectForKey:@"hide_email_invite"]];
        self.hideFacebookInvite = [Utility isStringTrue:[sessionDict objectForKey:@"hide_facebook_invite"]];
        self.hideTwitterInvite = [Utility isStringTrue:[sessionDict objectForKey:@"hide_twitter_invite"]];
        
        NSString *skIdentifiers = [Utility stringIfNotEmpty:[sessionDict objectForKey:@"sk_identifiers"]];
		if (skIdentifiers != nil) {
			NSSet *skSet = [NSSet setWithArray:[skIdentifiers componentsSeparatedByString:@","]];
			[[BRStoreKitPaymentManager sharedManager] setProductIdentifiers:skSet];
		}
		[BRStoreKitPaymentManager sharedManager].shouldWaitForProductRequest = [Utility isStringTrue:[sessionDict objectForKey:@"wait_for_sk"]];        
        
		if (animalDict != nil && (id) animalDict != [NSNull null]) {
			ProtagonistAnimal *animal = [[ProtagonistAnimal alloc] initWithApiResponse:animalDict];
			self.protagonistAnimal = animal;
			[animal release];
		}
		
        return YES;
	}
    return NO;
}

- (void)setProtagonistAnimal:(ProtagonistAnimal *)animal {
	[shopItems reset];
	[availableAchievements resetCollection];
    [protagonistAnimal cleanup];
	[protagonistAnimal release];
	protagonistAnimal = [animal retain];
}

- (BOOL)isFacebookUser {
	return (facebookUserId != nil && ![facebookUserId isEqualToString:@""] && ![facebookUserId isEqualToString:@"0"]);
}

- (BOOL)isTwitterUser {
	return (_twitterUserId != nil && ![_twitterUserId isEqualToString:@""] && ![_twitterUserId isEqualToString:@"0"]);
}


- (void)registerObserverForProtagonistAnimal:(id)observer {
	[self addObserver:observer forKeyPath:@"protagonistAnimal"
		  options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld)
			  context:NULL];
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

- (RestClient *)getRestClient {
    return [BRRestClient sharedManager];
}

- (BOOL)saveSessionPropertyList {
    NSString *sound = _canPlaySounds ? @"1" : @"0";
    NSString *vibration = _canPlayVibration ? @"1" : @"0";
    
    [sessionPropertyList removeAllObjects];
    [sessionPropertyList setObject:sound forKey:SOUND_KEY];
    [sessionPropertyList setObject:vibration forKey:VIBRATION_KEY];
    
    return [super saveSessionPropertyList];
}

- (void)initializeSessionFromPropertyList {
    [super initializeSessionFromPropertyList];
    _canPlaySounds = [[sessionPropertyList objectForKey:SOUND_KEY] isEqualToString:@"1"];
    _canPlayVibration = [[sessionPropertyList objectForKey:VIBRATION_KEY] isEqualToString:@"1"];    
}

- (NSString *)getOfferUrl {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[self userId], @"user_id", nil];
	
	[[BRStoreKitPaymentManager sharedManager] decorateURLParamWithProducts:params];
	
    NSString *url = [BRRestClient getOfferUrlWithParams:params];
    [params release];
    return url;
}

- (NSURLRequest *)getOfferRequest {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[self userId], @"user_id", nil];
	
	[[BRStoreKitPaymentManager sharedManager] decorateURLParamWithProducts:params];
	
    NSURLRequest *request = [BRRestClient getOfferRequestWithParams:params];
    [params release];
    return request;
}

- (NSString *)getExtraOfferUrl {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[self userId], @"user_id", nil];
	
	[[BRStoreKitPaymentManager sharedManager] decorateURLParamWithProducts:params];
	
    NSString *url = [BRRestClient getExtraOfferUrlWithParams:params];
    [params release];
    return url;
}

- (NSURLRequest *)getExtraOfferRequest {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[self userId], @"user_id", nil];
	
	[[BRStoreKitPaymentManager sharedManager] decorateURLParamWithProducts:params];
	
    NSURLRequest *request = [BRRestClient getExtraOfferRequestWithParams:params];
    [params release];
    return request;
}


- (NSString *)getGameUpdatesUrl {
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:[self userId], @"user_id", nil];
    NSString *url = [BRRestClient getGameUpdatesUrlWithParams:params];
    [params release];
    return url;
}

- (NSString *)getHelpUrlWithTypeString:(NSString *)type {
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:[self userId], @"user_id", nil];
    NSString *url = [BRRestClient getHelpUrlWithTypeString:type params:params];
    [params release];
    return url;
}

- (NSString *)getJobsUrl {
	return [[BRRestClient sharedManager] getJobsUrl:[self userId]];
}

- (NSString *)getBattleUrl {
	return [[BRRestClient sharedManager] getBattleUrl:[self userId]];
}

- (NSString *)getProfileUrl:(NSString *)animalId isBot:(NSString *)isBot {
	return [[BRRestClient sharedManager] getProfileUrl:[self userId] animalId:animalId isBot:isBot];
}


- (NSString *)getTopPlayersUrl {
	return [[BRRestClient sharedManager] getTopPlayerseUrl:[self userId]];
}


- (void)resumeFacebookSession:(id<FBSessionDelegate>)delegate {
	FBSession *fbSession = [FBSession sessionForApplication:FB_API_KEY secret:FB_APP_SECRET delegate:self];
	if (![self isFacebookUser]) {
		[fbSession logout];
	}
	_forwardFBSessionDelegate = delegate;
	if (![fbSession resume]) {
		FBLoginDialog* dialog = [[[FBLoginDialog alloc] initWithSession:fbSession] autorelease];
		[dialog show];
	}
}

- (void)flushTempFBVars {
	_forwardFBSessionDelegate = nil;	
	[_tempFBSession release];
	_tempFBSession = nil;	
}

- (void)session:(FBSession*)_session didLogin:(FBUID)uid {
    if ([self isFacebookUser] && !_hasUpdatedFacebookSession) { // otherwise we need to link accounts
		_hasUpdatedFacebookSession = YES;
		_tempFBUID = uid;
		[_tempFBSession release];
		_tempFBSession = [_session retain];
		
        [[BRAppDelegate sharedManager] showLoadingOverlayWithText:@"Updating Facebook Link"];
        [[BRRestClient sharedManager] account_updateIphoneFBSession:_session delegate:self];
    } else if (![self isFacebookUser]) {
		_tempFBUID = uid;
		[_tempFBSession release];
		_tempFBSession = [_session retain];		
		
		[[BRAppDelegate sharedManager] showLoadingOverlayWithText:@"Linking to Facebook"];
		[[BRRestClient sharedManager] account_linkToFacebook:uid session:_session delegate:self];
	} else {
		// forward the did login information on		
		[_forwardFBSessionDelegate session:_session didLogin:uid];
	}
}

#pragma mark RestResponseDelegate
- (void)remoteMethodDidLoad:(NSString *)method responseCode:(RestResponseCode)responseCode parsedResponse:(NSDictionary *)parsedResponse {        
    [[BRAppDelegate sharedManager] hideLoadingOverlay];
	if ([method isEqualToString:@"account.updateIphoneFBSession"]) {	
		if (responseCode == RestResponseCodeSuccess) {
			[_forwardFBSessionDelegate session:_tempFBSession didLogin:_tempFBUID];
		} else {
			[Utility alertWithTitle:@"Unable To Update" message:[parsedResponse objectForKey:@"response_message"]];			
		}
	} else if ([method isEqualToString:@"account.linkToFacebook"]) {
		if (responseCode == RestResponseCodeSuccess) {
			[[BRSession sharedManager] setFacebookUserId:[parsedResponse objectForKey:@"facebook_user_id"]];
			[_forwardFBSessionDelegate session:_tempFBSession didLogin:_tempFBUID];			
		} else {
			[Utility alertWithTitle:@"Unable To Link" message:[parsedResponse objectForKey:@"response_message"]];
		}
    }
	[self flushTempFBVars];
}

- (void)remoteMethodDidFail:(NSString *)method {
    [[BRAppDelegate sharedManager] hideLoadingOverlay]; 
	if ([method isEqualToString:@"account.linkToFacebook"]) {	
		[Utility alertWithTitle:@"Unable To Link" message:@"Unknown Error"];
	}
	[self flushTempFBVars];	
}

- (id)autorelease {
    return self;
}

- (void)launchPlusPlusWithOAuthKey:(NSString *)key oauthSecret:(NSString *)secret {
	_PPPlatformOAuthClientKey = [key copy];
	_PPPlatformOAuthClientSecret = [secret copy];

//	if (!_hasPPLoaded && _PPPlatformOAuthClientKey != nil && _PPPlatformOAuthClientSecret != nil) {
//		[NGPlatform sharedPlatform].delegate = self;	
//		[[NGPlatform sharedPlatform] launch];				
//		_hasPPLoaded = YES;
//	}	
}

#pragma mark NGPlatformDelegate
- (NSString *)platformOAuthClientKey {
	return _PPPlatformOAuthClientKey;
}

- (NSString *)platformOAuthClientSecret {
	return _PPPlatformOAuthClientSecret;
}

@end
