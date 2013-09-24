//
//  CreateComment.h
//  Color
//  发表评论
//  Created by chao han on 12-6-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BaseInterface.h"

@protocol CreateCommentInterfaceDelegate;
@interface CreateCommentInterface : BaseInterface <BaseInterfaceDelegate>{
    NSString *_mediaId;
    NSString *_content;
}

@property (nonatomic,assign) id<CreateCommentInterfaceDelegate> delegate;

-(void)createCommentByMediaId:(NSString *)mId good:(NSInteger) good;//顶
-(void)createCommentByMediaId:(NSString *)mId content:(NSString *)content feedId:(NSString *)fid;//发表评论
@end

@protocol CreateCommentInterfaceDelegate <NSObject>

-(void)createCommentDidFinished:(NSString *)mediaId content:(NSString *)content;
-(void)createCommentDidFailed:(NSString *)errorMsg;



@end
