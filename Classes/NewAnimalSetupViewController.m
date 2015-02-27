/**
 * NewAnimalSetupViewController.m
 * Copyright Miraphonic, Inc 2009. All rights reserved.
 *
 * @author Amit Matani 
 * @created 2/5/09.
 */

#import "NewAnimalSetupViewController.h"
#import "AnimalType.h"
#import "Consts.h"
#import "ProtagonistAnimal.h"
#import "BRSession.h"
#import "RemoteImageViewWithFileStore.h"
#import "BRAppDelegate.h"
#import "BRRestClient.h"
#import "BRTabManager.h"
#import "PostNewAccountViewController.h"

#define BASE_SCROLL_VIEW_HEIGHT 202
#define EXTENDED_SCROLL_VIEW_HEIGHT 416 

@implementation NewAnimalSetupViewController
@synthesize animalType, petName, createAnimalButton,
            animalImageView, myScrollView;

/**
 * initWithAnimalType inits the object while saving the animalType
 * @param AnimalType *_animalType
 * @return id - the newly created object
 */
- (id)initWithAnimalType:(AnimalType *)_animalType {
    if (self = [super initWithNibName:@"NewAnimalSetupView" bundle:[NSBundle mainBundle]]) {
        animalType = [_animalType retain];
        self.title = @"Adopt Pet";
    }
    return self;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [animalImageView loadImageWithUrl:animalType.imageSquare75];
    
    [petName becomeFirstResponder];
    
    petName.delegate = self;
	
    [createAnimalButton addTarget:self action:@selector(attemptAnimalCreation)
		   forControlEvents:UIControlEventTouchUpInside];
    
    CGFloat contentHeight = createAnimalButton.frame.origin.y + createAnimalButton.frame.size.height + 20;
    [myScrollView setContentSize:CGSizeMake(320, contentHeight)];
    myScrollView.frame = CGRectMake(0, 0, 320, BASE_SCROLL_VIEW_HEIGHT);
	
	if ([[BRSession sharedManager] protagonistAnimal] != nil) {
		
		isNewAccount = NO;
	} else {
		isNewAccount = YES;
	}
}

/**
 * attemptAccountCreation will take the credentials the user has provided 
 * and attempt to create an account with them.
 */
- (void)attemptAnimalCreation {
    // disable inputs and show that we are loading and scroll to the top
    myScrollView.frame = CGRectMake(0, 0, 320, EXTENDED_SCROLL_VIEW_HEIGHT);
    [self enableInputs:NO];
    [myScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    
    // handle any obvious input validation here
    if ([petName.text isEqualToString:@""]) {
        [self displayFailedAccountCreation:@"Name should not be empty"];
    } else { // we have passed basic validation, the rest will be done by the server
        [[BRRestClient sharedManager] account_createNewAnimal:animalType.typeId 
										name:petName.text
										email:@""
										phoneNumber:@""
										target:self
										finishedSelector:@selector(newAnimalFinishedWithResponse:parsedResponse:)
										failedSelector:@selector(newAnimalFailed)];
        [[BRAppDelegate sharedManager] showLoadingOverlayWithText:@"Adopting"];
   } 
}

/**
 */
- (void)newAnimalFinishedWithResponse:(NSNumber *)responseInt 
		parsedResponse:(NSDictionary *)parsedResponse {
    if ([BRRestClient isResponseSuccessful:responseInt]) {
        [[BRAppDelegate sharedManager] hideLoadingOverlay];        
		ProtagonistAnimal *protagonistAnimal = 
			[[ProtagonistAnimal alloc] initWithApiResponse:[parsedResponse objectForKey:@"animal"]];
		
		[[BRSession sharedManager] setProtagonistAnimal:protagonistAnimal];
		
		[protagonistAnimal release];
		
		[[[BRAppDelegate sharedManager] tabManager] login];
		
		UIViewController *viewController;
		viewController = [[PostNewAccountViewController alloc] init];
		[[self navigationController] pushViewController:viewController animated:YES];
		[viewController release];
    } else {
        [self displayFailedAccountCreation:[parsedResponse objectForKey:@"response_message"]];
    }
}

/**
 * newAccountFinishedWithResponse:parsedResponse: is called when the restclient
 * failed loading the account creation action.
 */
- (void)newAnimalFailed {
    [self displayFailedAccountCreation:@"Unknown Error"];
}

/**
 * displayFailedAccountCreation takes displays an error message on why the user could
 * not create an account
 * @param NSString *message - the message to display
 */
- (void)displayFailedAccountCreation:(NSString *)message {
    [[BRAppDelegate sharedManager] hideLoadingOverlay];            
    UIAlertView *failedAccountCreation = 
		[[UIAlertView alloc] initWithTitle:@"Unable to Adopt Pet" 
								   message:message 
								  delegate:self 
						 cancelButtonTitle:@"OK" 
						 otherButtonTitles:nil];
	[failedAccountCreation show];
	[failedAccountCreation release];
    [self enableInputs:YES];
    [petName becomeFirstResponder];	
}

- (void)enableInputs:(BOOL)shouldEnable {
    petName.enabled = shouldEnable;
    createAnimalButton.enabled = shouldEnable;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	myScrollView.frame = CGRectMake(0, 0, 320, BASE_SCROLL_VIEW_HEIGHT);   
}

#pragma mark UITextFieldDelegate methods
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    return YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}

- (void)dealloc {
    [animalType release];
    [petName release];
    [createAnimalButton release];
    [animalImageView release];	
    [myScrollView release];
    [super dealloc];
}


@end
