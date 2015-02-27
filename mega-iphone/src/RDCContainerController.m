/**
 * RDCContainerController.h
 * Copyright Miraphonic, Inc 2009. All rights reserved.
 *
 * RDCContainerController holds a AbstractRemoteDataController and
 * displays a loading overlay over it until it is ready to be shown
 *
 * @author Amit Matani
 * @created 1/15/09
 */

#import "RDCContainerController.h"
#import "AbstractRemoteDataController.h"
#import "Consts.h"


@implementation RDCContainerController
@synthesize containedRDC, initialLoadingIndicator, initialLoadingLabel, specialMessageLabel;

- (id)initWithRemoteDataController:(AbstractRemoteDataController *)controller {
    if (self = [super init]) {
        self.containedRDC = controller;
        containedRDC.containerController = self;
        self.title = containedRDC.title;
    }
    return self;
}

- (void)loadView {
    [super loadView];
    
    CGFloat topMargin = [self getTopMargin];
    CGFloat leftMargin = [self getLeftMargin];
    
    // setup the initial page loading indicator
    CGRect rect;
    rect = CGRectMake(leftMargin, topMargin, 30.0, 30.0);
	initialLoadingIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
	initialLoadingIndicator.frame = rect;
	initialLoadingIndicator.contentMode = UIViewContentModeCenter;
	initialLoadingIndicator.hidesWhenStopped = YES;
    [initialLoadingIndicator startAnimating];
	
	// setup the initial page loading String
	rect = CGRectMake(leftMargin + 35, topMargin, 200.0, 30.0);
	initialLoadingLabel = [[UILabel alloc] initWithFrame:rect];
	initialLoadingLabel.contentMode = UIViewContentModeCenter;
	initialLoadingLabel.font = [UIFont systemFontOfSize:[self getInitalLoadFontSize]];
	initialLoadingLabel.adjustsFontSizeToFitWidth = YES;
	initialLoadingLabel.textColor = [UIColor darkGrayColor];
	initialLoadingLabel.text = [self loadingText];
	

	[self.view addSubview:initialLoadingIndicator];
	[self.view addSubview:initialLoadingLabel];
    [self.view addSubview:containedRDC.view];
    
    self.view.backgroundColor = [UIColor whiteColor];
    debug_NSLog(@"loading the rdc");
}

/**
 * setViewFrame: sets the frame of the controller and also sets the frame
 * of the contained controller to be the same size and at 0,0 of the container
 * controller
 * @param CGRect frame - the frame
 */
- (void)setViewFrame:(CGRect)frame {
    // we cheat here because this shit doesnt work the way i want it to
    self.view.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, 480);
    CGRect containedFrame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    containedRDC.view.frame = containedFrame;
    debug_NSLog(@"frame origin %f", self.view.frame.origin.y);
}

/**
 * getLeftMargin returns the lef margin for the loading indicator
 * @return CGFloat left margin
 */
- (CGFloat)getLeftMargin {
    return 100.0;
}

/**
 * getLeftMargin returns the top margin for the loading indicator
 * @return CGFloat top margin
 */
- (CGFloat)getTopMargin {
    return 100.0;
}

/**
 * getInitalLoadFontSize returns the font size of the loading indicator
 * @return CGFloat font size
 */
- (CGFloat)getInitalLoadFontSize {
    return 20.0;
}

/**
 * showLoadingScreen will show the loading overlay
 * and hide the contained view controller
 */
- (void)showLoadingScreen {
    debug_NSLog(@"showLoadingScren");
    [initialLoadingIndicator startAnimating];            
    [self setContainedAndLoadingVisibility:0];
}

/**
 * showContainedViewController will hide the loading overlay
 * and show the contained view controller
 */
- (void)showContainedViewController {
    debug_NSLog(@"showContainedViewController");
    [initialLoadingIndicator stopAnimating];    
    [self setContainedAndLoadingVisibility:1];
}

/**
 * setContainedAndLoadingVisibility is a helper for showContainedViewController
 * and showLoadingScreen and will show and hide the views based on the
 * isLoading variable
 * 0 to show loading
 * 1 to show the containedRDC
 * 2 to show the special message
 */
- (void)setContainedAndLoadingVisibility:(NSInteger)status {
    if (initialLoadingLabel == nil) {
//        return;
    }
    debug_NSLog(@"status is: %d", status);
    initialLoadingLabel.hidden = initialLoadingIndicator.hidden = status != 0;
    containedRDC.view.hidden = status != 1;
    if (containedRDC.view.hidden) {
        debug_NSLog(@"contained rdc is hidden");
    }
    specialMessageLabel.hidden = status != 2;
}

/**
 * loadingText returns the string that is diplayed next to the loading
 * indicator when it is loading
 */
- (NSString *)loadingText {
	return @"Loading";
}

/**
 * displayMessageOverlay: takes a string and displays it on the loading screen
 * in place of the loading indicator and text
 * @param NSString *text
 */
- (void)displayMessageOverlay:(NSString *)text {
    // figure out size and shape of "none available" situation
	struct CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:[self getInitalLoadFontSize]]
		                       constrainedToSize:CGSizeMake(280, 20000)
			                   lineBreakMode:UILineBreakModeWordWrap];
	float height = size.height;
	
	CGRect rect = CGRectMake(20, [self getTopMargin], 280, height);
    if (specialMessageLabel == nil) {
	    specialMessageLabel = [[UILabel alloc] initWithFrame:rect];
    	specialMessageLabel.contentMode = UIViewContentModeTop;
    	specialMessageLabel.font = [UIFont systemFontOfSize:[self getInitalLoadFontSize]];
    	specialMessageLabel.textAlignment = UITextAlignmentCenter;
    	specialMessageLabel.numberOfLines = 0;
    	specialMessageLabel.textColor = [UIColor darkGrayColor];
        [self.view addSubview:specialMessageLabel];	    
    } else {
        specialMessageLabel.frame = rect;
    }
    
	specialMessageLabel.text = text;
    
    [self setContainedAndLoadingVisibility:2];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}

- (void)willDisplayFromNavigation {
    [containedRDC willDisplayFromNavigation];    
}

- (void)dealloc {
    [containedRDC release];
    [initialLoadingIndicator release];
    [initialLoadingLabel release];
    [specialMessageLabel release];
    [super dealloc];
}


@end
