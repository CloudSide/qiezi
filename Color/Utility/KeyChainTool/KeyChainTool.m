//
//  KeyChainTool.m
//  WeiLingPai
//
//  参考：http://www.cnblogs.com/v2m_/archive/2012/01/18/2325782.html
//
//  Created by hanchao on 14-1-16.
//  Copyright (c) 2014年 evil. All rights reserved.
//

#import "KeyChainTool.h"
#import <Security/Security.h>


@implementation KeyChainTool

+(BOOL)setValue:(NSString *)value forKey:(NSString *)key
{
    if (value.length > 0 && key.length > 0) {
        // 一个mutable字典结构存储item信息
        NSMutableDictionary* dic = [NSMutableDictionary dictionary];
        // 确定所属的类class
        [dic setObject:(id)kSecClassGenericPassword forKey:(id)kSecClass];
        // 设置其他属性attributes
        [dic setObject:key forKey:(id)kSecAttrAccount];
        // 添加密码 secValue  注意是object 是 NSData
        [dic setObject:[value dataUsingEncoding:NSUTF8StringEncoding] forKey:(id)kSecValueData];
        // SecItemAdd
        OSStatus s = SecItemAdd((CFDictionaryRef)dic, NULL);
        NSLog(@"add : %ld",s);
    }
    
    return YES;
}

+(NSString *)getValueByKey:(NSString *)key
{
    if (key.length >0) {
        // 查找条件：1.class 2.attributes 3.search option
        NSDictionary* query = [NSDictionary dictionaryWithObjectsAndKeys:kSecClassGenericPassword,kSecClass,
                               key,kSecAttrAccount,
                               kCFBooleanTrue,kSecReturnAttributes,nil];
        CFTypeRef result = nil;
        // 先找到一个item
        OSStatus s = SecItemCopyMatching((CFDictionaryRef)query, &result);
        NSLog(@"select name : %ld",s);  //  errSecItemNotFound 就是找不到
        NSLog(@"%@",result);
        if (s == noErr) {
            // 继续查找item的secValue
            NSMutableDictionary* dic = [NSMutableDictionary dictionaryWithDictionary:result];
            // 存储格式
            [dic setObject:(id)kCFBooleanTrue forKey:kSecReturnData];
            // 确定class
            [dic setObject:[query objectForKey:kSecClass] forKey:kSecClass];
            NSData* data = nil;
            // 查找secValue
            if (SecItemCopyMatching((CFDictionaryRef)dic, (CFTypeRef*)&data) == noErr) {
                if (data.length)
                   return [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
            }
        }
    }
    
    return nil;
}

+(BOOL)removeValueByKey:(NSString *)key
{
    if (key.length >0) {
        // 删除的条件
        NSDictionary* query = [NSDictionary dictionaryWithObjectsAndKeys:kSecClassGenericPassword,kSecClass,
                               key,kSecAttrAccount,nil];
        // SecItemDelete
        OSStatus status = SecItemDelete((CFDictionaryRef)query);
        NSLog(@"delete:%ld",status);    // //  errSecItemNotFound 就是没有
    }
    
    return YES;
}

@end
