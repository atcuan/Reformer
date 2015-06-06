//
//  UIScrollView+CHXRefreshControl.m
//  Informality
//
//  Created by Moch Xiao on 6/6/15.
//  Copyright (c) 2015 Moch Xiao (https://github.com/atcuan).
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
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
        UIView <INSPullToRefreshBackgroundViewDelegate> *pullToRefresh = [[INSDefaultPullToRefresh alloc] initWithFrame:defaultFrame backImage:[UIImage imageNamed:@"light_circle"] frontImage:[UIImage imageNamed:@"dark_circle"]];
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
    self.ins_infiniteScrollBackgroundView.preserveContentInset = NO;
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