//
//  CommentShowInterface.h
//  QieZi
//  根据mediaId查询评论列表
//  Created by chao han on 12-6-25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BaseInterface.h"

@protocol CommentShowInterfaceDelegate;

@interface CommentShowInterface : BaseInterface <BaseInterfaceDelegate>{
    BOOL isForPullRefresh;//是否用于下拉刷新
}

@property (nonatomic,assign) id<CommentShowInterfaceDelegate> delegate;

//根据开始时间,mediaId查询评论列表
-(void)getCommentListByStartTime:(NSTimeInterval)startTime mediaId:(NSString *)mediaId;

//根据结束时间,mediaId查询评论列表---用于下拉刷新
-(void)getCommentListByEndTime:(NSTimeInterval)endTime mediaId:(NSString *)mediaId;
@end

@protocol CommentShowInterfaceDelegate <NSObject>
-(void)getCommentListDidFinished:(NSArray *)mediaArray;
-(void)getCommentListDidFailed:(NSString *)errorMsg;

//用于下拉刷新的delegate
-(void)getCommentListByTimeDidFinished:(NSArray *)mediaArray;
-(void)getCommentListByTimeDidFailed:(NSString *)errorMsg;


@end
