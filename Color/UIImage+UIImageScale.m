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
    
    
    
    UIGraphicsBeginImageContext(size);   
    
    
    [self drawInRect:CGRectMake(xPos, yPos, width, height)];   
    
    
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();   
    
    
    UIGraphicsEndImageContext();   
    
    
    return scaledImage; 
}  

-(NSString *) image2String{
    NSData* pictureData = UIImageJPEGRepresentation(self,0.5f);
    NSString* pictureDataString = [pictureData base64Encoding];
    return pictureDataString;
}

@end
