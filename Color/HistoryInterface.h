//
//  HistoryInterface.h
//  Color
//  回忆
//  Created by chao han on 12-5-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BaseInterface.h"

@protocol HistoryInterfaceDelegate;

@interface HistoryInterface : BaseInterface <BaseInterfaceDelegate>{
    BOOL isForPullRefresh;//是否用于下拉刷新
}

@property (nonatomic,assign) id<HistoryInterfaceDelegate> delegate;

//根据结束时间获取以往图片列表
-(void)getHistoryListByStartTime:(NSTimeInterval)startTime;

//根据时间段获取列表---用于下拉刷新
-(void)getHistoryListByEndTime:(NSTimeInterval)endTime;

@end

@protocol HistoryInterfaceDelegate <NSObject>

-(void)getHistoryListDidFinished:(NSArray *)mediaArray;
-(void)getHistoryListDidFailed:(NSString *)errorMsg;

//用于下拉刷新的delegate
-(void)getHistoryListByTimeDidFinished:(NSArray *)mediaArray;
-(void)getHistoryListByTimeDidFailed:(NSString *)errorMsg;

@end