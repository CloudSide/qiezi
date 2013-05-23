//
//  AllCommentListInterface.h
//  Color
//  Created by chao han on 12-5-30.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BaseInterface.h"
@protocol AllCommentListInterfaceDelegate;
@interface AllCommentListInterface : BaseInterface <BaseInterfaceDelegate>{
    BOOL isForPullRefresh;
}

@property (nonatomic,assign) id<AllCommentListInterfaceDelegate> delegate;
-(void)getAllCommentListByStartTime:(NSTimeInterval)startTime;
-(void)getAllCommentListByEndTime:(NSTimeInterval)endTime;

@end

@protocol AllCommentListInterfaceDelegate <NSObject>

-(void)getAllCommentListDidFinished:(NSArray *)mediaArray;
-(void)getAllCommentListDidFailed:(NSString *)errorMsg;
-(void)getAllCommentListByTimeDidFinished:(NSArray *)mediaArray;
-(void)getAllCommentListByTimeDidFailed:(NSString *)errorMsg;

@end
