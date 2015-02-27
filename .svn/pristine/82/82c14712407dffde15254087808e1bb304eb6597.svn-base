/**
 * AnimalTypeDetailViewController.h
 * Copyright Miraphonic, Inc 2009. All rights reserved.
 *
 * AnimalTypeDetailViewController displays a detail view of the animaltype 
 * the user selected in the AnimalTypeSelectionController table.  The 
 * AnimalTypeSelectionController passes over the AnimalType object and
 * it is displayed in greater detail than could be possible on a table cell.
 * The user can decide to use this animal or go back.  If the user decides to
 * use the current animal it moves forward on the account creation
 *
 * @author Amit Matani
 * @created 1/15/09
 */

#import "BRGlobal.h"

@class AnimalType, RemoteImageViewWithFileStore;
@interface AnimalTypeDetailViewController : MegaViewController {
    UIScrollView *myScrollView;
    AnimalType *animalType;
    RemoteImageViewWithFileStore *animalImageView;
    UIButton *acceptPetButton;
}

/**
 * initWithAnimalType inits the object while saving the animalType
 * @param AnimalType *_animalType
 * @return id - the newly created object
 */
- (id)initWithAnimalType:(AnimalType *)_animalType;
- (void)showNewAnimalSetup;
- (CGPoint)setupKeyValueAtPoint:(CGPoint)p key:(NSString *)keyString value:(NSString *)valueString;

@end
