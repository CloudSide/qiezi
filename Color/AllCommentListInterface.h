//
//  AllCommentListInterface.h
//  Color
//  评论收件箱接口
//  Created by chao han on 12-5-30.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BaseInterface.h"
@protocol AllCommentListInterfaceDelegate;
@interface AllCommentListInterface : BaseInterface <BaseInterfaceDelegate>{
    BOOL isForPullRefresh;//是否用于下拉刷新
}


@property (nonatomic,assign) id<AllCommentListInterfaceDelegate> delegate;

//根据结束时间获取以往图片列表
-(void)getAllCommentListByStartTime:(NSTimeInterval)startTime;

//根据时间段获取列表---用于下拉刷新
-(void)getAllCommentListByEndTime:(NSTimeInterval)endTime;

@end

@protocol AllCommentListInterfaceDelegate <NSObject>

-(void)getAllCommentListDidFinished:(NSArray *)mediaArray;
-(void)getAllCommentListDidFailed:(NSString *)errorMsg;

//用于下拉刷新的delegate
-(void)getAllCommentListByTimeDidFinished:(NSArray *)mediaArray;
-(void)getAllCommentListByTimeDidFailed:(NSString *)errorMsg;

@end
