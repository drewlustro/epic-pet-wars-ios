/**
 * ItemTableViewController.h
 * Copyright Miraphonic, Inc 2009. All rights reserved.
 *
 * @author Amit Matani 
 * @created 3/22/09.
 */


#import <UIKit/UIKit.h>
#import "AbstractRemoteDataTableControllerWithTabs.h"


@class ItemTableViewContainerController, ShopItemRemoteCollection, EquipmentSet, ItemRemoteCollection, LoadingUIWebView, MutableEquipmentSet;
@interface ItemTableViewController : AbstractRemoteDataTableControllerWithTabs {
    ItemTableViewContainerController *itemTableContainerController;
    LoadingUIWebView *_headerWebView;
}

@property (nonatomic, assign) ItemTableViewContainerController *itemTableContainerController;


- (id)initWithEquipmentSet:(MutableEquipmentSet *)_equipmentSet withInitialSource:(ItemRemoteCollection *)initialDataSource;


@end
