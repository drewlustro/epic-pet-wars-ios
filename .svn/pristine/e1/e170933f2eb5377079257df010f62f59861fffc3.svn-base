//
//  BattleMasterViewController.h
//  battleroyale
//
//  Created by Amit Matani on 4/12/09.
//  Copyright 2009 Miraphonic, Inc. All rights reserved.
//

#import "BRGlobal.h"
#import "LoadingUIWebViewWithLocalRequest.h"
#import "TopLevelController.h"
#import "BRStoreKitPaymentManager.h"

@interface BattleMasterViewController : MegaViewController <TopLevelController, LoadingUIWebViewWithLocalRequestDelegate, BRStoreKitPaymentManagerProductRequestDelegate, BRStoreKitPaymentManagerPaymentDelegate> {
    IBOutlet UILabel *respectPointsOwnedLabel;
    IBOutlet LoadingUIWebViewWithLocalRequest *offersWebView;
    BOOL shouldReload;
}

@property (nonatomic, retain) UILabel *respectPointsOwnedLabel;
@property (nonatomic, retain) LoadingUIWebViewWithLocalRequest *offersWebView;
@property (nonatomic, assign) BOOL shouldReload;

- (void)loadOfferData;
- (void)failedRedeeming;
- (void)redeemOffer:(NSString *)offerId;

@end
