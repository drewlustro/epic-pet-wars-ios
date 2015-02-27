
//
//  JobTableViewCell.h
//  battleroyale
//
//  Created by Amit Matani on 1/30/09.
//  Copyright 2009 Miraphonic, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ABTableViewCell.h"
#import "JobViewController.h"

@class Job;
@interface JobTableViewCell : ABTableViewCell {
    id<JobPerformer> doJobDelegate;
    Job *job;
    NSMutableArray *itemImages;
}

@property (nonatomic, retain) Job *job;
@property (nonatomic, assign) id<JobPerformer> doJobDelegate;

@end
