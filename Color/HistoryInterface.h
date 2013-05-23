//
//  HistoryInterface.h
//  Color
//  Created by chao han on 12-5-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BaseInterface.h"

@protocol HistoryInterfaceDelegate;

@interface HistoryInterface : BaseInterface <BaseInterfaceDelegate>{
    BOOL isForPullRefresh;
}

@property (nonatomic,assign) id<HistoryInterfaceDelegate> delegate;
-(void)getHistoryListByStartTime:(NSTimeInterval)startTime;
-(void)getHistoryListByEndTime:(NSTimeInterval)endTime;

@end

@protocol HistoryInterfaceDelegate <NSObject>

-(void)getHistoryListDidFinished:(NSArray *)mediaArray;
-(void)getHistoryListDidFailed:(NSString *)errorMsg;
-(void)getHistoryListByTimeDidFinished:(NSArray *)mediaArray;
-(void)getHistoryListByTimeDidFailed:(NSString *)errorMsg;

@end