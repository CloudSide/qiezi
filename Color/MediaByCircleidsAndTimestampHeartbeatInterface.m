//
//  MediaByCircleidsAndTimestampHeartbeatInterface.m
//  Color
//
//  Created by chao han on 12-6-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MediaByCircleidsAndTimestampHeartbeatInterface.h"
#import "DeviceUtil.h"
#import "MediaModel.h"
#import "UserModel.h"

@implementation MediaByCircleidsAndTimestampHeartbeatInterface
@synthesize delegate = _delegate;

-(void)getMediaByCircleids:(NSString *)cidStr timestamp:(NSTimeInterval)timestamp
{
    self.needCacheFlag = NO;
    
    self.baseDelegate = self;
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:[DeviceUtil getMacAddress] forKey:@"deviceId"];
    [dict setObject:[NSString stringWithFormat:@"%.11g",[MySingleton sharedSingleton].lon] forKey:@"lon"];
    [dict setObject:[NSString stringWithFormat:@"%.10g",[MySingleton sharedSingleton].lat] forKey:@"lat"];
    [dict setObject:cidStr forKey:@"circleids"];
    [dict setObject:[NSString stringWithFormat:@"%d",(NSInteger)timestamp] forKey:@"timestamp"];
    
    self.interfaceUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@/user/picbycircleidsandbytimestamp",[MySingleton sharedSingleton].baseInterfaceUrl]];
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
//        "media": [
//                  {
//                      "userId": "580000015",
//                      "mediaId": "580000013_1339388060",
//                      "ctime": "1339388060",
//                      "type": 0,
//                      "circleId": "174",
//                      "originalUrl": "http://12qiezi-12qiezi.stor.sinaapp.com/original/580000013/580000013_1339388060.jpg",
//                      "thumbnailUrl": "http://12qiezi-12qiezi.stor.sinaapp.com/thumbnail/580000013/small_580000013_1339388060.jpg",
//                      "comCount": "0",
//                      "googCount": "0"
//                  },
//                  {
//                      "userId": "580000015",
//                      "mediaId": "580000014_1339262482",
//                      "ctime": "1339262482",
//                      "type": 1,
//                      "circleId": "163",
//                      "originalUrl": "http://12qiezi-12qiezi.stor.sinaapp.com/original/580000014/580000014_1339262482.3gp",
//                      "thumbnailUrl": "http://12qiezi-12qiezi.stor.sinaapp.com/thumbnail/580000014/small_580000014_1339262482.jpg",
//                      "comCount": "0",
//                      "googCount": "0"
//                  },
//                  {
//                      "userId": "580000015",
//                      "mediaId": "580000014_1339262433",
//                      "ctime": "1339262433",
//                      "type": 0,
//                      "circleId": "162",
//                      "originalUrl": "http://12qiezi-12qiezi.stor.sinaapp.com/original/580000014/580000014_1339262433.gif",
//                      "thumbnailUrl": "http://12qiezi-12qiezi.stor.sinaapp.com/thumbnail/580000014/small_580000014_1339262433.gif",
//                      "comCount": "0",
//                      "googCount": "0"
//                  }
//                  ]
//    }
//}

#pragma mark - BaseInterfaceDelegate
-(void)parseResult:(NSDictionary *)responseDict{
    if (responseDict && [responseDict count] > 0) {
        NSMutableDictionary *mediaDictionary = [[NSMutableDictionary alloc] init];//返回结果
        
        NSDictionary *content = [responseDict objectForKey:@"content"];
        NSArray *mediaArray = [content objectForKey:@"media"];
        
        for (NSDictionary *dict in mediaArray) {
            //丢弃自己拍摄的照片，自己拍摄的照片已经通过notification添加上去了
            if (![[MySingleton sharedSingleton].userId isEqualToString:[dict objectForKey:@"userId"]]) {
                MediaModel *mediaModel = [[MediaModel alloc] init];
                mediaModel.mid = [dict objectForKey:@"mediaId"];
                mediaModel.ctime = [NSDate dateWithTimeIntervalSince1970:[[dict objectForKey:@"ctime"]intValue]];
                mediaModel.mediaType = [[dict objectForKey:@"type"] intValue];
                mediaModel.circleId = [dict objectForKey:@"circleId"];
                mediaModel.originalUrl = [dict objectForKey:@"originalUrl"];
                mediaModel.thumbnailUrl = [dict objectForKey:@"thumbnailUrl"];
                mediaModel.comCount = [[dict objectForKey:@"comCount"] intValue];
                mediaModel.goodCount = [[dict objectForKey:@"goodCount"] intValue];
                
                UserModel *user = [[UserModel alloc] init];
                user.userId = [dict objectForKey:@"userId"];
                mediaModel.owner = user;
                [user release];
                
                NSMutableArray *marray = [mediaDictionary objectForKey:mediaModel.circleId];
                if (marray == nil) {
                    marray = [[NSMutableArray alloc] init];
                    [mediaDictionary setObject:marray forKey:mediaModel.circleId];
                    [marray release];
                }
                
                [marray addObject:mediaModel];
                [mediaModel release];
            }
        }
        
        [self.delegate getMediaByCircleidsAndTimestampDidFinished:mediaDictionary];
        [mediaDictionary release];
        
    }else{
        [self.delegate getMediaByCircleidsAndTimestampDidFinished:nil];
    }
}

-(void)requestIsFailed:(NSString *)errorMsg{
    [self.delegate getMediaByCircleidsAndTimestampDidFailed:errorMsg];
}
@end
