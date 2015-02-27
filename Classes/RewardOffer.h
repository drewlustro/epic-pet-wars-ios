/**
 * RewardOffer.h
 * Copyright Miraphonic, Inc 2009. All rights reserved.
 *
 * @author Amit Matani 
 * @created 2/3/09.
 */

#import <Foundation/Foundation.h>
#import "AbstractRestRequestedModel.h"

@interface RewardOffer : AbstractRestRequestedModel {	
    NSString *rewardId;
	NSString *name;
    NSString *expires;
    NSString *numAvailable;
    NSString *numSold;
    NSString *cost;
    NSString *bonusText;
	NSString *bonusTextIphone;
}

@property (nonatomic, copy) NSString *rewardId;
@property (nonatomic, copy) NSString *expires;
@property (nonatomic, copy) NSString *numAvailable;
@property (nonatomic, copy) NSString *numSold;
@property (nonatomic, copy) NSString *cost;
@property (nonatomic, copy) NSString *bonusText, *bonusTextIphone;
@property (nonatomic, copy) NSString *name;

@end
