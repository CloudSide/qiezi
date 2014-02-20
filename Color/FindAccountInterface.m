//
//  FindAccountInterface.m
//  QieZi
//
//  Created by hanchao on 14-2-19.
//
//

#import "FindAccountInterface.h"
#import "UserModel.h"
#import "MediaModel.h"

@implementation FindAccountInterface

//根据时间段获取列表---用于下拉刷新
-(void)findAccountByUserName:(NSString *)userName{

    self.baseDelegate = self;
    
    self.interfaceUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@/user.php?a=getuserlist&username=%@"
                                              ,[MySingleton sharedSingleton].baseInterfaceUrl,userName]];
    
    [self connect];
}

-(void)dealloc {
    self.delegate = nil;
    
    [super dealloc];
}

//{
//    "returncode": 10000,
//    "content": {
//        "userid": "580000017",
//        "name": "韩超",
//        "avatar": "avatar/580000017/580000017_1342618088.jpg",
//        "media": [
//                  {
//                      "location": {
//                          "province": "北京市",
//                          "city": "北京市",
//                          "district": "海淀区"
//                      },
//                      "thumbnail": "thumbnail/580000017/small_580000017_1380017530567.jpg"
//                  },
//                  ...
//                  ]
//    }
//}
#pragma mark - BaseInterfaceDelegate
-(void)parseResult:(NSDictionary *)responseDict{
    if (responseDict && [responseDict count] > 0) {
        NSInteger returncode = [[responseDict objectForKey:@"returncode"]intValue];
        
        NSMutableArray *resultList = [NSMutableArray array];
        if (returncode == 10000) {
            NSDictionary *content = [responseDict objectForKey:@"content"];
            
            NSArray *contentArray = [content objectForKey:@"content"];
            for (NSDictionary *userDict in contentArray) {
                NSDictionary *dict = [content objectForKey:@"content"];//
                UserModel *user = [[[UserModel alloc] init] autorelease];
                user.userId = [dict objectForKey:@"userid"];
                user.name = [dict objectForKey:@"name"];
                user.avatarUrl = [dict objectForKey:@"avatar"];
                NSMutableArray *picflow = [[NSMutableArray array] autorelease];
                user.lastPicFlow = picflow;
                
                NSArray *mediaArray = [dict objectForKey:@"media"];
                for (NSDictionary *media in mediaArray) {
                    MediaModel *mediaModel = [[[MediaModel alloc] init] autorelease];
                    mediaModel.mid = [media objectForKey:@"mediaId"];
                    mediaModel.ctime = [NSDate dateWithTimeIntervalSince1970:[[media objectForKey:@"ctime"]intValue]];
                    mediaModel.circleId = [media objectForKey:@"circleId"];
                    mediaModel.originalUrl = [media objectForKey:@"originalUrl"];
                    mediaModel.thumbnailUrl = [media objectForKey:@"thumbnailUrl"];
                    mediaModel.comCount = [[media objectForKey:@"comCount"] intValue];
                    mediaModel.goodCount = [[media objectForKey:@"goodCount"] intValue];
                    mediaModel.mediaType = [[media objectForKey:@"type"] intValue];

                    NSDictionary *location = [media objectForKey:@"location"];
                    mediaModel.city = [NSString stringWithFormat:@"%@ %@",[[location objectForKey:@"city"] stringValue]
                                       ,[[location objectForKey:@"district"] stringValue]];
                    
                    [picflow addObject:mediaModel];
                }
                
                [resultList addObject:user];
            }
            
        }
        
        [self.delegate findAccountDidFinished:resultList];
    }else{
       
        [self.delegate findAccountDidFailed:nil];
    }
}

-(void)requestIsFailed:(NSString *)errorMsg{
    [self.delegate findAccountDidFailed:errorMsg];
}

@end
