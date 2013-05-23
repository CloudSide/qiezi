//
//  UploadImageInterface.h
//  Color
//  Created by chao han on 12-5-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseInterface.h"

@protocol UploadImageInterfaceDelegate;

@interface UploadImageInterface : BaseInterface <BaseInterfaceDelegate>{
    long long int taskId;
}

@property (nonatomic,assign) id<UploadImageInterfaceDelegate> delegate;

-(void)doUploadImage:(UIImage *)image description:(NSString *)description 
            circleId:(NSInteger) cid lon:(double)lon lat:(double)lat
              taskId:(long long int)tId;

@end

@protocol UploadImageInterfaceDelegate <NSObject>

-(void)uploadImageDidFinishedTaskId:(long long int)tId;
-(void)uploadImageDidFailed:(NSString *)errorMsg taskId:(long long int)tId;

@end
