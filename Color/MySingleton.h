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
@property (nonatomic,readonly) NSString *baseInterfaceUrl;

@property (nonatomic,retain) NSString *name;
@property (nonatomic,retain) NSString *avatarUrl;
@property (nonatomic,retain) NSString *userId;
@property (nonatomic,retain) NSString *updateUrl;

-(BOOL)isStateDictExist;
@end

