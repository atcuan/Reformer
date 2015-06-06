//
//  UIScrollView+CHXRefreshControl.h
//  Informality
//
//  Created by Moch Xiao on 6/6/15.
//  Copyright (c) 2015 Moch Xiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reformer.h"

#ifdef EanbleCHXRefreshControl
#import <INSPullToRefresh/UIScrollView+INSPullToRefresh.h>

// add `pod 'INSPullToRefresh'` to your Podfile before use

@interface UIScrollView (CHXRefreshControl)

#pragma mark - PullToRefresh

- (void)chx_addPullToRefreshWithhandler:(INSPullToRefreshActionHandler)actionHandler;

- (void)chx_removePullToRefresh;

- (void)chx_setPullToRefreshEnabled:(BOOL)enabled;

- (void)chx_beginPullToRefresh;
- (void)chx_endPullToRefresh;

#pragma mark - InfinityScroll

- (void)chx_addInfinityScrollWithhandler:(INSInfinityScrollActionHandler)actionHandler;
- (void)chx_removeInfinityScroll;

- (void)chx_setInfinityScrollEnabled:(BOOL)enabled;

- (void)chx_beginInfinityScroll;
- (void)chx_endInfinityScroll;
- (void)chx_endInfinityScrollWithStoppingContentOffset:(BOOL)stopContentOffset;

@end

#endif