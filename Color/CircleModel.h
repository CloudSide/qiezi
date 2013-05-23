//
//  CircleModel.h
//  Color
//  Created by chao han on 12-6-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserModel.h"
#import "MediaModel.h"

@interface CircleModel : NSObject

@property (nonatomic,retain) NSString *cId;
@property (nonatomic,retain) NSDate *ctime;
@property (nonatomic,retain) NSMutableArray *usersArray;
@property (nonatomic,retain) NSMutableArray *mediasArray;


@end
