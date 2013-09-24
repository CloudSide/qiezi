//
//  NearByUsersHeartbeatInterface.m
//  QieZi
//  
//  Created by chao han on 12-7-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "NearByUsersHeartbeatInterface.h"
#import "DeviceUtil.h"
#import "UserModel.h"

@implementation NearByUsersHeartbeatInterface
@synthesize delegate = _delegate;

-(void)getNearByUsers
{
    self.needCacheFlag = NO;
    
    self.baseDelegate = self;
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:[DeviceUtil getMacAddress] forKey:@"deviceId"];
    [dict setObject:[NSString stringWithFormat:@"%.11g",[MySingleton sharedSingleton].lon] forKey:@"lon"];
    [dict setObject:[NSString stringWithFormat:@"%.10g",[MySingleton sharedSingleton].lat] forKey:@"lat"];
    
    self.interfaceUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@/nearby/nearbyusers",[MySingleton sharedSingleton].baseInterfaceUrl]];
    self.postKeyValues = dict;
    [dict release];
    
    [self connect];
}

-(void)dealloc {
    self.delegate = nil;
    
    [super dealloc];
}

//{
//    "returncode": 0,
//    "content": 
//                {
//                    "user": [
//                             {
//                                 "userId": "580000019",
//                                 "name": "tang",
//                                 "avatar": "avatar/580000019/580000019_1340088820.jpg"
//                             }
//                             ]
//                }
//                
//}

#pragma mark - BaseInterfaceDelegate
-(void)parseResult:(NSDictionary *)responseDict{
    if (responseDict && [responseDict count] > 0) {
        NSMutableArray *userArray = [[NSMutableArray alloc] init];//返回结果
        
        NSDictionary *contentDict = [responseDict objectForKey:@"content"];
        if (contentDict.count > 0) {
            NSArray *list = [contentDict objectForKey:@"user"];
            for (NSDictionary *dict in list) {
                UserModel *user = [[UserModel alloc] init];
                user.userId = [dict objectForKey:@"userId"];
                user.name = [dict objectForKey:@"name"];
                user.avatarUrl = [dict objectForKey:@"avatar"];
                
                [userArray addObject:user];
                [user release];
            }
            UserModel *um = [[UserModel alloc] init];
            um.userId = [MySingleton sharedSingleton].userId;
            um.name = [MySingleton sharedSingleton].name;
            um.avatarUrl = [MySingleton sharedSingleton].avatarUrl;
            
            [userArray addObject:um];
            [um release];
            
            [self.delegate getUsersDidFinished:userArray];
            [userArray release];
        }else
        {
            [self.delegate getUsersDidFinished:nil];
        }
    }else{
        [self.delegate getUsersDidFinished:nil];
    }
}

-(void)requestIsFailed:(NSString *)errorMsg{
    [self.delegate getUsersDidFailed:errorMsg];
}

@end
