//
//  BRUIViewControllerAdditions.h
//  battleroyale
//
//  Created by Amit Matani on 4/20/09.
//  Copyright 2009 Miraphonic, Inc. All rights reserved.
//

#import "Mega/Mega.h"

@interface MegaViewController (BRCategory) <UINavigationControllerDelegate>

- (void)styleNavigationBar;
- (void)showRightNavigationLogo:(BOOL)show;
- (BOOL)isShowingLogo;
- (void)showLoadingOverlayWithText:(NSString *)text;
- (void)hideLoadingOverlay;
- (void)dismissTopMostModalViewControllerWithAnimationAndSound;

@end
