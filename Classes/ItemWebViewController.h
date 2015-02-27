//
//  ItemWebViewController.h
//  battleroyale
//
//  Created by Amit Matani on 1/6/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "BRWebViewController.h"

@class Item;
@interface ItemWebViewController : BRWebViewController {
	Item *_item;
}

- (id)initWithItem:(Item *)item;
- (void)reloadLocalData;

@end
