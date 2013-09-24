//
//  NSDate+DynamicDateString.m
//  Color
//
//  Created by chao han on 12-6-1.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "NSDate+DynamicDateString.h"

@implementation NSDate (DynamicDateString)

-(NSString *)getDynamicDateStringFromNow{
    NSTimeInterval distanceFromNow = [self timeIntervalSinceNow];
    distanceFromNow = abs(distanceFromNow);
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];     
    
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit |     
    NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;    
    
    NSDateComponents *comps = [calendar components:unitFlags fromDate:self];
    [calendar release];
    
    NSString *weekDay = @"";
    switch ([comps weekday])   
    {   
        case 1:   
            weekDay=@"星期日";   
            break;   
        case 2:   
            weekDay=@"星期一";   
            break;   
        case 3:   
            weekDay=@"星期二";   
            break;   
        case 4:   
            weekDay=@"星期三";   
            break;   
        case 5:   
            weekDay=@"星期四";   
            break;   
        case 6:   
            weekDay=@"星期五";   
            break;   
        case 7:   
            weekDay=@"星期六";   
            break;   
    } 
    
    NSString *dateString ;
    if (distanceFromNow < 60) {//小于1分钟
        dateString = @"片刻前";
        
    }else if (distanceFromNow < 60 * 60) {//小于一小时
        dateString = [NSString stringWithFormat:@"%d分钟前",(NSInteger)distanceFromNow / 60];
        
    }else if (distanceFromNow < 24 * 60 * 60) {//小于一天
        dateString = [NSString stringWithFormat:@"%d小时%d分钟前",(NSInteger)distanceFromNow / 60 /60,(NSInteger)distanceFromNow / 60 % 60];
        
    }else if (distanceFromNow < 7 * 24 * 60 * 60) {//小于一周
        dateString = [NSString stringWithFormat:@"%@ %02d:%02d",weekDay,[comps hour],[comps minute]];
        
    }else if (distanceFromNow < 30 * 24 * 60 * 60) {//小于一月
        dateString = [NSString stringWithFormat:@"%d天前",(NSInteger)distanceFromNow / 24 / 60 / 60];
    }else {//大于1月
        dateString = [NSString stringWithFormat:@"%d月%d日",[comps month],[comps day]];
    }

    return dateString;
}



- (BOOL)isSameDay:(NSDate*)date 
{
    NSCalendar* calendar = [NSCalendar currentCalendar];
    
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
    
    NSDateComponents* comp1 = [calendar components:unitFlags fromDate:self];
    NSDateComponents* comp2 = [calendar components:unitFlags fromDate:date];
    
    return [comp1 day]   == [comp2 day] &&
        [comp1 month] == [comp2 month] &&
        [comp1 year]  == [comp2 year];
    
}

@end
