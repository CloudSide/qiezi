//
//  DynamicInterface.h
//  Color
//  Created by chao han on 12-5-30.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BaseInterface.h"

@protocol DynamicInterfaceDelegate;

@interface DynamicInterface : BaseInterface <BaseInterfaceDelegate>{
    BOOL isForPullRefresh;
}

@property (nonatomic,assign) id<DynamicInterfaceDelegate> delegate;
-(void)getDynamicListByStartTime:(NSTimeInterval)startTime;
-(void)getDynamicListByEndTime:(NSTimeInterval)endTime;
@end

@protocol DynamicInterfaceDelegate <NSObject>

-(void)getDynamicListDidFinished:(NSArray *)mediaArray;
-(void)getDynamicListDidFailed:(NSString *)errorMsg;
-(void)getDynamicListByTimeDidFinished:(NSArray *)mediaArray;
-(void)getDynamicListByTimeDidFailed:(NSString *)errorMsg;

@end
