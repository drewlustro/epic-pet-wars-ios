//
//  BRWebViewController.m
//  battleroyale
//
//  Created by Amit Matani on 12/22/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "BRWebViewController.h"
#import "ActionResult.h"
#import "BRSession.h"
#import "ProtagonistAnimal.h"
#import "BRRestClient.h"
#import "BRAppDelegate.h"
#import "EarnedAchievementContainerController.h"
#import "CommentTableViewContainerController.h"

// method controlers
#import "InviteContactsViewController.h"
#import "BattleViewController.h"
#import "TwitterFriendInviteViewController.h"
#import "TwitterOAuthLinkerViewController.h"
#import "EarnedAchievementContainerController.h"
#import "BattleMasterViewController.h"
#import "ProfileWebViewController.h"
#import "NewCommentViewController.h"

// method helpers
#import "OwnedEquipmentSet.h"
#import "ProtagonistAnimalItemManager.h"

// popup controllers
#import "ItemReceivedViewController.h"
#import "LeveledUpViewController.h"
#import "PostJobActionViewController.h"

@implementation BRWebViewController

@synthesize hasStartedInitialLoad = _hasStartedInitialLoad, hasPendingDelegate = _hasPendingDelegate, container = _container;

- (void)loadDataWithRequest:(NSURLRequest *)request {
	if (_hasStartedInitialLoad) {
		[((LoadingUIWebViewWithLocalRequest *)self.view) stringByEvaluatingJavaScriptFromString:@"requestingReload()"];
	}
	[((LoadingUIWebViewWithLocalRequest *)self.view) loadRequest:request];
	_hasStartedInitialLoad = YES;
}


// Implement loadView to create a view hierarchy programmatically, without using a nib.

- (void)loadView {
	LoadingUIWebViewWithLocalRequest *webView = [[LoadingUIWebViewWithLocalRequest alloc] init];
	
    webView.localDelegate = self;
	webView.delegate = self;
    webView.shouldOverride = NO;
	webView.scalesPageToFit = YES;
//	[webView setup];
	webView.launchExternalLinksInSafari = NO;
	webView.autoresizingMask = UIViewAutoresizingFlexibleHeight;

	_hasStartedInitialLoad = NO;	
	self.view = webView;
	
	[webView release];
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	_hasStartedInitialLoad = NO;
}


- (void)dealloc {
	ProtagonistAnimal *protagonist = [[BRSession sharedManager] protagonistAnimal];
	protagonist.fBDialogDelegate = nil;
	
	((UIWebView *)self.view).delegate = nil;
	((LoadingUIWebViewWithLocalRequest *)self.view).localDelegate = nil;
	
	
	if ([protagonist itemManager].delegate == (id)self) {
		[protagonist itemManager].delegate = nil;
	}
    [super dealloc];
}
#pragma mark LoadingUIWebViewWithLocalRequestDelegate Methods
- (void)webView:(LoadingUIWebViewWithLocalRequest *)webView handleLocalMethod:(NSString *)method params:(NSDictionary *)params {
    if ([method isEqualToString:@"alert"]) {
		/*        NSString *title = [params objectForKey:@"title"];
		 NSString *text = [params objectForKey:@"text"];
		 
		 if (title == nil) {
		 title = @"Alert";
		 }
		 
		 if (text == nil) {
		 return;
		 }
		 
		 NSString *success = [params objectForKey:@"success"];
		 NSString *twitterUserId= [params objectForKey:@"twitter_user_id"];		
		 if (success != nil && [success isEqualToString:@"1"]) {
		 _success = YES;
		 [[BRSession sharedManager] setTwitterUserId:twitterUserId];
		 }
		 
		 [self alertWithTitle:title message:text delegate:self];*/
    } else if ([method isEqualToString:@"showBattleMaster"]) { 
		BattleMasterViewController *bmvc = [[BattleMasterViewController alloc] init];
		[self.container presentModalViewControllerWithNavigationBar:bmvc];
		[bmvc release];
	} else if ([method isEqualToString:@"showProfile"]) {
		NSString *animalId = [params objectForKey:@"animal_id"];
		NSString *isBot = [params objectForKey:@"is_bot"];
		if (animalId != nil && ![animalId isEqualToString:@""]) {
			if (isBot == nil || [isBot isEqualToString:@""]) {
				isBot = @"0";
			} 
			ProfileWebViewController *pwvc = [[ProfileWebViewController alloc] initWithAnimalId:animalId isBot:isBot];
			[[self.container navigationController] pushViewController:pwvc animated:YES];
			[pwvc release];
		}
	} else if ([method isEqualToString:@"startBattle"]) {
		NSString *fromView = [params objectForKey:@"from_view"];
		NSString *isBot = [params objectForKey:@"is_bot"];
		NSString *animalId = [params objectForKey:@"animal_id"];
		[[BRAppDelegate sharedManager] showLoadingOverlayWithText:@"Starting Battle"];
		[[BRRestClient sharedManager] battle_startBattle:animalId isBot:isBot fromView:fromView
												  target:self finishedSelector:@selector(finishedStartingBattle:parsedResponse:)
										  failedSelector:@selector(failedStartingBattle)];
		self.hasPendingDelegate = YES;
    } else if ([method isEqualToString:@"showAchievements"]) {
		NSString *animalId = [params objectForKey:@"animal_id"];
		EarnedAchievementContainerController *eacc = [[EarnedAchievementContainerController alloc] initWithAnimalId:animalId];	
		[[self.container navigationController] pushViewController:eacc animated:YES];
		
		[eacc setViewFrame:CGRectMake(0, 0, FRAME_WIDTH, self.container.view.frame.size.height)];	    
		
		[eacc release];	
    } else if ([method isEqualToString:@"showComments"]) {
		NSString *userId = [params objectForKey:@"user_id"];
		CommentTableViewContainerController *ctvcc = [[CommentTableViewContainerController alloc] initWithUserId:userId];
		[[self.container navigationController] pushViewController:ctvcc animated:YES];
		
		[ctvcc setViewFrame:CGRectMake(0, 0, FRAME_WIDTH, self.container.view.frame.size.height)];    
		[ctvcc release];
	} else if ([method isEqualToString:@"leaveComment"]) {
		NewCommentViewController *ncvc = [[NewCommentViewController alloc] initWithUserId:[params objectForKey:@"user_id"]];
		UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:ncvc];
		[self.container presentModalViewController:nav animated:YES];
		[ncvc release];    
		[nav release];
	} else if ([method isEqualToString:@"showContacts"]) {
		InviteContactsViewController *icvc = [[InviteContactsViewController alloc] init];
		[self.container presentModalViewControllerWithNavigationBar:icvc];
		[icvc release];
	} else if ([method isEqualToString:@"twitter"]) {
		UIViewController *twitterView;
		if ([[BRSession sharedManager] isTwitterUser]) {
			twitterView = [[TwitterFriendInviteViewController alloc] init];
		} else {
			twitterView = [[TwitterOAuthLinkerViewController alloc] init];
			((TwitterOAuthLinkerViewController *)twitterView).delegate = self;
			self.hasPendingDelegate = YES;
		}
		[self.container presentModalViewControllerWithNavigationBar:twitterView];
		[twitterView release];						
	} else if ([method isEqualToString:@"broadcast"]) {
		// get the details from the server on what to broadcast
        [[BRAppDelegate sharedManager] showLoadingOverlayWithText:@"Loading"];        
        [[BRRestClient sharedManager] posse_getFacebookBroadcastAction:self];
		self.hasPendingDelegate = YES;
	} else if ([method isEqualToString:@"fbStreamDialog"]) {
		NSString *streamDialogData = [webView stringByEvaluatingJavaScriptFromString:@"getStreamDialogData()"];
		NSDictionary *streamDialogDictionary = [Utility decodeJSON:streamDialogData];
		[[BRSession sharedManager] protagonistAnimal].pendingTemplateItem = streamDialogDictionary;
	} else if ([method isEqualToString:@"equip"] || [method isEqualToString:@"unequip"]) {
		ProtagonistAnimal *protagonist = [[BRSession sharedManager] protagonistAnimal];		
		if ([protagonist itemManager].delegate == nil) {
			[protagonist itemManager].delegate = self;
			self.hasPendingDelegate = YES;
		}
		
		NSInteger slot = [params objectForKey:@"slot"] == @"1" ? 1 : 0;
		NSString *overlay;
		BOOL loading;
		if ([method isEqualToString:@"equip"]) {
			loading = [[protagonist itemManager] equipItemWithId:[params objectForKey:@"item_id"] categoryKey:[params objectForKey:@"category_key"] slot:slot];
			overlay = @"Equipping";
		} else {
			loading = [[protagonist itemManager] unequipItemWithId:[params objectForKey:@"item_id"] categoryKey:[params objectForKey:@"category_key"] slot:slot];
			overlay = @"Unequipping";
		}
		if (loading) {
			[[BRAppDelegate sharedManager] showLoadingOverlayWithText:overlay];
		}

	} else if ([method isEqualToString:@"use"]) {
		ProtagonistAnimal *protagonist = [[BRSession sharedManager] protagonistAnimal];		
		if ([protagonist itemManager].delegate == nil) {
			[protagonist itemManager].delegate = self;
			self.hasPendingDelegate = YES;
		}
		
		if ([[protagonist itemManager] useItemWithId:[params objectForKey:@"item_id"] categoryKey:[params objectForKey:@"category_key"]]) {
			[[BRAppDelegate sharedManager] showLoadingOverlayWithText:@"Using Item"];
		}
		/*
		// params have categoryKey

		Item *item = [[protagonist equipment] getItemInSetWithId:[params objectForKey:@"item_id"]];
		if (item != nil) {
			if ([protagonist itemManager].delegate == nil) {
				[protagonist itemManager].delegate = self;
				self.hasPendingDelegate = YES;
			}
			[[protagonist itemManager] useItem:item];

		}*/
	}
}

#pragma mark UIWebViewDelegate

- (void)webViewDidFinishLoad:(UIWebView *)webView {
	debug_NSLog(@"webview finished loading");
	NSString *resultString = [webView stringByEvaluatingJavaScriptFromString:@"getActionResult()"];
	debug_NSLog(resultString);
	NSDictionary *result = [Utility decodeJSON:resultString];
	if (result != nil) {
		ActionResult *actionResult = [[ActionResult alloc] initWithApiResponse:result];
		if (actionResult == nil) { return; }
		[[[BRSession sharedManager] protagonistAnimal] updateWithActionResult:actionResult];
		
		if (actionResult.battleId == nil) {
			if (actionResult.showPopup) {
				NSString *postJobHTML = nil; //= [parsedResponse objectForKey:@"postJobHTML"];
				
				if ([Utility stringIfNotEmpty:postJobHTML]) {
					[[SoundManager sharedManager] playSoundWithType:@"pet" vibrate:NO];
					PostJobActionViewController *pjavc = [[PostJobActionViewController alloc] initWithHTML:postJobHTML];
					[self.container presentModalViewControllerWithNavigationBar:pjavc];
					[pjavc release];
				} else {
					if ([actionResult.level intValue] > 0) {
						// the user leveled up due to the job
						LeveledUpViewController *luvc = [[LeveledUpViewController alloc] initWithActionResult:actionResult];
						[self.container presentModalViewController:luvc animated:YES];
						[luvc release];
					} else if (actionResult.item) {
						ItemReceivedViewController *irvc = [[ItemReceivedViewController alloc] initWithItem:actionResult.item];
						[self.container presentModalViewController:irvc animated:YES];
						[irvc release];
					} else {
						// make noise only if no battle, no popup, and no item received
						[[SoundManager sharedManager] playSoundWithType:@"pet" vibrate:NO];
					}
				}
			} else {
				NSString *sound = [Utility stringIfNotEmpty:[result objectForKey:@"sound"]];
				if (sound != nil) {
					[[SoundManager sharedManager] playSoundWithType:sound vibrate:NO];
				}
			}
		} else {
			BattleViewController *battleViewController = 
            [[BattleViewController alloc] initWithOpponentAnimal:actionResult.newChallenger andBattleId:actionResult.battleId andInitialAction:nil];
			[self.container presentModalViewController:battleViewController animated:YES];
			[battleViewController release];
		}
		
		[actionResult release];
	}
}

#pragma mark RestResponseDelegate
- (void)remoteMethodDidLoad:(NSString *)method responseCode:(RestResponseCode)responseCode parsedResponse:(NSDictionary *)parsedResponse {
	[[BRAppDelegate sharedManager] hideLoadingOverlay];
	if (responseCode == RestResponseCodeSuccess) {
		ActionResult *actionResult = [[ActionResult alloc] initWithApiResponse:[parsedResponse objectForKey:@"action_result"]];
		
		if ([actionResult hasFacebookDialog]) {
			[[BRSession sharedManager] protagonistAnimal].fBDialogDelegate = self;
			self.hasPendingDelegate = YES;
		}
		
		[[[BRSession sharedManager] protagonistAnimal] updateWithActionResult:actionResult];			
		[[BRAppDelegate sharedManager] showNotification:actionResult.formattedResponse 
											  withWidth:[actionResult.formattedResponseWidth floatValue]
											  andHeight:[actionResult.formattedResponseHeight floatValue]];				
		[actionResult release];
	} else {
		[self alertWithTitle:@"Error" message:[parsedResponse objectForKey:@"response_message"]];
	}
	self.hasPendingDelegate = NO;
}

- (void)remoteMethodDidFail:(NSString *)method {
    if ([method isEqualToString:@"posse.getFacebookBroadcastAction"]) {    
        [[BRAppDelegate sharedManager] hideLoadingOverlay];    
    }
	self.hasPendingDelegate = NO;
}

# pragma mark BRRestClient Responders
- (void)failedToStartBattle:(NSString *)message {
	[[BRAppDelegate sharedManager] hideLoadingOverlay];	        
	[self alertWithTitle:@"Unable to Battle" message:message];
}

- (void)finishedStartingBattle:(NSNumber *)responseInt parsedResponse:(NSDictionary *)parsedResponse {
	if ([BRRestClient isResponseSuccessful:responseInt]) {		
		Animal *opponent = [[Animal alloc] initWithApiResponse:[parsedResponse objectForKey:@"opponent_animal"]];
		NSString *battleId = [parsedResponse objectForKey:@"battle_id"];
		BattleViewController *battleViewController = [[BattleViewController alloc] initWithOpponentAnimal:opponent andBattleId:battleId andInitialAction:nil];
		[self.container presentModalViewController:battleViewController animated:YES];
		[battleViewController release];
        [opponent release];
		[[BRAppDelegate sharedManager] hideLoadingOverlay];		
	} else {
        [self failedToStartBattle:[parsedResponse objectForKey:@"response_message"]];
	}
	self.hasPendingDelegate = NO;
}

- (void)failedStartingBattle {
    [self failedToStartBattle:@"Unknown Error"];
	self.hasPendingDelegate = NO;
}

#pragma mark TwitterOAuthLinkerViewControllerDelegate Methods
- (void)didFinishAttemptedLink:(BOOL)wasSuccessful {
	if (wasSuccessful) {
		TwitterFriendInviteViewController *twitterView = [[TwitterFriendInviteViewController alloc] init];		
		[[self.container modalViewController] presentModalViewControllerWithNavigationBar:twitterView];
		[twitterView release];
	} else {
		[self.container dismissTopMostModalViewControllerWithAnimation];
	}
	self.hasPendingDelegate = NO;
}

#pragma mark FBDialogDelegate Methods
- (void)dialogDidSucceed:(FBDialog*)dialog {
    [[BRAppDelegate sharedManager] showLoadingOverlayWithText:@"Loading"];        
    [[BRRestClient sharedManager] posse_getFacebookBroadcastAction:self];
	[[BRSession sharedManager] protagonistAnimal].fBDialogDelegate = nil;
	self.hasPendingDelegate = NO;
}

- (void)dialogDidCancel:(FBDialog*)dialog {
	[[BRSession sharedManager] protagonistAnimal].fBDialogDelegate = nil;
	self.hasPendingDelegate = NO;
}

#pragma mark ProtagonistAnimalItemManagerDelegate
- (void)handleSuccessfulResult:(ActionResult *)actionResult {
	// TODO put something here for updates for equipping
    [[BRAppDelegate sharedManager] hideLoadingOverlay];
    
    if (actionResult.formattedResponse != nil) {
        [[BRAppDelegate sharedManager] showNotification:actionResult.formattedResponse 
                                              withWidth:[actionResult.formattedResponseWidth floatValue]
                                              andHeight:[actionResult.formattedResponseHeight floatValue]];
    }
	self.hasPendingDelegate = NO;
}

- (void)equippedItem:(Item *)item slot:(NSInteger)slot result:(ActionResult *)actionResult {
	[self handleSuccessfulResult:actionResult];
}

- (void)failedToEquipItem:(Item *)item message:(NSString *)message {
	[self alertWithTitle:@"Error" message:message];
	[[BRAppDelegate sharedManager] hideLoadingOverlay];
}

- (void)unequippedItem:(Item *)item slot:(NSInteger)slot result:(ActionResult *)actionResult {
	[self handleSuccessfulResult:actionResult];
}

- (void)failedToUnequipItem:(Item *)item message:(NSString *)message {
	[self alertWithTitle:@"Error" message:message];
	[[BRAppDelegate sharedManager] hideLoadingOverlay];
}

- (void)usedItem:(Item *)item result:(ActionResult *)actionResult {
	[[SoundManager sharedManager] playSoundWithType:@"powerup" vibrate:NO];
	[self handleSuccessfulResult:actionResult];
	
}
- (void)failedToUseItem:(Item *)item message:(NSString *)message {
	[self alertWithTitle:@"Error" message:message];
	[[BRAppDelegate sharedManager] hideLoadingOverlay];
}

@end
