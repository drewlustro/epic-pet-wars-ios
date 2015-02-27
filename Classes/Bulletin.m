/**
 * Bulletin.m
 * Copyright Miraphonic, Inc 2009. All rights reserved.
 *
 * @author Amit Matani 
 * @created 04/29/09.
 */

#import "Bulletin.h"


@implementation Bulletin 
@synthesize bulletinId, senderUid, senderName, senderAnimalId, text, created;

static NSDictionary *fieldMap;

+ (void)initialize {
    if (self = [Bulletin class]) {
		fieldMap = [[NSDictionary alloc] initWithObjectsAndKeys:
		            @"setBulletinId:", @"id",
                    @"setBulletinId:", @"bulletin_id",
                    @"setSenderUid:", @"sender_uid",
                    @"setSenderName:", @"sender_name",
                    @"setSenderAnimalId:", @"sender_animal_id",
                    @"setText:", @"text",
                    @"setCreated:", @"created",
                    nil
					];
	}
}

+ (NSDictionary *)GetFieldMapHelper {
    return fieldMap;
}

- (void)dealloc {
    [bulletinId release];
    [senderUid release];
    [senderName release];
    [senderAnimalId release];
    [text release];
    [created release];
    [super dealloc];
}


@end
