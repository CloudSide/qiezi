//
//  UploadVideoInterface.h
//  Color
//  Created by chao han on 12-5-24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BaseInterface.h"

@protocol UploadVideoInterfaceDelegate;

@interface UploadVideoInterface : BaseInterface <BaseInterfaceDelegate>{
    long long int taskId;
}
@property (nonatomic,assign) id<UploadVideoInterfaceDelegate> delegate;

-(void)doUploadVideo:(NSData *)videoData thumbnail:(UIImage *)thumbnail 
         description:(NSString *)description circleId:(NSInteger) cid 
                 lon:(double)lon lat:(double)lat taskId:(long long int)tId;

@end

@protocol UploadVideoInterfaceDelegate <NSObject>

-(void)uploadVideoDidFinishedTaskId:(long long int)tId;
-(void)uploadVideoDidFailed:(NSString *)errorMsg taskId:(long long int)tId;

@end
