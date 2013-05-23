//
//  DynamicInterface.m
//  Color
//
//  Created by chao han on 12-5-30.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "DynamicInterface.h"
#import "DeviceUtil.h"
#import "MediaModel.h"
#import "UserModel.h"

@implementation DynamicInterface
@synthesize delegate = _delegate;
-(void)getDynamicListByStartTime:(NSTimeInterval)startTime{
    isForPullRefresh = NO;
    self.baseDelegate = self;
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:[DeviceUtil getMacAddress] forKey:@"deviceId"];
    [dict setObject:[NSString stringWithFormat:@"%d",(NSInteger)startTime] forKey:@"startTime"];
    
    self.interfaceUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@/media/dynamic",[MySingleton sharedSingleton].baseInterfaceUrl]];
    self.postKeyValues = dict;
    [dict release];
    
    [self connect];
}
-(void)getDynamicListByEndTime:(NSTimeInterval)endTime{
    isForPullRefresh = YES;
    self.baseDelegate = self;
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:[DeviceUtil getMacAddress] forKey:@"deviceId"];
    
    [dict setObject:[NSString stringWithFormat:@"%d",(NSInteger)endTime] forKey:@"endTime"];
    
    self.interfaceUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@/media/dynamic",[MySingleton sharedSingleton].baseInterfaceUrl]];
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
        NSArray *dynamiclist = [content objectForKey:@"list"];
        for (NSDictionary *picArrayInDynamic in dynamiclist) {
            NSMutableDictionary *dynamic = [NSMutableDictionary dictionary];
            [mediaArray addObject:dynamic];
            
            NSArray *userNames = [picArrayInDynamic objectForKey:@"users"];
            [dynamic setObject:userNames forKey:@"userNames"];
            
            NSNumber *num = [picArrayInDynamic objectForKey:@"num"];
            [dynamic setObject:num forKey:@"num"];

            NSArray *medias = [picArrayInDynamic objectForKey:@"medias"];
            NSMutableArray *picArray = [NSMutableArray array];
            [dynamic setObject:picArray forKey:@"picArray"];
            
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
                
                [picArray addObject:mediaModel];
                
                if (i == 0) {
                    [dynamic setObject:mediaModel.ctime forKey:@"date"];
                    [dynamic setObject:[media objectForKey:@"circleId"] forKey:@"circleId"];
                }
                
                ++i;
            }
        }
                
        if (isForPullRefresh) {
            [self.delegate getDynamicListByTimeDidFinished:mediaArray];
        }else{
            [self.delegate getDynamicListDidFinished:mediaArray];
        }
        [mediaArray release];
        
    }else{
        if (isForPullRefresh) {
            [self.delegate getDynamicListByTimeDidFinished:nil];
        }else{
            [self.delegate getDynamicListDidFinished:nil];
        }
    }
}

-(void)requestIsFailed:(NSString *)errorMsg{
    if (isForPullRefresh) {
        [self.delegate getDynamicListByTimeDidFailed:errorMsg];
    }else{
        [self.delegate getDynamicListDidFailed:errorMsg];
    }
    
}

@end
