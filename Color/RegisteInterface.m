//
//  RegisteInterface.m
//  Color
//
//  Created by chao han on 12-5-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "RegisteInterface.h"
#import "DeviceUtil.h"
#import "JSONKit.h"

@implementation RegisteInterface
@synthesize request = _request , delegate = _delegate;

-(void)doRegiste:(NSString *)name avatar:(NSString *) avatar format:(NSString *)format email:(NSString *)email {
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/user/register",[MySingleton sharedSingleton].baseInterfaceUrl]];
    self.request = [ASIHTTPRequest requestWithURL:url];
    [self.request setTimeOutSeconds:15];
    
    NSMutableDictionary *requestDict = [[NSMutableDictionary alloc] init];
    [requestDict setObject:[DeviceUtil getMacAddress] forKey:@"deviceId"];
    [requestDict setObject:[NSString stringWithFormat:@"%.11g",[MySingleton sharedSingleton].lon] forKey:@"lon"];
    [requestDict setObject:[NSString stringWithFormat:@"%.10g",[MySingleton sharedSingleton].lat] forKey:@"lat"];
    
    [requestDict setObject:name forKey:@"name"];
    [requestDict setObject:avatar forKey:@"avatar"];
    [requestDict setObject:@"jpg" forKey:@"format"];
    [requestDict setObject:email forKey:@"email"];
    
    [self.request appendPostData:[[requestDict JSONString] dataUsingEncoding:NSUTF8StringEncoding]];
    [requestDict release];
    
    [self.request setDelegate:self];
    [self.request startAsynchronous]; 
    
}

#pragma mark - ASIHttpRequestDelegate
-(void)requestFinished:(ASIHTTPRequest *)request {    
    NSString *responseBody = request.responseString;
    NSDictionary *respDict = (NSDictionary *)[responseBody objectFromJSONString];
    if (respDict && [[respDict objectForKey:@"returncode"] intValue] == 0) {
        NSDictionary *respDictValue = (NSDictionary *)[respDict objectForKey:@"content"];
        [MySingleton sharedSingleton].sessionId = [respDictValue objectForKey:@"sessionId"];
        [MySingleton sharedSingleton].userId = [respDictValue objectForKey:@"userId"];
        [MySingleton sharedSingleton].name = [respDictValue objectForKey:@"name"];
        [MySingleton sharedSingleton].avatarUrl = [respDictValue objectForKey:@"avatar"];
        
        [self.delegate registeDidFinished];
        
    }else{
        NSInteger returncode = [[respDict objectForKey:@"returncode"] intValue];//失败
        NSLog(@"returncode : %d",returncode);
        
        [self.delegate registeDidFailed];
    }
}

-(void)requestFailed:(ASIHTTPRequest *)request {
    NSLog(@"%@",[[request error] localizedDescription]);
    [self.delegate registeDidFailed];
}

-(void)dealloc {
    [self.request clearDelegatesAndCancel];
    self.request = nil;
    
    [super dealloc];
}

@end
