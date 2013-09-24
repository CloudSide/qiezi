//
//  MediaByUserIdInterface.h
//  Color
//  根据用户id获取media信息
//  Created by chao han on 12-6-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BaseInterface.h"

@protocol MediaByUserIdInterfaceDelegate;

@interface MediaByUserIdInterface : BaseInterface <BaseInterfaceDelegate>{
    BOOL isForPullRefresh;//是否用于下拉刷新
}

@property (nonatomic,assign) id<MediaByUserIdInterfaceDelegate> delegate;

//根据结束时间获取以往图片列表
-(void)getMediaByUserIdListByStartTime:(NSTimeInterval)startTime userId:(NSString *)userId;

//根据时间段获取列表---用于下拉刷新
-(void)getMediaByUserIdListByEndTime:(NSTimeInterval)endTime userId:(NSString *)userId;

@end

@protocol MediaByUserIdInterfaceDelegate <NSObject>

-(void)getMediaByUserIdListDidFinished:(NSArray *)mediaArray;
-(void)getMediaByUserIdListDidFailed:(NSString *)errorMsg;

//用于下拉刷新的delegate
-(void)getMediaByUserIdListByTimeDidFinished:(NSArray *)mediaArray;
-(void)getMediaByUserIdListByTimeDidFailed:(NSString *)errorMsg;

@end
