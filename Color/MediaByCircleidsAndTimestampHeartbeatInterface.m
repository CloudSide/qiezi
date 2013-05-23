//
//  MediaByCircleidsAndTimestampHeartbeatInterface.m
//  Color
//
//  Created by chao han on 12-6-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MediaByCircleidsAndTimestampHeartbeatInterface.h"
#import "DeviceUtil.h"
#import "MediaModel.h"
#import "UserModel.h"

@implementation MediaByCircleidsAndTimestampHeartbeatInterface
@synthesize delegate = _delegate;

-(void)getMediaByCircleids:(NSString *)cidStr timestamp:(NSTimeInterval)timestamp
{
    self.needCacheFlag = NO;
    
    self.baseDelegate = self;
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:[DeviceUtil getMacAddress] forKey:@"deviceId"];
    [dict setObject:[NSString stringWithFormat:@"%.11g",[MySingleton sharedSingleton].lon] forKey:@"lon"];
    [dict setObject:[NSString stringWithFormat:@"%.10g",[MySingleton sharedSingleton].lat] forKey:@"lat"];
    [dict setObject:cidStr forKey:@"circleids"];
    [dict setObject:[NSString stringWithFormat:@"%d",(NSInteger)timestamp] forKey:@"timestamp"];
    
    self.interfaceUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@/user/picbycircleidsandbytimestamp",[MySingleton sharedSingleton].baseInterfaceUrl]];
    self.postKeyValues = dict;
    [dict release];
    
    [self connect];
}

-(void)dealloc {
    self.delegate = nil;
    
    [super dealloc];
}
-(void)parseResult:(NSDictionary *)responseDict{
    if (responseDict && [responseDict count] > 0) {
        NSMutableDictionary *mediaDictionary = [[NSMutableDictionary alloc] init];
        
        NSDictionary *content = [responseDict objectForKey:@"content"];
        NSArray *mediaArray = [content objectForKey:@"media"];
        
        for (NSDictionary *dict in mediaArray) {
            if (![[MySingleton sharedSingleton].userId isEqualToString:[dict objectForKey:@"userId"]]) {
                MediaModel *mediaModel = [[MediaModel alloc] init];
                mediaModel.mid = [dict objectForKey:@"mediaId"];
                mediaModel.ctime = [NSDate dateWithTimeIntervalSince1970:[[dict objectForKey:@"ctime"]intValue]];
                mediaModel.mediaType = [[dict objectForKey:@"type"] intValue];
                mediaModel.circleId = [dict objectForKey:@"circleId"];
                mediaModel.originalUrl = [dict objectForKey:@"originalUrl"];
                mediaModel.thumbnailUrl = [dict objectForKey:@"thumbnailUrl"];
                mediaModel.comCount = [[dict objectForKey:@"comCount"] intValue];
                mediaModel.goodCount = [[dict objectForKey:@"goodCount"] intValue];
                
                UserModel *user = [[UserModel alloc] init];
                user.userId = [dict objectForKey:@"userId"];
                mediaModel.owner = user;
                [user release];
                
                NSMutableArray *marray = [mediaDictionary objectForKey:mediaModel.circleId];
                if (marray == nil) {
                    marray = [[NSMutableArray alloc] init];
                    [mediaDictionary setObject:marray forKey:mediaModel.circleId];
                    [marray release];
                }
                
                [marray addObject:mediaModel];
                [mediaModel release];
            }
        }
        
        [self.delegate getMediaByCircleidsAndTimestampDidFinished:mediaDictionary];
        [mediaDictionary release];
        
    }else{
        [self.delegate getMediaByCircleidsAndTimestampDidFinished:nil];
    }
}

-(void)requestIsFailed:(NSString *)errorMsg{
    [self.delegate getMediaByCircleidsAndTimestampDidFailed:errorMsg];
}
@end
