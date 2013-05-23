//
//  SendLogInterface.m
//  QieZi
//
//  Created by chao han on 12-7-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SendLogInterface.h"
#import "DeviceUtil.h"
#import "Reachability.h"

@implementation SendLogInterface
@synthesize request = _request ,delegate = _delegate;

-(void)sendLog {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *logPath = [documentsDirectory stringByAppendingPathComponent:@"log.txt"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    BOOL isDirectory = NO;
    BOOL exists = [fileManager fileExistsAtPath:logPath isDirectory:&isDirectory];
    if ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == kReachableViaWiFi
        && exists && !isDirectory) {
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];     
        NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit |     
        NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;    
        NSDateComponents *comps = [calendar components:unitFlags fromDate:[NSDate date]];
        NSString *dateStr = [NSString stringWithFormat:@"%04d%02d%02d%02d%02d%02d",comps.year,comps.month,comps.day,comps.hour,comps.minute,comps.second];
        [calendar release];
        
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/collect_log.php",[MySingleton sharedSingleton].baseInterfaceUrl]];
        self.request = [ASIFormDataRequest requestWithURL:url];
        [self.request setFile:logPath 
                 withFileName:[NSString stringWithFormat:@"%@-log-%@.txt",[DeviceUtil getMacAddress],dateStr] 
               andContentType:@"multipart/form-data" 
                       forKey:@"file"];
        self.request.delegate = self;
        
        [self.request startAsynchronous]; 
    }else{
        [self.delegate sendLogDidFinished];
    }
    
}

#pragma mark - ASIHttpRequestDelegate
-(void)requestFinished:(ASIHTTPRequest *)request {    
    NSString *responseBody = request.responseString;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *logPath = [documentsDirectory stringByAppendingPathComponent:@"log.txt"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtPath:logPath error:nil];

    [self.delegate sendLogDidFinished];
}

-(void)requestFailed:(ASIHTTPRequest *)request {
    // failed!!
    [self.delegate sendLogDidFailed];
}

-(void)dealloc {
    [self.request clearDelegatesAndCancel];
    self.request = nil;
    
    [super dealloc];
}

@end
