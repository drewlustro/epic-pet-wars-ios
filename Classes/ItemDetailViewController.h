/**
 * ItemDetailViewController.h
 * Copyright Miraphonic, Inc 2009. All rights reserved.
 *
 * The ItemDetailViewController handles the detail view
 * of items.  It shows the items stats as well as
 * gives the ability to sell or buy the item in the store
 *
 * @author Amit Matani
 * @created 1/28/09
 */

#import "BRGlobal.h"

@class HUDViewController, Item, Notifier, AbstractRemoteDataTableController;
@interface ItemDetailViewController : MegaViewController {
    HUDViewController *hud;
    Item *item;
    UILabel *numOwnedLabel;
    UIButton *sellButton;
    AbstractRemoteDataTableController *containerTable;
    NSInteger numItemsPurchasingOrSelling;
}
@property (nonatomic, assign) AbstractRemoteDataTableController *containerTable;
@property (nonatomic, readonly) Item *item;

- (id)initWithItem:(Item *)_item;
- (void)setupLabelWithName:(NSString *)name andValue:(NSInteger)value withRect:(CGRect)rect;
- (void)setupLabelWithName:(NSString *)name andTextValue:(NSString *)value withRect:(CGRect)rect;
- (CGFloat)setupButtonsAtPoint:(CGPoint)point;

/** 
 * buyItem is called when the buy button is clicked.  It will put up a loading
 * screen and request to purchase the item from the server
 */
- (void)buyItemClicked;
- (void)buyItemWithAmount:(NSInteger)amount;

- (void)sellItemClicked;
- (void)sellItemWithAmount:(NSInteger)amount;

- (void)finishedPurchase:(NSNumber *)responseInt parsedResponse:(NSDictionary *)parsedResponse;
- (void)failedPurchase;
- (void)finishedSale:(NSNumber *)responseInt parsedResponse:(NSDictionary *)parsedResponse;
- (void)finishedPurchase:(NSNumber *)responseInt parsedResponse:(NSDictionary *)parsedResponse;
- (void)decrementNumOwned:(NSInteger)amount;
- (void)incrementNumOwned:(NSInteger)amount;
- (void)failedAction:(NSString *)message;
- (void)setupCashflowLabelWithValue:(NSInteger)value withRect:(CGRect)rect;

@end
