//
//  MediaByCircleidsAndTimestampHeartbeatInterface.h
//  Color
//  Created by chao han on 12-6-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BaseInterface.h"

@protocol MediaByCircleidsAndTimestampHeartbeatInterfaceDelegate;
@interface MediaByCircleidsAndTimestampHeartbeatInterface : BaseInterface <BaseInterfaceDelegate>

@property (nonatomic,assign) id<MediaByCircleidsAndTimestampHeartbeatInterfaceDelegate> delegate;

-(void)getMediaByCircleids:(NSString *)cidStr timestamp:(NSTimeInterval)timestamp;

@end

@protocol MediaByCircleidsAndTimestampHeartbeatInterfaceDelegate <NSObject>

-(void)getMediaByCircleidsAndTimestampDidFinished:(NSDictionary *)mediaArray;
-(void)getMediaByCircleidsAndTimestampDidFailed:(NSString *)errorMsg;


@end
