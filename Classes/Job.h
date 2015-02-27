//
//  Job.h
//  battleroyale
//
//  Created by Amit Matani on 1/30/09.
//  Copyright 2009 Miraphonic, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AbstractRestRequestedModel.h"

@interface Job : AbstractRestRequestedModel {
    NSString *jobId;
    NSString *name;
    NSString *details;
    NSInteger requiresLevel;
    NSInteger requiresEnergy;
    NSInteger requiresMoney;
	NSInteger requiresPosse;
    NSMutableArray *requiresItems;
    NSString *rewardExpFloor;
    NSString *rewardExpCeil;
    NSString *rewardMoneyFloor;
    NSString *rewardMoneyCeil;
    NSString *hasRewardItem;
    NSString *bossBotAnimalId;
    NSDictionary *requiredItemCounts;
	BOOL _requiresTwitter, _requiresFacebook;
}
@property (nonatomic, copy) NSString *jobId;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *details;
@property (nonatomic, assign) NSInteger requiresLevel;
@property (nonatomic, assign) NSInteger requiresEnergy;
@property (nonatomic, assign) NSInteger requiresMoney;
@property (nonatomic, assign) NSInteger requiresPosse;
@property (nonatomic, retain) NSMutableArray *requiresItems;
@property (nonatomic, copy) NSString *rewardExpFloor;
@property (nonatomic, copy) NSString *rewardExpCeil;
@property (nonatomic, copy) NSString *rewardMoneyFloor;
@property (nonatomic, copy) NSString *rewardMoneyCeil;
@property (nonatomic, copy) NSString *hasRewardItem;
@property (nonatomic, copy) NSString *bossBotAnimalId;
@property (nonatomic, retain) NSDictionary *requiredItemCounts;
@property (nonatomic, assign) BOOL requiresTwitter, requiresFacebook;

- (BOOL)doesJobHaveRewardItem;

@end
