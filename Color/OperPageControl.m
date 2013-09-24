//
//  OperPageControl.m
//  Color
//
//  Created by chao han on 12-5-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "OperPageControl.h"

@interface OperPageControl (){  //声明一个私有方法，该方法不允许对象直接使用

    CGFloat _kSpacing;
}
- (void)updateLastDot;
@end

@implementation OperPageControl

- (id)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame]){
        if ([self respondsToSelector:@selector(setCurrentPageIndicatorTintColor:)] && [self respondsToSelector:@selector(setPageIndicatorTintColor:)]) {
            [self setCurrentPageIndicatorTintColor:[UIColor clearColor]];
            [self setPageIndicatorTintColor:[UIColor clearColor]];
        }
        
        [self setBackgroundColor:[UIColor clearColor]];
        _kSpacing=10.0f;
        for (UIView *su in self.subviews) {
            [su removeFromSuperview];
        }
        self.contentMode=UIViewContentModeRedraw;
    }
    return self;
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    
    if ([self respondsToSelector:@selector(setCurrentPageIndicatorTintColor:)] && [self respondsToSelector:@selector(setPageIndicatorTintColor:)]) {
        [self setCurrentPageIndicatorTintColor:[UIColor clearColor]];
        [self setPageIndicatorTintColor:[UIColor clearColor]];
    }
    
    [self setBackgroundColor:[UIColor clearColor]];
    _kSpacing=10.0f;
    for (UIView *su in self.subviews) {
        [su removeFromSuperview];
    }
    self.contentMode=UIViewContentModeRedraw;
}

-(void) setNumberOfPages:(NSInteger)page
{
    [super setNumberOfPages:page];
    
    self.bounds = CGRectMake(0, 0,
                             page * ([UIImage imageNamed:@"tinyStar.png"].size.width + _kSpacing),
                             self.bounds.size.height);
    
    if ([[[UIDevice currentDevice]systemVersion]floatValue] < 7.0) {
        [self updateLastDot];
    }
    
    [self setNeedsDisplay];
}

-(void) setCurrentPage:(NSInteger)page
{
    [super setCurrentPage:page];
    
    if ([[[UIDevice currentDevice]systemVersion]floatValue] < 7.0) {
        [self updateLastDot];
    }
    
    [self setNeedsDisplay];
}

// 捕捉点击事件
- (void)endTrackingWithTouch : (UITouch *)touch withEvent:(UIEvent *)event
{
//    [super endTrackingWithTouch:touch withEvent:event];
    
    if ([[[UIDevice currentDevice]systemVersion]floatValue] < 7.0) {
        [self updateLastDot];
    }
    
    [self setNeedsDisplay];
}

// 更新显示所有的点按钮
- (void)updateLastDot
{
    for (NSInteger i = 0 ; i < self.subviews.count ; ++i) {
        UIImageView *dot = [self.subviews objectAtIndex:i];
        
        if (i == self.subviews.count - 1) {
            if ([dot respondsToSelector:@selector(setImage:)]) {
                dot.image = [UIImage imageNamed:@"tinyStar.png"];
                dot.alpha = self.currentPage == i ? 1.0f : 0.5f;
            }
        }else{
            if ([dot respondsToSelector:@selector(setImage:)]) {
                dot.alpha = 1.0f;
                dot.image = self.currentPage == i ?
                    [UIImage imageNamed:@"whiteDot.png"]: [UIImage imageNamed:@"blackDot.png"];
            }
        }
    }

}

-(void)drawRect:(CGRect)iRect
{
    int i;
    CGRect rect;
    
    iRect = self.bounds;
    
    if ( self.opaque ) {
        [self.backgroundColor set];
        UIRectFill( iRect );
    }
    
    if ( self.hidesForSinglePage && self.numberOfPages == 1 ) return;
    
    UIImage *dotImage = [UIImage imageNamed:@"tinyStar.png"];
    
    rect.size.height = dotImage.size.height;
    rect.size.width = self.numberOfPages * dotImage.size.width + ( self.numberOfPages - 1 ) * _kSpacing;
    rect.origin.x = floorf( ( iRect.size.width - rect.size.width ) / 2.0 );
    rect.origin.y = floorf( ( iRect.size.height - rect.size.height ) / 2.0 );
    rect.size.width = dotImage.size.width;
    
    for ( i = 0; i < self.numberOfPages; ++i ) {
        
        UIImage *dotImage = nil;
        if (i == self.subviews.count - 1) {
            dotImage = [UIImage imageNamed:@"tinyStar.png"];
        }else if(self.currentPage == i){
            dotImage = [UIImage imageNamed:@"whiteDot.png"];
        }else{
            dotImage = [UIImage imageNamed:@"blackDot.png"];
        }
        
        [dotImage drawInRect: rect];
        
        rect.origin.x += dotImage.size.width + _kSpacing;
    }
}

- (void)dealloc
{
    [super dealloc];
}
@end
