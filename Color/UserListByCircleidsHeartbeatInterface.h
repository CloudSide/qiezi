//
//  UserListByCircleidsHeartbeatInterface.h
//  Color
//  根据circleId获取对应圈子成员 心跳接口
//  Created by chao han on 12-6-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BaseInterface.h"

@protocol UserListByCircleidsHeartbeatInterfaceDelegate;
@interface UserListByCircleidsHeartbeatInterface : BaseInterface <BaseInterfaceDelegate>{
    NSString *_circleId;
}

@property (nonatomic,assign) id<UserListByCircleidsHeartbeatInterfaceDelegate> delegate;

-(void)getUserListByCircleids:(NSString *)cid;

@end

@protocol UserListByCircleidsHeartbeatInterfaceDelegate <NSObject>

-(void)getUserListByCircleidsDidFinished:(NSArray *)userArray circleId:(NSString *)cid;
-(void)getUserListByCircleidsDidFailed:(NSString *)errorMsg;


@end
