//
//  NSString+URLEncoding.h
//  paixiu_plugin
//	
//	功能：urlencode，urldecode
//
//  Created by evil on 12-2-10.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSString (URLEncodingAdditions)
- (NSString *)URLEncodedString;
- (NSString *)URLDecodedString;

//- (NSString *)stringByDecodingHTMLEntitiesInString;//解析html unicode
@end