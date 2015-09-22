//
//  UIButton+CHXCacheImage.h
//  Haioo
//
//  Created by Moch Xiao on 9/22/15.
//  Copyright © 2015 Haioo. All rights reserved.
//

#import <UIKit/UIKit.h>

#ifdef SDWebImageAddition

@interface UIButton (CHXCacheImage)

/// Fetch image from memory cache or disk cache.
/// If got image data, setup
- (void)chx_setCachedImageWithTargetPath:(NSString *)targetPath;

/// Lazy setup image for `UIButton`, If already have cached data, abort
/// Note that invoke this method you must invoked `chx_setCachedImageWithTargetPath:` first
- (void)chx_lazyLoadImageWithTargetPath:(NSString *)targetPath
                               forState:(UIControlState)state
                       placeholderImage:(UIImage *)placeholderImage;


/// Fetch background image from memory cache or disk cache.
/// If got image data, setup
- (void)chx_setCachedBackgroundImageWithTargetPath:(NSString *)targetPath;

/// Lazy setup background image for `UIButton`, If already have cached data, abort
/// Note that invoke this method you must invoked `chx_setCachedImageWithTargetPath:` first
- (void)chx_lazyLoadBackgroundImageWithTargetPath:(NSString *)targetPath
                               forState:(UIControlState)state
                       placeholderImage:(UIImage *)placeholderImage;


@end

#endif
