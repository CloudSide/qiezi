//
//  GetUserInfoInterface.m
//  Color
//
//  Created by chao han on 12-6-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "GetUserInfoInterface.h"
#import "DeviceUtil.h"
#import "UserModel.h"

@implementation GetUserInfoInterface
@synthesize delegate = _delegate;

-(void)getUserInfoByUserId:(NSString *)userId
{
    self.baseDelegate = self;
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:[DeviceUtil getMacAddress] forKey:@"deviceId"];
    [dict setObject:[NSString stringWithFormat:@"%.11g",[MySingleton sharedSingleton].lon] forKey:@"lon"];
    [dict setObject:[NSString stringWithFormat:@"%.10g",[MySingleton sharedSingleton].lat] forKey:@"lat"];
    
    [dict setObject:userId?userId:@"" forKey:@"userId"];
    
    self.interfaceUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@/user/getuserinfo",[MySingleton sharedSingleton].baseInterfaceUrl]];
    self.postKeyValues = dict;
    [dict release];
    
    [self connect];
}

-(void)dealloc {
    self.delegate = nil;
    
    [super dealloc];
}

//{
//returncode: "0",
//content: [
//          {
//              "userId": "580000009",
//              "name": "\u6807\u54e5",
//              "avatar": "http:\/\/12qiezi-12qiezi.stor.sinaapp.com\/avatar\/580000009\/580000009_1338540631.jpg"
//          }
//          ]
//}

#pragma mark - BaseInterfaceDelegate
-(void)parseResult:(NSDictionary *)responseDict{
    if (responseDict && [responseDict count] > 0) {
        NSArray *content = [responseDict objectForKey:@"content"];
        
        if ([content count]>0) {
            NSDictionary *dict = [content objectAtIndex:0];
            UserModel *user = [[UserModel alloc] init];
            user.userId = [dict objectForKey:@"userId"];
            user.name = [dict objectForKey:@"name"];
            user.avatarUrl = [dict objectForKey:@"avatar"];
            
            [self.delegate getUserInfoByUserIdDidFinished:user];
            [user release];
        }
    }else{
        [self.delegate getUserInfoByUserIdDidFinished:nil];
    }
}

-(void)requestIsFailed:(NSString *)errorMsg{
    [self.delegate getUserInfoByUserIdDidFailed:errorMsg];
}


@end
