//
//  RegisteInterface.h
//  Color
//
//  Created by chao han on 12-5-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"

@protocol RegisteInterfaceDelegate;
@interface RegisteInterface : NSObject <ASIHTTPRequestDelegate>

@property (nonatomic,retain) ASIHTTPRequest *request;
@property (nonatomic,assign) id<RegisteInterfaceDelegate> delegate;

-(void)doRegiste:(NSString *)name avatar:(NSString *) avatar format:(NSString *)format email:(NSString *)email;//注册
@end

@protocol RegisteInterfaceDelegate

-(void)registeDidFinished;
-(void)registeDidFailed;

@end
