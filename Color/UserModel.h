//
//  UserModel.h
//  Color
//  用户model
//  Created by chao han on 12-5-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserModel : NSObject
//"userId": "580000003",
//"name": "sfh",
//"avatar": "http://12qiezi-12qiezi.stor.sinaapp.com/avatar/580000003/580000003_1338002076.JPEG"
@property (nonatomic,retain) NSString *userId;
@property (nonatomic,retain) NSString *name;
@property (nonatomic,retain) NSString *avatarUrl;


@end
