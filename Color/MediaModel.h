//
//  MediaModel.h
//  Color
//  媒体对象
//  Created by chao han on 12-5-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UserModel;
@interface MediaModel : NSObject
//"mediaId": "580000003_1338003354",
//"ctime": "1338003354",
//"circleId": "13",
//"originalUrl": "http://12qiezi-12qiezi.stor.sinaapp.com/original/580000003/580000003_1338003354.mov",
//"thumbnailUrl": "http://12qiezi-12qiezi.stor.sinaapp.com/thumbnail/580000003/small_580000003_1338003354.jpg",
//"comCount": "0",
//"goodCount": "0",

@property (nonatomic,retain) NSString *mid;
@property (nonatomic,retain) NSDate *ctime;
@property (nonatomic,retain) NSString *circleId;
@property (nonatomic,retain) NSString *originalUrl;
@property (nonatomic,retain) NSString *thumbnailUrl;
@property (nonatomic,assign) NSInteger comCount;
@property (nonatomic,assign) NSInteger goodCount;
@property (nonatomic,assign) NSInteger mediaType;//0:照片  1:视频
@property (nonatomic,retain) UserModel *owner;
@property (nonatomic,retain) NSMutableArray *commentArray;
@property (nonatomic,assign) BOOL hasMygood;//我顶过没

@property (nonatomic,retain) NSString *city;
//"province": "北京市",
//"city": "北京市",
//"district": "海淀区"


@end
