//
//  JoinCircleInterface.m
//  Color
//
//  Created by chao han on 12-6-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "JoinCircleInterface.h"
#import "DeviceUtil.h"

@implementation JoinCircleInterface
@synthesize delegate = _delegate;

-(void)joinCircleById:(NSInteger) cid{
    self.needCacheFlag = NO;
    
    self.baseDelegate = self;
    circleId = cid;
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:[DeviceUtil getMacAddress] forKey:@"deviceId"];
    [dict setObject:[NSString stringWithFormat:@"%d",cid] forKey:@"circleId"];
    
    self.interfaceUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@/nearby/joincircle",[MySingleton sharedSingleton].baseInterfaceUrl]];
    self.postKeyValues = dict;
    [dict release];
    
    [self connect];
}

-(void)dealloc {
    self.delegate = nil;
    
    [super dealloc];
}

#pragma mark - BaseInterfaceDelegate
-(void)parseResult:(NSDictionary *)responseDict{
    [self.delegate joinCircleDidFinished:circleId];
}

-(void)requestIsFailed:(NSString *)errorMsg{
    [self.delegate joinCircleDidFailed:errorMsg];
}



@end
