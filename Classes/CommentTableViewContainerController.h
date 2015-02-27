/**
 * CommentTableViewContainerController.h
 * Copyright Miraphonic, Inc 2009. All rights reserved.
 *
 * @author Amit Matani 
 * @created 2/13/09.
 */


#import <UIKit/UIKit.h>
#import "RDCContainerController.h"

@interface CommentTableViewContainerController : RDCContainerController {
	NSString *_userId;
}

@property (readonly) NSString *userId;

- (id)initWithUserId:(NSString *)userId;
- (void)newComment;

@end
