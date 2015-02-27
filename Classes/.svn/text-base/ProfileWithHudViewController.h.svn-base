/**
 * ProfileWithHudViewController.h
 * Copyright Miraphonic, Inc 2009. All rights reserved.
 *
 * @author Amit Matani 
 * @created 2/12/09.
 */


#import <UIKit/UIKit.h>
#import "AbstractRemoteDataController.h"
#import "RestOperation.h"

@class Animal, HUDViewController, ProfileViewController;
@interface ProfileWithHudViewController : AbstractRemoteDataController <RestResponseDelegate> {
	BOOL initialLoadRequired;
	Animal *animal;
	NSString *animalId;
	HUDViewController *hud;
	ProfileViewController *profileViewController;
    RestOperation *loadAnimalOperation;
}

- (void)doInitialSetup:(BOOL)loadRequired;
- (id)initWithAnimal:(Animal *)_animal;
- (id)initWithAnimalId:(NSString *)_animalId;
- (void)displayProfileView;
- (void)startBattle;
- (void)failedStartingBattle;
- (void)showAchievements;
- (void)showComments;
- (void)failedToStartBattle:(NSString *)message;
@end
