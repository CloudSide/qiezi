//
//  TabBarShareView.m
//  Color
//
//  Created by chao han on 12-5-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "TabBarShareView.h"

@implementation TabBarShareView

@synthesize backBtn = _backBtn , shareBtn = _shareBtn , homeBtn = _homeBtn;

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
    self.shareBtn = nil;
    self.homeBtn = nil;
    
    [super dealloc];
}

@end
