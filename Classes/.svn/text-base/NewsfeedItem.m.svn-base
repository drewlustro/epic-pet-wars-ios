/**
 * NewsfeedItem.m
 * Copyright Miraphonic, Inc 2009. All rights reserved.
 *
 * @author Amit Matani 
 * @created 02/16/09.
 */

#import "NewsfeedItem.h"


@implementation NewsfeedItem 
@synthesize newsfeedItemId, actorUid, actorAnimalId, targetUid, targetAnimalId, title, content, pictureUrl, type;

static NSDictionary *fieldMap;

+ (void)initialize {
    if (self = [NewsfeedItem class]) {
		fieldMap = [[NSDictionary alloc] initWithObjectsAndKeys:
		            @"setNewsfeedItemId:", @"id",
                    @"setActorUid:", @"actor_uid",
                    @"setActorAnimalId:", @"actor_animal_id",
                    @"setTargetUid:", @"target_uid",
                    @"setTargetAnimalId:", @"target_animal_id",
                    @"setTitle:", @"title",
                    @"setContent:", @"content",					
                    @"setPictureUrl:", @"iphone_image",
                    @"setType:", @"type",
                    nil
					];
	}
}

+ (NSDictionary *)GetFieldMapHelper {
    return fieldMap;
}

- (BOOL)hasImage {
	return (self.pictureUrl != nil && ![self.pictureUrl isEqualToString:@""]);
}

- (BOOL)hasAnimalActor {
	return (self.actorAnimalId != nil && ![self.actorAnimalId isEqualToString:@""] && ![self.actorAnimalId isEqualToString:@"0"]);	
}

- (void)dealloc {
    [newsfeedItemId release];
    [actorUid release];
    [actorAnimalId release];
    [targetUid release];
    [targetAnimalId release];
    [title release];
	[content release];
    [pictureUrl release];
    [type release];
    [super dealloc];
}


@end
