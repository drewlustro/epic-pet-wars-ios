/**
 * EarnedAchievementRemoteCollection.h
 * Copyright Miraphonic, Inc 2009. All rights reserved.
 *
 * @author Amit Matani 
 * @created 2/5/09.
 */

#import <Foundation/Foundation.h>
#import "AchievementRemoteCollection.h"

@interface EarnedAchievementRemoteCollection : AchievementRemoteCollection {
	NSString *animalId;
}
- (id)initWithAnimalId:(NSString *)_animalId;

@end
