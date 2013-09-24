//
//  TabBarCommentView.m
//  Color
//
//  Created by chao han on 12-6-24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "TabBarCommentView.h"

@implementation TabBarCommentView

@synthesize backBtn = _backBtn , commentBtn = _commentBtn , homeBtn = _homeBtn;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
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

-(void)dealloc{
    self.backBtn = nil;
    self.commentBtn = nil;
    self.homeBtn = nil;
    
    [super dealloc];
}


@end
