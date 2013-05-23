//
//  UIUtil.h
//  ZReader_HD
//
//  Created by  on 12-3-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIUtil : NSObject
+(CGRect)getFrame:(UIView*)view relativeParentView:(UIView*)parentView;

+(UIImage *) string2Image:(NSString *)string;

+ (UIImage *)scaleAndRotateImage:(UIImage *)image;
@end

CGFloat distance(CGPoint a, CGPoint b);