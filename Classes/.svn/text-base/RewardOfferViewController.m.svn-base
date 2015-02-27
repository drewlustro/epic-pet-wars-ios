//
//  RewardOfferViewController.m
//  battleroyale
//
//  Created by Amit Matani on 3/12/09.
//  Copyright 2009 Miraphonic, Inc. All rights reserved.
//

#import "RewardOfferViewController.h"
#import "BRRestClient.h"
#import "BRSession.h"
#import "Consts.h"
#import "Utility.h"
#import "LoadingUIWebView.h"
#import "BRSRTableViewController.h"



@implementation RewardOfferViewController
@synthesize webView;


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	[webView loadRequest:[[BRSession sharedManager] getExtraOfferRequest]];	
    webView.localDelegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}

- (void)webView:(LoadingUIWebViewWithLocalRequest *)webView handleLocalMethod:(NSString *)method params:(NSDictionary *)params {
    if ([method isEqualToString:@"showSR"]) {
        SRMode mode = [[params objectForKey:@"mode"] intValue];
        NSInteger offersPerPage = [[params objectForKey:@"offersPerPage"] intValue];
        if (offersPerPage <= 0) { offersPerPage = 30; }
        BRSRTableViewController *stvc = [[BRSRTableViewController alloc] initWithGameId:[[BRSession sharedManager] offerId] 
                                                                             userId:[[BRSession sharedManager] userId] 
                                                                               mode:mode offersPerPage:offersPerPage];
        [[self navigationController] pushViewController:stvc animated:YES];
        [stvc release];
        
    }
}



- (void)dealloc {
    webView.localDelegate = nil;
    webView.delegate = nil;
    [webView release];
    [super dealloc];
}


@end
