//
//  DiarySectionView.m
//  Color
//
//  Created by chao han on 12-5-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "DiarySectionView.h"

@implementation DiarySectionView

@synthesize dateLabel = _dateLabel , monthYearLabel = _monthYearLabel , weekLabel = _weekLabel;

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

-(void)dealloc {
    self.dateLabel = nil;
    self.monthYearLabel = nil;
    self.weekLabel = nil;
    
    [super dealloc];
}

@end
