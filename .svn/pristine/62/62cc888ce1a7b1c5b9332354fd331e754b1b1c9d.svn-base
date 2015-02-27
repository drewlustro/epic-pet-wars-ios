//
//  BRStoreKitPaymentManager.h
//  battleroyale
//
//  Created by Amit Matani on 10/22/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>
#import "BRRestClient.h"

@protocol BRStoreKitPaymentManagerProductRequestDelegate, BRStoreKitPaymentManagerPaymentDelegate;

@interface BRStoreKitPaymentManager : NSObject <SKPaymentTransactionObserver, RestResponseDelegate, SKProductsRequestDelegate> {
	SKPaymentTransaction *_completingTransaction;
	BOOL _observing, _startedCompleting, _loadedProducts;
	NSMutableArray *_storedTransactions;
	NSArray *_products;
	SKProductsRequest *_productsRequest;
	BOOL _shouldWaitForProductRequest, _isMTXAllowed;
	NSString* promoProduct;
	id<BRStoreKitPaymentManagerProductRequestDelegate> _productRequestDelegate;
	id<BRStoreKitPaymentManagerPaymentDelegate> _paymentDelegate;
}

@property (nonatomic, copy) NSString* promoProduct;
@property (nonatomic, assign) BOOL shouldWaitForProductRequest;
@property (nonatomic, assign) id<BRStoreKitPaymentManagerProductRequestDelegate> productRequestDelegate;
@property (nonatomic, assign) id<BRStoreKitPaymentManagerPaymentDelegate> paymentDelegate;

+ (BRStoreKitPaymentManager *)sharedManager;
- (void)purchaseProductWithProductIndentifier:(NSString *)indentifier;
- (void)beginObserving;
+ (NSString *)encode:(const uint8_t *)input length:(NSInteger)length;
- (NSArray *)getProducts;
- (void)setProductIdentifiers:(NSSet *)identifiers;
- (BOOL)hasLoadedProducts;
- (void)decorateURLParamWithProducts:(NSMutableDictionary *)params;
- (void)startCreditingPurchases;


@end

@protocol BRStoreKitPaymentManagerProductRequestDelegate 

- (void)loadedProducts;

@optional

- (void)failedLoadingProducts;

@end

@protocol BRStoreKitPaymentManagerPaymentDelegate 

- (void)finishedPayment:(NSDictionary *)parsedResponse;

@optional

- (void)failedPayment;

@end
