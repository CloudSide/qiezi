//
//  RemoveMediaInterface.m
//  Color
//
//  Created by chao han on 12-6-24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "RemoveMediaInterface.h"
#import "DeviceUtil.h"

@implementation RemoveMediaInterface

@synthesize delegate = _delegate;

-(void)removeMediaById:(NSString *)mediaId{
    self.needCacheFlag = NO;
    
    _mediaId = [mediaId retain];
    self.baseDelegate = self;
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:[DeviceUtil getMacAddress] forKey:@"deviceId"];
    [dict setObject:mediaId forKey:@"mediaId"];
    
    self.interfaceUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@/media/delete",[MySingleton sharedSingleton].baseInterfaceUrl]];
    self.postKeyValues = dict;
    [dict release];
    
    [self connect];
}

-(void)dealloc {
    self.delegate = nil;
    [_mediaId release];
    
    [super dealloc];
}

//{
//    "returncode": "0",
//}
#pragma mark - BaseInterfaceDelegate
-(void)parseResult:(NSDictionary *)responseDict{
    [self.delegate removeMediaByIdDidFinished:_mediaId];
}

-(void)requestIsFailed:(NSString *)errorMsg{
    [self.delegate removeMediaByIdDidFailed:errorMsg];
}
@end
