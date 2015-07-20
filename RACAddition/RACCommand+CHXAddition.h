//
//  RACCommand+CHXAddition.h
//  Haioo
//
//  Created by Moch Xiao on 6/15/15.
//  Copyright (c) 2015 Haioo. All rights reserved.
//

#import "RACCommand.h"

#ifdef RACAddition

extern NSString const * kErrorKey;

@interface RACCommand (CHXAddition)

- (RACSignal *)chx_next;
- (RACSignal *)chx_error;
- (RACSignal *)chx_completed;

@end
#endif