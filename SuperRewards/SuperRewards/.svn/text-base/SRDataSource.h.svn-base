/*
 * Copyright 2009 Miraphonic
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 *    http://www.apache.org/licenses/LICENSE-2.0
 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#import "SuperRewards/SRGlobal.h"

typedef enum {
    SRModeAll = 0,
    SRModeFree = 1,
    SRModePaid = 2,
    SRModeMobile = 3
} SRMode;

@class SROffer;
@protocol SRDataSourceDelegate;

@interface SRDataSource : NSObject {
    id<SRDataSourceDelegate> delegate;
    NSString *gameId;
    NSString *userId;
    SRMode mode;
    NSInteger offersPerPage;
    NSString *modeString;    
    
    NSInteger numPages;
    NSString *currency;
    NSString *problemsUrl;
    
    NSMutableArray *offers;
    
    NSInteger currentPage;
    
    // xml required items
    NSXMLParser *myParser;
    
    SROffer *activeOffer;
    
    NSMutableString *contentsOfCurrentElement;
    NSString *currentElementName;
    
    BOOL isLoading, hasCompletedInitialLoad, errorLoading;
}

@property (nonatomic, assign) id<SRDataSourceDelegate> delegate;
@property (nonatomic, readonly) SRMode mode;
@property (nonatomic, readonly) NSInteger offersPerPage;
@property (nonatomic, readonly) NSMutableArray *offers;
@property (nonatomic, readonly) BOOL isLoading, hasCompletedInitialLoad;
@property (nonatomic, readonly) NSInteger numPages;
@property (nonatomic, readonly) NSString *currency;
@property (nonatomic, readonly) NSString *problemsUrl;

- (id)initWithGameId:(NSString *)_gameId userId:(NSString *)_userId mode:(SRMode)_mode offersPerPage:(NSInteger)_offersPerPage;
- (void)loadNextPage;

@end

@protocol SRDataSourceDelegate <NSObject>

@optional
- (void)offersFinishedLoadingFromDataSource:(SRDataSource *)dataSource;
- (void)offersFailedLoadingFromDataSource:(SRDataSource *)dataSource;

@end
