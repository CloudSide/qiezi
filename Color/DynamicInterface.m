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

//根据结束时间获取以往图片列表
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



//根据时间段获取列表---用于下拉刷新
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

//{
//    "returncode": "0",
//    "content": {
//        "list": [
//                 {
//                     "medias": [
//                                {
//                                    "mediaId": "580000010_1338619254",
//                                    "ctime": "1338619254",
//                                    "circleId": "104",
//                                    "originalUrl": "http://12qiezi-12qiezi.stor.sinaapp.com/original/580000010/580000010_1338619254.jpg",
//                                    "thumbnailUrl": "http://12qiezi-12qiezi.stor.sinaapp.com/thumbnail/580000010/small_580000010_1338619254.jpg",
//                                    "comCount": "0",
//                                    "goodCount": "0",
//                                    "type": 0
//                                },
//                                {
//                                    "mediaId": "580000010_1338619234",
//                                    "ctime": "1338619234",
//                                    "circleId": "104",
//                                    "originalUrl": "http://12qiezi-12qiezi.stor.sinaapp.com/original/580000010/580000010_1338619234.jpg",
//                                    "thumbnailUrl": "http://12qiezi-12qiezi.stor.sinaapp.com/thumbnail/580000010/small_580000010_1338619234.jpg",
//                                    "comCount": "0",
//                                    "goodCount": "0",
//                                    "type": 0
//                                },
//                                {
//                                    "mediaId": "580000010_1338618834",
//                                    "ctime": "1338618834",
//                                    "circleId": "104",
//                                    "originalUrl": "http://12qiezi-12qiezi.stor.sinaapp.com/original/580000010/580000010_1338618834.jpg",
//                                    "thumbnailUrl": "http://12qiezi-12qiezi.stor.sinaapp.com/thumbnail/580000010/small_580000010_1338618834.jpg",
//                                    "comCount": "0",
//                                    "goodCount": "0",
//                                    "type": 0
//                                },
//                                {
//                                    "mediaId": "580000010_1338618807",
//                                    "ctime": "1338618807",
//                                    "circleId": "104",
//                                    "originalUrl": "http://12qiezi-12qiezi.stor.sinaapp.com/original/580000010/580000010_1338618807.jpg",
//                                    "thumbnailUrl": "http://12qiezi-12qiezi.stor.sinaapp.com/thumbnail/580000010/small_580000010_1338618807.jpg",
//                                    "comCount": "0",
//                                    "goodCount": "0",
//                                    "type": 0
//                                }
//                                ],
//                     "users": [
//                               "qqq"
//                               ]
//                 },
//                 {
//                     "medias": [
//                                {
//                                    "mediaId": "580000010_1338609662",
//                                    "ctime": "1338609662",
//                                    "circleId": "95",
//                                    "originalUrl": "http://12qiezi-12qiezi.stor.sinaapp.com/original/580000010/580000010_1338609662.jpg",
//                                    "thumbnailUrl": "http://12qiezi-12qiezi.stor.sinaapp.com/thumbnail/580000010/small_580000010_1338609662.jpg",
//                                    "comCount": "0",
//                                    "goodCount": "0",
//                                    "type": 0
//                                }
//                                ],
//                     "users": [
//                               "qqq"
//                               ]
//                 }
//                 ],
//        "user": null,
//        "currentpage": 0,
//        "totalpage": 0
//    }
//}

#pragma mark - BaseInterfaceDelegate
-(void)parseResult:(NSDictionary *)responseDict{
    if (responseDict && [responseDict count] > 0) {
        NSMutableArray *mediaArray = [[NSMutableArray alloc] init];//返回多次动态结果
        
        NSDictionary *content = [responseDict objectForKey:@"content"];
        NSArray *dynamiclist = [content objectForKey:@"list"];//多次动态
        
        for (NSDictionary *picArrayInDynamic in dynamiclist) {
            //一次动态的dict
            NSMutableDictionary *dynamic = [NSMutableDictionary dictionary];
            [mediaArray addObject:dynamic];
            
            NSArray *userNames = [picArrayInDynamic objectForKey:@"users"];//圈子成员人名
            [dynamic setObject:userNames forKey:@"userNames"];
            
            NSNumber *num = [picArrayInDynamic objectForKey:@"num"];//media数量
            [dynamic setObject:num forKey:@"num"];

            NSArray *medias = [picArrayInDynamic objectForKey:@"medias"];
            NSMutableArray *picArray = [NSMutableArray array];//该次动态的照片和视频
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
