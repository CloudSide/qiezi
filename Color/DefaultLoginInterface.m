//
//  DefaultLoginInterface.m
//  ZReader_HD
//
//  Created by  on 12-3-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "DefaultLoginInterface.h"
#import "DeviceUtil.h"
#import "ASIHTTPRequest.h"
#import "JSONKit.h"
#import "MySingleton.h"


@implementation DefaultLoginInterface

@synthesize delegate = _delegate;


-(void)doLogin {
   
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/user/checkdevice",[MySingleton sharedSingleton].baseInterfaceUrl]];
    _request = [ASIHTTPRequest requestWithURL:url];
    [_request setTimeOutSeconds:15];
    

    NSMutableDictionary *requestDict = [[NSMutableDictionary alloc] init];
    [requestDict setObject:[DeviceUtil getMacAddress] forKey:@"deviceId"];
    [requestDict setObject:@"1" forKey:@"version"];//当前版本号
    
    
    [_request appendPostData:[[requestDict JSONString] dataUsingEncoding:NSUTF8StringEncoding]];
    [requestDict release];
    
    [_request setDelegate:self];
    [_request startAsynchronous]; 
    
}

//{
//    "returncode": 0,
//    "content": {
//        "isNew": 0,
//        "userId": "580000010",
//        "name": "qqq",
//        "avatar": "http://12qiezi-12qiezi.stor.sinaapp.com/avatar/580000010/580000010_1338607311.jpg",
//        "sessionId": "90f4aee4baecd01d1b88456d85caac9e"
//        "url":"http://www.12qiezi.com"
//    }
//}

#pragma mark - ASIHttpRequestDelegate
-(void)requestFinished:(ASIHTTPRequest *)request {    
    NSString *responseBody = request.responseString;

    NSDictionary *respDict = (NSDictionary *)[responseBody objectFromJSONString];
    if (respDict && [[respDict objectForKey:@"returncode"] intValue] == 0) {
        NSDictionary *respDictValue = (NSDictionary *)[respDict objectForKey:@"content"];
        NSString *sessionId = [respDictValue objectForKey:@"sessionId"];
        NSInteger isNew = [[respDictValue objectForKey:@"isNew"] intValue];
        NSString *url = [respDictValue objectForKey:@"url"];
        [MySingleton sharedSingleton].updateUrl = url;
        
        if (isNew == 0) {//老用户
            [MySingleton sharedSingleton].sessionId = sessionId;
            [MySingleton sharedSingleton].name = [respDictValue objectForKey:@"name"];
            [MySingleton sharedSingleton].avatarUrl = [respDictValue objectForKey:@"avatar"];
            [MySingleton sharedSingleton].userId = [respDictValue objectForKey:@"userId"];
        }
        
        if (_delegate) {
            [_delegate loginDidFinished:isNew updateUrl:url];
        }
    }else{
        NSInteger returncode = [[respDict objectForKey:@"returncode"] intValue];//失败
        NSLog(@"returncode : %d",returncode);
        
        if (_delegate) {
            [_delegate loginDidFailed];
        }
    }
}

-(void)requestFailed:(ASIHTTPRequest *)request {
    if (_delegate) {
        [_delegate loginDidFailed];
    }
}

-(void)dealloc {
    self.delegate = nil;
    [_request clearDelegatesAndCancel];
    
    [super dealloc];
}

@end
