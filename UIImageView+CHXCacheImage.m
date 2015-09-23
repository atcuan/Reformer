//
//  UIImageView+CHXCacheImage.m
//  Haioo
//
//  Created by Moch Xiao on 9/22/15.
//  Copyright © 2015 Haioo. All rights reserved.
//

#import "UIImageView+CHXCacheImage.h"

#ifdef SDWebImageAddition

#import "UIImageView+WebCache.h"

@implementation UIImageView (CHXCacheImage)

- (void)chx_setCachedImageWithTargetPath:(NSString *)targetPath {
    [self chx_setCachedImageWithTargetPath:targetPath placeholderImage:nil];
}

- (void)chx_setCachedImageWithTargetPath:(NSString *)targetPath placeholderImage:(UIImage *)placeholderImage {
    UIImage *cachedImage = [self cachedImageForTargetPath:targetPath];
    
    if (cachedImage) {
        self.image = cachedImage;
    }
    else {
        self.image = placeholderImage;
    }
}

- (void)chx_lazyLoadImageWithTargetPath:(NSString *)targetPath placeholderImage:(UIImage *)placeholderImage {
    UIImage *cachedImage = [self cachedImageForTargetPath:targetPath];
    if (!cachedImage) {
        [self sd_setImageWithURL:[NSURL URLWithString:targetPath] placeholderImage:placeholderImage completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (!error &&[imageURL.absoluteString isEqualToString:targetPath]) {
                self.alpha = 0;
                [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    self.alpha = 1;
                } completion:nil];
            }
        }];
    }
}

- (UIImage *)cachedImageForTargetPath:(NSString *)targetPath {
    if (!targetPath || !targetPath.length) {
        return nil;
    }
    
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    SDImageCache *cache = [manager imageCache];
    NSString *key = [manager cacheKeyForURL:[NSURL URLWithString:targetPath]];
    UIImage *image = [cache imageFromMemoryCacheForKey:key];
    
    return image;
}

@end

#endif
