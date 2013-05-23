//
//  CircleModel.m
//  Color
//
//  Created by chao han on 12-6-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CircleModel.h"

@implementation CircleModel
@synthesize cId = _cId , usersArray = _usersArray , mediasArray = _mediasArray
 , ctime = _ctime;


-(void)dealloc{
    self.cId = nil;
    self.mediasArray = nil;
    self.usersArray = nil;
    self.ctime = nil;
    
    [super dealloc];
}
@end
