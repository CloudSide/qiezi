//
//  PendingUploadTaskDTO.m
//  Color
//
//  Created by chao han on 12-6-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "PendingUploadTaskDTO.h"

@implementation PendingUploadTaskDTO
@synthesize pid = _pid , filePath = _filePath , mediaType = _mediaType
 , retryTimes = _retryTimes , errorCode = _errorCode , lon = _lon , lat = _lat
 , circleId = _circleId , description = _description , pendingState = _pendingState
 , thumbnailPath = _thumbnailPath;

-(void)dealloc
{
    self.filePath = nil;
    self.errorCode = nil;
    self.circleId = nil;
    self.description = nil;
    self.thumbnailPath = nil;
    
    [super dealloc];
}
@end
