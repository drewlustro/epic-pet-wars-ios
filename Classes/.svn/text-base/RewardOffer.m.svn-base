/**
 * RewardOffer.m
 * Copyright Miraphonic, Inc 2009. All rights reserved.
 *
 * @author Amit Matani 
 * @created 2/3/09.
 */

#import "RewardOffer.h"


@implementation RewardOffer

@synthesize rewardId, name, expires, numAvailable, numSold, cost, bonusText, bonusTextIphone;
static NSDictionary *fieldMap;

+ (void)initialize {
    if (self = [RewardOffer class]) {
		fieldMap = [[NSDictionary alloc] initWithObjectsAndKeys:
					@"setRewardId:", @"id",
					@"setName:", @"name",
					@"setExpires:", @"expires",
					@"setNumAvailable:", @"num_available",
					@"setNumSold:", @"num_sold",
					@"setCost:", @"cost",
					@"setBonusText:", @"bonus_text",
					@"setBonusTextIphone:", @"bonus_text_iphone",
					nil
					];
	}
}

+ (NSDictionary *)GetFieldMapHelper {
    return fieldMap;
}

- (void)dealloc {
	[rewardId release];
	[name release];
	[expires release];
	[numAvailable release];
	[numSold release];
	[cost release];
	[bonusText release];
	[bonusTextIphone release];
    [super dealloc];
}
@end
