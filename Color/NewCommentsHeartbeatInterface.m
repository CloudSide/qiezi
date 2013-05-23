//
//  NewCommentsHeartbeatInterface.m
//  Color
//
//  Created by chao han on 12-6-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "NewCommentsHeartbeatInterface.h"
#import "DeviceUtil.h"

@implementation NewCommentsHeartbeatInterface

@synthesize delegate = _delegate;

-(void)getNewCommentsAmount{
    self.needCacheFlag = NO;
    
    self.baseDelegate = self;
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:[DeviceUtil getMacAddress] forKey:@"deviceId"];
    [dict setObject:[NSString stringWithFormat:@"%.11g",[MySingleton sharedSingleton].lon] forKey:@"lon"];
    [dict setObject:[NSString stringWithFormat:@"%.10g",[MySingleton sharedSingleton].lat] forKey:@"lat"];
    
//    NSLog(@"lon:[%@] lat:[%@]",[dict objectForKey:@"lon"],[dict objectForKey:@"lat"]);
    
    self.interfaceUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@/user/newcomments",[MySingleton sharedSingleton].baseInterfaceUrl]];
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
    if (responseDict && [responseDict count] > 0) {
        NSNumber *commentAmount = [responseDict objectForKey:@"commentAmount"];
        
        [self.delegate getNewCommentsAmountDidFinished:[commentAmount intValue]];
        
    }else{
        [self.delegate getNewCommentsAmountDidFinished:0];
    }
}

-(void)requestIsFailed:(NSString *)errorMsg{
    [self.delegate getNewCommentsAmountDidFailed:errorMsg];
}


@end
