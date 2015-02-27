/**
 * RedeemCodeViewController.m
 * Copyright Miraphonic, Inc 2009. All rights reserved.
 *
 * @author Amit Matani 
 * @created 2/9/09.
 */

#import "RedeemCodeViewController.h"
#import "BRRestClient.h"
#import "BRSession.h"
#import "BRAppDelegate.h"
#import "ProtagonistAnimal.h"
#import "PosseAnimalRemoteCollection.h"
#import "ActionResult.h"

@implementation RedeemCodeViewController
@synthesize redeemCodeButton, redeemCodeTextField;

// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)init {
    if (self = [super initWithNibName:@"RedeemCodeView" bundle:[NSBundle mainBundle]]) {
		self.title = @"Redeem Code";
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
	
	[redeemCodeButton addTarget:self action:@selector(redeemCodeButtonClicked) 
			   forControlEvents:UIControlEventTouchUpInside];
    redeemCodeTextField.delegate = self;
}

- (void)redeemCodeButtonClicked {
	[[BRAppDelegate sharedManager] showLoadingOverlayWithText:@"Redeeming"];
	[[BRRestClient sharedManager] posse_redeemCode:redeemCodeTextField.text target:self 
								  finishedSelector:@selector(finishedRedeeming:parsedResponse:)
									failedSelector:@selector(failedRedeeming)];
}

- (void)finishedRedeeming:(NSNumber *)responseInt parsedResponse:(NSDictionary *)parsedResponse {
	if ([BRRestClient isResponseSuccessful:responseInt]) {
		[[BRAppDelegate sharedManager] hideLoadingOverlay];
		ProtagonistAnimal *protag = [[BRSession sharedManager] protagonistAnimal];
		
		ActionResult *ar = [[ActionResult alloc] initWithApiResponse:[parsedResponse objectForKey:@"action_result"]];
        [protag updateWithActionResult:ar];
		NSString *msg = (ar == nil || [ar.message isEqualToString:@""]) ? @"You've successfully added them to your posse!" : ar.message;
		
		Animal *animal = [[Animal alloc] initWithApiResponse:[parsedResponse objectForKey:@"posse_animal"]];
		if (animal) {
			[protag.posse insertObject:animal atIndex:0];
		}
		
        [[BRAppDelegate sharedManager] showPlainTextNotification:msg];
		
		[animal release];
		[ar release];
		redeemCodeTextField.text = @"";
	} else {
		[self failedRedeeming];
	}
}

- (void)failedRedeeming {
	[[BRAppDelegate sharedManager] hideLoadingOverlay];	
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self redeemCodeButtonClicked];
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}


- (void)dealloc {
	[redeemCodeTextField release];
    [redeemCodeButton release];
    [super dealloc];
}


@end
