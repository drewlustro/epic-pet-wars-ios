/**
 * BRRestClient.h
 * Copyright Miraphonic, Inc 2009. All rights reserved.
 *
 * RestClient is the client that handles all calls to the 
 * REST API. It is a singleton and has to be used through 
 * a shared manager
 *
 * @author Amit Matani
 * @created 1/13/09
 */

#import <Foundation/Foundation.h>
#import "RestClient.h"
#import "FBConnect/FBConnect.h"
#import <StoreKit/StoreKit.h>

@class Invite;
@interface BRRestClient : RestClient {

}

+ (BRRestClient *)sharedManager;


+ (NSURLRequest *)getOfferRequestWithParams:(NSDictionary *)params;
+ (NSString *)getOfferUrlWithParams:(NSDictionary *)params;
+ (NSURLRequest *)getExtraOfferRequestWithParams:(NSDictionary *)params;
+ (NSString *)getExtraOfferUrlWithParams:(NSDictionary *)params;
+ (NSString *)getFBLoginUrl;
+ (NSString *)getGameUpdatesUrlWithParams:(NSDictionary *)params;
+ (NSString *)getHelpUrlWithTypeString:(NSString *)type params:(NSDictionary *)params;
- (NSString *)getJobsUrl:(NSString *)userId;
- (NSString *)getBattleUrl:(NSString *)userId;
- (NSString *)getProfileUrl:(NSString *)userId animalId:(NSString *)animalId isBot:(NSString *)isBot;
- (NSString *)getTopPlayerseUrl:(NSString *)userId;

#pragma mark Authentication methods

- (void)auth_getSessionWithDeviceId:(BOOL)shouldCreate target:(id)target 
				   finishedSelector:(SEL)finishedSelector failedSelector:(SEL)failedSelector;
- (void)auth_getSessionWithDeviceId:(id<RestResponseDelegate>)delegate;

- (void)auth_getSessionWithFBUID:(FBUID)_uid fbSessionKey:(NSString *)fbSessionKey 
                 fbSessionSecret:(NSString *)fbSessionSecret target:(id)target 
                finishedSelector:(SEL)finishedSelector failedSelector:(SEL)failedSelector;


		
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
     failedSelector:(SEL)failedSelector;

- (void)account_linkToFacebook:(FBUID)_uid session:(FBSession *)session delegate:(id<RestResponseDelegate>)delegate;
- (void)account_updateIphoneFBSession:(FBSession *)session delegate:(id<RestResponseDelegate>)delegate;

- (void)account_createNewAnimal:(NSString *)animalTypeId name:(NSString *)name 
					      email:(NSString *)email phoneNumber:(NSString *)phoneNumber
						 target:(id)target finishedSelector:(SEL)finishedSelector 
				 failedSelector:(SEL)failedSelector;

- (void)account_getUserAnimals:(NSInteger)start limit:(NSInteger)limit 
                        target:(id)target finishedSelector:(SEL)finishedSelector
                failedSelector:(SEL)failedSelector;

- (void)account_switchToAnimal:(NSString *)animalId 
						target:(id)target 
			  finishedSelector:(SEL)finishedSelector 
				failedSelector:(SEL)failedSelector;

- (void)account_deactivateAnimal:(NSString *)animalId 
                          target:(id)target 
                finishedSelector:(SEL)finishedSelector 
                  failedSelector:(SEL)failedSelector;

- (void)account_getOfferHtml:(id)target 
            finishedSelector:(SEL)finishedSelector 
              failedSelector:(SEL)failedSelector;

- (void)account_offerRemoved;

- (void)account_sendFeedback:(NSString *)feedBack email:(NSString *)email target:(id)target 
            finishedSelector:(SEL)finishedSelector
              failedSelector:(SEL)failedSelector;

- (void)account_setNotificationDeviceToken:(NSData *)deviceToken;


#pragma mark Animal Methods
- (void)animal_getPrimaryAnimal:(NSString *)user_id
        target:(id)target finishedSelector:(SEL)finishedSelector failedSelector:(SEL)failedSelector;

- (void)animal_withdrawFunds:(unsigned long long)amount delegate:(id<RestResponseDelegate>)delegate;

- (void)animal_depositFunds:(unsigned long long)amount delegate:(id<RestResponseDelegate>)delegate;
        
- (void)animal_loadAnimal:(NSString *)animalId
				   target:(id)target finishedSelector:(SEL)finishedSelector failedSelector:(SEL)failedSelector;

- (void)animal_updateEnergy:(id)target finishedSelector:(SEL)finishedSelector 
			 failedSelector:(SEL)failedSelector;     

- (void)animal_updateHp:(id)target finishedSelector:(SEL)finishedSelector 
         failedSelector:(SEL)failedSelector;

- (void)animal_updateMoney:(id)target finishedSelector:(SEL)finishedSelector 
            failedSelector:(SEL)failedSelector;

- (void)animal_petAnimal:(id)target finishedSelector:(SEL)finishedSelector 
        failedSelector:(SEL)failedSelector;

- (void)animal_forage:(id)target finishedSelector:(SEL)finishedSelector
		failedSelector:(SEL)failedSelector;

- (void)animal_getExternalActions:(id)target finishedSelector:(SEL)finishedSelector
		failedSelector:(SEL)failedSelector;

- (void)animal_autoRevive:(id)target finishedSelector:(SEL)finishedSelector
		   failedSelector:(SEL)failedSelector;

- (void)animal_useHosptial:(id)target finishedSelector:(SEL)finishedSelector
		failedSelector:(SEL)failedSelector;

- (void)animal_streamPublishAttempted:(FBUID)_uid callback:(NSString *)callback;

#pragma mark Item Methods
- (void)item_getItemsForAnimal:(id)target finishedSelector:(SEL)finishedSelector 
        failedSelector:(SEL)failedSelector;

- (void)item_buyItem:(NSString *)itemId amount:(NSInteger)amount target:(id)target 
    finishedSelector:(SEL)finishedSelector failedSelector:(SEL)failedSelector;

- (void)item_sellItem:(NSString *)itemId amount:(NSInteger)amount target:(id)target 
     finishedSelector:(SEL)finishedSelector failedSelector:(SEL)failedSelector;

- (void)item_equipItem:(NSString *)itemId slot:(NSInteger)slot target:(id)target 
    finishedSelector:(SEL)finishedSelector failedSelector:(SEL)failedSelector;
    
- (void)item_unequipItem:(NSString *)itemId slot:(NSInteger)slot target:(id)target 
    finishedSelector:(SEL)finishedSelector failedSelector:(SEL)failedSelector;

- (void)item_useItem:(NSString *)itemId target:(id)target 
    finishedSelector:(SEL)finishedSelector failedSelector:(SEL)failedSelector;

- (void)item_getItemsInShop:(id)target 
    finishedSelector:(SEL)finishedSelector failedSelector:(SEL)failedSelector;

- (void)item_getItemsInShopWithCategory:(NSString *)category 
                                  start:(NSInteger)start 
                                  limit:(NSInteger)limit 
                                 target:(id)target 
                       finishedSelector:(SEL)finishedSelector 
                         failedSelector:(SEL)failedSelector;

- (void)item_getItemsForAnimalWithCategory:(NSString *)category 
                                     start:(NSInteger)start 
                                     limit:(NSInteger)limit 
                                    target:(id)target 
                          finishedSelector:(SEL)finishedSelector 
                            failedSelector:(SEL)failedSelector;
    
- (void)job_getJobs:(id)target finishedSelector:(SEL)finishedSelector failedSelector:(SEL)failedSelector;

- (void)job_doJob:(NSString *)jobId target:(id)target 
        finishedSelector:(SEL)finishedSelector failedSelector:(SEL)failedSelector;

- (void)battle_getAvailableChallengers:(id)target 
		finishedSelector:(SEL)finishedSelector failedSelector:(SEL)failedSelector;

- (void)battle_startBattle:(NSString *)opponentAnimalId isBot:(NSString *)isBot fromView:(NSString *)fromView
                    target:(id)target finishedSelector:(SEL)finishedSelector failedSelector:(SEL)failedSelector;

- (void)battle_attack:(NSString *)battleId target:(id)target 
		  finishedSelector:(SEL)finishedSelector failedSelector:(SEL)failedSelector;

- (void)battle_useItem:(NSString *)battleId itemId:(NSString *)itemId target:(id)target 
	  finishedSelector:(SEL)finishedSelector failedSelector:(SEL)failedSelector;

- (void)battle_run:(NSString *)battleId target:(id)target 
	 finishedSelector:(SEL)finishedSelector failedSelector:(SEL)failedSelector;

- (void)reward_getOffersForToday:(id)target finishedSelector:(SEL)finishedSelector
		failedSelector:(SEL)failedSelector;

- (void)reward_redeemOffer:(NSString *)offerId target:(id)target 
		finishedSelector:(SEL)finishedSelector failedSelector:(SEL)failedSelector;

- (void)reward_redeemStoreKitOfferWithTransaction:(SKPaymentTransaction *)transaction
										 delegate:(id<RestResponseDelegate>)delegate;

- (void)reward_sendOfferLinkWithEmail:(NSString *)email link:(NSString *)link name:(NSString *)name
                             currency:(NSString *)currency target:(id)target 
                     finishedSelector:(SEL)finishedSelector failedSelector:(SEL)failedSelector;


- (void)achievement_getAvailableAcievements:(NSInteger)start limit:(NSInteger)limit 
		target:(id)target finishedSelector:(SEL)finishedSelector
		failedSelector:(SEL)failedSelector;

- (void)achievement_getEarnedAcievements:(NSString *)animalId start:(NSInteger)start limit:(NSInteger)limit 
		target:(id)target finishedSelector:(SEL)finishedSelector
		failedSelector:(SEL)failedSelector;

- (void)posse_inviteUserWithFriendCode:(NSString *)friendCode target:(id)target 
					  finishedSelector:(SEL)finishedSelector failedSelector:(SEL)failedSelector;

- (void)posse_inviteUserWithUserId:(NSString *)userId target:(id)target 
				  finishedSelector:(SEL)finishedSelector failedSelector:(SEL)failedSelector;

- (void)posse_deleteLink:(NSString *)targetId
                  target:(id)target finishedSelector:(SEL)finishedSelector
          failedSelector:(SEL)failedSelector;

- (void)posse_getInvites:(NSInteger)start limit:(NSInteger)limit 
				  target:(id)target finishedSelector:(SEL)finishedSelector
		  failedSelector:(SEL)failedSelector;

- (void)posse_getInviteCount:(id)target finishedSelector:(SEL)finishedSelector
              failedSelector:(SEL)failedSelector;

- (void)posse_acceptInvite:(NSString *)inviterUid
					target:(id)target finishedSelector:(SEL)finishedSelector
			failedSelector:(SEL)failedSelector;

- (void)posse_rejectInvite:(Invite *)invite
					target:(id)target finishedSelector:(SEL)finishedSelecto
			failedSelector:(SEL)failedSelector;

- (void)posse_sendInvites:(NSArray *)contacts name:(NSString *)name target:(id)target 
         finishedSelector:(SEL)finishedSelector failedSelector:(SEL)failedSelector;

- (void)posse_redeemCode:(NSString *)code target:(id)target 
			  finishedSelector:(SEL)finishedSelector failedSelector:(SEL)failedSelector;

- (void)posse_getPosseAnimals:(NSInteger)start limit:(NSInteger)limit 
					   target:(id)target finishedSelector:(SEL)finishedSelector
			   failedSelector:(SEL)failedSelector;

- (void)posse_getFacebookFriends:(id)target finishedSelector:(SEL)finishedSelector
				  failedSelector:(SEL)failedSelector;

- (void)posse_getInviteOptionHTML:(id<RestResponseDelegate>)delegate;
- (void)posse_getFacebookBroadcastAction:(id<RestResponseDelegate>)delegate;

- (void)comment_getComments:(NSString *)animalId start:(NSInteger)start limit:(NSInteger)limit 
					 target:(id)target finishedSelector:(SEL)finishedSelector
			 failedSelector:(SEL)failedSelector;

- (void)comment_removeComment:(NSString *)commentId
                       target:(id)target finishedSelector:(SEL)finishedSelector
               failedSelector:(SEL)failedSelector;

- (void)comment_sendComment:(NSString *)userId comment:(NSString *)comment 
					 target:(id)target finishedSelector:(SEL)finishedSelector
			 failedSelector:(SEL)failedSelector;

- (void)comment_sendBulletin:(NSString *)comment 
                         target:(id)target finishedSelector:(SEL)finishedSelector
                 failedSelector:(SEL)failedSelector;

- (void)comment_getBulletins:(NSString *)userId start:(NSInteger)start limit:(NSInteger)limit 
                      target:(id)target finishedSelector:(SEL)finishedSelector
              failedSelector:(SEL)failrewardedSelector;

- (void)newsfeed_getNewsfeedItems:(NSInteger)start limit:(NSInteger)limit 
						   target:(id)target finishedSelector:(SEL)finishedSelector
				   failedSelector:(SEL)failedSelector;

- (void)topAnimals_getTopListFor:(NSString *)field start:(NSInteger)start limit:(NSInteger)limit 
                          target:(id)target finishedSelector:(SEL)finishedSelector
                  failedSelector:(SEL)failedSelector;
    
- (NSString *)getSettingsUrl;
- (NSString *)getTwitterLinkUrl;
- (NSString *)getTwitterFriendUrl;
- (NSString *)getPosseHelpUrl;

@end
