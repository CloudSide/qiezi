//
//  MySingleton.h
//  ZReader_HD
//
//  Created by zcom on 12-3-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

#define kCLLocationManagerDidStarted @"kCLLocationManagerDidStarted"

@interface MySingleton : NSObject <CLLocationManagerDelegate>{
    BOOL isLocationStarted;
}


+ (MySingleton *)sharedSingleton;

@property (nonatomic,retain) CLLocationManager *man;

@property (nonatomic,assign) double lon;
@property (nonatomic,assign) double lat;

@property (nonatomic,assign) NSInteger currentCircleId;
@property (nonatomic,assign) UIImagePickerControllerCameraFlashMode lastCameraFlashMode;

@property (nonatomic,strong) NSString *sessionId;
@property (nonatomic,readonly) NSString *baseInterfaceUrl;//接口地址根路径

@property (nonatomic,retain) NSString *name;//本机用户名
@property (nonatomic,retain) NSString *avatarUrl;//本机用户头像
@property (nonatomic,retain) NSString *userId;
@property (nonatomic,retain) NSString *updateUrl;//软件更新url

-(BOOL)isStateDictExist;//状态文件是否存在
@end

