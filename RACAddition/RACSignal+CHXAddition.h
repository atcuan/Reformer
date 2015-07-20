//
//  RACSignal+CHXAddition.h
//  Haioo
//
//  Created by Moch Xiao on 7/20/15.
//  Copyright (c) 2015 Haioo. All rights reserved.
//

#import "RACSignal.h"

#ifdef RACAddition

@interface RACSignal (CHXAddition)
- (instancetype)takeUntilDidHandleReceivedMemoryWarningForViewControler:(UIViewController *)viewController;
@end

#endif