//
//  GetUserInfoInterface.h
//  Color
//  Created by chao han on 12-6-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BaseInterface.h"

@class UserModel;
@protocol GetUserInfoInterfaceDelegate;
@interface GetUserInfoInterface : BaseInterface <BaseInterfaceDelegate>

@property (nonatomic,assign) id<GetUserInfoInterfaceDelegate> delegate;

-(void)getUserInfoByUserId:(NSString *)userId;

@end

@protocol GetUserInfoInterfaceDelegate <NSObject>

-(void)getUserInfoByUserIdDidFinished:(UserModel *)userModel;
-(void)getUserInfoByUserIdDidFailed:(NSString *)errorMsg;



@end
