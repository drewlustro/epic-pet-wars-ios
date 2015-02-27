//
//  TreasureChestViewController.m
//  battleroyale
//
//  Created by Amit Matani on 4/23/09.
//  Copyright 2009 Miraphonic, Inc. All rights reserved.
//

#import "TreasureChestViewController.h"
#import "BRRestClient.h"
#import "BRSession.h"
#import "BRAppDelegate.h"
#import "ItemReceivedViewController.h"
#import "ActionResult.h"
#import "ProtagonistAnimal.h"

@implementation TreasureChestViewController

@synthesize treasureCodeTextField, treasureCodeButton;

// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)init {
    if (self = [super initWithNibName:@"TreasureChestView" bundle:[NSBundle mainBundle]]) {
		self.title = @"Treasure Code";
    }
    return self;
}


/*
 // Implement loadView to create a view hierarchy programmatically, without using a nib.
 - (void)loadView {
 }
 */


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	[treasureCodeButton addTarget:self action:@selector(treasureCodeButtonClicked) 
			   forControlEvents:UIControlEventTouchUpInside];
    treasureCodeTextField.delegate = self;
}

- (void)treasureCodeButtonClicked {
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:treasureCodeTextField.text, @"code", nil];
    [[BRRestClient sharedManager] callRemoteMethod:@"account.redeemTreasureCode" params:params delegate:self];
    [self showLoadingOverlayWithText:@"Redeeming"];
    [treasureCodeTextField resignFirstResponder];
}

- (void)remoteMethodDidLoad:(NSString *)method responseCode:(RestResponseCode)responseCode parsedResponse:(NSDictionary *)parsedResponse {
    [[BRAppDelegate sharedManager] hideLoadingOverlay];    
    treasureCodeTextField.text = @"";    
	if (responseCode == RestResponseCodeSuccess) {
		ActionResult *actionResult = [[ActionResult alloc] initWithApiResponse:[parsedResponse objectForKey:@"action_result"]];
		[[[BRSession sharedManager] protagonistAnimal] updateWithActionResult:actionResult];
		
		if (![Utility stringIfNotEmpty:actionResult.popupHTML]) {
			if (actionResult.item) {
				ItemReceivedViewController *irvc = [[ItemReceivedViewController alloc] initWithItem:actionResult.item];
				[self presentModalViewController:irvc animated:YES];
				[irvc release];
			} else {
				[[BRAppDelegate sharedManager] showNotification:actionResult.formattedResponse 
													  withWidth:[actionResult.formattedResponseWidth floatValue]
													  andHeight:[actionResult.formattedResponseHeight floatValue]];
			}
		}
		
		[actionResult release];        

	} else {
        [self alertWithTitle:@"Could Not Redeem" message:[parsedResponse objectForKey:@"response_message"]];
    }    
}

- (void)remoteMethodDidFail:(NSString *)method {
    [[BRAppDelegate sharedManager] hideLoadingOverlay];        
    [self alertWithTitle:@"Could Not Redeem" message:@"Unknown Error"];
    treasureCodeTextField.text = @"";
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self treasureCodeButtonClicked];
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}


- (void)dealloc {
	[treasureCodeButton release];
    [treasureCodeTextField release];
    [super dealloc];
}


@end
