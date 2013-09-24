//
//  AllCommentListInterface.m
//  Color
//
//  Created by chao han on 12-5-30.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "AllCommentListInterface.h"
#import "DeviceUtil.h"
#import "CommentModel.h"
#import "UserModel.h"
#import "NSString+URLEncoding.h"

@implementation AllCommentListInterface
@synthesize delegate = _delegate;


//根据结束时间获取以往图片列表
-(void)getAllCommentListByStartTime:(NSTimeInterval)startTime;
{
    isForPullRefresh = NO;
    self.baseDelegate = self;
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:[DeviceUtil getMacAddress] forKey:@"deviceId"];
    [dict setObject:[NSString stringWithFormat:@"%d",(NSInteger)startTime] forKey:@"startTime"];
    
    self.interfaceUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@/comment/tome",[MySingleton sharedSingleton].baseInterfaceUrl]];
    self.postKeyValues = dict;
    [dict release];
    
    [self connect];
}

//根据时间段获取列表---用于下拉刷新
-(void)getAllCommentListByEndTime:(NSTimeInterval)endTime
{
    isForPullRefresh = YES;
    self.baseDelegate = self;
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:[DeviceUtil getMacAddress] forKey:@"deviceId"];
    [dict setObject:[NSString stringWithFormat:@"%d",(NSInteger)endTime] forKey:@"endTime"];
    
    self.interfaceUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@/comment/tome",[MySingleton sharedSingleton].baseInterfaceUrl]];
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
//                     "id": "164",
//                     "mediaId": "580000010_1339224914",
//                     "ctime": "1339403323",
//                     "content": "这谁啊？",
//                     "isgood": "0",
//                     "status": "1",
//                     "userId": "580000010",
//                     "avatar": "http://12qiezi-12qiezi.stor.sinaapp.com/avatar/580000010/580000010_1339210952.png",
//                     "name": "益飞",
//                     "thumbnailUrl": "http://12qiezi-12qiezi.stor.sinaapp.com/thumbnail/580000010/small_580000010_1339224914.jpg"
//                     "circleId":"11"
//                 },
//                 {
//                     "id": "163",
//                     "mediaId": "580000010_1339224914",
//                     "ctime": "1339403303",
//                     "content": "",
//                     "isgood": "1",
//                     "status": "1",
//                     "userId": "580000010",
//                     "avatar": "http://12qiezi-12qiezi.stor.sinaapp.com/avatar/580000010/580000010_1339210952.png",
//                     "name": "益飞",
//                     "thumbnailUrl": "http://12qiezi-12qiezi.stor.sinaapp.com/thumbnail/580000010/small_580000010_1339224914.jpg"
//                     "circleId":"11"
//                 }
//                 ]
//    }
//}

#pragma mark - BaseInterfaceDelegate
-(void)parseResult:(NSDictionary *)responseDict{
    if (responseDict && [responseDict count] > 0) {
        NSMutableArray *commentArray = [[NSMutableArray alloc] init];//返回结果
        
        NSDictionary *content = [responseDict objectForKey:@"content"];
        NSArray *listArray = [content objectForKey:@"list"];
        
        for (NSDictionary *commentDict in listArray) {
            CommentModel *cm = [[CommentModel alloc] init];
            cm.mediaId = [commentDict objectForKey:@"mediaId"];
            cm.ctime = [NSDate dateWithTimeIntervalSince1970:[[commentDict objectForKey:@"ctime"]intValue]];
            cm.content = [[commentDict objectForKey:@"content"] URLDecodedString];
            cm.isGood = [commentDict objectForKey:@"isgood"];
            cm.status = [commentDict objectForKey:@"status"];
            cm.thumbnailUrl = [commentDict objectForKey:@"thumbnailUrl"];
            cm.circleId = [commentDict objectForKey:@"circleId"];
            
            UserModel *userModel = [[[UserModel alloc] init] autorelease];
            userModel.userId = [commentDict objectForKey:@"userId"];
            userModel.name = [commentDict objectForKey:@"name"];
            userModel.avatarUrl = [commentDict objectForKey:@"avatar"];
            cm.owner = userModel;
            
            [commentArray addObject:cm];
            [cm release];
        }
        
        if (isForPullRefresh) {
            [self.delegate getAllCommentListByTimeDidFinished:commentArray];
        }else{
            [self.delegate getAllCommentListDidFinished:commentArray];
        }
        [commentArray release];
        
    }else{
        if (isForPullRefresh) {
            [self.delegate getAllCommentListByTimeDidFinished:nil];
        }else{
            [self.delegate getAllCommentListDidFinished:nil];
        }

    }
}

-(void)requestIsFailed:(NSString *)errorMsg{
    if (isForPullRefresh) {
        [self.delegate getAllCommentListByTimeDidFailed:errorMsg];
    }else{
        [self.delegate getAllCommentListDidFailed:errorMsg];
    }

}

@end
