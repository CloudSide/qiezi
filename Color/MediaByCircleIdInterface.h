//
//  MediaByCircleIdInterface.h
//  Color
//  根据圈子id获取照片列表  用于回忆、动态二级页面
//  Created by chao han on 12-6-1.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BaseInterface.h"
@protocol MediaByCircleIdInterfaceDelegate;

@interface MediaByCircleIdInterface : BaseInterface <BaseInterfaceDelegate>{
    BOOL isForPullRefresh;//是否用于下拉刷新
}
@property (nonatomic,assign) id<MediaByCircleIdInterfaceDelegate> delegate;

//根据结束时间获取以往图片列表
-(void)getMediaByCircleId:(NSString *)circleId startTime:(NSTimeInterval)startTime;

//根据时间段获取列表---用于下拉刷新
-(void)getMediaByCircleId:(NSString *)circleId endTime:(NSTimeInterval)endTime;
@end

@protocol MediaByCircleIdInterfaceDelegate <NSObject>

-(void)getMediaByCircleIdDidFinished:(NSArray *)mediaArray;
-(void)getMediaByCircleIdDidFailed:(NSString *)errorMsg;

//用于下拉刷新的delegate
-(void)getMediaByTimeDidFinished:(NSArray *)mediaArray;
-(void)getMediaByTimeDidFailed:(NSString *)errorMsg;
@end
