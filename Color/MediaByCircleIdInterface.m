//
//  MediaByCircleIdInterface.m
//  Color
//
//  Created by chao han on 12-6-1.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MediaByCircleIdInterface.h"
#import "DeviceUtil.h"
#import "MediaModel.h"
#import "UserModel.h"
#import "CommentModel.h"
#import "NSString+URLEncoding.h"

@implementation MediaByCircleIdInterface
@synthesize delegate = _delegate ;

//根据结束时间获取以往图片列表
-(void)getMediaByCircleId:(NSString *)circleId startTime:(NSTimeInterval)startTime{
    isForPullRefresh = NO;
    
    self.baseDelegate = self;
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:[DeviceUtil getMacAddress] forKey:@"deviceId"];
    [dict setObject:circleId forKey:@"circleId"];
    [dict setObject:[NSString stringWithFormat:@"%d",(NSInteger)startTime] forKey:@"startTime"];
    
    self.interfaceUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@/media/getbycircleid",[MySingleton sharedSingleton].baseInterfaceUrl]];
    self.postKeyValues = dict;
    [dict release];
    
    [self connect];
}


//根据时间段获取列表---用于下拉刷新
-(void)getMediaByCircleId:(NSString *)circleId endTime:(NSTimeInterval)endTime{
    isForPullRefresh = YES;
    self.baseDelegate = self;
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:[DeviceUtil getMacAddress] forKey:@"deviceId"];
    [dict setObject:circleId forKey:@"circleId"];
    [dict setObject:[NSString stringWithFormat:@"%d",(NSInteger)endTime] forKey:@"endTime"];
    
    self.interfaceUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@/media/getbycircleid",[MySingleton sharedSingleton].baseInterfaceUrl]];
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
//                     "mediaId": "580000003_1338212658",
//                     "ctime": "1338212658",
//                     "originalUrl": "http://12qiezi-12qiezi.stor.sinaapp.com/original/580000003/580000003_1338212658.jpg",
//                     "thumbnailUrl": "http://12qiezi-12qiezi.stor.sinaapp.com/thumbnail/580000003/small_580000003_1338212658.jpg",
//                     "comCount": "0",
//                     "goodCount": "0",
//                    "mygood": 0,
//                     "comment": [
//                                {
//                                  "name": "p",
//                                  "content": "法庭巨响"
//                                }
//                     ],
//                    "loction": {
//                        "province": "北京市",
//                        "city": "北京市",
//                        "district": "海淀区"
//                    },
//                     "user": {
//                         "userId": "580000003",
//                         "name": "sfh",
//                         "avatar": "http://12qiezi-12qiezi.stor.sinaapp.com/avatar/580000003/580000003_1338002076.JPEG"
//                     }
//                 }
//                 ],
//        "currentpage": 1,
//        "totalpage": 1
//    }
//}
#pragma mark - BaseInterfaceDelegate
-(void)parseResult:(NSDictionary *)responseDict{
    if (responseDict && [responseDict count] > 0) {
        NSMutableArray *mediaArray = [[NSMutableArray alloc] init];//返回结果
        
        NSDictionary *content = [responseDict objectForKey:@"content"];
        NSArray *list = [content objectForKey:@"list"];
        for (NSDictionary *media in list) {
            MediaModel *mediaModel = [[[MediaModel alloc] init] autorelease];
            mediaModel.mid = [media objectForKey:@"mediaId"];
            mediaModel.ctime = [NSDate dateWithTimeIntervalSince1970:[[media objectForKey:@"ctime"]intValue]];
            mediaModel.circleId = [media objectForKey:@"circleId"];
            mediaModel.originalUrl = [media objectForKey:@"originalUrl"];
            mediaModel.thumbnailUrl = [media objectForKey:@"thumbnailUrl"];
            mediaModel.comCount = [[media objectForKey:@"comCount"] intValue];
            mediaModel.goodCount = [[media objectForKey:@"goodCount"] intValue];
            mediaModel.mediaType = [[media objectForKey:@"type"] intValue];
            mediaModel.hasMygood = [[media objectForKey:@"mygood"] intValue] > 0 ? YES : NO;
            
            NSDictionary *loctionDict = [media objectForKey:@"loction"];
            mediaModel.city = [loctionDict objectForKey:@"city"];
            
            NSDictionary *userDict = [media objectForKey:@"user"];
            UserModel *userModel = [[[UserModel alloc] init] autorelease];
            userModel.userId = [userDict objectForKey:@"userId"];
            userModel.name = [userDict objectForKey:@"name"];
            userModel.avatarUrl = [userDict objectForKey:@"avatar"];
            mediaModel.owner = userModel;
            
            NSMutableArray *commentArray = [media objectForKey:@"comment"];
            NSMutableArray *comments = [[NSMutableArray alloc] init];
            for (NSDictionary *commentDict in commentArray) {
                CommentModel *cm = [[CommentModel alloc] init];
                cm.ownerName = [commentDict objectForKey:@"name"];
                cm.content = [[commentDict objectForKey:@"content"] URLDecodedString];
                
                [comments addObject:cm];
                [cm release];
            }
            mediaModel.commentArray = comments;
            [comments release];
            
            [mediaArray addObject:mediaModel];
        }
        
        if (isForPullRefresh) {
            [self.delegate getMediaByTimeDidFinished:mediaArray];
        }else{
            [self.delegate getMediaByCircleIdDidFinished:mediaArray];
        }
        [mediaArray release];
        
    }else{
        if (isForPullRefresh) {
            [self.delegate getMediaByTimeDidFinished:nil];
        }else{
            [self.delegate getMediaByCircleIdDidFinished:nil];
        }
    }
}

-(void)requestIsFailed:(NSString *)errorMsg{
    if (isForPullRefresh) {
        [self.delegate getMediaByTimeDidFailed:errorMsg];
    }else{
        [self.delegate getMediaByCircleIdDidFailed:errorMsg];
    }
}

@end
