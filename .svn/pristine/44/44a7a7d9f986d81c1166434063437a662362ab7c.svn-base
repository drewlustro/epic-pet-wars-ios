/**
 * FacebookUser.h
 * Copyright Miraphonic, Inc 2009. All rights reserved.
 *
 * @author Amit Matani 
 * @created 02/12/09.
 */

#import <Foundation/Foundation.h>
#import "AbstractRestRequestedModel.h"

@class Animal;
@interface FacebookUser : AbstractRestRequestedModel {
    NSString *facebookUserId;
    NSString *name;  
    Animal *animal;
	BOOL inPosse, inviteSent, inviteReceived;
}

@property (nonatomic, copy) NSString *facebookUserId;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, retain) Animal *animal;
@property (nonatomic, assign) BOOL inPosse, inviteSent, inviteReceived;

@end
