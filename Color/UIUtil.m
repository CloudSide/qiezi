//
//  UIUtil.m
//  ZReader_HD
//
//  Created by  on 12-3-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "UIUtil.h"
#import "NSData+Additions.h"


@implementation UIUtil

+(CGRect)getFrame:(UIView*)view relativeParentView:(UIView*)parentView {
    if (view && parentView) {
        CGRect frame = view.frame;
        if ([view.superview isMemberOfClass:[parentView class]]) {
            return frame;
        }else{
            CGRect superframe = [UIUtil getFrame:view.superview relativeParentView:parentView];
            frame.origin.x += superframe.origin.x;
            frame.origin.y += superframe.origin.y;
            
            return frame;
        }
    }
    
    return CGRectMake(0, 0, 0, 0);
}

+(UIImage *) string2Image:(NSString *)string{
    UIImage *image = [UIImage imageWithData:[NSData dataWithBase64EncodedString:string]];
    return image;
}

// 用于裁剪摄像头拍照后的图片
// Code from: http://discussions.apple.com/thread.jspa?messageID=7949889
+ (UIImage *)scaleAndRotateImage:(UIImage *)image {
//    int kMaxResolution = 640; // Or whatever
    int kDestResolution = 640; // Or whatever
    
    CGImageRef imgRef = image.CGImage;
    
    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);
    
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    CGRect bounds = CGRectMake(0, 0, width, height);
    //    if (width > kMaxResolution || height > kMaxResolution) {
    //        CGFloat ratio = width/height;
    //        if (ratio > 1) {
    //            bounds.size.width = kMaxResolution;
    //            bounds.size.height = roundf(bounds.size.width / ratio);
    //        }
    //        else {
    //            bounds.size.height = kMaxResolution;
    //            bounds.size.width = roundf(bounds.size.height * ratio);
    //        }
    //    }
    
//    CGFloat smallerWidth = width > height ? height : width;
    
    //修改为最小边永远都是kDestResolution
//    if (smallerWidth > kDestResolution) {
        CGFloat ratio = width/height;
        if (ratio > 1) {//宽大于高
            bounds.size.height = kDestResolution;
            bounds.size.width = roundf(bounds.size.height * ratio);
        }
        else {//宽小于高
            bounds.size.width = kDestResolution;
            bounds.size.height = roundf(bounds.size.width / ratio);
        }
//    }
    
    CGFloat scaleRatio = bounds.size.width / width;
    CGSize imageSize = CGSizeMake(CGImageGetWidth(imgRef), CGImageGetHeight(imgRef));
    CGFloat boundHeight;
    UIImageOrientation orient = image.imageOrientation;
    switch(orient) {
            
        case UIImageOrientationUp: //EXIF = 1
            transform = CGAffineTransformIdentity;
            break;
            
        case UIImageOrientationUpMirrored: //EXIF = 2
            transform = CGAffineTransformMakeTranslation(imageSize.width, 0.0);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            break;
            
        case UIImageOrientationDown: //EXIF = 3
            transform = CGAffineTransformMakeTranslation(imageSize.width, imageSize.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationDownMirrored: //EXIF = 4
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.height);
            transform = CGAffineTransformScale(transform, 1.0, -1.0);
            break;
            
        case UIImageOrientationLeftMirrored: //EXIF = 5
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, imageSize.width);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationLeft: //EXIF = 6
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.width);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationRightMirrored: //EXIF = 7
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeScale(-1.0, 1.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        case UIImageOrientationRight: //EXIF = 8
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, 0.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        default:
            [NSException raise:NSInternalInconsistencyException format:@"Invalid image orientation"];
            
    }
    
    UIGraphicsBeginImageContext(bounds.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if (orient == UIImageOrientationRight || orient == UIImageOrientationLeft) {
        CGContextScaleCTM(context, -scaleRatio, scaleRatio);
        CGContextTranslateCTM(context, -height, 0);
    }
    else {
        CGContextScaleCTM(context, scaleRatio, -scaleRatio);
        CGContextTranslateCTM(context, 0, -height);
    }
    
    CGContextConcatCTM(context, transform);
    
    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);
    UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return imageCopy;
}


@end

CGFloat distance(CGPoint a, CGPoint b) {
	return sqrtf(powf(a.x-b.x, 2) + powf(a.y-b.y, 2));
}