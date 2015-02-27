/**
 * Post.m
 * Copyright Miraphonic, Inc 2009. All rights reserved.
 *
 * @author Amit Matani 
 * @created 02/13/09.
 */

#import "Post.h"


@implementation Post 
@synthesize commentId, senderUid, senderAnimalId, senderName, receiverUid, text, created;

static NSDictionary *fieldMap;

+ (void)initialize {
    if (self = [Post class]) {
		fieldMap = [[NSDictionary alloc] initWithObjectsAndKeys:
		            @"setCommentId:", @"id",
                    @"setSenderUid:", @"sender_uid",
                    @"setSenderAnimalId:", @"sender_animal_id",
                    @"setSenderName:", @"sender_name",
                    @"setReceiverUid:", @"receiver_uid",
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
    [commentId release];
    [senderUid release];
    [senderAnimalId release];
    [senderName release];
    [receiverUid release];
    [text release];
    [created release];
    [super dealloc];
}


@end
