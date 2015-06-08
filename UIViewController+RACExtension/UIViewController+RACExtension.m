//
//  UIViewController+RACExtension.m
//  Haioo
//
//  Created by Moch Xiao on 6/8/15.
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

#import "UIViewController+RACExtension.h"

#ifdef EnableUIViewControllerRACExtension

#import <objc/runtime.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

static char RACExtensionLoading;
static char RACExtensionerrorMessage;

@implementation UIViewController (RACExtension)

@dynamic rac_loading;
@dynamic rac_errorMessage;

#pragma mark - Dynamic Accessors

- (BOOL)rac_loading {
    return [objc_getAssociatedObject(self, &RACExtensionLoading) boolValue];
}

- (void)setRac_loading:(BOOL)rac_loading {
    NSString *key = NSStringFromSelector(_cmd);
    [self willChangeValueForKey:key];
    objc_setAssociatedObject(self, &RACExtensionLoading,
                             @(rac_loading),
                             OBJC_ASSOCIATION_ASSIGN);
    [self didChangeValueForKey:key];
}

- (NSString *)rac_errorMessage {
    return objc_getAssociatedObject(self, &RACExtensionerrorMessage);
}

- (void)setRac_errorMessage:(NSString *)rac_errorMessage {
    NSString *key = NSStringFromSelector(_cmd);
    [self willChangeValueForKey:key];
    objc_setAssociatedObject(self, &RACExtensionerrorMessage,
                             rac_errorMessage,
                             OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self didChangeValueForKey:key];
}

#pragma mark - load

+ (void)load {
    // swizzle
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [UIViewController chx_swizzleInstanceMethod:[UIViewController class] originalSelector:@selector(viewDidLoad) overrideSelector:@selector(hack_viewDidLoad)];
    });
}

#pragma mark - Hack

- (void)hack_viewDidLoad {
    [self hack_viewDidLoad];
    
    @weakify(self);
    // 添加 RAC 订阅
    [[[[RACObserve(self, rac_loading) skip:1] replayLast] deliverOnMainThread] subscribeNext:^(NSNumber *loading) {
        @strongify(self);
        if ([self respondsToSelector:@selector(rac_reactive_loading:)]) {
            [self rac_reactive_loading:[loading boolValue]];
        }
    }];
    [[[[RACObserve(self, rac_errorMessage) replayLast] filter:^BOOL(NSString *errorMessage) {
        return nil != errorMessage && errorMessage.length > 0;
    }] deliverOnMainThread] subscribeNext:^(NSString *errorMessage) {
        @strongify(self);
        if ([self respondsToSelector:@selector(rac_reactive_errorMessage:)]) {
            [self rac_reactive_errorMessage:errorMessage];
        }
    }];
}

#pragma mark - Reactive methods

- (void)rac_reactive_loading:(BOOL)loading {}
- (void)rac_reactive_errorMessage:(NSString *)errorMessage {}

#pragma mark - Private

// 该方法应该在 dispatch_once 中执行
+ (void)chx_swizzleInstanceMethod:(Class)clazz originalSelector:(SEL)originalSelector overrideSelector:(SEL)overrideSelector {
    Method originalMethod = class_getInstanceMethod(clazz, originalSelector);
    Method overrideMethod = class_getInstanceMethod(clazz, overrideSelector);
    
    if (class_addMethod(clazz, originalSelector, method_getImplementation(overrideMethod), method_getTypeEncoding(overrideMethod))) {
        class_replaceMethod(clazz, overrideSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, overrideMethod);
    }
}

@end

#endif