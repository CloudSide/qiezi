//
//  MediaModel.m
//  Color
//
//  Created by chao han on 12-5-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MediaModel.h"

@implementation MediaModel
@synthesize mid = _mid , ctime = _ctime , circleId = _circleId , originalUrl = _originalUrl
, thumbnailUrl = _thumbnailUrl , comCount = _comCount , goodCount = _goodCount
, mediaType = _mediaType , owner = _owner , commentArray = _commentArray
, hasMygood = _hasMygood , city = _city;

-(void)dealloc{
    self.mid = nil;
    self.ctime = nil;
    self.circleId = nil;
    self.originalUrl = nil;
    self.thumbnailUrl = nil;
    self.owner = nil;
    self.commentArray = nil;
    self.city = nil;
    
    [super dealloc];
}
@end
