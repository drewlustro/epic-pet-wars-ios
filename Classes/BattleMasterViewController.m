//
//  BattleMasterViewController.m
//  battleroyale
//
//  Created by Amit Matani on 4/12/09.
//  Copyright 2009 Miraphonic, Inc. All rights reserved.
//

#import "BattleMasterViewController.h"
#import "Consts.h"
#import "BRSession.h"
#import "ProtagonistAnimal.h"
#import "BRRestClient.h"
#import "ItemReceivedViewController.h"
#import "BRAppDelegate.h"
#import "ActionResult.h"
#import "RewardOfferViewController.h"
#import "BRTabManager.h"
#import "BRSRTableViewController.h"
#import "BRStoreKitPaymentManager.h"


@implementation BattleMasterViewController
@synthesize offersWebView, respectPointsOwnedLabel, shouldReload;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:@"BattleMasterView" bundle:[NSBundle mainBundle]]) {
        // Custom initialization
        shouldReload = NO;
        self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Battle Master" image:[UIImage imageNamed:@"tab_bar_battle_master.png"] tag:3];
        self.title = @"Battle Master";
		[[[BRSession sharedManager] protagonistAnimal] registerObserverToAllProperties:self];		        
        [[BRSession sharedManager] registerObserverForProtagonistAnimal:self];        
    }
    return self;
}
- (void)resetNumPointsText {
	respectPointsOwnedLabel.text = [NSString stringWithFormat:@"You have %d respect points", 
                                    [[[BRSession sharedManager] protagonistAnimal] respectPoints]];    
}


- (void)viewDidLoad {
    offersWebView.scalesPageToFit = NO;
    offersWebView.localDelegate = self;
	[BRStoreKitPaymentManager sharedManager].paymentDelegate = self;
    
    [self loadOfferData];
    [self resetNumPointsText];    
}

- (void)loadOfferData {
	if ([[BRStoreKitPaymentManager sharedManager] hasLoadedProducts] ||
		![[BRStoreKitPaymentManager sharedManager] shouldWaitForProductRequest]) {

		[offersWebView loadRequest:[[BRSession sharedManager] getOfferRequest]];
	} else {
		[[BRAppDelegate sharedManager] showLoadingOverlayWithText:@"Connecting to iTunes"];
		[BRStoreKitPaymentManager sharedManager].productRequestDelegate = self;
	}
}

- (void)showMoreOffers {
    RewardOfferViewController *rovc = [[RewardOfferViewController alloc] init];
    [[self navigationController] pushViewController:rovc animated:YES];
    [rovc release];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex == 1) {
		[self showMoreOffers];
	}
}


#pragma mark LoadingUIWebViewWithLocalRequest method
- (void)webView:(LoadingUIWebViewWithLocalRequest *)webView handleLocalMethod:(NSString *)method params:(NSDictionary *)params {
    if ([method isEqualToString:@"showMoreOffers"]) {
		[[SoundManager sharedManager] playSoundWithType:@"popup" vibrate:NO];
        [self showMoreOffers];
    } else if ([method isEqualToString:@"redeem"]) {
        NSString *offerId = [params objectForKey:@"offer_id"];
        if (offerId != nil) {
			[[SoundManager sharedManager] playSoundWithType:@"pet" vibrate:NO];
            [self redeemOffer:offerId];
        }
    } else if ([method isEqualToString:@"showSR"]) {
		[[SoundManager sharedManager] playSoundWithType:@"popup" vibrate:NO];
        SRMode mode = [[params objectForKey:@"mode"] intValue];
        NSInteger offersPerPage = [[params objectForKey:@"offersPerPage"] intValue];
        if (offersPerPage <= 0) { offersPerPage = 30; }
        BRSRTableViewController *stvc = [[BRSRTableViewController alloc] initWithGameId:[[BRSession sharedManager] offerId] 
                                                                             userId:[[BRSession sharedManager] userId] 
                                                                               mode:mode offersPerPage:offersPerPage];
        [[self navigationController] pushViewController:stvc animated:YES];
        [stvc release];
    } else if ([method isEqualToString:@"storeKitPurchase"]) {
		NSString *identifier = [params objectForKey:@"identifier"];
		[[BRStoreKitPaymentManager sharedManager] purchaseProductWithProductIndentifier:identifier];
	}
}

- (void)redeemOffer:(NSString *)offerId {
    [[BRRestClient sharedManager] reward_redeemOffer:offerId
                                              target:self 
                                    finishedSelector:@selector(finishedRedeeming:parsedResponse:) 
                                      failedSelector:@selector(failedRedeeming)];
    [[BRAppDelegate sharedManager] showLoadingOverlayWithText:@"Redeeming"];	
}

- (void)finishedRedeeming:(NSNumber *)responseInt parsedResponse:(NSDictionary *)parsedResponse {
    [[BRAppDelegate sharedManager] hideLoadingOverlay];    
    
	if ([BRRestClient isResponseSuccessful:responseInt]) {
		ActionResult *actionResult = 
        [[ActionResult alloc] initWithApiResponse:[parsedResponse objectForKey:@"action_result"]];
		[[[BRSession sharedManager] protagonistAnimal] updateWithActionResult:actionResult];
		
		if (![Utility stringIfNotEmpty:actionResult.popupHTML]) {
			if (actionResult.item) {
				ItemReceivedViewController *irvc = [[ItemReceivedViewController alloc] initWithItem:actionResult.item];
				[self presentModalViewController:irvc animated:YES];
				[irvc release];
			} else {
				[[SoundManager sharedManager] playSoundWithType:@"powerup" vibrate:NO];
				[[BRAppDelegate sharedManager] showNotification:actionResult.formattedResponse 
													  withWidth:[actionResult.formattedResponseWidth floatValue]
													  andHeight:[actionResult.formattedResponseHeight floatValue]];
			}
		}
		
		
		[actionResult release];
		
		[self resetNumPointsText];
        
        // check to see if the battle master wants us to reload the offers
        NSString *shouldRefresh = [parsedResponse objectForKey:@"should_refresh"];
        if ((id)shouldRefresh != [NSNull null] && [shouldRefresh intValue] == 1) {
            [self loadOfferData];
        }
		
		
            
	} else {
        UIAlertView *requiresPoints =
        [[UIAlertView alloc] initWithTitle:@"Cannot Redeem" 
                                   message:@"You do not have enough respect points for this offer."
                                  delegate:self
                         cancelButtonTitle:@"OK" 
                         otherButtonTitles:@"Get More", nil];
        [requiresPoints show];
        [requiresPoints release];
	}
}

- (void)failedRedeeming {
	[[BRAppDelegate sharedManager] hideLoadingOverlay];
	UIAlertView *requiresPoints =
        [[UIAlertView alloc] initWithTitle:@"Cannot Redeem" 
							   message:@"Unknown Error. Please try again later"
							  delegate:self
					 cancelButtonTitle:@"OK" 
					 otherButtonTitles:nil];
	[requiresPoints show];
	[requiresPoints release];
}

#pragma mark BRStoreKitPaymentManagerProductRequestDelegate
- (void)loadedProducts {
	[[BRAppDelegate sharedManager] hideLoadingOverlay];
	[offersWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[[BRSession sharedManager] getOfferUrl]]]];	
}

#pragma mark BRStoreKitPaymentManagerPaymentDelegate
- (void)finishedPayment:(NSDictionary *)parsedResponse {
	NSString *shouldRefresh = [parsedResponse objectForKey:@"should_refresh"];
	if ((id)shouldRefresh != [NSNull null] && [shouldRefresh intValue] == 1) {
		[self loadOfferData];
	}	
}

#pragma mark Top Level Methods
- (void)handleSelected {
	if (shouldReload) {
        [self loadOfferData];
	}
	shouldReload = NO;
}

- (void)handleLogin {
    shouldReload = YES;
}

- (void)handleLogout {}

- (void)handleDeath {}

- (void)handleRevive {}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object
						change:(NSDictionary *)change context:(void *)context {       
    if ([keyPath isEqualToString:@"protagonistAnimal"]) {
        [[[BRSession sharedManager] protagonistAnimal] registerObserverToAllProperties:self];
        return;
    }    
    if ([keyPath isEqualToString:@"level"]) {
		shouldReload = YES;
		if ([[[BRAppDelegate sharedManager] tabManager] getSelectedViewController] == 
			[self navigationController]) {
			[self handleSelected];
		}
	} else if ([keyPath isEqualToString:@"respectPoints"]) {
		[self resetNumPointsText];
	}
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}


- (void)dealloc {
    offersWebView.delegate = nil;
    offersWebView.localDelegate = nil;
	
	if ([BRStoreKitPaymentManager sharedManager].productRequestDelegate == self) {
		[BRStoreKitPaymentManager sharedManager].productRequestDelegate = nil;
	}
	
	if ([BRStoreKitPaymentManager sharedManager].paymentDelegate == self) {
		[BRStoreKitPaymentManager sharedManager].paymentDelegate = nil;
	}
	
    [offersWebView release];
    [respectPointsOwnedLabel release];
    [super dealloc];
}


@end
