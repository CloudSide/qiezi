//
//  SendLogInterface.h
//  QieZi
//
//  Created by chao han on 12-7-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIFormDataRequest.h"

@protocol SendLogInterfaceDelegate;

@interface SendLogInterface : NSObject <ASIHTTPRequestDelegate>

@property (nonatomic,retain) ASIFormDataRequest *request;
@property (nonatomic,assign) id<SendLogInterfaceDelegate> delegate;

-(void)sendLog;
@end

@protocol SendLogInterfaceDelegate

-(void)sendLogDidFinished;
-(void)sendLogDidFailed;

@end
