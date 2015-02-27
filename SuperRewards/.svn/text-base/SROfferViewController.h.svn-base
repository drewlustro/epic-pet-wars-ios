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

@class SROffer;
@interface SROfferViewController : UIViewController {
    IBOutlet UILabel *name, *description, *payout, *requirements;
    SROffer *offer;
    NSString *currency;
    IBOutlet UIButton *completeOfferButton, *launchSafariButton, *emailLinkButton;
    IBOutlet UIImageView *typeImageView;
}

@property (nonatomic, retain) UILabel *name, *description, *payout, *requirements;
@property (nonatomic, retain) UIButton *completeOfferButton, *launchSafariButton, *emailLinkButton;
@property (nonatomic, retain) UIImageView *typeImageView;

- (id)initWithOffer:(SROffer *)offer currencyName:(NSString *)currencyName;

@end
