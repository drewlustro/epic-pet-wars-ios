//
//  UIViewControllerAdditions.m
//  mega framework
//
//  Created by Amit Matani on 4/19/09.
//  Copyright 2009 Miraphonic, Inc. All rights reserved.
//

#import "Mega/MegaGlobal.h"

#import "Mega/RDCContainerController.h"
#import "Mega/AbstractRemoteDataController.h"


@implementation UIViewController (MegaCategory)

- (void)alertWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate 
     cancelButtonTitle:(NSString *)cancelButtonTitle 
      otherButtonTitle:(NSString *)otherButtonTitle {
    UIAlertView *alertView = 
        [[UIAlertView alloc] initWithTitle:title message:message 
                                  delegate:delegate cancelButtonTitle:cancelButtonTitle 
                         otherButtonTitles:otherButtonTitle, nil];
    [alertView show];
    [alertView release];
}

- (void)alertWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate {
    [self alertWithTitle:title message:message delegate:delegate cancelButtonTitle:@"Ok" otherButtonTitle:nil];
}

- (void)alertWithTitle:(NSString *)title message:(NSString *)message {
    [self alertWithTitle:title message:message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitle:nil];    
}

- (void)dismissTopMostModalViewControllerWithAnimation {
    [self dismissModalViewControllerAnimated:YES];
}

- (void)addLeftCloseButton {
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:@"Close"
																   style:UIBarButtonItemStylePlain
																  target:self 
																  action:@selector(leftCloseButtonTapped)];
    self.navigationItem.leftBarButtonItem = leftButton;
	[leftButton release];
}

- (void)leftCloseButtonTapped {
	[self dismissTopMostModalViewControllerWithAnimation];
}

- (void)presentModalViewControllerWithNavigationBar:(UIViewController *)viewController {
	UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:viewController];    
    [self presentModalViewController:nav animated:YES];     
    if (viewController.navigationItem.leftBarButtonItem == nil) {
        [viewController addLeftCloseButton];
    }
    [nav release];
}

- (void)presentModalRDCContainerController:(RDCContainerController *)rdc {
    [self presentModalViewControllerWithNavigationBar:rdc];
    [rdc setViewFrame:CGRectMake(0, 0, FRAME_WIDTH, FRAME_HEIGHT_WITH_NAVIGATION_BAR)];
}

- (void)presentModalRDTController:(AbstractRemoteDataController *)rdt {
    RDCContainerController *container = [[RDCContainerController alloc] initWithRemoteDataController:rdt];
    [self presentModalRDCContainerController:container];
    [container release];
}




@end
