//
//  CircleByTimestampHeartbeatInterface.h
//  Color
//  附近圈子心跳接口 -- 根据时间点返回附近圈子列表
//  Created by chao han on 12-6-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BaseInterface.h"

@protocol CircleByTimestampHeartbeatInterfaceDelegate;
@interface CircleByTimestampHeartbeatInterface : BaseInterface <BaseInterfaceDelegate>

@property (nonatomic,assign) id<CircleByTimestampHeartbeatInterfaceDelegate> delegate;

-(void)getCircleByTimestamp:(NSTimeInterval) timestamp;

@end

@protocol CircleByTimestampHeartbeatInterfaceDelegate <NSObject>

-(void)getCircleByTimestampDidFinished:(NSArray *)circleArray;
-(void)getCircleByTimestampDidFailed:(NSString *)errorMsg;


@end
