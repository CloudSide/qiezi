//
//  CommentModel.h
//  Color
//  评论model
//  Created by chao han on 12-5-30.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserModel.h"

@interface CommentModel : NSObject

@property (nonatomic,retain) NSString *commentId;
@property (nonatomic,retain) NSString *ownerName;
@property (nonatomic,retain) NSString *content;
@property (nonatomic,retain) NSString *isGood;//1表示赞
@property (nonatomic,retain) NSString *status;//1表示未读
@property (nonatomic,retain) NSString *mediaId;
@property (nonatomic,retain) NSDate *ctime;
@property (nonatomic,retain) UserModel *owner;
@property (nonatomic,retain) NSString *thumbnailUrl;//???
@property (nonatomic,retain) NSString *circleId;
@property (nonatomic,retain) UserModel *feedUser;

@end
