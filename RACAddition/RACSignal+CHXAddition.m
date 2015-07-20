//
//  RACSignal+CHXAddition.m
//  Haioo
//
//  Created by Moch Xiao on 7/20/15.
//  Copyright (c) 2015 Haioo. All rights reserved.
//

#import "RACSignal+CHXAddition.h"
#import "UIViewController+RACExtension.h"

#ifdef RACAddition

@implementation RACSignal (CHXAddition)

- (instancetype)takeUntilDidHandleReceivedMemoryWarningForViewControler:(UIViewController *)viewController {
    return [self takeUntil:[viewController rac_signalForSelector:@selector(rac_handleReceivedMemoryWarning)]];
}

@end

#endif
