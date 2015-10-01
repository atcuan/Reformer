//
//  UIImageView+CHXCacheImage.h
//  Haioo
//
//  Created by Moch Xiao on 9/22/15.
//  Copyright © 2015 Haioo. All rights reserved.
//

#import <UIKit/UIKit.h>

#ifdef SDWebImageAddition

@interface UIImageView (CHXCacheImage)

/// Fetch image from memory cache or disk cache.
/// If got image data, setup
- (void)chx_setCachedImageWithTargetPath:(NSString *)targetPath;
/// Fetch image from memory cache or disk cache.
/// If got image data, setup, If not, use placeholderImage
- (void)chx_setCachedImageWithTargetPath:(NSString *)targetPath placeholderImage:(UIImage *)placeholderImage;

/// Lazy setup Image for `UIImageView`, If already have cached data, abort
/// Note that invoke this method you must invoked `chx_setCachedImageWithTargetPath:` first
- (void)chx_lazyLoadImageWithTargetPath:(NSString *)targetPath placeholderImage:(UIImage *)placeholderImage;

@end


#endif