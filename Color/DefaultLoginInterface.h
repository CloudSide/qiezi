//
//  DefaultLoginInterface.h
//
//  Created by  on 12-3-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"


@protocol DefaultLoginInterfaceDelegate;

@interface DefaultLoginInterface : NSObject <ASIHTTPRequestDelegate> {
    ASIHTTPRequest *_request;
}

@property (nonatomic,assign) id<DefaultLoginInterfaceDelegate> delegate;

-(void)doLogin;
@end

@protocol DefaultLoginInterfaceDelegate

-(void)loginDidFinished:(NSInteger)isNew updateUrl:(NSString *)url;
-(void)loginDidFailed;

@end
