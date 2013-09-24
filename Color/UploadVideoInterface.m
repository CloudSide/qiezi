//
//  UploadVideoInterface.m
//  Color
//
//  Created by chao han on 12-5-24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "UploadVideoInterface.h"
#import "DeviceUtil.h"
#import "UIImage+UIImageScale.h"
#import "NSData+Additions.h"
#import "NSString+MD5.h"

@implementation UploadVideoInterface

@synthesize delegate = _delegate;

-(void)doUploadVideo:(NSData *)videoData thumbnail:(UIImage *)thumbnail 
         description:(NSString *)description circleId:(NSInteger) cid 
                 lon:(double)lon lat:(double)lat taskId:(long long int)tId{
    self.needCacheFlag = NO;
    _timeOutSecond = 30;//网络超时30秒
    
    taskId = tId;
    self.baseDelegate = self;
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:[DeviceUtil getMacAddress] forKey:@"deviceId"];
    [dict setObject:[NSString stringWithFormat:@"%.11g",lon] forKey:@"lon"];
    [dict setObject:[NSString stringWithFormat:@"%.10g",lat] forKey:@"lat"];
    [dict setObject:@"mov" forKey:@"format"];
    [dict setObject:[videoData base64Encoding] forKey:@"data"];
    
    NSString *thumbnailImageBase64Str = [[thumbnail image2String] retain];
    [dict setObject:thumbnailImageBase64Str forKey:@"thumbnailData"];
    [dict setObject:[thumbnailImageBase64Str md5HexDigest] forKey:@"md5"];
    [thumbnailImageBase64Str release];
    
    [dict setObject:@"jpg" forKey:@"thumbnailFormat"];
    [dict setObject:[NSString stringWithFormat:@"%d",cid] forKey:@"circleId"];
    [dict setObject:@"1024" forKey:@"size"];
    [dict setObject:description forKey:@"description"];
    
    NSLog(@"lon:[%@]  lat:[%@]  md5:[%@]",[dict objectForKey:@"lon"],[dict objectForKey:@"lat"],[dict objectForKey:@"md5"]);
    
    self.interfaceUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@/media/uploadvideo",[MySingleton sharedSingleton].baseInterfaceUrl]];
    self.postKeyValues = dict;
    [dict release];
    
    [self connect];
}

-(void)dealloc {
    self.delegate = nil;
    
    [super dealloc];
}


//{
//    "returncode": "0",
//    "content": {
//        "mediaId": "580000015_1339668430",
//        "ctime": "1339668430",
//        "circleId": "231",
//        "originalUrl": "http://12qiezi-12qiezi.stor.sinaapp.com/original/580000015/580000015_1339668430.3gp",
//        "thumbnailUrl": "http://12qiezi-12qiezi.stor.sinaapp.com/thumbnail/580000015/small_580000015_1339668430.jpg"
//    }
//}
#pragma mark - BaseInterfaceDelegate
-(void)parseResult:(NSDictionary *)responseDict{
    if (responseDict && [responseDict count] > 0) {
        NSDictionary *content = [responseDict objectForKey:@"content"];
        [MySingleton sharedSingleton].currentCircleId = [[content objectForKey:@"circleId"] intValue];
    }
    
    [self.delegate uploadVideoDidFinishedTaskId:taskId];
}

-(void)requestIsFailed:(NSString *)errorMsg{
    [self.delegate uploadVideoDidFailed:errorMsg taskId:taskId];
}

@end
