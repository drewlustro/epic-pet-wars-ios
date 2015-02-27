/**
 * Invite.h
 * Copyright Miraphonic, Inc 2009. All rights reserved.
 *
 * @author Amit Matani 
 * @created 02/07/09.
 */

#import <Foundation/Foundation.h>
#import "AbstractRestRequestedModel.h"

@class Animal;
@interface Invite : AbstractRestRequestedModel {
    NSString *inviteId;
    NSString *inviterUid;  
    NSString *inviteeUid;  
    Animal *inviterAnimal;  
    NSString *source;  
    NSString *viewed;  
    NSString *created;  
}

@property (nonatomic, copy) NSString *inviteId;
@property (nonatomic, copy) NSString *inviterUid;
@property (nonatomic, copy) NSString *inviteeUid;
@property (nonatomic, retain) Animal *inviterAnimal;
@property (nonatomic, copy) NSString *source;
@property (nonatomic, copy) NSString *viewed;
@property (nonatomic, copy) NSString *created;

@end
