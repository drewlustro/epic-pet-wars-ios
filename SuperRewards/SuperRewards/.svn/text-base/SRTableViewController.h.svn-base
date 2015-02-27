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
#import "SuperRewards/SRDataSource.h"

@class SRTableViewDataSource, SROfferViewController, SROffer;


@interface SRTableViewController : UIViewController <UITableViewDelegate, SRDataSourceDelegate> {
    UITableView *myTableView;
    SRTableViewDataSource *dataSource;
    
    NSArray *dataSources, *titles;
    UIScrollView *tabsContainer;
    NSInteger selectedIndex;
    UIButton *selectedButton;
    UIView *leftScrollOverlay, *rightScrollOverlay;
    
    NSString *problemsUrl;
}

@property (nonatomic, retain) UITableView *myTableView;

- (id)initWithGameId:(NSString *)_gameId userId:(NSString *)_userId mode:(SRMode)_mode 
       offersPerPage:(NSInteger)_offersPerPage;
- (SROfferViewController *)getOfferViewController:(SROffer *)offer currency:(NSString *)currency;

@end
