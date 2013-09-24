//
//  CreateCircleInterface.h
//  Color
//  创建圈子
//  Created by chao han on 12-6-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BaseInterface.h"
#import "CircleModel.h"

@protocol CreateCircleInterfaceDelegate;
@interface CreateCircleInterface : BaseInterface <BaseInterfaceDelegate>

@property (nonatomic,assign) id<CreateCircleInterfaceDelegate> delegate;

-(void)createCircle;

@end

@protocol CreateCircleInterfaceDelegate <NSObject>

-(void)createCircleDidFinished:(CircleModel *)circleModel;
-(void)createCircleDidFailed:(NSString *)errorMsg;


@end
