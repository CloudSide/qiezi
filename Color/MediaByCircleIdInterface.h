//
//  MediaByCircleIdInterface.h
//  Color
//  Created by chao han on 12-6-1.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BaseInterface.h"
@protocol MediaByCircleIdInterfaceDelegate;

@interface MediaByCircleIdInterface : BaseInterface <BaseInterfaceDelegate>{
    BOOL isForPullRefresh;
}
@property (nonatomic,assign) id<MediaByCircleIdInterfaceDelegate> delegate;
-(void)getMediaByCircleId:(NSString *)circleId startTime:(NSTimeInterval)startTime;
-(void)getMediaByCircleId:(NSString *)circleId endTime:(NSTimeInterval)endTime;
@end
@protocol MediaByCircleIdInterfaceDelegate <NSObject>
-(void)getMediaByCircleIdDidFinished:(NSArray *)mediaArray;
-(void)getMediaByCircleIdDidFailed:(NSString *)errorMsg;
-(void)getMediaByTimeDidFinished:(NSArray *)mediaArray;
-(void)getMediaByTimeDidFailed:(NSString *)errorMsg;
@end
