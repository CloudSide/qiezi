//
//  MediaByUserIdInterface.h
//  Color
//  Created by chao han on 12-6-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BaseInterface.h"

@protocol MediaByUserIdInterfaceDelegate;

@interface MediaByUserIdInterface : BaseInterface <BaseInterfaceDelegate>{
    BOOL isForPullRefresh;
}

@property (nonatomic,assign) id<MediaByUserIdInterfaceDelegate> delegate;

-(void)getMediaByUserIdListByStartTime:(NSTimeInterval)startTime userId:(NSString *)userId;
-(void)getMediaByUserIdListByEndTime:(NSTimeInterval)endTime userId:(NSString *)userId;

@end

@protocol MediaByUserIdInterfaceDelegate <NSObject>

-(void)getMediaByUserIdListDidFinished:(NSArray *)mediaArray;
-(void)getMediaByUserIdListDidFailed:(NSString *)errorMsg;
-(void)getMediaByUserIdListByTimeDidFinished:(NSArray *)mediaArray;
-(void)getMediaByUserIdListByTimeDidFailed:(NSString *)errorMsg;

@end
