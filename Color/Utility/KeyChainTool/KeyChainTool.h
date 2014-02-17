//
//  KeyChainTool.h
//  WeiLingPai
//
//  keychain工具类
//
//  Created by hanchao on 14-1-16.
//  Copyright (c) 2014年 evil. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KeyChainTool : NSObject

+(BOOL)setValue:(NSString *)value forKey:(NSString *)key;

+(NSString *)getValueByKey:(NSString *)key;

+(BOOL)removeValueByKey:(NSString *)key;

@end
