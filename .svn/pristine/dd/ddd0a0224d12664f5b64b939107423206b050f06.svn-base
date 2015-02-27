/**
 * ProfileViewController.h
 * Copyright Miraphonic, Inc 2009. All rights reserved.
 *
 * @author Amit Matani 
 * @created 2/12/09.
 */


#import "Mega/Mega.h"

@class Animal, RemoteImageViewWithFileStore, ProfileWithHudViewController;
@interface ProfileViewController : MegaViewController {
	Animal *animal;
	IBOutlet RemoteImageViewWithFileStore *animalImage, *armorImage, *weaponImage, *accessory1Image, *accessory2Image, *backgroundView;
	IBOutlet UIButton *attackButton, *commentButton, *achievementButton;
	ProfileWithHudViewController *parentController;
    IBOutlet UILabel *posseSize, *wins, *losses, *ranAway, *passiveWins, *passiveLosses, *level, *achievements, *rank;
}

@property (nonatomic, assign) ProfileWithHudViewController *parentController;
@property (nonatomic, retain) RemoteImageViewWithFileStore *animalImage, *armorImage, *weaponImage, *accessory1Image, *accessory2Image, *backgroundView;
@property (nonatomic, retain) UIButton *attackButton, *commentButton, *achievementButton;
@property (nonatomic, retain) UILabel *posseSize, *wins, *losses, *ranAway, *passiveWins, *passiveLosses, *level, *achievements, *rank;

- (id)initWithAnimal:(Animal *)animal;
- (void)achievementButtonClicked;
- (void)commentButtonClicked;

@end
