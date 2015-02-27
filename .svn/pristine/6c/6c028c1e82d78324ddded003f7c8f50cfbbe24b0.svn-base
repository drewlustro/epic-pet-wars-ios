//
//  BRStoreKitPaymentManager.m
//  battleroyale
//
//  Created by Amit Matani on 10/22/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "BRStoreKitPaymentManager.h"
#import "Consts.h"
#import "BRAppDelegate.h"
#import "Utility.h"
#import "ActionResult.h"
#import "BRSession.h"
#import "ProtagonistAnimal.h"

#define HAS_NOT_LOADED_PRODUCT_REQUEST 1
#define HAS_LOADED_PRODUCT_REQUEST 2

@implementation BRStoreKitPaymentManager

@synthesize shouldWaitForProductRequest = _shouldWaitForProductRequest, 
productRequestDelegate = _productRequestDelegate, 
paymentDelegate = _paymentDelegate;

@synthesize promoProduct;
static BRStoreKitPaymentManager *sharedPaymentManager = nil;

+ (BRStoreKitPaymentManager *)sharedManager {
    @synchronized(self) {
        if (sharedPaymentManager == nil) {
            [[self alloc] init]; // assignment not done here
        }
    }
    return sharedPaymentManager;
}

+ (id)allocWithZone:(NSZone *)zone {
    @synchronized(self) {
        if (sharedPaymentManager == nil) {
            sharedPaymentManager = [super allocWithZone:zone];
            return sharedPaymentManager;  // assignment and return on first allocation
        }
    }
    return nil; //on subsequent allocation attempts return nil
}

- (id)init {
	if (self = [super init]) {
		_storedTransactions = [[NSMutableArray alloc] initWithCapacity:5];
		Class storeKitQueue = (NSClassFromString(@"SKPaymentQueue"));		
		_isMTXAllowed = storeKitQueue != nil;
	}
	return self;
}

- (void)beginObserving {
	if (_isMTXAllowed && !_observing) {
		_observing = YES;
		[[SKPaymentQueue defaultQueue] addTransactionObserver:self];		
	}
}

- (void)completeTransaction:(SKPaymentTransaction *)transaction {
	if (!_startedCompleting) {
		[_storedTransactions addObject:transaction];
		return;
	}
	[[BRAppDelegate sharedManager] hideLoadingOverlay];
	[[BRAppDelegate sharedManager] showLoadingOverlayWithText:@"Crediting Purchase"];
	
	[_completingTransaction release];
	_completingTransaction = [transaction retain];
	
	[[BRRestClient sharedManager] reward_redeemStoreKitOfferWithTransaction:transaction delegate:self];
}

- (void)restoreTransaction:(SKPaymentTransaction *)transaction {
    [self completeTransaction:transaction.originalTransaction];
}

- (void)startCreditingPurchases {
	if (_isMTXAllowed && !_startedCompleting) {
		_startedCompleting = YES;
		
		for (SKPaymentTransaction *transaction in _storedTransactions) { 
			[self completeTransaction:transaction];
		}
	}
}

- (void)setProductIdentifiers:(NSSet *)identifiers {
	if (_isMTXAllowed && _productsRequest == nil) {
		_productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:identifiers];
		_productsRequest.delegate = self;
		[_productsRequest start];
	}
}

- (void)purchaseProductWithProductIndentifier:(NSString *)indentifier {
	if (_isMTXAllowed) {
		// put up the screens that say connecting to apple etc here
		SKPayment *payment = [SKPayment paymentWithProductIdentifier:indentifier];
		[[SKPaymentQueue defaultQueue] addPayment:payment];
		[[BRAppDelegate sharedManager] showLoadingOverlayWithText:@"Connecting to iTunes"];
	}
}

- (void)failedTransaction:(SKPaymentTransaction *)transaction {
	[[BRAppDelegate sharedManager] hideLoadingOverlay];
	if (transaction.error.code != SKErrorPaymentCancelled) { 
		//		[Utility alertWithTitle:@"Error" message:transaction.error.localizedDescription];
	}
	
	[[SKPaymentQueue defaultQueue] finishTransaction: transaction];	
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
	[promoProduct release];
}

- (id)autorelease {   
    return self;
}

#pragma mark SKPaymentTransactionObserver methods
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions {
	for (SKPaymentTransaction *transaction in transactions) { 
		switch (transaction.transactionState) { 
			case SKPaymentTransactionStatePurchased: 
				[self completeTransaction:transaction];
				debug_NSLog(@"PURCHASED");
				break; 
			case SKPaymentTransactionStateFailed: 
				debug_NSLog(@"PAYMENT FAILED");
				[self failedTransaction:transaction]; 
				break; 
			case SKPaymentTransactionStateRestored: 
				debug_NSLog(@"RESTORED");				
				[self restoreTransaction:transaction]; 
				break;
			default: 
				break; 
        }
	}
}

- (BOOL)hasLoadedProducts {
	if (!_isMTXAllowed) {
		return YES;
	}
	return _loadedProducts;
}

- (NSArray *)getProducts {
	return _products;
}

- (void)decorateURLParamWithProducts:(NSMutableDictionary *)params {
	if ([self hasLoadedProducts]) {
		NSArray *products = [self getProducts];
		NSMutableArray *productIds = [[NSMutableArray alloc] initWithCapacity:[products count]];
		
		if (products) {
			for (SKProduct *product in products) {
				[productIds addObject:product.productIdentifier];
				
				[params setObject:product.localizedTitle forKey:[NSString stringWithFormat:@"sk_%@_title", product.productIdentifier]];
				[params setObject:product.localizedDescription forKey:[NSString stringWithFormat:@"sk_%@_description", product.productIdentifier]];
				
				NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
				[numberFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
				[numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
				[numberFormatter setLocale:product.priceLocale];
				NSString *formattedString = [numberFormatter stringFromNumber:product.price];
				
				[params setObject:formattedString forKey:[NSString stringWithFormat:@"sk_%@_price", product.productIdentifier]];
			}
			
			if (promoProduct != nil) {
				[params setObject:promoProduct forKey:@"promo_productID"];
			}
			[params setObject:[productIds componentsJoinedByString:@","] forKey:@"sk_products"];
			
		}
	}	
}

#pragma mark SKProductsRequestDelegate
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
	_products = [response.products retain];
	_loadedProducts = YES;
	[_productRequestDelegate loadedProducts];
}

#pragma mark RestResponseDelegate methods
- (void)cleanupTransaction {
	[_completingTransaction release];
	_completingTransaction = nil;
}

- (void)remoteMethodDidLoad:(NSString *)method responseCode:(RestResponseCode)responseCode parsedResponse:(NSDictionary *)parsedResponse {
	[[BRAppDelegate sharedManager] hideLoadingOverlay];	
	
	if (responseCode == RestResponseCodeSuccess) {
		ActionResult *actionResult = [[ActionResult alloc] initWithApiResponse:[parsedResponse objectForKey:@"action_result"]];
		[[[BRSession sharedManager] protagonistAnimal] updateWithActionResult:actionResult];
		
		[Utility alertWithTitle:@"Purchase Completed" message:actionResult.message];
		[_paymentDelegate finishedPayment:parsedResponse];
		
		[[SKPaymentQueue defaultQueue] finishTransaction:_completingTransaction];
	} else {
		[Utility alertWithTitle:@"Error" message:[parsedResponse objectForKey:@"response_message"]];
	}
	[self cleanupTransaction];
}

- (void)remoteMethodDidFail:(NSString *)method {
	[[BRAppDelegate sharedManager] hideLoadingOverlay];		
	[Utility alertWithTitle:@"Error" message:@"Unknown Error"];
	[self cleanupTransaction];
}

+ (NSString *)encode:(const uint8_t *)input length:(NSInteger)length {
    static char table[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
	
    NSMutableData *data = [NSMutableData dataWithLength:((length + 2) / 3) * 4];
    uint8_t *output = (uint8_t *)data.mutableBytes;
	
    for (NSInteger i = 0; i < length; i += 3) {
        NSInteger value = 0;
        for (NSInteger j = i; j < (i + 3); j++) {
			value <<= 8;
			
			if (j < length) {
				value |= (0xFF & input[j]);
			}
        }
		
        NSInteger index = (i / 3) * 4;
        output[index + 0] =                    table[(value >> 18) & 0x3F];
        output[index + 1] =                    table[(value >> 12) & 0x3F];
        output[index + 2] = (i + 1) < length ? table[(value >> 6)  & 0x3F] : '=';
        output[index + 3] = (i + 2) < length ? table[(value >> 0)  & 0x3F] : '=';
    }
	
    return [[[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding] autorelease];
}



@end
