//
//  NearByUsersHeartbeatInterface.h
//  QieZi
//  Created by chao han on 12-7-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BaseInterface.h"

@protocol NearByUsersHeartbeatInterfaceDelegate;
@interface NearByUsersHeartbeatInterface : BaseInterface <BaseInterfaceDelegate>

@property (nonatomic,assign) id<NearByUsersHeartbeatInterfaceDelegate> delegate;

-(void)getNearByUsers;

@end

@protocol NearByUsersHeartbeatInterfaceDelegate <NSObject>

-(void)getUsersDidFinished:(NSArray *)userArray;
-(void)getUsersDidFailed:(NSString *)errorMsg;


@end

