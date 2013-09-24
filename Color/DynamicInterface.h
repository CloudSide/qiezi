//
//  DynamicInterface.h
//  Color
//  动态接口
//  Created by chao han on 12-5-30.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BaseInterface.h"

@protocol DynamicInterfaceDelegate;

@interface DynamicInterface : BaseInterface <BaseInterfaceDelegate>{
    BOOL isForPullRefresh;//是否用于下拉刷新
}

@property (nonatomic,assign) id<DynamicInterfaceDelegate> delegate;

//根据结束时间获取以往图片列表
-(void)getDynamicListByStartTime:(NSTimeInterval)startTime;

//根据时间段获取列表---用于下拉刷新
-(void)getDynamicListByEndTime:(NSTimeInterval)endTime;
@end

@protocol DynamicInterfaceDelegate <NSObject>

-(void)getDynamicListDidFinished:(NSArray *)mediaArray;
-(void)getDynamicListDidFailed:(NSString *)errorMsg;

//用于下拉刷新的delegate
-(void)getDynamicListByTimeDidFinished:(NSArray *)mediaArray;
-(void)getDynamicListByTimeDidFailed:(NSString *)errorMsg;

@end
