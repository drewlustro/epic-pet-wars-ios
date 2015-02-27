/**
 * FacebookUser.m
 * Copyright Miraphonic, Inc 2009. All rights reserved.
 *
 * @author Amit Matani 
 * @created 02/12/09.
 */

#import "FacebookUser.h"
#import "Animal.h"

@implementation FacebookUser 
@synthesize facebookUserId, name, animal, inPosse, inviteSent, inviteReceived;

static NSDictionary *fieldMap;

+ (void)initialize {
    if (self = [FacebookUser class]) {
		fieldMap = [[NSDictionary alloc] initWithObjectsAndKeys:
		            @"setFacebookUserId:", @"id",
                    @"setName:", @"name",
                    @"setAnimalWithApiResponse:", @"animal",
					@"setInPosseWithString:", @"in_posse",
					@"setInviteSentWithString:", @"invite_sent",
					@"setInviteReceivedWithString:", @"invite_received",
                    nil
					];
	}
}

+ (NSDictionary *)GetFieldMapHelper {
    return fieldMap;
}

- (void)setAnimalWithApiResponse:(NSDictionary *)_value {
	Animal *temp = [[Animal alloc] initWithApiResponse:_value];
	self.animal = temp;
	[temp release];
}

- (void)setInPosseWithString:(NSString *)_value {
	self.inPosse = [_value isEqualToString:@"1"];
}

- (void)setInviteReceivedWithString:(NSString *)_value {
	self.inviteReceived = [_value isEqualToString:@"1"];
}

- (void)setInviteSentWithString:(NSString *)_value {
	self.inviteSent = [_value isEqualToString:@"1"];
}

- (void)dealloc {
    [facebookUserId release];
    [name release];
    [animal release];
    [super dealloc];
}


@end
