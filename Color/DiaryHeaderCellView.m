//
//  DiaryHeaderCellView.m
//  Color
//  回忆主界面  tableview 第一行，用户信息cell
//  Created by chao han on 12-5-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "DiaryHeaderCellView.h"

@implementation DiaryHeaderCellView

@synthesize headIconView = _headIconView , nameLabel = _nameLabel , friendScrollView = _friendScrollView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.friendScrollView.scrollsToTop = NO;
    }
    return self;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

-(void) dealloc {
    self.headIconView = nil;
    self.nameLabel = nil;
    self.friendScrollView = nil;
    
    [super dealloc];
}

@end
