//
//  CommentShowInterface.h
//  QieZi
//  Created by chao han on 12-6-25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BaseInterface.h"

@protocol CommentShowInterfaceDelegate;

@interface CommentShowInterface : BaseInterface <BaseInterfaceDelegate>{
    BOOL isForPullRefresh;
}

@property (nonatomic,assign) id<CommentShowInterfaceDelegate> delegate;

-(void)getCommentListByStartTime:(NSTimeInterval)startTime mediaId:(NSString *)mediaId;
-(void)getCommentListByEndTime:(NSTimeInterval)endTime mediaId:(NSString *)mediaId;
@end

@protocol CommentShowInterfaceDelegate <NSObject>
-(void)getCommentListDidFinished:(NSArray *)mediaArray;
-(void)getCommentListDidFailed:(NSString *)errorMsg;
-(void)getCommentListByTimeDidFinished:(NSArray *)mediaArray;
-(void)getCommentListByTimeDidFailed:(NSString *)errorMsg;


@end
