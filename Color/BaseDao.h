//
//  BaseDao.h
//  MagFan
//
//  Created by chao han on 12-6-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"

@interface BaseDao : NSObject

@property (nonatomic, retain) FMDatabase *db;

@end
