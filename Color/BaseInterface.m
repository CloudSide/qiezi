//
//  BaseInterface.m
//  Color
//
//  Created by chao han on 12-5-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BaseInterface.h"
#import "JSONKit.h"
#import "InterfaceCache.h"
#import "DeviceUtil.h"

@implementation BaseInterface

@synthesize request = _request , baseDelegate = _baseDelegate , interfaceUrl = _interfaceUrl
, postKeyValues = _postKeyValues 
, mDefaultLoginInterface = _mDefaultLoginInterface , needCacheFlag = _needCacheFlag;

-(id)init
{
    self = [super init];
    if (self) {
        self.needCacheFlag = YES;
        _timeOutSecond = 5;
    }
    
    return self;
}

//保存服务器返回的内容
-(void)writeLog:(NSString *)responseBody url:(NSString *)url
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *logPath = [documentsDirectory stringByAppendingPathComponent:@"log.txt"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
//    NSError *error;
    
    BOOL isDirectory = NO;
    BOOL exists = [fileManager fileExistsAtPath:logPath isDirectory:&isDirectory];
    if (!exists || isDirectory) {
        [fileManager removeItemAtPath:logPath error:nil];
        
        //创建文件
//        [fileManager createDirectoryAtPath:pendingUploadsPath withIntermediateDirectories:NO attributes:nil error:nil];
        NSString *emptyFilecontent = [NSString stringWithFormat:@""];
        [emptyFilecontent writeToFile:logPath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    }
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];     
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit |     
    NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;    
    NSDateComponents *comps = [calendar components:unitFlags fromDate:[NSDate date]];
    NSString *dateStr = [NSString stringWithFormat:@"%04d%02d%02d%02d%02d%02d",comps.year,comps.month,comps.day,comps.hour,comps.minute,comps.second];
    [calendar release];
    
    NSFileHandle *myHandle = [NSFileHandle fileHandleForWritingAtPath:logPath];
    [myHandle seekToEndOfFile];
    [myHandle writeData:[[NSString stringWithFormat:@"\n%@,%@,%@,%@",[DeviceUtil getMacAddress],dateStr,url , responseBody] dataUsingEncoding:NSUTF8StringEncoding]];
    [myHandle closeFile];
}

-(void)connect {
    if (self.interfaceUrl) {
        NSMutableString *urlStr = [NSMutableString stringWithFormat:@"%@?session_id=%@"
                                   ,self.interfaceUrl
                                   ,[MySingleton sharedSingleton].sessionId];
        
        if (self.needCacheFlag && self.postKeyValues) {
            for (NSString *key in self.postKeyValues) {
                if ([key isEqualToString:@"lon"] || [key isEqualToString:@"lat"]) {
                    continue;
                }
                [urlStr appendString:[NSString stringWithFormat:@"&%@=%@",key,[self.postKeyValues objectForKey:key]]];
            }
        }
        
        NSURL *url = [[NSURL alloc] initWithString:urlStr];
        self.request = [ASIHTTPRequest requestWithURL:url];
        [url release];
        
        if (self.needCacheFlag)
        {
            //设置缓存机制
            [[InterfaceCache sharedCache] setShouldRespectCacheControlHeaders:NO];
            [self.request setDownloadCache:[InterfaceCache sharedCache]];
            [self.request setCachePolicy:ASIAskServerIfModifiedWhenStaleCachePolicy | ASIFallbackToCacheIfLoadFailsCachePolicy];
            [self.request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
        }
        
        [self.request setTimeOutSeconds:_timeOutSecond];
        
        if (self.postKeyValues) {
            [self.request appendPostData:[[self.postKeyValues JSONString] dataUsingEncoding:NSUTF8StringEncoding]];
        }
        
        [self.request setDelegate:self];
        [self.request startAsynchronous]; 
    }else{
        //抛出异常
    }
}

#pragma mark - ASIHttpRequestDelegate
-(void)requestFinished:(ASIHTTPRequest *)request {
    NSString *responseBody = request.responseString;
    NSLog(@"==============%@",responseBody);
    [self writeLog:responseBody url:[request.url absoluteString]];
    
    NSDictionary *respDict = [(NSDictionary *)[responseBody objectFromJSONString] retain];
    NSInteger returncode = [[respDict objectForKey:@"returncode"] intValue];//结果码
    
    if (returncode == 0) {//返回成功
        [_baseDelegate parseResult:respDict];
    }else{
        //TODO 判断session过期标志
        if (returncode == 99999) {
            [self.request clearDelegatesAndCancel];
            self.request = nil;
            
            self.mDefaultLoginInterface = [[[DefaultLoginInterface alloc] init] autorelease];
            self.mDefaultLoginInterface.delegate = self;
            [self.mDefaultLoginInterface doLogin];
            
        }else{
            NSLog(@"returncode : %d",returncode);
            [self.baseDelegate requestIsFailed:[NSString stringWithFormat:@"%d", returncode]];
        }
    }
    
    [respDict release];
    respDict = nil;
}

-(void)requestFailed:(ASIHTTPRequest *)request {
    NSLog(@"%@",request.error.localizedDescription);
    [self writeLog:request.error.localizedDescription url:[request.url absoluteString]];
    [self.baseDelegate requestIsFailed:request.error.localizedDescription];//未知错误或网络错误
}


-(void)dealloc {
    [self.request clearDelegatesAndCancel];
    self.request = nil;
    
    self.baseDelegate = nil;
    self.interfaceUrl = nil;
    self.postKeyValues = nil;
    
    self.mDefaultLoginInterface.delegate = nil;
    self.mDefaultLoginInterface = nil;
    
    [super dealloc];
}

#pragma mark - DefaultLoginInterfaceDelegate
-(void)loginDidFinished:(NSInteger) isNew updateUrl:(NSString *)url{
    [self connect];
    
    self.mDefaultLoginInterface.delegate = nil;
    self.mDefaultLoginInterface = nil;
}

-(void)loginDidFailed{
    self.mDefaultLoginInterface.delegate = nil;
    self.mDefaultLoginInterface = nil;
}


@end
