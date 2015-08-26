//
//  NSObject+CHXLifting.m
//  Haioo
//
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

#import "NSObject+CHXLifting.h"

#ifdef RACAddition

#import "RACSignal.h"
#import "NSObject+RACLifting.h"

@implementation NSObject (CHXLifting)

- (RACSignal *)chx_liftSelector:(SEL)selector withSignals:(RACSignal *)firstSignal, ... NS_REQUIRES_NIL_TERMINATION {
    if (![self respondsToSelector:selector]) {
        NSLog(@"%@ did not response selector(%@)", self, NSStringFromSelector(selector));
        return [RACSignal return:nil];
    }
    
    return [self rac_liftSelector:selector withSignals:firstSignal, nil];
}

- (RACSignal *)chx_liftSelector:(SEL)selector withSignalsFromArray:(NSArray *)signals {
    if (![self respondsToSelector:selector]) {
        NSLog(@"%@ did not response selector(%@)", self, NSStringFromSelector(selector));
        return [RACSignal return:nil];
    }

    return [self rac_liftSelector:selector withSignalsFromArray:signals];
}

- (RACSignal *)chx_liftSelector:(SEL)selector withSignalOfArguments:(RACSignal *)arguments {
    if (![self respondsToSelector:selector]) {
        NSLog(@"%@ did not response selector(%@)", self, NSStringFromSelector(selector));
        return [RACSignal return:nil];
    }
    
    return [self rac_liftSelector:selector withSignalOfArguments:arguments];
}

@end

#endif