//
//  ISOpenCVImageProcesser.h
//  iScan
//
//  Created by zzyong on 2020/1/16.
//  Copyright © 2020 zzyong. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UIImage;

NS_ASSUME_NONNULL_BEGIN

@interface ISOpenCVImageProcesser : NSObject

+ (nullable UIImage *)converToGrayImage:(UIImage *)originalImg;

+ (nullable UIImage *)converToThresholdImage:(UIImage *)originalImg;

@end

NS_ASSUME_NONNULL_END
