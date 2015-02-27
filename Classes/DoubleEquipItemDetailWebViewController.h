//
//  DoubleEquipItemDetailWebViewController.h
//  battleroyale
//
//  Created by Amit Matani on 1/8/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ItemDetailWebViewController.h"


@interface DoubleEquipItemDetailWebViewController : ItemDetailWebViewController {
    UIButton *_equipButton0, *_equipButton1;
}
- (void)equipItem:(id)sender;
- (void)unequipItem:(id)sender;

@end
