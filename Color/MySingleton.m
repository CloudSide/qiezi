//
//  MySingleton.m
//  ZReader_HD
//
//  Created by zcom on 12-3-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MySingleton.h"

#import "KeyChainTool.h"

#define kWBUSERID   @"kWBUSERID"

@implementation MySingleton

@synthesize sessionId;
@synthesize baseInterfaceUrl = _baseInterfaceUrl;
@synthesize man = _man;
@synthesize lon = _lon , lat = _lat;
@synthesize currentCircleId = _currentCircleId;
@synthesize name = _name , avatarUrl = _avatarUrl , userId = _userId;
@synthesize lastCameraFlashMode = _lastCameraFlashMode , updateUrl = _updateUrl;


+ (MySingleton *)sharedSingleton
{
    static MySingleton *sharedSingleton=nil;
    
    @synchronized(self)
    {
        if (!sharedSingleton)
            sharedSingleton = [[MySingleton alloc] init];
        
        return sharedSingleton;
    }
}

-(id)init {
    self = [super init];
    
    if (self) {
        _baseInterfaceUrl = @"http://12qiezi.sinaapp.com";
        
        self.man = [[[CLLocationManager alloc] init] autorelease];
        
//        self.currentCircleId = 0;
        
        // 如果可以利用本地服务时
        if([CLLocationManager locationServicesEnabled]){
            // 接收事件的实例
            self.man.delegate = self;
            // 发生事件的的最小距离间隔（缺省是不指定）
            self.man.distanceFilter = kCLDistanceFilterNone;
            // 精度 (缺省是Best)
            self.man.desiredAccuracy = kCLLocationAccuracyBest;
            // 开始测量
            [self.man startUpdatingLocation];
        }
    }
    
    return self;
}

//从plist中获取状态dict
-(NSMutableDictionary *)getStateDict
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                         NSUserDomainMask, YES); 
    NSString *plistFile = [[paths objectAtIndex:0]
                           stringByAppendingPathComponent:@"state.plist"];
    
    NSMutableDictionary *stateDict = [[[NSMutableDictionary alloc] initWithContentsOfFile:plistFile] autorelease];
    if (!stateDict) {
        stateDict = [[[NSMutableDictionary alloc] init] autorelease];
        
        //初始化状态值
        [stateDict setObject:[NSNumber numberWithInt:0] forKey:@"lastCircleId"];//上次所在圈子id
        [stateDict setObject:[NSNumber numberWithInt:UIImagePickerControllerCameraFlashModeAuto] 
                      forKey:@"lastCameraFlashMode"];//上次相机闪光灯状态
        
        [stateDict setObject:@"" forKey:@"name"];//用户昵称
        [stateDict setObject:@"" forKey:@"userId"];//用户id
        [stateDict setObject:@"" forKey:@"avatarUrl"];//用户头像
        
        [stateDict writeToFile:plistFile atomically:YES];//保存plist
    }
    
    return stateDict;
}

//状态文件是否存在
-(BOOL)isStateDictExist
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                         NSUserDomainMask, YES); 
    NSString *plistFile = [[paths objectAtIndex:0]
                           stringByAppendingPathComponent:@"state.plist"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    return [fileManager fileExistsAtPath:plistFile];
}

//保存状态dict到plist
-(void)saveStateDict:(NSMutableDictionary *)stateDict
{
    if (stateDict) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                             NSUserDomainMask, YES); 
        NSString *plistFile = [[paths objectAtIndex:0]
                               stringByAppendingPathComponent:@"state.plist"];
        
        [stateDict writeToFile:plistFile atomically:YES];//保存plist
    }
}

-(void)dealloc{
    self.sessionId = nil;
    [_baseInterfaceUrl release];
    _baseInterfaceUrl = nil;
    self.man = nil;
    
    self.name = nil;
    self.avatarUrl = nil;
    self.userId = nil;
    self.updateUrl = nil;
    self.wbUserId = nil;
    
    [super dealloc];
}

#pragma mark - CLLocationManagerDelegate method

// 如果GPS测量成果以下的函数被调用
- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation{
    
//    if (self.lon == 0 && self.lat == 0) {
//        [[NSNotificationCenter defaultCenter] postNotificationName: kCLLocationManagerDidStarted object: nil];
//    }
    
    // 取得经纬度
    CLLocationCoordinate2D coordinate = newLocation.coordinate;
    self.lat = coordinate.latitude;
    self.lon = coordinate.longitude;
    // 取得精度
    CLLocationAccuracy horizontal = newLocation.horizontalAccuracy;
    CLLocationAccuracy vertical = newLocation.verticalAccuracy;
    // 取得高度
    CLLocationDistance altitude = newLocation.altitude;
    // 取得时刻
    NSDate *timestamp = [newLocation timestamp];
    
    // 以下面的格式输出 format: <latitude>, <longitude>> +/- <accuracy>m @ <date-time>
//    NSLog([newLocation description]);
    
//    // 与上次测量地点的间隔距离
//    if(oldLocation != nil){
//        CLLocationDistance d = [newLocation getDistanceFrom:oldLocation];
//        NSLog([NSString stringWithFormat:@"%f", d]);
//    }
    
    if (!isLocationStarted) {
        isLocationStarted = YES;
        [[NSNotificationCenter defaultCenter] postNotificationName: kCLLocationManagerDidStarted object: nil];
    }
}

// 如果GPS测量失败了，下面的函数被调用
- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error{
    NSLog(@"%@",[error localizedDescription]);
}

-(NSInteger)currentCircleId//getCurrentCircleId
{
    NSMutableDictionary *stateDict = [self getStateDict];
    return [[stateDict objectForKey:@"lastCircleId"] intValue];
}

-(void)setCurrentCircleId:(NSInteger)cid{
    NSMutableDictionary *stateDict = [self getStateDict];
    [stateDict setObject:[NSNumber numberWithInt:cid] forKey:@"lastCircleId"];
    [self saveStateDict:stateDict];
}

-(UIImagePickerControllerCameraFlashMode)lastCameraFlashMode
{
    NSMutableDictionary *stateDict = [self getStateDict];
    return [[stateDict objectForKey:@"lastCameraFlashMode"] intValue];
}

-(void)setLastCameraFlashMode:(UIImagePickerControllerCameraFlashMode)lastCameraFlashMode
{
    NSMutableDictionary *stateDict = [self getStateDict];
    [stateDict setObject:[NSNumber numberWithInt:lastCameraFlashMode] forKey:@"lastCameraFlashMode"];
    [self saveStateDict:stateDict];
}

//重写用户昵称方法
-(void)setName:(NSString *)name
{
    NSMutableDictionary *stateDict = [self getStateDict];
    [stateDict setObject:name forKey:@"name"];
    [self saveStateDict:stateDict];
}

-(NSString *)name
{
    NSMutableDictionary *stateDict = [self getStateDict];
    return [stateDict objectForKey:@"name"];
}

//重写用户头像方法
-(void)setAvatarUrl:(NSString *)avatarUrl
{
    NSMutableDictionary *stateDict = [self getStateDict];
    [stateDict setObject:avatarUrl forKey:@"avatarUrl"];
    [self saveStateDict:stateDict];
}

-(NSString *)avatarUrl
{
    NSMutableDictionary *stateDict = [self getStateDict];
    return [stateDict objectForKey:@"avatarUrl"];
}

//重写userId相关方法
-(void)setUserId:(NSString *)userId
{
    NSMutableDictionary *stateDict = [self getStateDict];
    [stateDict setObject:userId forKey:@"userId"];
    [self saveStateDict:stateDict];
}

-(NSString *)userId
{
    NSMutableDictionary *stateDict = [self getStateDict];
    return [stateDict objectForKey:@"userId"];
}

-(NSString *)wbUserId
{
    return [KeyChainTool getValueByKey:kWBUSERID];
}

-(void)setWbUserId:(NSString *)wbUserId
{
    if (wbUserId.length==0) {
        
        [KeyChainTool removeValueByKey:kWBUSERID];
    }else{
    
        [KeyChainTool setValue:wbUserId forKey:kWBUSERID];
    }
}

@end
