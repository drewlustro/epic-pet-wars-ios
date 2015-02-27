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


@interface SRStatusTableViewCell : UITableViewCell {
    BOOL loading;
    UIActivityIndicatorView *loadingIndicatorView;
    UILabel *statusTitle, *statusSubtitle;
}

@property (nonatomic, assign) BOOL loading;

- (void)setTitle:(NSString *)_title subTitle:(NSString *)_subTitle;

@end
