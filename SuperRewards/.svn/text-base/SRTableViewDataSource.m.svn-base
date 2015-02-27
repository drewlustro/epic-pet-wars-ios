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

#import "SRTableViewDataSource.h"
#import "SRStatusTableViewCell.h"
#import "SROfferTableViewCell.h"

#define SR_STATUS @"SRStatus"
#define SR_OFFER @"SROffer"

@implementation SRTableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        if ([offers count] == 0) { // cover up the whole area
            return tableView.frame.size.height;
        }
    } else if ([offers count] == indexPath.row) {
        return 80;
    }
    
    return 100;
}

#pragma mark UITableViewDataSource methods
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier = nil;
    if (indexPath.row == 0) {
        if ([offers count] == 0) {
            cellIdentifier = SR_STATUS;
        }
    } else if ([offers count] == indexPath.row) {
        cellIdentifier = SR_STATUS;
    }
    
    if (cellIdentifier == nil) {
        cellIdentifier = SR_OFFER;
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        if ([cellIdentifier isEqualToString:SR_STATUS]) {
            cell = [[[SRStatusTableViewCell alloc] initWithFrame:CGRectMake(0, 0, 0, 0) reuseIdentifier:cellIdentifier] autorelease];
        } else {
            cell = [self getOfferTableViewCellWithIdentifier:cellIdentifier];
        }
    }
    
    if ([cellIdentifier isEqualToString:SR_OFFER]) { 
		((SROfferTableViewCell *)cell).currency = self.currency;
        ((SROfferTableViewCell *)cell).offer = [offers objectAtIndex:indexPath.row];
    } else {
        // for convenience
        SRStatusTableViewCell *statusCell = (SRStatusTableViewCell *)cell;
        statusCell.loading = NO;
        if (isLoading) {
            statusCell.loading = YES;            
        } else if ([offers count] == 0) {
            if  (hasCompletedInitialLoad) { // didnt find anything
                
            } else if (errorLoading) { 
                
            }
        } else { // this is the loading screen at the bottom of hte page
            [statusCell setTitle:@"Load More Offers" subTitle:[NSString stringWithFormat:@"Viewing Page %d of %d", currentPage, numPages]];
        }
    }
    return cell;
}

- (SROfferTableViewCell *)getOfferTableViewCellWithIdentifier:(NSString *)cellIdentifier {
    return [[[SROfferTableViewCell alloc] initWithFrame:CGRectMake(0, 0, 0, 0) reuseIdentifier:cellIdentifier] autorelease];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([offers count] == 0) {
        return 1;
    } else if (currentPage < numPages - 1) {
        return [offers count] + 1;
    } else {
        return [offers count];
    }
}



@end
