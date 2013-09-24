//
//  CircleByTimestampHeartbeatInterface.m
//  Color
//
//  Created by chao han on 12-6-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CircleByTimestampHeartbeatInterface.h"
#import "DeviceUtil.h"
#import "CircleModel.h"
#import "UserModel.h"

@implementation CircleByTimestampHeartbeatInterface
@synthesize delegate = _delegate;

-(void)getCircleByTimestamp:(NSTimeInterval) timestamp
{
    self.needCacheFlag = NO;
    
    self.baseDelegate = self;
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:[DeviceUtil getMacAddress] forKey:@"deviceId"];
    [dict setObject:[NSString stringWithFormat:@"%.11g",[MySingleton sharedSingleton].lon] forKey:@"lon"];
    [dict setObject:[NSString stringWithFormat:@"%.10g",[MySingleton sharedSingleton].lat] forKey:@"lat"];
    [dict setObject:[NSString stringWithFormat:@"%d",(NSInteger)timestamp] forKey:@"timestamp"];
    
    self.interfaceUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@/user/circlebytimestamp",[MySingleton sharedSingleton].baseInterfaceUrl]];
    self.postKeyValues = dict;
    [dict release];
    
    [self connect];
}

-(void)dealloc {
    self.delegate = nil;
    
    [super dealloc];
}

//{
//    "returncode": "0",
//    "content": {
//        "circle": [
//                   {
//                       "circleId": "179",
//                       "user": [
//                                {
//                                    "userId": "580000009",
//                                    "name": "标哥",
//                                    "avatar": "http://12qiezi-12qiezi.stor.sinaapp.com/avatar/580000009/580000009_1338540631.jpg"
//                                }
//                                ],
//                       "ctime": "1339460760"
//                   }
//                   ]
//    }
//}

#pragma mark - BaseInterfaceDelegate
-(void)parseResult:(NSDictionary *)responseDict{
    if (responseDict && [responseDict count] > 0) {
        NSMutableArray *circleArray = [[NSMutableArray alloc] init];//返回结果
        
        NSDictionary *content = [responseDict objectForKey:@"content"];
        NSArray *circles = [content objectForKey:@"circle"];
        
        for (NSDictionary *circleDict in circles) {
            CircleModel *cir = [[CircleModel alloc] init];
            cir.cId = [circleDict objectForKey:@"circleId"];
            cir.ctime = [NSDate dateWithTimeIntervalSince1970:[[circleDict objectForKey:@"ctime"]intValue]];
            
            NSArray *users = [circleDict objectForKey:@"user"];
            NSMutableArray *userArray = [[[NSMutableArray alloc] init] autorelease];
            cir.usersArray = userArray;
            for (NSDictionary *userDict in users) {
                UserModel *userModel = [[[UserModel alloc] init] autorelease];
                userModel.userId = [userDict objectForKey:@"userId"];
                userModel.name = [userDict objectForKey:@"name"];
                userModel.avatarUrl = [userDict objectForKey:@"avatar"];
                
                [userArray addObject:userModel];
            }
            
            [circleArray addObject:cir];
            [cir release];
        }
        
        [self.delegate getCircleByTimestampDidFinished:circleArray];
        [circleArray release];
        
    }else{
        [self.delegate getCircleByTimestampDidFinished:nil];
    }
}

-(void)requestIsFailed:(NSString *)errorMsg{
    [self.delegate getCircleByTimestampDidFailed:errorMsg];
}


@end
