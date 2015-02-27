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
#import "SRABTableViewCell.h"

@class SROffer;
@interface SROfferTableViewCell : SRABTableViewCell {
    SROffer *offer;
    NSString *currency;
}

@property (nonatomic, retain) SROffer *offer;
@property (nonatomic, copy) NSString *currency;

@end