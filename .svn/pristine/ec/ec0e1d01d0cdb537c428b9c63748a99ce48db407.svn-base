//
//  LoadingOverlayViewController.m
//  battleroyale
//
//  Created by Amit Matani on 1/26/09.
//  Copyright 2009 Miraphonic, Inc. All rights reserved.
//

#import "LoadingOverlayViewController.h"


@implementation LoadingOverlayViewController
@synthesize loadingLabelText;

- (id)init {
    if (self = [super initWithNibName:@"LoadingOverlayView" bundle:[NSBundle mainBundle]]) {
    }
    return self;
}

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/

- (void)setLoadingLabelText:(NSString *)_value {
    [loadingLabelText release];
    loadingLabelText = [_value copy];
    loadingLabel.text = loadingLabelText;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    [indicator startAnimating];
    loadingLabel.text = loadingLabelText;
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}


- (void)dealloc {
    [loadingLabelText release];
    [loadingLabel release];
    [indicator release];
    [super dealloc];
}


@end
