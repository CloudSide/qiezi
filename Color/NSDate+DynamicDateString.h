//
//  NSDate+DynamicDateString.h
//  Color
//
//  Created by chao han on 12-6-1.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (DynamicDateString)

-(NSString *)getDynamicDateStringFromNow;//根据当前时间获取用于显示的时间格式

-(BOOL)isSameDay:(NSDate*)date;//比较两个date是否是同一天
@end
