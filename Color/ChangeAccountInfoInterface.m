//
//  ChangeAccountInfoInterface.m
//  Color
//
//  Created by chao han on 12-6-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ChangeAccountInfoInterface.h"
#import "DeviceUtil.h"

@implementation ChangeAccountInfoInterface
@synthesize delegate = _delegate;

-(void)changeAccountInfo:(NSString *)name tel:(NSString *)tel{
    self.needCacheFlag = NO;
    
    self.baseDelegate = self;
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:[DeviceUtil getMacAddress] forKey:@"deviceId"];
    [dict setObject:[NSString stringWithFormat:@"%.11g",[MySingleton sharedSingleton].lon] forKey:@"lon"];
    [dict setObject:[NSString stringWithFormat:@"%.10g",[MySingleton sharedSingleton].lat] forKey:@"lat"];
    [dict setObject:name forKey:@"name"];
    
    self.interfaceUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@/user/updateuserinfo",[MySingleton sharedSingleton].baseInterfaceUrl]];
    self.postKeyValues = dict;
    [dict release];
    
    [self connect];
}

-(void)dealloc {
    self.delegate = nil;
    
    [super dealloc];
}

-(void)parseResult:(NSDictionary *)responseDict{
    
    [self.delegate changeAccountInfoDidFinished];
}

-(void)requestIsFailed:(NSString *)errorMsg{
    [self.delegate changeAccountInfoDidFailed:errorMsg];
}

@end
