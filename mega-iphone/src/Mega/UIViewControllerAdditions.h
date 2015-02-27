//
//  UIViewControllerAdditions.h
//  mega framework
//
//  Created by Amit Matani on 4/19/09.
//  Copyright 2009 Miraphonic, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RDCContainerController, AbstractRemoteDataController;
@interface UIViewController (MegaCategory)

- (void)alertWithTitle:(NSString *)title message:(NSString *)message;
- (void)alertWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate;
- (void)alertWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate 
       cancelButtonTitle:(NSString *)cancelButtonTitle 
       otherButtonTitle:(NSString *)otherButtonTitle;

- (void)dismissTopMostModalViewControllerWithAnimation;
- (void)addLeftCloseButton;
- (void)leftCloseButtonTapped;

- (void)presentModalViewControllerWithNavigationBar:(UIViewController *)viewController;
- (void)presentModalRDCContainerController:(RDCContainerController *)rdc;
- (void)presentModalRDTController:(AbstractRemoteDataController *)rdt;


@end
