//
//  BRDialog.h
//  battleroyale
//
//  Created by amit on 1/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@class BRWebViewController;

@protocol BRDialogDelegate;
@interface BRDialog : UIView {
	BRWebViewController *_webViewController;
	UILabel* _titleLabel;
	UIButton* _closeButton;
	UIDeviceOrientation _orientation;
	BOOL _showingKeyboard;
	
	NSURLRequest *_request;
	NSString *_html;
	
	id<BRDialogDelegate> _delegate;
}


/**
 * The title that is shown in the header atop the view;
 */
@property(nonatomic,copy) NSString* title;
@property(nonatomic,assign) id<BRDialogDelegate> delegate;


- (id)initWithHTML:(NSString *)html;
- (id)initWithRequest:(NSURLRequest *)request;

/**
 * Displays the view with an animation.
 *
 * The view will be added to the top of the current key window.
 */
- (void)show;

/**
 * Displays the first page of the dialog.
 *
 * Do not ever call this directly.  It is intended to be overriden by subclasses.
 */
- (void)load;

/**
 * Hides the view and notifies delegates of success or cancellation.
 */
- (void)dismiss:(BOOL)animated;


/**
 * Subclasses may override to perform actions just prior to showing the dialog.
 */
- (void)dialogWillAppear;

/**
 * Subclasses may override to perform actions just after the dialog is hidden.
 */
- (void)dialogWillDisappear;


@end

///////////////////////////////////////////////////////////////////////////////////////////////////


@protocol BRDialogDelegate <NSObject>

@optional

/**
 * Called when the dialog succeeds and is about to be dismissed.
 */
- (void)dialogDidDismiss:(BRDialog*)dialog;

@end
