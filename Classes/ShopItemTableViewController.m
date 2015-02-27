/**
 * ShopItemTableViewController.m
 * Copyright Miraphonic, Inc 2009. All rights reserved.
 *
 * @author Amit Matani 
 * @created 3/22/09.
 */

#import "ShopItemTableViewController.h"
#import "ShopItemTableViewCell.h"
#import "ShopItemRemoteCollection.h"
#import "Consts.h"
#import "BRSession.h"
#import "EquipmentSet.h"
#import "TableViewWithInnerScrollView.h"
#import "BRRestClient.h"

@implementation ShopItemTableViewController
- (id)init {
    if (self = [super initWithEquipmentSet:(EquipmentSet *)[[BRSession sharedManager] shopItems] withInitialSource:[[[BRSession sharedManager] shopItems] useable]]) {

    }
    return self;
}


- (UITableViewCell *)tableviewCellWithReuseIdentifier:(NSString *)identifier {
    return [[[ShopItemTableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:identifier] autorelease];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}

- (NSString *)noneAvailableString {
    return [NSString stringWithFormat:@"There are currently no %@ items in the shop.  Check back later once your pet levels up.", 
            ((ItemRemoteCollection *)dataSource).category];
}

- (void)dealloc {
    [super dealloc];
}


@end
