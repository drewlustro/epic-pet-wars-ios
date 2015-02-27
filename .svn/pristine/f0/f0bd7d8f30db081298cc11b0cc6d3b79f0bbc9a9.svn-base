/**
 * NewsfeedItem.h
 * Copyright Miraphonic, Inc 2009. All rights reserved.
 *
 * @author Amit Matani 
 * @created 02/16/09.
 */

#import <Foundation/Foundation.h>
#import "AbstractRestRequestedModel.h"

@interface NewsfeedItem : AbstractRestRequestedModel {
    NSString *newsfeedItemId;
    NSString *actorUid;  
    NSString *actorAnimalId;  
    NSString *targetUid;  
    NSString *targetAnimalId;  
    NSString *title;
	NSString *content;
    NSString *pictureUrl;  
    NSString *type;  
}

@property (nonatomic, copy) NSString *newsfeedItemId;
@property (nonatomic, copy) NSString *actorUid;
@property (nonatomic, copy) NSString *actorAnimalId;
@property (nonatomic, copy) NSString *targetUid;
@property (nonatomic, copy) NSString *targetAnimalId;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *pictureUrl;
@property (nonatomic, copy) NSString *type;

- (BOOL)hasImage;
- (BOOL)hasAnimalActor;

@end
