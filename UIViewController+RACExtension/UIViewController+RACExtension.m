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

static const void * RACExtensioneWillHandleMemoryWarningSignal = @"chx_willHandleMemoryWarningSignal";
static const void * RACExtensioneMemoryWarningActive = @"rac_memoryWarningActive";

#pragma mark -

@interface NSObject (RACExtension)
@end

// https://github.com/atcuan/WildAppExtension/blob/master/Categories/NSObjectExtension.m#L157
@implementation NSObject (RACExtension)

- (void)rac_associateObject:(id)object forKey:(const void *)key {
    [self willChangeValueForKey:(__bridge NSString *)key];
    objc_setAssociatedObject(self, key, object, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self didChangeValueForKey:(__bridge NSString *)key];
}

- (void)rac_associateWeaklyObject:(id)object forKey:(const void *)key {
    objc_setAssociatedObject(self, key, object, OBJC_ASSOCIATION_ASSIGN);
}

- (id)rac_associatedObjectForKey:(const void *)key {
    return objc_getAssociatedObject(self, key);
}

@end

#pragma mark - UIViewController (RACExtension)

@interface UIViewController ()
@property (nonatomic, assign) BOOL rac_memoryWarningActive;
@end

@implementation UIViewController (RACExtension)

#pragma mark - Dynamic Accessors

- (RACSignal *)chx_willHandleMemoryWarningSignal {
    return [self rac_associatedObjectForKey:RACExtensioneWillHandleMemoryWarningSignal];
}

- (void)setChx_willHandleMemoryWarningSignal:(RACSignal *)chx_willHandleMemoryWarningSignal {
    [self rac_associateObject:chx_willHandleMemoryWarningSignal forKey:RACExtensioneWillHandleMemoryWarningSignal];
}

- (void)setRac_memoryWarningActive:(BOOL)rac_memoryWarningActive {
    [self rac_associateWeaklyObject:@(rac_memoryWarningActive) forKey:RACExtensioneMemoryWarningActive];
}

- (BOOL)rac_memoryWarningActive {
    return [[self rac_associatedObjectForKey:RACExtensioneMemoryWarningActive] boolValue];
}

#pragma mark - load

+ (void)load {
    // swizzle
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [UIViewController rac_swizzleInstanceMethodOriginalSelector:@selector(initWithNibName:bundle:) overrideSelector:@selector(rac_hook_initWithNibName:bundle:)];
        [UIViewController rac_swizzleInstanceMethodOriginalSelector:@selector(viewDidLoad) overrideSelector:@selector(rac_hook_viewDidLoad)];
        [UIViewController rac_swizzleInstanceMethodOriginalSelector:@selector(didReceiveMemoryWarning) overrideSelector:@selector(rac_hook_didReceiveMemoryWarning)];
    });
}

- (instancetype)rac_hook_initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    id instance = [self rac_hook_initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    @weakify(self);
    self.chx_willHandleMemoryWarningSignal = [[[RACObserve(self, rac_memoryWarningActive) filter:^BOOL(NSNumber *rac_memoryWarningActive) {
        return [rac_memoryWarningActive boolValue];
    }] map:^id(id _) {
        @strongify(self);
        return self;
    }] setNameWithFormat:@"%@ -chx_willHandleMemoryWarningSignal", self];
    
    return instance;
}

- (void)rac_hook_viewDidLoad {
    [self rac_hook_viewDidLoad];
    
    self.rac_memoryWarningActive = NO;
}

- (void)rac_hook_didReceiveMemoryWarning {
    if (!self.view.window && self.isViewLoaded) {
        self.rac_memoryWarningActive = YES;
    }

    [self rac_hook_didReceiveMemoryWarning];
}

#pragma mark - Public

- (void)chx_presentError:(NSError *)error {
    [[[UIAlertView alloc] initWithTitle:error.localizedDescription
                                message:error.localizedRecoverySuggestion
                               delegate:nil
                      cancelButtonTitle:NSLocalizedString(@"OK", nil)
                      otherButtonTitles:nil] show];
}

- (void)chx_presentErrorMessage:(NSString *)errorMessage {
    [[[UIAlertView alloc] initWithTitle:@""
                                message:errorMessage
                               delegate:nil
                      cancelButtonTitle:NSLocalizedString(@"OK", nil)
                      otherButtonTitles:nil] show];
}


#pragma mark - Private

// 该方法应该在 dispatch_once 中执行
+ (void)rac_swizzleInstanceMethodOriginalSelector:(SEL)originalSelector overrideSelector:(SEL)overrideSelector {
    Class clazz = [UIViewController class];
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