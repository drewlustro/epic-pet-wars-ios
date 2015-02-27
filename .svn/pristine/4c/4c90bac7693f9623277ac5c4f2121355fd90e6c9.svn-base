/**
 * HomeActionViewController.h
 * Copyright Miraphonic, Inc 2009. All rights reserved.
 *
 * HomeActionViewController is a tableHeaderView for the newsfeed table.
 * It is the main view of the home screen.  From it, users can perform 
 * single player actions and use items.
 *
 * @author Amit Matani
 * @created 1/14/09
 */

#import "BRGlobal.h"

@class RemoteImageViewWithFileStore, Item, AnimalAnimationUIView;
@interface HomeActionViewController : MegaViewController <ScrollableTabBarDelegate> {
    IBOutlet RemoteImageViewWithFileStore *animalImage, *backgroundImage;
    IBOutlet RemoteImageViewWithFileStore *armorImage;
    IBOutlet RemoteImageViewWithFileStore *weaponImage;
    IBOutlet RemoteImageViewWithFileStore *accessory1Image;            
    IBOutlet RemoteImageViewWithFileStore *accessory2Image;
    IBOutlet UIButton *petButton, *equipmentButton, *shopButton;
    IBOutlet AnimalAnimationUIView *animalAnimationUIView;
}

@property (nonatomic, retain) RemoteImageViewWithFileStore *animalImage, *backgroundImage;
@property (nonatomic, retain) RemoteImageViewWithFileStore *armorImage;
@property (nonatomic, retain) RemoteImageViewWithFileStore *weaponImage;
@property (nonatomic, retain) RemoteImageViewWithFileStore *accessory1Image;            
@property (nonatomic, retain) RemoteImageViewWithFileStore *accessory2Image;
@property (nonatomic, retain) UIButton *petButton, *equipmentButton, *shopButton;
@property (nonatomic, retain) AnimalAnimationUIView *animalAnimationUIView;

/**
 * update will update the view with the data in the session
 */
- (void)update;
- (void)displayActionFailed:(NSString *)title withMessage:(NSString *)message;
- (void)setImage:(RemoteImageViewWithFileStore *)image withItem:(Item *)item;
- (void)cleanup;

@end
