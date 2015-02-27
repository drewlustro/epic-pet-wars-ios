//
//  ScrollableTabBar.h
//  mega framework
//
//  Created by Amit Matani on 4/19/09.
//  Copyright 2009 Miraphonic, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ScrollableTabBarDelegate;


@interface ScrollableTabBar : UIView <UIScrollViewDelegate> {
    NSInteger _selectedIndex;
    
    NSMutableArray *_titles;
    NSMutableArray *_buttons;
    
    UIScrollView *_scrollView;
    UIImageView *_backgroundView;
    
    UIView *_overflowRight;
    UIView *_overflowLeft;
    
    id<ScrollableTabBarDelegate> _delegate;
    
    UIColor *_unselectedColor, *_shadowColor, *_shadowColorSelected;
	BOOL _disableShadow;
}

- (void)setTabs:(NSArray *)titles;
- (void)addTab:(NSString *)title;
- (void)changeShadowOffset:(CGSize)offset;

@property (nonatomic, assign) id<ScrollableTabBarDelegate> delegate;
@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, assign) BOOL disableShadow;
@property (nonatomic, retain) UIColor *unselectedColor, *shadowColor, *shadowColorSelected;


@end

@protocol ScrollableTabBarDelegate <NSObject>

@optional
- (BOOL)scrollableTabBar:(ScrollableTabBar *)scrollableTabBar shouldSelectIndex:(NSInteger)index;
- (void)scrollableTabBar:(ScrollableTabBar *)scrollableTabBar didSelectIndex:(NSInteger)index;

@end
