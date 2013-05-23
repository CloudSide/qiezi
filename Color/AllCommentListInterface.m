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
-(void)parseResult:(NSDictionary *)responseDict{
    if (responseDict && [responseDict count] > 0) {
        NSMutableArray *commentArray = [[NSMutableArray alloc] init];
        
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
