//
//  FriendListInterface.h
//  Color
//  获取好友列表
//  Created by chao han on 12-5-30.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BaseInterface.h"

@protocol FriendListInterfaceDelegate;

@interface FriendListInterface : BaseInterface <BaseInterfaceDelegate>

@property (nonatomic,assign) id<FriendListInterfaceDelegate> delegate;

-(void)getFriendList;

@end

@protocol FriendListInterfaceDelegate <NSObject>

-(void)getFriendListDidFinished:(NSArray *)friendArray;
-(void)getFriendListDidFailed:(NSString *)errorMsg;


@end
