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

#import <Foundation/Foundation.h>
#import "Session.h"
#import "FBConnect/FBConnect.h"
//#import "NGPlatform.h"

@class ProtagonistAnimal, ShopEquipmentSet, AchievementRemoteCollection, InviteRemoteCollection, FacebookUserRemoteCollection, AbstractAnimalRemoteCollectionStore;
@interface BRSession : Session <FBSessionDelegate, RestResponseDelegate> {
    ProtagonistAnimal *protagonistAnimal;
	ShopEquipmentSet *shopItems;
	AchievementRemoteCollection *availableAchievements;
	InviteRemoteCollection *pendingInvites;
	
	// facebook
	FacebookUserRemoteCollection *facebookFriends;
	NSString *facebookUserId;
    NSString *fbApiKey;
    NSString *fbSecret;
	
	// twitter
	NSString *_twitterUserId;
	
    NSString *email;
    NSString *offerId;
    BOOL isEmailVerified, _canPlaySounds, _canPlayVibration;
	NSArray *_topListKeys, *_topListValues;
	
	BOOL _hasUpdatedFacebookSession;
	FBSession *_tempFBSession;
	FBUID _tempFBUID;
	id<FBSessionDelegate> _forwardFBSessionDelegate;	
	
	// plus+ information
	NSString *_PPPlatformOAuthClientKey, *_PPPlatformOAuthClientSecret;
	BOOL _hasPPLoaded;
    
	// invite information
    BOOL _hideFacebookInvite, _hideTwitterInvite, _hideEmailInvite;
}

@property (nonatomic, retain) ProtagonistAnimal *protagonistAnimal;
@property (nonatomic, readonly) ShopEquipmentSet *shopItems;
@property (nonatomic, readonly) AchievementRemoteCollection *availableAchievements;
@property (nonatomic, readonly) InviteRemoteCollection *pendingInvites;
@property (nonatomic, readonly) FacebookUserRemoteCollection *facebookFriends;
@property (nonatomic, copy) NSString *facebookUserId;
@property (nonatomic, copy) NSString *email, *offerId;
@property (nonatomic, assign) BOOL isEmailVerified, canPlaySounds, canPlayVibration, 
                                    hideFacebookInvite, hideTwitterInvite, hideEmailInvite;
@property (nonatomic, retain) NSArray *topListKeys, *topListValues;
@property (nonatomic, copy) NSString *twitterUserId;

+ (BRSession *)sharedManager;
- (void)registerObserverForProtagonistAnimal:(id)observer;
- (BOOL)isFacebookUser;
- (BOOL)isTwitterUser;
- (NSString *)getExtraOfferUrl;
- (NSString *)getOfferUrl;
- (NSURLRequest *)getOfferRequest;
- (NSURLRequest *)getExtraOfferRequest;
- (NSString *)getGameUpdatesUrl;
- (NSString *)getJobsUrl;
- (NSString *)getProfileUrl:(NSString *)animalId isBot:(NSString *)isBot;
- (NSString *)getBattleUrl;
- (NSString *)getTopPlayersUrl;
- (NSString *)getHelpUrlWithTypeString:(NSString *)type;
- (void)resumeFacebookSession:(id<FBSessionDelegate>)delegate;

- (void)launchPlusPlusWithOAuthKey:(NSString *)key oauthSecret:(NSString *)secret;

@end
