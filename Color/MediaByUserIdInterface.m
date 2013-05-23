//
//  MediaByUserIdInterface.m
//  Color
//
//  Created by chao han on 12-6-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MediaByUserIdInterface.h"
#import "DeviceUtil.h"
#import "MediaModel.h"
#import "UserModel.h"

@implementation MediaByUserIdInterface
@synthesize delegate = _delegate;
-(void)getMediaByUserIdListByStartTime:(NSTimeInterval)startTime userId:(NSString *)userId{
    isForPullRefresh = NO;
    self.baseDelegate = self;
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:[DeviceUtil getMacAddress] forKey:@"deviceId"];
    [dict setObject:[NSString stringWithFormat:@"%d",(NSInteger)startTime] forKey:@"startTime"];
    [dict setObject:userId?userId:@"" forKey:@"userId"];
    
    self.interfaceUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@/media/getbyuserid",[MySingleton sharedSingleton].baseInterfaceUrl]];
    self.postKeyValues = dict;
    [dict release];
    
    [self connect];
}

-(void)getMediaByUserIdListByEndTime:(NSTimeInterval)endTime userId:(NSString *)userId{
    isForPullRefresh = YES;
    self.baseDelegate = self;
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:[DeviceUtil getMacAddress] forKey:@"deviceId"];
    [dict setObject:[NSString stringWithFormat:@"%d",(NSInteger)endTime] forKey:@"endTime"];
    [dict setObject:userId forKey:@"userId"];
    self.interfaceUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@/media/getbyuserid",[MySingleton sharedSingleton].baseInterfaceUrl]];
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
        NSMutableArray *mediaArray = [[NSMutableArray alloc] init];
        NSDictionary *content = [responseDict objectForKey:@"content"];
        NSArray *list = [content objectForKey:@"list"];
        for (NSArray *medias in list) {
            NSMutableDictionary *days = [NSMutableDictionary dictionary];
            [mediaArray addObject:days];
            NSMutableArray *mediaArray = [NSMutableArray array];
            [days setObject:mediaArray forKey:@"mediaArray"];
            NSInteger i = 0;
            for (NSDictionary *media in medias) {
                MediaModel *mediaModel = [[[MediaModel alloc] init] autorelease];
                mediaModel.mid = [media objectForKey:@"mediaId"];
                mediaModel.ctime = [NSDate dateWithTimeIntervalSince1970:[[media objectForKey:@"ctime"]intValue]];
                mediaModel.circleId = [media objectForKey:@"circleId"];
                mediaModel.originalUrl = [media objectForKey:@"originalUrl"];
                mediaModel.thumbnailUrl = [media objectForKey:@"thumbnailUrl"];
                mediaModel.comCount = [[media objectForKey:@"comCount"] intValue];
                mediaModel.goodCount = [[media objectForKey:@"goodCount"] intValue];
                mediaModel.mediaType = [[media objectForKey:@"type"] intValue];
                
                NSDictionary *userDict = [media objectForKey:@"user"];
                UserModel *userModel = [[[UserModel alloc] init] autorelease];
                userModel.userId = [userDict objectForKey:@"userId"];
                userModel.name = [userDict objectForKey:@"name"];
                userModel.avatarUrl = [userDict objectForKey:@"avatar"];
                mediaModel.owner = userModel;
                
                [mediaArray addObject:mediaModel];
                
                if (i == 0) {
                    [days setObject:mediaModel.ctime forKey:@"date"];
                }
                
                ++i;
            }
        }
        
        if (isForPullRefresh) {
            [self.delegate getMediaByUserIdListByTimeDidFinished:mediaArray];
        }else{
            [self.delegate getMediaByUserIdListDidFinished:mediaArray];
        }
        [mediaArray release];
        
    }else{
        if (isForPullRefresh) {
            [self.delegate getMediaByUserIdListByTimeDidFailed:nil];
        }else{
            [self.delegate getMediaByUserIdListDidFailed:nil];
        }
    }
}

-(void)requestIsFailed:(NSString *)errorMsg{
    if (isForPullRefresh) {
        [self.delegate getMediaByUserIdListByTimeDidFailed:errorMsg];
    }else{
        [self.delegate getMediaByUserIdListDidFailed:errorMsg];
    }
}

@end
