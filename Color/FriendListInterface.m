//
//  FriendListInterface.m
//  Color
//
//  Created by chao han on 12-5-30.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "FriendListInterface.h"
#import "DeviceUtil.h"
#import "MySingleton.h"
#import "UserModel.h"

@implementation FriendListInterface

@synthesize delegate = _delegate;

-(void)getFriendList{
    self.baseDelegate = self;
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:[DeviceUtil getMacAddress] forKey:@"deviceId"];
    [dict setObject:[NSString stringWithFormat:@"%.11g",[MySingleton sharedSingleton].lon] forKey:@"lon"];
    [dict setObject:[NSString stringWithFormat:@"%.10g",[MySingleton sharedSingleton].lat] forKey:@"lat"];
    
    self.interfaceUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@/user/getfriendlist",[MySingleton sharedSingleton].baseInterfaceUrl]];
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
//    "content": [
//                {
//                    "userId": "580000005",
//                    "name": "abcddd",
//                    "avatar": "http://12qiezi-colorstorage.stor.sinaapp.com/avatar/580000005/580000005_1338050833.png"
//                }
//                ]
//}

#pragma mark - BaseInterfaceDelegate
-(void)parseResult:(NSDictionary *)responseDict{
    if (responseDict && [responseDict count] > 0) {
        NSMutableArray *friendArray = [[NSMutableArray alloc] init];//返回结果
        
        NSArray *content = [responseDict objectForKey:@"content"];
        
        for (NSDictionary *friendDict in content) {
            UserModel *fm = [[UserModel alloc] init];
            fm.userId = [friendDict objectForKey:@"userId"];
            fm.name = [friendDict objectForKey:@"name"];
            fm.avatarUrl = [friendDict objectForKey:@"avatar"];
            
            [friendArray addObject:fm];
            [fm release];
        }
        
        [self.delegate getFriendListDidFinished:friendArray];
        [friendArray release];
        
    }else{
        [self.delegate getFriendListDidFinished:nil];
    }
}

-(void)requestIsFailed:(NSString *)errorMsg{
    [self.delegate getFriendListDidFailed:errorMsg];
}



@end
