//
//  ISOpenCVImageProcesser.m
//  iScan
//
//  Created by zzyong on 2020/1/16.
//  Copyright © 2020 zzyong. All rights reserved.
//
// OpenCV docs: https://docs.opencv.org/4.1.0/
// tessdata: https://github.com/tesseract-ocr/tessdata
// MMCamScanner: https://github.com/mukyasa/MMCamScanner
// SwiftyTesseract: https://github.com/SwiftyTesseract/SwiftyTesseract


#ifdef __cplusplus
    #import <opencv2/opencv.hpp>
    #import <opencv2/imgproc.hpp>
#endif

#import "ISOpenCVImageProcesser.h"
#import <UIKit/UIKit.h>
#import "UIImage+Alpha.h"


@implementation ISOpenCVImageProcesser

+ (nullable UIImage *)converToGrayImage:(UIImage *)originalImg
{
    if (originalImg == nil) {
        return nil;
    }
    
    cv::Mat greyMat;
    UIImageToMat(originalImg, greyMat, originalImg.hasAlpha);
    cv::cvtColor(greyMat, greyMat, cv::COLOR_BGR2GRAY);
    
    return MatToUIImage(greyMat);
}

+ (nullable UIImage *)converToThresholdImage:(UIImage *)originalImg
{
    if (originalImg == nil) {
        return nil;
    }
    
    cv::Mat thresholdMat;
    UIImageToMat(originalImg, thresholdMat, originalImg.hasAlpha);
    cv::threshold(thresholdMat, thresholdMat, 127, 255, cv::THRESH_BINARY);
    
    return MatToUIImage(thresholdMat);
}

#pragma mark - Private

static UIImage* MatToUIImage(const cv::Mat& image)
{
    
    NSData *data = [NSData dataWithBytes:image.data
                                  length:image.step.p[0] * image.rows];
    
    CGColorSpaceRef colorSpace;
    
    if (image.elemSize() == 1) {
        colorSpace = CGColorSpaceCreateDeviceGray();
    } else {
        colorSpace = CGColorSpaceCreateDeviceRGB();
    }
    
    CGDataProviderRef provider =
    CGDataProviderCreateWithCFData((__bridge CFDataRef)data);
    
    // Preserve alpha transparency, if exists
    bool alpha = image.channels() == 4;
    CGBitmapInfo bitmapInfo = (alpha ? kCGImageAlphaLast : kCGImageAlphaNone) | kCGBitmapByteOrderDefault;
    
    // Creating CGImage from cv::Mat
    CGImageRef imageRef = CGImageCreate(image.cols,
                                        image.rows,
                                        8 * image.elemSize1(),
                                        8 * image.elemSize(),
                                        image.step.p[0],
                                        colorSpace,
                                        bitmapInfo,
                                        provider,
                                        NULL,
                                        false,
                                        kCGRenderingIntentDefault
                                        );
    
    
    // Getting UIImage from CGImage
    UIImage *finalImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    CGDataProviderRelease(provider);
    CGColorSpaceRelease(colorSpace);
    
    return finalImage;
}

static void UIImageToMat(const UIImage* image, cv::Mat& m, bool alphaExist)
{
    CGColorSpaceRef colorSpace = CGImageGetColorSpace(image.CGImage);
    CGFloat cols = CGImageGetWidth(image.CGImage), rows = CGImageGetHeight(image.CGImage);
    CGContextRef contextRef;
    CGBitmapInfo bitmapInfo = kCGImageAlphaPremultipliedLast;
    if (CGColorSpaceGetModel(colorSpace) == kCGColorSpaceModelMonochrome)
    {
        m.create(rows, cols, CV_8UC1); // 8 bits per component, 1 channel
        bitmapInfo = kCGImageAlphaNone;
        if (!alphaExist)
            bitmapInfo = kCGImageAlphaNone;
        else
            m = cv::Scalar(0);
        contextRef = CGBitmapContextCreate(m.data, m.cols, m.rows, 8,
                                           m.step[0], colorSpace,
                                           bitmapInfo);
    }
    else
    {
        m.create(rows, cols, CV_8UC4); // 8 bits per component, 4 channels
        if (!alphaExist)
            bitmapInfo = kCGImageAlphaNoneSkipLast |
            kCGBitmapByteOrderDefault;
        else
            m = cv::Scalar(0);
        contextRef = CGBitmapContextCreate(m.data, m.cols, m.rows, 8,
                                           m.step[0], colorSpace,
                                           bitmapInfo);
    }
    CGContextDrawImage(contextRef, CGRectMake(0, 0, cols, rows),
                       image.CGImage);
    CGContextRelease(contextRef);
}

@end
