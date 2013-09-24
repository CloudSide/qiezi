//
//  CommentShowInterface.m
//  QieZi
//
//  Created by chao han on 12-6-25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CommentShowInterface.h"
#import "DeviceUtil.h"
#import "CommentModel.h"
#import "NSString+URLEncoding.h"

@implementation CommentShowInterface
@synthesize delegate = _delegate;

//根据开始时间,mediaId查询评论列表
-(void)getCommentListByStartTime:(NSTimeInterval)startTime mediaId:(NSString *)mediaId;
{
    isForPullRefresh = NO;
    self.baseDelegate = self;
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:[DeviceUtil getMacAddress] forKey:@"deviceId"];
    [dict setObject:[NSString stringWithFormat:@"%d",(NSInteger)startTime] forKey:@"startTime"];
    [dict setObject:mediaId forKey:@"mediaId"];
    
    self.interfaceUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@/comment/show",[MySingleton sharedSingleton].baseInterfaceUrl]];
    self.postKeyValues = dict;
    [dict release];
    
    [self connect];
}

//根据结束时间,mediaId查询评论列表---用于下拉刷新
-(void)getCommentListByEndTime:(NSTimeInterval)endTime mediaId:(NSString *)mediaId;
{
    isForPullRefresh = YES;
    self.baseDelegate = self;
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:[DeviceUtil getMacAddress] forKey:@"deviceId"];
    [dict setObject:[NSString stringWithFormat:@"%d",(NSInteger)endTime] forKey:@"endTime"];
    [dict setObject:mediaId forKey:@"mediaId"];
    
    self.interfaceUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@/comment/show",[MySingleton sharedSingleton].baseInterfaceUrl]];
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
//                     "id": "155",
//                     "ctime": "1339306139",
//                     "content": "标哥，有评论啦~",
//                    "feedId": {
//                        "name": "test111",
//                        "avatar": "avatar/580000016/580000016_1341394263.jpg",
//                        "userId": "580000016"
//                    },
//                     "avatar": "http://12qiezi-12qiezi.stor.sinaapp.com/avatar/580000012/580000012_1339213555.jpg",
//                     "name": "L"
//                     "userId":"12121212"
//                 },
//                 {
//                     "id": "153",
//                     "ctime": "1339304104",
//                     "content": "good",
//                    "feedId": {
//                        "name": "test111",
//                        "avatar": "avatar/580000016/580000016_1341394263.jpg",
//                        "userId": "580000016"
//                    },
//                     "avatar": "http://12qiezi-12qiezi.stor.sinaapp.com/avatar/580000012/580000012_1339213555.jpg",
//                     "name": "L"
//                     "userId":"12121212"
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
            cm.ctime = [NSDate dateWithTimeIntervalSince1970:[[commentDict objectForKey:@"ctime"]intValue]];
            cm.content = [[commentDict objectForKey:@"content"] URLDecodedString];
            
            NSDictionary *feedDict = [commentDict objectForKey:@"feedId"];
            if (![feedDict isMemberOfClass:[NSNull class]] && [feedDict count] > 0) {
                UserModel *feedUser = [[[UserModel alloc] init] autorelease];
                feedUser.userId = [feedDict objectForKey:@"userId"];
                feedUser.name = [feedDict objectForKey:@"name"];
                feedUser.avatarUrl = [feedDict objectForKey:@"avatar"];
                cm.feedUser = feedUser;
            }
            
            UserModel *userModel = [[[UserModel alloc] init] autorelease];
            userModel.userId = [commentDict objectForKey:@"userId"];
            userModel.name = [commentDict objectForKey:@"name"];
            userModel.avatarUrl = [commentDict objectForKey:@"avatar"];
            cm.owner = userModel;
            
            [commentArray addObject:cm];
            [cm release];
        }
        
        if (isForPullRefresh) {
            [self.delegate getCommentListByTimeDidFinished:commentArray];
        }else{
            [self.delegate getCommentListDidFinished:commentArray];
        }
        [commentArray release];
        
    }else{
        if (isForPullRefresh) {
            [self.delegate getCommentListByTimeDidFinished:nil];
        }else{
            [self.delegate getCommentListDidFinished:nil];
        }
    }
}

-(void)requestIsFailed:(NSString *)errorMsg{
    if (isForPullRefresh) {
        [self.delegate getCommentListByTimeDidFailed:errorMsg];
    }else{
        [self.delegate getCommentListDidFailed:errorMsg];
    }
    
}
@end
