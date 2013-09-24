//
//  UIButton+BPBadgeButton.m
//  Color
//
//  Created by chao han on 12-6-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "UIButton+BPBadgeButton.h"
#import "MKNumberBadgeView.h"
#import <objc/runtime.h>

static char const * const badgeKey = "badge";

@interface UIButton ()
-(MKNumberBadgeView *)badgeView;
@end

@implementation UIButton (BPBadgeButton)

-(void)setBadge:(NSUInteger)newBadge
{
    MKNumberBadgeView *badgeView = [self badgeView];
    badgeView.value = newBadge;
    badgeView.frame = CGRectMake((self.frame.size.width-badgeView.badgeSize.width)/2,
                                 -20,
                                 badgeView.badgeSize.width+10,
                                 self.frame.size.height);
    badgeView.hidden = (newBadge == 0);
}

-(NSUInteger)badge
{
    MKNumberBadgeView *badgeView = [self badgeView];
    return badgeView.value;
}

-(MKNumberBadgeView *)badgeView;
{
    MKNumberBadgeView *badgeView = (MKNumberBadgeView *)objc_getAssociatedObject(self, badgeKey);
    badgeView.userInteractionEnabled = NO;
    if(!badgeView){
        badgeView = [[MKNumberBadgeView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        [self addSubview:badgeView];
        badgeView.hidden = YES;
        objc_setAssociatedObject(self, badgeKey, badgeView, OBJC_ASSOCIATION_RETAIN);
    }
    return badgeView;
}
@end
