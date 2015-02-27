/**
 * Invite.m
 * Copyright Miraphonic, Inc 2009. All rights reserved.
 *
 * @author Amit Matani 
 * @created 02/07/09.
 */

#import "Invite.h"
#import "Animal.h"

@implementation Invite 
@synthesize inviteId, inviterUid, inviteeUid, inviterAnimal, source, viewed, created;

static NSDictionary *fieldMap;

+ (void)initialize {
    if (self = [Invite class]) {
		fieldMap = [[NSDictionary alloc] initWithObjectsAndKeys:
		            @"setInviteId:", @"id",
                    @"setInviterUid:", @"inviter_uid",
                    @"setInviterAnimalWithApiResponse:", @"inviter_animal",					
                    @"setInviteeUid:", @"invitee_uid",
                    @"setSource:", @"source",
                    @"setViewed:", @"viewed",
                    @"setCreated:", @"created",
                    nil
					];
	}
}

+ (NSDictionary *)GetFieldMapHelper {
    return fieldMap;
}

- (void)setInviterAnimalWithApiResponse:(NSDictionary *)_value {
	Animal *animalTemp = [[Animal alloc] initWithApiResponse:_value];
	self.inviterAnimal = animalTemp;
	[animalTemp release];
}

- (void)dealloc {
    [inviteId release];
    [inviterUid release];
    [inviteeUid release];
    [inviterAnimal release];
    [source release];
    [viewed release];
    [created release];
    [super dealloc];
}


@end
