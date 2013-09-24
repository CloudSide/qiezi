//
//  UIImage+UIImageScale.m
//  Color
//
//  Created by chao han on 12-5-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "UIImage+UIImageScale.h"
#import "NSData+Additions.h"

@implementation UIImage (UIImageScale)

//截取部分图像 
-(UIImage*)getSubImage:(CGRect)rect 
{ 
    CGImageRef subImageRef = CGImageCreateWithImageInRect(self.CGImage, rect); 
    CGRect smallBounds = CGRectMake(0, 0, CGImageGetWidth(subImageRef), CGImageGetHeight(subImageRef)); 
    
    UIGraphicsBeginImageContext(smallBounds.size); 
    CGContextRef context = UIGraphicsGetCurrentContext(); 
    CGContextDrawImage(context, smallBounds, subImageRef); 
    UIImage* smallImage = [UIImage imageWithCGImage:subImageRef];
    if (subImageRef != NULL) {
        CFRelease(subImageRef);
    }
    UIGraphicsEndImageContext(); 
    
    return smallImage; 
} 

//等比例缩放 
-(UIImage*)scaleToSize:(CGSize)size  
{ 
    CGFloat width = CGImageGetWidth(self.CGImage); 
    CGFloat height = CGImageGetHeight(self.CGImage); 
    
    float verticalRadio = size.height*1.0/height;  
    float horizontalRadio = size.width*1.0/width; 
    
    float radio = 1; 
    if(verticalRadio>1 && horizontalRadio>1) 
    { 
        radio = verticalRadio > horizontalRadio ? horizontalRadio : verticalRadio;    
    } 
    else 
    { 
        radio = verticalRadio < horizontalRadio ? verticalRadio : horizontalRadio;    
    } 
    
    width = width*radio; 
    height = height*radio; 
    
    int xPos = (size.width - width)/2; 
    int yPos = (size.height-height)/2; 
    
    // 创建一个bitmap的context   
    // 并把它设置成为当前正在使用的context   
    UIGraphicsBeginImageContext(size);   
    
    // 绘制改变大小的图片   
    [self drawInRect:CGRectMake(xPos, yPos, width, height)];   
    
    // 从当前context中创建一个改变大小后的图片   
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();   
    
    // 使当前的context出堆栈   
    UIGraphicsEndImageContext();   
    
    // 返回新的改变大小后的图片   
    return scaledImage; 
}  

-(NSString *) image2String{
    NSData* pictureData = UIImageJPEGRepresentation(self,0.5f);//进行图片压缩从0.0到1.0（0.0表示最大压缩，质量最低);
    NSString* pictureDataString = [pictureData base64Encoding];//图片转码成为base64Encoding，
    return pictureDataString;
}

@end
