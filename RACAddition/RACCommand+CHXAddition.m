//
//  RACCommand+CHXAddition.m
//  Haioo
//
//  Created by Moch Xiao on 6/15/15.
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

#import "RACCommand+CHXAddition.h"

#ifdef RACAddition


@implementation RACCommand (CHXAddition)

- (RACSignal *)chx_next {
    RACSignal *next = [[self.executionSignals flattenMap:^RACStream *(RACSignal *subscribeSignal) {
        return [[[subscribeSignal materialize] filter:^BOOL(RACEvent *event) {
            return event.eventType == RACEventTypeNext;
        }] dematerialize];
    }] deliverOnMainThread];

    return next;
}

- (RACSignal *)chx_error {
    RACSignal *error = [[[self.errors filter:^BOOL(NSError *error) {
        return nil != error;
    }] map:^id(NSError *error) {
        return [error localizedDescription];
    }] deliverOnMainThread];

    return error;
}

- (RACSignal *)chx_completed {
    RACSignal *completed = [[self.executionSignals flattenMap:^RACStream *(RACSignal *subscribeSignal) {
        return [[subscribeSignal materialize] filter:^BOOL(RACEvent *event) {
            return event.eventType == RACEventTypeCompleted;
        }];
    }] deliverOnMainThread];
    
    return completed;
}

@end
#endif