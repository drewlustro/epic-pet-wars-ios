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

#import "SuperRewards/SROffer.h"
#import "SROfferViewController.h"
#import "SROfferWebViewController.h"

@implementation SROfferViewController
@synthesize name, description, payout, requirements, 
            completeOfferButton, launchSafariButton, emailLinkButton,
            typeImageView;

- (id)initWithOffer:(SROffer *)_offer currencyName:(NSString *)currencyName {
    if (self = [super initWithNibName:@"SROfferView" bundle:nil]) {    
        offer = [_offer retain];
        currency = [currencyName copy];
    }
    return self;
}

- (void)viewDidLoad {
    name.text = offer.name;
    description.text = offer.description;
    payout.text = [NSString stringWithFormat:@"%d %@", offer.payout, currency];
    requirements.text = offer.requirements;
    
    [completeOfferButton addTarget:self action:@selector(completeOfferButtonClicked) 
                  forControlEvents:UIControlEventTouchUpInside];
    [launchSafariButton addTarget:self action:@selector(launchSafariButtonClicked) 
                  forControlEvents:UIControlEventTouchUpInside];
    [emailLinkButton addTarget:self action:@selector(emailLinkButtonClicked) 
                  forControlEvents:UIControlEventTouchUpInside];
    
    NSString *imageName;
    switch (offer.type) {
        case SROfferTypeFree:
            imageName = @"sr_free_icon.png";
            break;
        case SROfferTypePaid:
            imageName = @"sr_paid_icon.png";
            break;
        case SROfferTypeMobile:
            imageName = @"sr_mobile_icon.png";
            break;            
        default:
            break;
    }
    
    if (imageName) {
        typeImageView.image = [UIImage imageNamed:imageName];
    }
	self.title = @"Details";
}

- (void)completeOfferButtonClicked {
    SROfferWebViewController *srowvc = [[SROfferWebViewController alloc] initWithUrl:offer.url];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:srowvc];
    nav.navigationBar.barStyle = [self navigationController].navigationBar.barStyle;
    [self presentModalViewController:nav animated:YES];
    [nav release];
    [srowvc release];
}

- (void)launchSafariButtonClicked {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:offer.url]];    
}


- (void)emailLinkButtonClicked { // open mail.app on the device with the link
    NSString *subject = @"Requested Link";
    NSString *body = 
        [NSString stringWithFormat:@"Click this link and complete the offer to earn more %@:\n\n%@\n%@", currency, offer.name, offer.url];
    
    NSString *mailString = 
    [NSString stringWithFormat:@"mailto:?to=&subject=%@&body=%@", 
                                 [subject stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding], 
                                 [body stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:mailString]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}


- (void)dealloc {
    [offer release];
    [currency release];
    [name release];
    [description release];
    [payout release];
    [requirements release];
    [launchSafariButton release];
    [emailLinkButton release];
    [typeImageView release];
    
    [super dealloc];
}


@end
