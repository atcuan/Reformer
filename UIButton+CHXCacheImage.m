//
//  UIButton+CHXCacheImage.m
//  Haioo
//
//  Created by Moch Xiao on 9/22/15.
//  Copyright © 2015 Haioo. All rights reserved.
//

#import "UIButton+CHXCacheImage.h"

#ifdef SDWebImageAddition

@implementation UIButton (CHXCacheImage)

- (void)chx_setCachedImageWithTargetPath:(NSString *)targetPath {
    UIImage *cachedImage = [self cachedImageForTargetPath:targetPath];
    
    if (cachedImage) {
        [self setImage:cachedImage forState:UIControlStateNormal];
    }
}

- (void)chx_lazyLoadImageWithTargetPath:(NSString *)targetPath forState:(UIControlState)state placeholderImage:(UIImage *)placeholderImage {
    UIImage *cachedImage = [self cachedImageForTargetPath:targetPath];
    if (!cachedImage) {
        [self sd_setImageWithURL:[NSURL URLWithString:targetPath]
                        forState:state
                placeholderImage:placeholderImage];
    }
}

- (void)chx_setCachedBackgroundImageWithTargetPath:(NSString *)targetPath {
    UIImage *cachedImage = [self cachedImageForTargetPath:targetPath];
    
    if (cachedImage) {
        [self setBackgroundImage:cachedImage forState:UIControlStateNormal];
    }
}

- (void)chx_lazyLoadBackgroundImageWithTargetPath:(NSString *)targetPath
                                         forState:(UIControlState)state
                                 placeholderImage:(UIImage *)placeholderImage {
    UIImage *cachedImage = [self cachedImageForTargetPath:targetPath];
    if (!cachedImage) {
        [self sd_setBackgroundImageWithURL:[NSURL URLWithString:targetPath]
                                  forState:state
                          placeholderImage:placeholderImage];
    }
}

#pragma mark - 

- (UIImage *)cachedImageForTargetPath:(NSString *)targetPath {
    if (!targetPath || !targetPath.length) {
        return nil;
    }
    
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    SDImageCache *cache = [manager imageCache];
    NSString *key = [manager cacheKeyForURL:[NSURL URLWithString:targetPath]];
    UIImage *image = [cache imageFromMemoryCacheForKey:key];
    if (!image) {
        image = [cache imageFromDiskCacheForKey:key];
    }
    
    return image;
}


@end


#endif