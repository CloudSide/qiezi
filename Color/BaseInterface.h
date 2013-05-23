//
//  BaseInterface.h
//  Color
//  Created by chao han on 12-5-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"
#import "DefaultLoginInterface.h"

@protocol BaseInterfaceDelegate;

@interface BaseInterface : NSObject <ASIHTTPRequestDelegate,DefaultLoginInterfaceDelegate>{
    NSInteger _timeOutSecond;
}

@property (nonatomic,assign) BOOL needCacheFlag;
@property (nonatomic,retain) ASIHTTPRequest *request;
@property (nonatomic,assign) id<BaseInterfaceDelegate> baseDelegate;
@property (nonatomic,retain) NSString *interfaceUrl;
@property (nonatomic,retain) NSDictionary *postKeyValues;

@property (nonatomic,retain) DefaultLoginInterface *mDefaultLoginInterface;

-(void)connect;

@end

@protocol BaseInterfaceDelegate <NSObject>

@required
-(void)parseResult:(NSDictionary *)responseDict;
-(void)requestIsFailed:(NSString *)errorMsg;

@optional

@end