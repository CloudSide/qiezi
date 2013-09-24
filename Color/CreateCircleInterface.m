//
//  CreateCircleInterface.m
//  Color
//
//  Created by chao han on 12-6-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CreateCircleInterface.h"
#import "DeviceUtil.h"
#import "CircleModel.h"

@implementation CreateCircleInterface

@synthesize delegate = _delegate;

//创建 http://12qiezi.sinaapp.com/nearby/createcircle
//参数deviceId 返回 {"returncode":"0","content":{"circleid":123}}

-(void)createCircle{
    self.needCacheFlag = NO;
    
    self.baseDelegate = self;
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:[DeviceUtil getMacAddress] forKey:@"deviceId"];
    [dict setObject:[NSString stringWithFormat:@"%.11g",[MySingleton sharedSingleton].lon] forKey:@"lon"];
    [dict setObject:[NSString stringWithFormat:@"%.10g",[MySingleton sharedSingleton].lat] forKey:@"lat"];
    
    self.interfaceUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@/nearby/createcircle",[MySingleton sharedSingleton].baseInterfaceUrl]];
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
//        "circleid": 123
//        ,"ctime":"1341124227"
//    }
//}

#pragma mark - BaseInterfaceDelegate
-(void)parseResult:(NSDictionary *)responseDict{
    if (responseDict && [responseDict count] > 0) {
        NSDictionary *content = [responseDict objectForKey:@"content"];
        NSNumber *circleId = [content objectForKey:@"circleid"];
        
        [MySingleton sharedSingleton].currentCircleId = [circleId intValue];
        
        CircleModel *cm = [[CircleModel alloc] init];
        cm.cId = [NSString stringWithFormat:@"%d",[MySingleton sharedSingleton].currentCircleId];
        cm.ctime = [NSDate dateWithTimeIntervalSince1970:[[content objectForKey:@"ctime"]intValue]];
        
        [self.delegate createCircleDidFinished:cm];
        [cm release];
    }else{
        [self.delegate createCircleDidFailed:@"no circleId found"];
    }
}

-(void)requestIsFailed:(NSString *)errorMsg{
    [self.delegate createCircleDidFailed:errorMsg];
}


@end
