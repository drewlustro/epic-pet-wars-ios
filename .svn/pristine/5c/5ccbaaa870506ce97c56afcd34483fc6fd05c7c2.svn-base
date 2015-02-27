//
//  ItemAmountViewController.m
//  battleroyale
//
//  Created by Amit Matani on 3/24/09.
//  Copyright 2009 Miraphonic, Inc. All rights reserved.
//

#import "ItemAmountViewController.h"
#import "ItemDetailWebViewController.h"
#import "Item.h"
#import "RemoteImageViewWithFileStore.h"
#import "BRGlobal.h"

@implementation ItemAmountViewController
@synthesize itemDetailViewController, picker, owned, 
            itemImage, cancelButton;

// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil 
      itemDetailViewController:(ItemDetailWebViewController *)idvc {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        itemDetailViewController = idvc;
    }
    return self;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    UINavigationBar *navBar = self.navigationController.navigationBar;
	navBar.barStyle = UIBarStyleBlackOpaque;	
    
    Item *item = itemDetailViewController.item;
    [itemImage loadImageWithUrl:item.imageSquare100];
    
    [cancelButton addTarget:self action:@selector(cancelButtonClicked) forControlEvents:UIControlEventTouchUpInside];    
    
    picker.delegate = self;
    picker.dataSource = self;
    
    owned.text = [NSString stringWithFormat:@"%d", item.numOwned];
	[[SoundManager sharedManager] playSoundWithType:@"popup" vibrate:NO];
}

- (void)cancelButtonClicked {		
	[self dismissTopMostModalViewControllerWithAnimationAndSound];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return 200;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return 1;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}


- (void)dealloc {
    [picker release];
    [owned release];
    [itemImage release];
    [cancelButton release];
    
    [super dealloc];
}


@end
