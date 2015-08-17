//
//  CHXCommandReformer.m
//  RACErrorCatch
//
//  Created by Moch Xiao on 6/3/15.
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

#import "CHXCommand.h"

#ifdef EanbleCHXCommand

#import <ReactiveCocoa/ReactiveCocoa.h>

@interface CHXCommand ()

@property (nonatomic, strong, readwrite) RACSignal *errors;
@property (nonatomic, strong, readwrite) RACSignal *errorMessage;
@property (nonatomic, strong, readwrite) RACSignal *next;
@property (nonatomic, strong, readwrite) RACSignal *completed;

@end

@implementation CHXCommand

- (instancetype)initWithTrigger:(RACSignal *)triggerSignal signalBlock:(RACSignal * (^)(id input))signalBlock {
    self = [super init];
    if (!self) {
        return nil;
    }

    RACSignal *theSignal = [[triggerSignal map:^id(id value) {
        return [[[signalBlock(value) subscribeOn:[RACScheduler mainThreadScheduler]] replayLast] logError];
    }] replayLast];
    
    RACSignal *executionSignals = [[theSignal catchTo:[RACSignal empty]] setNameWithFormat:@"%@ -executionSignal", self];
    
    // next
    self.next = [[[executionSignals flattenMap:^RACStream *(RACSignal *subscribeSignal) {
        return [[[subscribeSignal materialize] filter:^BOOL(RACEvent *event) {
            return event.eventType == RACEventTypeNext;
        }] dematerialize];
    }] deliverOnMainThread] setNameWithFormat:@"%@ -next", self];
    
    // completed
    self.completed = [[[executionSignals flattenMap:^RACStream *(RACSignal *subscribeSignal) {
        return [[subscribeSignal materialize] filter:^BOOL(RACEvent *event) {
            return event.eventType == RACEventTypeCompleted;
        }];
    }] deliverOnMainThread] setNameWithFormat:@"%@ -completed", self];
    
    // errors
    self.errors = [[[theSignal flattenMap:^RACStream *(RACSignal *signal) {
        return [[signal ignoreValues] catch:^RACSignal *(NSError *error) {
            return [RACSignal return:error];
        }];
    }] deliverOnMainThread] setNameWithFormat:@"%@ -errors", self];
    
    self.errorMessage = [[self.errors filter:^BOOL(id value) {
        return value;
    }] map:^id(NSError *error) {
        return error.userInfo[@"Error"];
    }];
    
    // subscribe
    RACDisposable *theSignalDisposable = [theSignal subscribeError:^(NSError *error) {
    } completed:^{
    }];
    
    [RACDisposable disposableWithBlock:^{
        [theSignalDisposable dispose];
    }];
    
    return self;
}

@end

#endif