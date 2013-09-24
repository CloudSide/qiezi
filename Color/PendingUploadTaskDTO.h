//
//  PendingUploadTaskDTO.h
//  Color
//
//  Created by chao han on 12-6-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PendingUploadTaskDTO : NSObject

@property (nonatomic,assign) NSInteger pid;
@property (nonatomic,retain) NSString *filePath;
@property (nonatomic,assign) NSInteger mediaType;
@property (nonatomic,assign) NSInteger retryTimes;
@property (nonatomic,retain) NSString *errorCode;
@property (nonatomic,assign) double lon;
@property (nonatomic,assign) double lat;
@property (nonatomic,retain) NSString *circleId;
@property (nonatomic,retain) NSString *description;
@property (nonatomic,retain) NSString *thumbnailPath;
@property (nonatomic,assign) NSInteger pendingState;//0,等待上传  1,上传中  2,上传失败

@end
