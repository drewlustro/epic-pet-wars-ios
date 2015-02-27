/**
 * NewAnimalSetupViewController.h
 * Copyright Miraphonic, Inc 2009. All rights reserved.
 *
 * @author Amit Matani 
 * @created 2/5/09.
 */


#import "MegaViewController.h"

@class AnimalType, RemoteImageViewWithFileStore;
@interface NewAnimalSetupViewController : MegaViewController <UITextFieldDelegate> {
	IBOutlet AnimalType *animalType;
	IBOutlet UITextField *petName;
	IBOutlet UIButton *createAnimalButton;
    IBOutlet RemoteImageViewWithFileStore *animalImageView;	
    IBOutlet UIScrollView *myScrollView;
	
	BOOL isNewAccount;
}

@property (nonatomic, retain) AnimalType *animalType;
@property (nonatomic, retain) UITextField *petName;
@property (nonatomic, retain) UIButton *createAnimalButton;
@property (nonatomic, retain) RemoteImageViewWithFileStore *animalImageView;	
@property (nonatomic, retain) UIScrollView *myScrollView;

- (void)newAnimalFailed;
- (void)displayFailedAccountCreation:(NSString *)message;
- (void)enableInputs:(BOOL)shouldEnable;

@end
