//
//  ScrollableTabBar.m
//  mega framework
//
//  Created by Amit Matani on 4/19/09.
//  Copyright 2009 Miraphonic, Inc. All rights reserved.
//

#import "ScrollableTabBar.h"
#import "Utility.h"
#define HEIGHT 40

@implementation ScrollableTabBar
@synthesize delegate = _delegate, selectedIndex = _selectedIndex,
            unselectedColor = _unselectedColor, shadowColor = _shadowColor, 
            shadowColorSelected = _shadowColorSelected;
@synthesize disableShadow = _disableShadow;

// private
- (void)layoutTabs {
#define PADDING 5
#define BUTTON_Y_OFFSET 5
#define BUTTON_HEIGHT 30
#define INITIAL_PADDING 10
    
    float xOffset = INITIAL_PADDING;
    float height = _scrollView.frame.size.height;
    UIFont *font = [UIFont boldSystemFontOfSize:12];
    UIColor *selectedColor = [UIColor whiteColor];    
	CGSize shadowOffset = CGSizeMake(0, -1);    
	if (_disableShadow)
	{
		shadowOffset = CGSizeMake(0, 0);  
	}

    if (_shadowColor == nil) {
        self.shadowColor = [UIColor whiteColor];
    }
    
    if (_shadowColorSelected == nil) {
        self.shadowColorSelected = [UIColor blackColor];
    }
    
    if (_unselectedColor == nil) {
        self.unselectedColor = WEBCOLOR(0x222222FF);
    }

    
    UIImage *tabBackground = [[UIImage imageNamed:@"scroll_generic_button.png"] stretchableImageWithLeftCapWidth:14 topCapHeight:0];
    for (int i = 0; i < [_titles count]; i += 1) {
        NSString *title = [_titles objectAtIndex:i];
        UIButton *tabButton = [UIButton buttonWithType:UIButtonTypeCustom];
        tabButton.font = font;
        [tabButton addTarget:self action:@selector(tabButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        if (_selectedIndex == i) {
            tabButton.enabled = NO;
        }
        
        CGSize s = [title sizeWithFont:font constrainedToSize:CGSizeMake(4000, height) lineBreakMode:UILineBreakModeWordWrap];
        tabButton.frame = CGRectMake(xOffset, BUTTON_Y_OFFSET, s.width + 4 * PADDING, BUTTON_HEIGHT);
        tabButton.titleShadowOffset = shadowOffset;
        
        // unselected state
        [tabButton setTitle:title forState:UIControlStateNormal];
        [tabButton setTitleColor:_unselectedColor forState:UIControlStateNormal];
        [tabButton setTitleShadowColor:_shadowColor forState:UIControlStateNormal];
        // selected state
        [tabButton setTitleColor:selectedColor forState:UIControlStateDisabled];
        [tabButton setBackgroundImage:tabBackground forState:UIControlStateDisabled];
        [tabButton setTitleShadowColor:_shadowColorSelected forState:UIControlStateDisabled];
        
        xOffset += tabButton.frame.size.width + PADDING;    
        [_scrollView addSubview:tabButton];
        
        [_buttons addObject:tabButton];
    }
    _scrollView.contentSize = CGSizeMake(xOffset + INITIAL_PADDING, _scrollView.frame.size.height);

}

- (void)layoutOverlays {
#define OVERLAY_WIDTH 30    
    if (_scrollView.contentOffset.x > 0) {
        if (_overflowLeft == nil) {
            _overflowLeft = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"item_scroll_left_overlay.png"]];
            _overflowLeft.frame = CGRectMake(0, 0, OVERLAY_WIDTH, _scrollView.frame.size.height);
            _overflowLeft.backgroundColor = [UIColor clearColor];
            [self addSubview:_overflowLeft];
        }
        _overflowLeft.hidden = NO;
    } else if (_overflowLeft != nil) {
        _overflowLeft.hidden = YES;
    }

    if (_scrollView.contentSize.width - _scrollView.frame.size.width > _scrollView.contentOffset.x) {
        if (_overflowRight == nil) {
            _overflowRight = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"item_scroll_right_overlay.png"]];
            _overflowRight.frame = 
                CGRectMake(self.frame.size.width - OVERLAY_WIDTH, 0, OVERLAY_WIDTH, _scrollView.frame.size.height);
            _overflowRight.backgroundColor = [UIColor clearColor];            

            [self addSubview:_overflowRight];
        }
        _overflowRight.hidden = NO;
    } else if (_overflowLeft != nil) {
        _overflowRight.hidden = YES;
    }
}

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // we force the height to 40 for now
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, HEIGHT);
        _selectedIndex = NSIntegerMax;
        _titles = [[NSMutableArray alloc] initWithCapacity:5];
        _buttons = [[NSMutableArray alloc] initWithCapacity:5]; 
        
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        //_scrollView.backgroundColor = WEBCOLOR(0xDDDDDDFF);
		_scrollView.backgroundColor = [UIColor clearColor];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.delegate = self;	
		_disableShadow = NO;
		_backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"item_scroll_bg.png"]];
		_backgroundView.frame = CGRectMake(0, 0, self.frame.size.width, HEIGHT);
		[self addSubview:_backgroundView];
		
		
        [self addSubview:_scrollView];
    }
    return self;
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, HEIGHT)];
    _scrollView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    _backgroundView.frame = CGRectMake(0, 0, self.frame.size.width, HEIGHT);    
}

- (void)setTabs:(NSArray *)titles {
    for (NSString *title in titles) {
        [_titles addObject:title];
    }
    [self setNeedsDisplay];
}

- (void)addTab:(NSString *)title {
    [_titles addObject:title];
    [self setNeedsDisplay];
}

- (void)setSelectedIndex:(NSInteger)index {
    if ([_buttons count] == 0) { // have not loaded yet
        _selectedIndex = index;
        return;
    }
    
    if (index >= [_buttons count]) {
        return;
    }
    
    if (_delegate != nil && [_delegate respondsToSelector:@selector(scrollableTabBar:shouldSelectIndex:)]) {
        if (![_delegate scrollableTabBar:self shouldSelectIndex:index]) {
            return;
        }
    }
    
    UIButton *oldButton = nil;
    if (_selectedIndex < [_buttons count]) {
        oldButton = [_buttons objectAtIndex:_selectedIndex];
    }
    oldButton.enabled = YES;
    
    UIButton *newButton = [_buttons objectAtIndex:index];
    newButton.enabled = NO;
    
    _selectedIndex = index;
    
    if (_delegate != nil && [_delegate respondsToSelector:@selector(scrollableTabBar:didSelectIndex:)]) {
        [_delegate scrollableTabBar:self didSelectIndex:index];
    }    
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    [self layoutTabs];
    [self layoutOverlays];    
}

- (void)layoutSubviews {
    [self layoutOverlays];
}

- (void)tabButtonClicked:(UIButton *)button {
    NSInteger index;
    for (index = 0; index < [_titles count]; index += 1) {
        if ([[button titleForState:UIControlStateNormal] isEqualToString:[_titles objectAtIndex:index]]) {
            break;
        }
    }
    
    if (index == [_titles count]) { return; } // bad error case
    
    self.selectedIndex = index;
}


- (void)dealloc {
    
    [_overflowRight release];
    [_overflowLeft release];
    
    [_scrollView release];
    [_backgroundView release];
    
    [_titles release];
    [_buttons release];
    
    [_unselectedColor release];
    [_shadowColor release]; 
    [_shadowColorSelected release];
    
    [super dealloc];
}


@end
