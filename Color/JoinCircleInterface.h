//
//  JoinCircleInterface.h
//  Color
//  加入圈子
//  Created by chao han on 12-6-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BaseInterface.h"
@protocol JoinCircleInterfaceDelegate;
@interface JoinCircleInterface : BaseInterface <BaseInterfaceDelegate>{
    NSInteger circleId;
}

@property (nonatomic,assign) id<JoinCircleInterfaceDelegate> delegate;

-(void)joinCircleById:(NSInteger) cid;

@end

@protocol JoinCircleInterfaceDelegate <NSObject>

-(void)joinCircleDidFinished:(NSInteger) cid;
-(void)joinCircleDidFailed:(NSString *)errorMsg;



@end
