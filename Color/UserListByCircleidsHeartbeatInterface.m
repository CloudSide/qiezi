//
//  UserListByCircleidsHeartbeatInterface.m
//  Color
//  Created by chao han on 12-6-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "UserListByCircleidsHeartbeatInterface.h"
#import "DeviceUtil.h"
#import "UserModel.h"

@implementation UserListByCircleidsHeartbeatInterface
@synthesize delegate = _delegate;

-(void)getUserListByCircleids:(NSString *)cid
{
    self.needCacheFlag = NO;
    
    [_circleId release];
    _circleId = [cid retain];
    
    self.baseDelegate = self;
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:[DeviceUtil getMacAddress] forKey:@"deviceId"];
    [dict setObject:[NSString stringWithFormat:@"%.11g",[MySingleton sharedSingleton].lon] forKey:@"lon"];
    [dict setObject:[NSString stringWithFormat:@"%.10g",[MySingleton sharedSingleton].lat] forKey:@"lat"];
    [dict setObject:cid forKey:@"circleids"];
    
    self.interfaceUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@/user/userbycircleids",[MySingleton sharedSingleton].baseInterfaceUrl]];
    self.postKeyValues = dict;
    [dict release];
    
    [self connect];
}

-(void)dealloc {
    self.delegate = nil;
    [_circleId release];
    
    [super dealloc];
}

-(void)parseResult:(NSDictionary *)responseDict{
    if (responseDict && [responseDict count] > 0) {
        NSMutableArray *userArray = [[NSMutableArray alloc] init];
        
        NSArray *contentArray = [responseDict objectForKey:@"content"];
        if (contentArray.count > 0) {
            NSArray *list = [[contentArray objectAtIndex:0] objectForKey:@"user"];
            for (NSDictionary *dict in list) {
                UserModel *user = [[UserModel alloc] init];
                user.userId = [dict objectForKey:@"userId"];
                user.name = [dict objectForKey:@"name"];
                user.avatarUrl = [dict objectForKey:@"avatar"];
                
                [userArray addObject:user];
                [user release];
            }
            
            [self.delegate getUserListByCircleidsDidFinished:userArray circleId:_circleId];
            [userArray release];
        }else
        {
            [self.delegate getUserListByCircleidsDidFinished:nil circleId:_circleId];
        }
    }else{
        [self.delegate getUserListByCircleidsDidFinished:nil circleId:_circleId];
    }
}

-(void)requestIsFailed:(NSString *)errorMsg{
    [self.delegate getUserListByCircleidsDidFailed:errorMsg];
}

@end
