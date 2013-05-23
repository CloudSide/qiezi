//
//  MySingleton.m
//  ZReader_HD
//
//  Created by zcom on 12-3-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MySingleton.h"

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
        if([CLLocationManager locationServicesEnabled]){
            self.man.delegate = self;
            self.man.distanceFilter = kCLDistanceFilterNone;
            self.man.desiredAccuracy = kCLLocationAccuracyBest;
            [self.man startUpdatingLocation];
        }
    }
    
    return self;
}
-(NSMutableDictionary *)getStateDict
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                         NSUserDomainMask, YES); 
    NSString *plistFile = [[paths objectAtIndex:0]
                           stringByAppendingPathComponent:@"state.plist"];
    
    NSMutableDictionary *stateDict = [[[NSMutableDictionary alloc] initWithContentsOfFile:plistFile] autorelease];
    if (!stateDict) {
        stateDict = [[[NSMutableDictionary alloc] init] autorelease];
        [stateDict setObject:[NSNumber numberWithInt:0] forKey:@"lastCircleId"];
        [stateDict setObject:[NSNumber numberWithInt:UIImagePickerControllerCameraFlashModeAuto] 
                      forKey:@"lastCameraFlashMode"];
        
        [stateDict setObject:@"" forKey:@"name"];
        [stateDict setObject:@"" forKey:@"userId"];
        [stateDict setObject:@"" forKey:@"avatarUrl"];
        [stateDict writeToFile:plistFile atomically:YES];
    }
    
    return stateDict;
}
-(BOOL)isStateDictExist
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                         NSUserDomainMask, YES); 
    NSString *plistFile = [[paths objectAtIndex:0]
                           stringByAppendingPathComponent:@"state.plist"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    return [fileManager fileExistsAtPath:plistFile];
}
-(void)saveStateDict:(NSMutableDictionary *)stateDict
{
    if (stateDict) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                             NSUserDomainMask, YES); 
        NSString *plistFile = [[paths objectAtIndex:0]
                               stringByAppendingPathComponent:@"state.plist"];
        
        [stateDict writeToFile:plistFile atomically:YES];
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
    
    [super dealloc];
}
- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation{
    CLLocationCoordinate2D coordinate = newLocation.coordinate;
    self.lat = coordinate.latitude;
    self.lon = coordinate.longitude;
    CLLocationAccuracy horizontal = newLocation.horizontalAccuracy;
    CLLocationAccuracy vertical = newLocation.verticalAccuracy;
    CLLocationDistance altitude = newLocation.altitude;
    NSDate *timestamp = [newLocation timestamp];
    if (!isLocationStarted) {
        isLocationStarted = YES;
        [[NSNotificationCenter defaultCenter] postNotificationName: kCLLocationManagerDidStarted object: nil];
    }
}
- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error{
    NSLog(@"%@",[error localizedDescription]);
}

-(NSInteger)currentCircleId
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

@end
