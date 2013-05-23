//
//  UploadMediaService.h
//  Color
//  Created by chao han on 12-5-31.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UploadImageInterface.h"
#import "UploadVideoInterface.h"

@interface UploadMediaService : NSObject <UploadImageInterfaceDelegate,UploadVideoInterfaceDelegate> {
    NSOperationQueue *operationQueue;
}

- (void)addOperation:(long long int)taskId;
-(void)addOperationAfterDelay:(NSNumber *)taskId;

@property (retain,nonatomic) NSOperationQueue *operationQueue;

@property (retain,nonatomic) NSMutableDictionary *interfaceHolder;

@end
