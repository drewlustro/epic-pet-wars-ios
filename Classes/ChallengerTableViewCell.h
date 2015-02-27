/**
 * ChallengerTableViewCell.h
 * Copyright Miraphonic, Inc 2009. All rights reserved.
 *
 * @author Amit Matani 
 * @created 2/1/09.
 */

#import <UIKit/UIKit.h>
#import "ABTableViewCell.h"
#import "Challenger.h"
#import "BattleListViewController.h"

@interface ChallengerTableViewCell : ABTableViewCell {
	Challenger *challenger;
	UIImage *animalImage, *weaponImage, *armorImage, *accessory1Image, *accessory2Image;
	id<BattleManager> battleDelegate;
}

@property (nonatomic, retain) Challenger *challenger;
@property (nonatomic, retain) UIImage *animalImage, *weaponImage, *armorImage, *accessory1Image, *accessory2Image;
@property (nonatomic, assign) id<BattleManager> battleDelegate;


- (void)setAnimalImage:(UIImage *)_value withUrl:(NSString *)url;
- (void)setWeaponImage:(UIImage *)_value withUrl:(NSString *)url;
- (void)setArmorImage:(UIImage *)_value withUrl:(NSString *)url;
- (void)setAccessory1Image:(UIImage *)_value withUrl:(NSString *)url;
- (void)setAccessory2Image:(UIImage *)_value withUrl:(NSString *)url;
- (void)postImageLoad;

@end
