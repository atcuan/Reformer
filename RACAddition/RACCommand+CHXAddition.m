//
//  RACCommand+CHXAddition.m
//  Haioo
//
//  Created by Moch Xiao on 6/15/15.
//  Copyright (c) 2015 Haioo. All rights reserved.
//

#import "RACCommand+CHXAddition.h"

#ifdef EanbleCHXCommand

NSString const * kErrorKey = @"Error";

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
        return error.userInfo[kErrorKey];
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