//
//  CreateComment.m
//  Color
//
//  Created by chao han on 12-6-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CreateCommentInterface.h"
#import "DeviceUtil.h"
#import "NSString+URLEncoding.h"

@implementation CreateCommentInterface

@synthesize delegate = _delegate;

-(void)createCommentByMediaId:(NSString *)mId good:(NSInteger) good{
    self.needCacheFlag = NO;
    
    self.baseDelegate = self;
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:[DeviceUtil getMacAddress] forKey:@"deviceId"];
    [dict setObject:[NSString stringWithFormat:@"%.11g",[MySingleton sharedSingleton].lon] forKey:@"lon"];
    [dict setObject:[NSString stringWithFormat:@"%.10g",[MySingleton sharedSingleton].lat] forKey:@"lat"];
    [dict setObject:mId forKey:@"mediaId"];
    [dict setObject:[NSString stringWithFormat:@"%d",good] forKey:@"good"];
    [dict setObject:@"" forKey:@"content"];
    
    self.interfaceUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@/comment/create",[MySingleton sharedSingleton].baseInterfaceUrl]];
    self.postKeyValues = dict;
    [dict release];
    
    [self connect];
}

-(void)createCommentByMediaId:(NSString *)mId content:(NSString *)content feedId:(NSString *)fid{
    _mediaId = [mId retain];
    _content = [content retain];
    
    self.needCacheFlag = NO;
    
    self.baseDelegate = self;
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:[DeviceUtil getMacAddress] forKey:@"deviceId"];
    [dict setObject:[NSString stringWithFormat:@"%.11g",[MySingleton sharedSingleton].lon] forKey:@"lon"];
    [dict setObject:[NSString stringWithFormat:@"%.10g",[MySingleton sharedSingleton].lat] forKey:@"lat"];
    [dict setObject:mId forKey:@"mediaId"];
    [dict setObject:[content URLEncodedString] forKey:@"content"];
    
    if (fid != nil) {
        [dict setObject:fid forKey:@"feedId"];
    }
    [dict setObject:[NSString stringWithFormat:@"%d",0] forKey:@"good"];
    
    self.interfaceUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@/comment/create",[MySingleton sharedSingleton].baseInterfaceUrl]];
    self.postKeyValues = dict;
    [dict release];
    
    [self connect];
}

-(void)dealloc {
    self.delegate = nil;
    [_content release];
    [_mediaId release];
    
    [super dealloc];
}


#pragma mark - BaseInterfaceDelegate
-(void)parseResult:(NSDictionary *)responseDict{
    [self.delegate createCommentDidFinished:_mediaId content:_content];
    
}

-(void)requestIsFailed:(NSString *)errorMsg{
    [self.delegate createCommentDidFailed:errorMsg];
}

@end
