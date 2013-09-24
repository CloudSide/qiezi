//
//  NewCommentsHeartbeatInterface.h
//  Color
//  新评论心跳接口
//  Created by chao han on 12-6-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BaseInterface.h"

@protocol NewCommentsHeartbeatInterfaceDelegate;
@interface NewCommentsHeartbeatInterface : BaseInterface <BaseInterfaceDelegate>

@property (nonatomic,assign) id<NewCommentsHeartbeatInterfaceDelegate> delegate;

-(void)getNewCommentsAmount;

@end

@protocol NewCommentsHeartbeatInterfaceDelegate <NSObject>

-(void)getNewCommentsAmountDidFinished:(NSInteger )newCommentsAmount;
-(void)getNewCommentsAmountDidFailed:(NSString *)errorMsg;


@end
