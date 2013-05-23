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

-(void)parseResult:(NSDictionary *)responseDict{
    if (responseDict && [responseDict count] > 0) {
        NSMutableArray *commentArray = [[NSMutableArray alloc] init];
        
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
