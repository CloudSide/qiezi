//
//  NSString+URLEncoding.m
//  paixiu_plugin
//
//  Created by evil on 12-2-10.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "NSString+URLEncoding.h"


@implementation NSString (URLEncodingAdditions)

- (NSString *)URLEncodedString
{
    NSString *result = (NSString *)
	CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
											(CFStringRef)self,
											NULL,
											CFSTR("!*'();:@&amp;=+$,/?%#[] "),
											kCFStringEncodingUTF8);
    [result autorelease];
    return result;
}

- (NSString*)URLDecodedString
{
    NSString *result = (NSString *)
	CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault,
															(CFStringRef)self,
															CFSTR(""),
															kCFStringEncodingUTF8);
    [result autorelease];
    return result;
}

//- (NSString *)stringByDecodingHTMLEntitiesInString {
//    NSMutableString *results = [NSMutableString string];
//    NSScanner *scanner = [NSScanner scannerWithString:self];
//    [scanner setCharactersToBeSkipped:nil];
//    while (![scanner isAtEnd]) {
//        NSString *temp;
//        if ([scanner scanUpToString:@"&" intoString:&temp]) {
//            [results appendString:temp];
//        }
//        if ([scanner scanString:@"&" intoString:NULL]) {
//            BOOL valid = YES;
//            unsigned c = 0;
//            NSUInteger savedLocation = [scanner scanLocation];
//            if ([scanner scanString:@"#" intoString:NULL]) {
//                // it's a numeric entity
//                if ([scanner scanString:@"x" intoString:NULL]) {
//                    // hexadecimal
//                    unsigned int value;
//                    if ([scanner scanHexInt:&value]) {
//                        c = value;
//                    } else {
//                        valid = NO;
//                    }
//                } else {
//                    // decimal
//                    int value;
//                    if ([scanner scanInt:&value] && value >= 0) {
//                        c = value;
//                    } else {
//                        valid = NO;
//                    }
//                }
//                if (![scanner scanString:@";" intoString:NULL]) {
//                    // not ;-terminated, bail out and emit the whole entity
//                    valid = NO;
//                }
//            } else {
//                if (![scanner scanUpToString:@";" intoString:&temp]) {
//                    // &; is not a valid entity
//                    valid = NO;
//                } else if (![scanner scanString:@";" intoString:NULL]) {
//                    // there was no trailing ;
//                    valid = NO;
//                } else if ([temp isEqualToString:@"amp"]) {
//                    c = '&';
//                } else if ([temp isEqualToString:@"quot"]) {
//                    c = '"';
//                } else if ([temp isEqualToString:@"lt"]) {
//                    c = '<';
//                } else if ([temp isEqualToString:@"gt"]) {
//                    c = '>';
//                } else {
//                    // unknown entity
//                    valid = NO;
//                }
//            }
//            if (!valid) {
//                // we errored, just emit the whole thing raw
//                [results appendString:[self substringWithRange:NSMakeRange(savedLocation, [scanner scanLocation]-savedLocation)]];
//            } else {
//                [results appendFormat:@"%C", c];
//            }
//        }
//    }
//    return results;
//}


@end


