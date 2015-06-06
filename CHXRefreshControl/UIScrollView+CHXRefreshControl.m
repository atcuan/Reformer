//
//  UIScrollView+CHXRefreshControl.m
//  Informality
//
//  Created by Moch Xiao on 6/6/15.
//  Copyright (c) 2015 Moch Xiao. All rights reserved.
//

#import "UIScrollView+CHXRefreshControl.h"

#ifdef EanbleCHXRefreshControl

#import "INSDefaultPullToRefresh.h"
#import "INSDefaultInfiniteIndicator.h"

@implementation UIScrollView (CHXRefreshControl)

#pragma mark - PullToRefresh

- (void)chx_addPullToRefreshWithhandler:(INSPullToRefreshActionHandler)actionHandler {
    [self ins_addPullToRefreshWithHeight:64 handler:actionHandler];
    
    CGRect defaultFrame = CGRectMake(0, 0, 24, 24);
        UIView <INSPullToRefreshBackgroundViewDelegate> *pullToRefresh = [[INSDefaultPullToRefresh alloc] initWithFrame:defaultFrame backImage:[UIImage imageNamed:@"circleLight"] frontImage:[UIImage imageNamed:@"circleDark"]];
    self.ins_pullToRefreshBackgroundView.delegate = pullToRefresh;
    [self.ins_pullToRefreshBackgroundView addSubview:pullToRefresh];
}

- (void)chx_removePullToRefresh {
    [self ins_removePullToRefresh];
}

- (void)chx_setPullToRefreshEnabled:(BOOL)enabled {
    [self ins_setPullToRefreshEnabled:enabled];
}

- (void)chx_beginPullToRefresh {
    [self ins_beginPullToRefresh];
}

- (void)chx_endPullToRefresh {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self ins_endPullToRefresh];
    });
}

#pragma mark - InfinityScroll

- (void)chx_addInfinityScrollWithhandler:(INSInfinityScrollActionHandler)actionHandler {
    [self ins_addInfinityScrollWithHeight:64 handler:actionHandler];
    
    CGRect defaultFrame = CGRectMake(0, 0, 24, 24);
    UIView <INSAnimatable> *infinityIndicator = [[INSDefaultInfiniteIndicator alloc] initWithFrame:defaultFrame];
    [self.ins_infiniteScrollBackgroundView addSubview:infinityIndicator];
    [infinityIndicator startAnimating];
}

- (void)chx_removeInfinityScroll {
    [self ins_removeInfinityScroll];
}

- (void)chx_setInfinityScrollEnabled:(BOOL)enabled {
    [self ins_setInfinityScrollEnabled:enabled];
}

- (void)chx_beginInfinityScroll {
    [self ins_beginPullToRefresh];
}

- (void)chx_endInfinityScroll {
    [self ins_endInfinityScroll];
}

- (void)chx_endInfinityScrollWithStoppingContentOffset:(BOOL)stopContentOffset {
    [self ins_endInfinityScrollWithStoppingContentOffset:stopContentOffset];
}


@end

#endif