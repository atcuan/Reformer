//
//  UIScrollView+CHXRefreshControl.h
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