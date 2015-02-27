//
//  BankViewController.m
//  battleroyale
//
//  Created by Amit Matani on 4/30/09.
//  Copyright 2009 Miraphonic, Inc. All rights reserved.
//

#import "BankViewController.h"
#import "BRSession.h"
#import "ProtagonistAnimal.h"
#import "ActionResult.h"
#import "BRRestClient.h"
#import "BRAppDelegate.h"

@implementation BankViewController
@synthesize bankBalanceLabel, cashBalanceLabel, depositFeeLabel, withdrawFeeLabel, amountTextField, 
            withdrawButton, depositButton;

- (id)init {
    if (self = [super initWithNibName:@"BankView" bundle:nil]) {
        self.title = @"Bank";
    }
    return self;
}

- (void)updateMoneyLabels {
    ProtagonistAnimal *animal = [[BRSession sharedManager] protagonistAnimal];
    
	NSNumberFormatter *format = [[NSNumberFormatter alloc] init];
	[format setNumberStyle:NSNumberFormatterDecimalStyle];
	
	NSNumber *bankFundsNum = [[NSNumber alloc] initWithUnsignedLongLong:animal.bankFunds];
	NSString *bankFunds = [[NSString alloc] initWithString:[format stringFromNumber:bankFundsNum]];
	
	NSNumber *moneyNum = [[NSNumber alloc] initWithUnsignedLongLong:animal.money];
	NSString *money = [[NSString alloc] initWithString:[format stringFromNumber:moneyNum]];
	
    bankBalanceLabel.text = [NSString stringWithFormat:@"¥%@", bankFunds];    
    cashBalanceLabel.text = [NSString stringWithFormat:@"¥%@", money];
    
	[format release];
	[bankFundsNum release];
	[bankFunds release];
	[moneyNum release];
	[money release];
	
}

- (void)setCostLabel:(UILabel *)label withPercentageString:(NSString *)percentage {
    int value = [percentage floatValue] * 100;
    if (value == 0) {
        label.text = @"Free";
    } else {
        label.text = [NSString stringWithFormat:@"%d%% Fee", value];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    ProtagonistAnimal *animal = [[BRSession sharedManager] protagonistAnimal];
    
    [self updateMoneyLabels];
    
    [self setCostLabel:depositFeeLabel withPercentageString:animal.bankDepositPercentage];
    [self setCostLabel:withdrawFeeLabel withPercentageString:animal.bankWithdrawalPercentage];
    
    [withdrawButton addTarget:self action:@selector(withdrawButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [depositButton addTarget:self action:@selector(depositButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    [amountTextField becomeFirstResponder];
}

- (BOOL)validateAmount:(unsigned long long)amount checkAgainst:(unsigned long long)total {
    if (amount <= 0) {
        [self alertWithTitle:@"Error" message:@"Please enter a value greater than 0"];
    } else if (amount > total) {
        [self alertWithTitle:@"Error" message:@"Insufficient funds"];
    } else {
        return YES;
    }
    return NO;
}

#pragma mark UIButton methods
- (void)withdrawButtonClicked {
    ProtagonistAnimal *animal = [[BRSession sharedManager] protagonistAnimal];    
    unsigned long long value = [amountTextField.text longLongValue];
    if ([self validateAmount:value checkAgainst:animal.bankFunds]) {
		[[SoundManager sharedManager] playSoundWithType:@"buy" vibrate:NO];
        [self showLoadingOverlayWithText:@"Withdrawing"];
        [[BRRestClient sharedManager] animal_withdrawFunds:value delegate:self];        
    }
}

- (void)depositButtonClicked {
    ProtagonistAnimal *animal = [[BRSession sharedManager] protagonistAnimal];    
    unsigned long long value = [amountTextField.text longLongValue];
    if ([self validateAmount:value checkAgainst:animal.money]) {    
		[[SoundManager sharedManager] playSoundWithType:@"sell" vibrate:NO];
        [self showLoadingOverlayWithText:@"Depositing"];
        [[BRRestClient sharedManager] animal_depositFunds:value delegate:self];
    }
}

#pragma mark RestResponseDelegate
- (void)remoteMethodDidLoad:(NSString *)method responseCode:(RestResponseCode)responseCode parsedResponse:(NSDictionary *)parsedResponse {
    [self hideLoadingOverlay];
    if (responseCode == RestResponseCodeSuccess) {
		ActionResult *actionResult = [[ActionResult alloc] initWithApiResponse:[parsedResponse objectForKey:@"action_result"]];
		[[[BRSession sharedManager] protagonistAnimal] updateWithActionResult:actionResult];
    
        [[BRAppDelegate sharedManager] showNotification:actionResult.formattedResponse 
                                              withWidth:[actionResult.formattedResponseWidth floatValue]
                                              andHeight:[actionResult.formattedResponseHeight floatValue]];
		[actionResult release];
        
        amountTextField.text = nil;
        [self updateMoneyLabels];
    } else {
        [self alertWithTitle:@"Error" message:[parsedResponse objectForKey:@"response_message"]];        
    }
}

- (void)remoteMethodDidFail:(NSString *)method {
    [self hideLoadingOverlay];
    [self alertWithTitle:@"Error" message:@"Unknown Error"];
}


- (void)dealloc {
    [bankBalanceLabel release];
    [cashBalanceLabel release];
    [depositFeeLabel release];
    [withdrawFeeLabel release];
    [amountTextField release];
    [withdrawButton release];
    [depositButton release];
    [super dealloc];
}


@end
