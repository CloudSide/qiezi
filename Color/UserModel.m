//
//  UserModel.m
//  Color
//
//  Created by chao han on 12-5-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "UserModel.h"

@implementation UserModel
@synthesize userId = _userId , name = _name , avatarUrl = _avatarUrl;

-(void)dealloc {
    self.userId = nil;
    self.name = nil;
    self.avatarUrl = nil;
    
    [super dealloc];
}

@end
