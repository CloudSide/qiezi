//
//  OperPageControl.m
//  Color
//
//  Created by chao han on 12-5-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "OperPageControl.h"

@interface OperPageControl (private)
- (void)updateLastDot;
@end

@implementation OperPageControl

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    return self;
}

-(void) setNumberOfPages:(NSInteger)page
{
    [super setNumberOfPages:page];
    [self updateLastDot];
}

-(void) setCurrentPage:(NSInteger)page
{
    [super setCurrentPage:page];
    [self updateLastDot];
}
- (void)endTrackingWithTouch : (UITouch *)touch withEvent:(UIEvent *)event
{
//    [super endTrackingWithTouch:touch withEvent:event];
    [self updateLastDot];
}
- (void)updateLastDot
{
    for (NSInteger i = 0 ; i < self.subviews.count ; ++i) {
        UIImageView *dot = [self.subviews objectAtIndex:i];
        
        if (i == self.subviews.count - 1) {
            dot.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"tinyStar" ofType:@"png"]];
            dot.alpha = self.currentPage == i ? 1.0f : 0.5f;
        }else{
            dot.alpha = 1.0f;
            dot.image = self.currentPage == i ?
                    [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"whiteDot" ofType:@"png"]] 
                    : [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"blackDot" ofType:@"png"]];
        }
    }
}

- (void)dealloc
{
    [super dealloc];
}
@end
