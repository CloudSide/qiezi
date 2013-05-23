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
-(void)parseResult:(NSDictionary *)responseDict{
    if (responseDict && [responseDict count] > 0) {
        NSMutableArray *mediaArray = [[NSMutableArray alloc] init];
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
