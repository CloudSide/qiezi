//
//  UploadMediaService.h
//  Color
//  后台照片、视频文件上传服务
//  Created by chao han on 12-5-31.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UploadImageInterface.h"
#import "UploadVideoInterface.h"

@interface UploadMediaService : NSObject <UploadImageInterfaceDelegate,UploadVideoInterfaceDelegate> {
    NSOperationQueue *operationQueue;
}

- (void)addOperation:(long long int)taskId;
-(void)addOperationAfterDelay:(NSNumber *)taskId;

@property (retain,nonatomic) NSOperationQueue *operationQueue;

@property (retain,nonatomic) NSMutableDictionary *interfaceHolder;//持有所有接口的dict

@end
