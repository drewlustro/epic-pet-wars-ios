//
//  JobViewController.h
//  battleroyale
//
//  Created by Amit Matani on 1/30/09.
//  Copyright 2009 Miraphonic, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BasicTopLevelViewController.h"
#import "RDCContainerController.h"
#import "TwitterOAuthLinkerViewController.h"

@class HUDViewController, Job;

@protocol JobPerformer

- (void)attemptToDoJob:(Job *)job;

@end

typedef enum {
    ChosenAlertViewFacebookConnect,
	ChosenAlertViewTwitterConnect,
	ChosenAlertViewNone
} ChosenAlertView;

@interface JobViewController : BasicTopLevelViewController <JobPerformer, TwitterOAuthLinkerDelegate> {
    RDCContainerController *jobsTableContainer;
    BOOL newLogin;
	ChosenAlertView _chosenAlertView;
	Job *_attemptedJob;
}

@property (nonatomic, readonly) RDCContainerController *jobsTableContainer;

- (void)finishedDoingJob:(NSNumber *)responseCode 
        parsedResponse:(NSDictionary *)parsedResponse;
- (void)failedDoingJob;
- (void)failedDoingJobWithMessage:(NSString *)message;

@end
