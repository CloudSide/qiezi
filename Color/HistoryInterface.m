//
//  HistoryInterface.m
//  Color
//
//  Created by chao han on 12-5-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "HistoryInterface.h"
#import "DeviceUtil.h"
#import "MediaModel.h"
#import "UserModel.h"

@implementation HistoryInterface
@synthesize delegate = _delegate;

//根据结束时间获取以往图片列表
-(void)getHistoryListByStartTime:(NSTimeInterval)startTime{
    isForPullRefresh = NO;
    self.baseDelegate = self;
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:[DeviceUtil getMacAddress] forKey:@"deviceId"];
    [dict setObject:[NSString stringWithFormat:@"%d",(NSInteger)startTime] forKey:@"startTime"];
    
    self.interfaceUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@/media/history",[MySingleton sharedSingleton].baseInterfaceUrl]];
    self.postKeyValues = dict;
    [dict release];
    
    [self connect];
}

//根据时间段获取列表---用于下拉刷新
-(void)getHistoryListByEndTime:(NSTimeInterval)endTime{
    isForPullRefresh = YES;
    self.baseDelegate = self;
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:[DeviceUtil getMacAddress] forKey:@"deviceId"];
    [dict setObject:[NSString stringWithFormat:@"%d",(NSInteger)endTime] forKey:@"endTime"];
    
    self.interfaceUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@/media/history",[MySingleton sharedSingleton].baseInterfaceUrl]];
    self.postKeyValues = dict;
    [dict release];
    
    [self connect];
}

-(void)dealloc {
    self.delegate = nil;
    
    [super dealloc];
}

//{
//    "returncode": "10000",
//    "content": {
//        "list": [
//                 [
//                               {
//                                   "mediaId": "580000003_1338003354",
//                                   "ctime": "1338003354",
//                                   "circleId": "13",
//                                   "originalUrl": "http://12qiezi-12qiezi.stor.sinaapp.com/original/580000003/580000003_1338003354.mov",
//                                   "thumbnailUrl": "http://12qiezi-12qiezi.stor.sinaapp.com/thumbnail/580000003/small_580000003_1338003354.jpg",
//                                   "comCount": "0",
//                                   "goodCount": "0",
//                                   "user": {
//                                       "userId": "580000003",
//                                       "name": "sfh",
//                                       "avatar": "http://12qiezi-12qiezi.stor.sinaapp.com/avatar/580000003/580000003_1338002076.JPEG"
//                                   }
//                               },
//                               {
//                                   "mediaId": "580000003_1338003354",
//                                   "ctime": "1338003354",
//                                   "circleId": "13",
//                                   "originalUrl": "http://12qiezi-12qiezi.stor.sinaapp.com/original/580000003/580000003_1338003354.mov",
//                                   "thumbnailUrl": "http://12qiezi-12qiezi.stor.sinaapp.com/thumbnail/580000003/small_580000003_1338003354.jpg",
//                                   "comCount": "0",
//                                   "goodCount": "0",
//                                   "user": {
//                                       "userId": "580000003",
//                                       "name": "sfh",
//                                       "avatar": "http://12qiezi-12qiezi.stor.sinaapp.com/avatar/580000003/580000003_1338002076.JPEG"
//                                   }
//                               }
//                               ]
//                 
//                 ]],
//        "currentpage": 1,
//        "totalpage": 1
//    }
//}

#pragma mark - BaseInterfaceDelegate
-(void)parseResult:(NSDictionary *)responseDict{
    if (responseDict && [responseDict count] > 0) {
        NSMutableArray *mediaArray = [[NSMutableArray alloc] init];//返回结果
        
        NSDictionary *content = [responseDict objectForKey:@"content"];
        NSArray *list = [content objectForKey:@"list"];//多天

        for (NSArray *medias in list) {
            //一天的dict
            NSMutableDictionary *days = [NSMutableDictionary dictionary];
//            [days setObject:[NSDate dateWithTimeIntervalSince1970:[[dict objectForKey:@"date"]intValue]] forKey:@"date"];
            [mediaArray addObject:days];
            
            //该天的照片和视频
            NSMutableArray *mediaArray = [NSMutableArray array];
            [days setObject:mediaArray forKey:@"mediaArray"];
            
//            NSArray *medias = [dict objectForKey:@"media"];
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
            [self.delegate getHistoryListByTimeDidFinished:mediaArray];
        }else{
            [self.delegate getHistoryListDidFinished:mediaArray];
        }
        [mediaArray release];
        
    }else{
        if (isForPullRefresh) {
            [self.delegate getHistoryListByTimeDidFinished:nil];
        }else{
            [self.delegate getHistoryListDidFinished:nil];
        }
    }
}

-(void)requestIsFailed:(NSString *)errorMsg{
    if (isForPullRefresh) {
        [self.delegate getHistoryListByTimeDidFailed:errorMsg];
    }else{
        [self.delegate getHistoryListDidFailed:errorMsg];
    }
}
@end
