//
//  ItemWebViewController.m
//  battleroyale
//
//  Created by Amit Matani on 1/6/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ItemWebViewController.h"
#import "Item.h"

@implementation ItemWebViewController

- (id)initWithItem:(Item *)item {
	if (self = [super init]) {
		_item = [item retain];
	}
	return self;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
	[super webViewDidFinishLoad:webView];
	[self reloadLocalData];
}

- (void)reloadLocalData {
	NSString *item = [_item serializeToJavascriptArray];
	debug_NSLog(item);

	[(UIWebView *)self.view stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"setItem(%@)", item]];	
}
- (void)dealloc {
	[_item release];
	[super dealloc];
}

@end
