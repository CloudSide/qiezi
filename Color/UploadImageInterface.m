//
//  UploadImageInterface.m
//  Color
//
//  Created by chao han on 12-5-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "UploadImageInterface.h"
#import "DeviceUtil.h"
#import "UIImage+UIImageScale.h"
#import "NSString+MD5.h"

@implementation UploadImageInterface
@synthesize delegate = _delegate;

-(void)doUploadImage:(UIImage *)image description:(NSString *)description 
            circleId:(NSInteger) cid lon:(double)lon lat:(double)lat
              taskId:(long long int)tId{
    self.needCacheFlag = NO;
    _timeOutSecond = 30;
    taskId = tId;
    self.baseDelegate = self;
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:[DeviceUtil getMacAddress] forKey:@"deviceId"];
    [dict setObject:[NSString stringWithFormat:@"%.11g",lon] forKey:@"lon"];
    [dict setObject:[NSString stringWithFormat:@"%.10g",lat] forKey:@"lat"];
    
    [dict setObject:@"jpg" forKey:@"format"];
    
    NSString *imageBase64Str = [[image image2String] retain];
    [dict setObject:imageBase64Str forKey:@"data"];
    [dict setObject:[imageBase64Str md5HexDigest] forKey:@"md5"];
    [imageBase64Str release];
    
    [dict setObject:[NSString stringWithFormat:@"%d",cid] forKey:@"circleId"];
    [dict setObject:@"1024" forKey:@"size"];
    [dict setObject:description forKey:@"description"];
    
    NSLog(@"lon:[%@]  lat:[%@]  md5:[%@]  circleId:[%@]",[dict objectForKey:@"lon"],[dict objectForKey:@"lat"],[dict objectForKey:@"md5"],[dict objectForKey:@"circleId"]);
    
    self.interfaceUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@/media/uploadphoto",[MySingleton sharedSingleton].baseInterfaceUrl]];
    self.postKeyValues = dict;
    [dict release];
    
    [self connect];
}

-(void)dealloc {
    self.delegate = nil;
    
    [super dealloc];
}

#pragma mark - BaseInterfaceDelegate
-(void)parseResult:(NSDictionary *)responseDict{
    if (responseDict && [responseDict count] > 0) {
        NSDictionary *content = [responseDict objectForKey:@"content"];
        [MySingleton sharedSingleton].currentCircleId = [[content objectForKey:@"circleId"] intValue];
    }
    
    [self.delegate uploadImageDidFinishedTaskId:taskId];
}

-(void)requestIsFailed:(NSString *)errorMsg{
    [self.delegate uploadImageDidFailed:errorMsg taskId:taskId];
}

@end
