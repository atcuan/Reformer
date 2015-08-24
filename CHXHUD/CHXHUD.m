//
//  CHXHUD.m
//  GettingStarted
//
//  Created by Moch Xiao on 2015-02-06.
//  Copyright (c) 2015 Moch Xiao (https://github.com/cuzv).
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

#import "CHXHUD.h"

#ifdef EanbleCHXHUD

#import "JGProgressHUD.h"
#import "JGProgressHUDFadeZoomAnimation.h"

static JGProgressHUD *HUD;
static UIView *presentView;

@implementation CHXHUD

+ (void)showHUDWithMessage:(NSString *)message {
//    if (HUD.targetView) {
//        [HUD removeFromSuperview];
//    }
    
    JGProgressHUD *staticHUD = [self staticHUD];
    staticHUD.indicatorView = nil;
    staticHUD.textLabel.text = message;
    [staticHUD dismissAfterDelay:1.2f];
    [staticHUD showInView:presentView animated:YES];
}

+ (void)showHUDWithMessage:(NSString *)message fromView:(UIView *)view {
    if (!view.window) {
        return;
    }
    [self showHUDWithMessage:message];
}

+ (void)showLoadingHUDWithMessage:(NSString *)message {
//    if (HUD.targetView) {
//        [HUD removeFromSuperview];
//    }
    
    JGProgressHUD *staticHUD = [self staticHUD];
    staticHUD.interactionType = JGProgressHUDInteractionTypeBlockAllTouches;
    JGProgressHUDFadeZoomAnimation *animation = [JGProgressHUDFadeZoomAnimation animation];
    staticHUD.HUDView.layer.shadowColor = [UIColor blackColor].CGColor;
    staticHUD.HUDView.layer.shadowOffset = CGSizeZero;
    staticHUD.HUDView.layer.shadowOpacity = 0.4f;
    staticHUD.HUDView.layer.shadowRadius = 8.0f;
    staticHUD.animation = animation;
    staticHUD.textLabel.text = message.length ? message : @"加载中...";
    [staticHUD showInView:presentView animated:YES];
}

+ (void)showLoadingHUD {
//    if (HUD.targetView) {
//        [HUD removeFromSuperview];
//    }
    
    JGProgressHUD *staticHUD = [self staticHUD];
    [staticHUD showInView:presentView animated:YES];
}

+ (void)removeHUDIfExist {
    [HUD dismissAnimated:YES];
}

+ (JGProgressHUD *)staticHUD {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        HUD = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleDark];
        HUD.interactionType = JGProgressHUDInteractionTypeBlockNoTouches;
        HUD.textLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];
        presentView = [UIApplication sharedApplication].keyWindow;        
    });
    
    return HUD;
}

@end

#endif