/**
 * Bulletin.h
 * Copyright Miraphonic, Inc 2009. All rights reserved.
 *
 * @author Amit Matani 
 * @created 04/29/09.
 */

#import <Foundation/Foundation.h>
#import "AbstractRestRequestedModel.h"

@interface Bulletin : AbstractRestRequestedModel {
    NSString *bulletinId;  
    NSString *senderUid;  
    NSString *senderName;  
    NSString *senderAnimalId;  
    NSString *text;  
    NSString *created;  
}

@property (nonatomic, copy) NSString *bulletinId;
@property (nonatomic, copy) NSString *senderUid;
@property (nonatomic, copy) NSString *senderName;
@property (nonatomic, copy) NSString *senderAnimalId;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy) NSString *created;

@end
