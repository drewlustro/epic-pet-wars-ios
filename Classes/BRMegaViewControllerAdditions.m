//
//  BRUIViewControllerAdditions.m
//  battleroyale
//
//  Created by Amit Matani on 4/20/09.
//  Copyright 2009 Miraphonic, Inc. All rights reserved.
//

#import "BRMegaViewControllerAdditions.h"
#import "BRAppDelegate.h"

#define LOGO_TAG 500

@implementation MegaViewController (BRCategory)

- (void)styleNavigationBar {
    /** LOGO STYLED TOP NAVIGATION BAR **/
	UINavigationBar *navBar = self.navigationController.navigationBar;
	navBar.barStyle = UIBarStyleBlackOpaque;
    if ([navBar viewWithTag:LOGO_TAG] == nil) {
        UIImageView *topLogo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"navigation_bar_logo.png"]];
        topLogo.frame = CGRectMake(FRAME_WIDTH - TOP_BAR_LOGO_WIDTH, 0, TOP_BAR_LOGO_WIDTH, TOP_BAR_LOGO_HEIGHT);
        topLogo.tag = LOGO_TAG;
        [navBar addSubview: topLogo];
        [topLogo release];    
    }
}

- (void)showRightNavigationLogo:(BOOL)show {
	UINavigationBar *navBar = self.navigationController.navigationBar;
    [navBar viewWithTag:LOGO_TAG].hidden = !show;
}

- (BOOL)isShowingLogo {
	UINavigationBar *navBar = self.navigationController.navigationBar;
    UIView *logo = [navBar viewWithTag:LOGO_TAG];
    if (logo != nil) {
        return !logo.hidden;
    }
    return false;
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[BRAppDelegate sharedManager].currentlyActiveViewController = self;
    if (self.navigationItem != nil) {
        [self styleNavigationBar];        
        [self showRightNavigationLogo:self.navigationItem.rightBarButtonItem == nil];
    }
}

- (void)willDisplayFromNavigation {}

- (void)viewDidLoad {
    [self navigationController].delegate = self;
}

- (void)leftCloseButtonTapped {
	// Play Sound
    [self dismissTopMostModalViewControllerWithAnimationAndSound];
}

- (void)dismissTopMostModalViewControllerWithAnimationAndSound {
	[[SoundManager sharedManager] playSoundWithType:@"close" vibrate:NO];	
	[self dismissTopMostModalViewControllerWithAnimation];    
}

#pragma mark NavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController 
      willShowViewController:(UIViewController *)viewController 
                    animated:(BOOL)animated {
    if ([viewController isKindOfClass:[MegaViewController class]]) {
        MegaViewController *vc = (MegaViewController *)viewController;
        [vc willDisplayFromNavigation];
        navigationController.delegate = vc;
    }
}

- (void)showLoadingOverlayWithText:(NSString *)text {
    [[BRAppDelegate sharedManager] showLoadingOverlayWithText:text];
}

- (void)hideLoadingOverlay {
    [[BRAppDelegate sharedManager] hideLoadingOverlay];
}


@end