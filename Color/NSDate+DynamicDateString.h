//
//  NSDate+DynamicDateString.h
//  Color
//
//  Created by chao han on 12-6-1.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (DynamicDateString)

-(NSString *)getDynamicDateStringFromNow;

-(BOOL)isSameDay:(NSDate*)date;
@end
