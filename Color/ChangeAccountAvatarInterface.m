//
//  ChangeAccountAvatarInterface.m
//  Color
//
//  Created by chao han on 12-6-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ChangeAccountAvatarInterface.h"
#import "DeviceUtil.h"
#import "UIImage+UIImageScale.h"

@implementation ChangeAccountAvatarInterface
@synthesize delegate = _delegate;

-(void)changeMyAvatar:(UIImage *)image{
    self.needCacheFlag = NO;
    
    self.baseDelegate = self;
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:[DeviceUtil getMacAddress] forKey:@"deviceId"];
    [dict setObject:[NSString stringWithFormat:@"%.11g",[MySingleton sharedSingleton].lon] forKey:@"lon"];
    [dict setObject:[NSString stringWithFormat:@"%.10g",[MySingleton sharedSingleton].lat] forKey:@"lat"];
    [dict setObject:@"jpg" forKey:@"format"];
    [dict setObject:[image image2String] forKey:@"avatar"];
    
    self.interfaceUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@/user/updateavatar",[MySingleton sharedSingleton].baseInterfaceUrl]];
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
//        "avatar": "http://12qiezi-12qiezi.stor.sinaapp.com/avatar/580000016/580000016_1340184196.gif"
//    }
//}

#pragma mark - BaseInterfaceDelegate
-(void)parseResult:(NSDictionary *)responseDict{
    if (responseDict && [responseDict count] > 0) {
        NSDictionary *content = [responseDict objectForKey:@"content"];
        [MySingleton sharedSingleton].avatarUrl = [content objectForKey:@"avatar"];
    }
    
    [self.delegate changeMyAvatarDidFinished];
}

-(void)requestIsFailed:(NSString *)errorMsg{
    [self.delegate changeMyAvatarDidFailed:errorMsg];
}

@end
