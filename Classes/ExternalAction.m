/**
 * ExternalAction.m
 * Copyright Miraphonic, Inc 2009. All rights reserved.
 *
 * @author Amit Matani 
 * @created 03/05/09.
 */

#import "ExternalAction.h"


@implementation ExternalAction 
@synthesize externalActionId, animalId, actorAnimalId, explanation, content, hp, respectPoints, posseSize, mood, achievements, achievementId, processed, newsfeedTemplateId, created;

static NSDictionary *fieldMap;

+ (void)initialize {
    if (self = [ExternalAction class]) {
		fieldMap = [[NSDictionary alloc] initWithObjectsAndKeys:
		            @"setExternalActionId:", @"id",
                    @"setAnimalId:", @"animal_id",
                    @"setActorAnimalId:", @"actor_animal_id",
                    @"setExplanation:", @"explanation",
                    @"setContent:", @"content",
                    @"setHp:", @"hp",
                    @"setRespectPoints:", @"respect_points",
                    @"setPosseSize:", @"posse_size",
                    @"setMood:", @"mood",
                    @"setAchievements:", @"achievements",
                    @"setAchievementId:", @"achievement_id",
                    @"setProcessed:", @"processed",
                    @"setNewsfeedTemplateId:", @"newsfeed_template_id",
                    @"setCreated:", @"created",
                    nil
					];
	}
}

+ (NSDictionary *)GetFieldMapHelper {
    return fieldMap;
}

- (void)dealloc {
    [externalActionId release];
    [animalId release];
    [actorAnimalId release];
    [explanation release];
    [content release];
    [hp release];
    [respectPoints release];
    [posseSize release];
    [mood release];
    [achievements release];
    [achievementId release];
    [processed release];
    [newsfeedTemplateId release];
    [created release];
    [super dealloc];
}


@end
