//
//  UIImage+Alpha.m
//  iScan
//
//  Created by zzyong on 2020/1/16.
//  Copyright © 2020 zzyong. All rights reserved.
//

#import "UIImage+Alpha.h"

@implementation UIImage (Alpha)

- (BOOL)hasAlpha
{
    CGImageAlphaInfo alpha = CGImageGetAlphaInfo(self.CGImage);
    
    return (alpha == kCGImageAlphaFirst ||
            alpha == kCGImageAlphaLast ||
            alpha == kCGImageAlphaPremultipliedFirst ||
            alpha == kCGImageAlphaPremultipliedLast);
}

@end
