//
//  MediaModel.h
//  Color
//  Created by chao han on 12-5-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UserModel;
@interface MediaModel : NSObject
@property (nonatomic,retain) NSString *mid;
@property (nonatomic,retain) NSDate *ctime;
@property (nonatomic,retain) NSString *circleId;
@property (nonatomic,retain) NSString *originalUrl;
@property (nonatomic,retain) NSString *thumbnailUrl;
@property (nonatomic,assign) NSInteger comCount;
@property (nonatomic,assign) NSInteger goodCount;
@property (nonatomic,assign) NSInteger mediaType;//1:视频
@property (nonatomic,retain) UserModel *owner;
@property (nonatomic,retain) NSMutableArray *commentArray;
@property (nonatomic,assign) BOOL hasMygood;//我顶过没
@property (nonatomic,retain) NSString *city;
@end
