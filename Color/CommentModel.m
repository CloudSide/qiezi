//
//  CommentModel.m
//  Color
//
//  Created by chao han on 12-5-30.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CommentModel.h"

@implementation CommentModel
@synthesize mediaId = _mediaId , ctime = _ctime , content = _content , owner = _owner
, thumbnailUrl = _thumbnailUrl , circleId = _circleId , commentId = _commentId
, ownerName = _ownerName , isGood = _isGood , status = _status , feedUser = _feedUser;

-(void)dealloc{
    self.mediaId = nil;
    self.ctime = nil;
    self.content = nil;
    self.owner = nil;
    self.thumbnailUrl = nil;
    self.circleId = nil;
    self.commentId = nil;
    self.ownerName = nil;
    self.isGood = nil;
    self.status = nil;
    self.feedUser = nil;
    
    [super dealloc];
}

@end
