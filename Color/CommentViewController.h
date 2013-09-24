//
//  CommentViewController.h
//  Color
//
//  Created by chao han on 12-6-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol CommentDelegate;
@interface CommentViewController : UIViewController <UITextViewDelegate>{
    NSInteger spaceAmount;
}

@property (nonatomic,retain) UITextView *mTextView;
@property (nonatomic,assign) id<CommentDelegate> delegate;

@property (nonatomic,retain) NSString *feedId;//回复人id
@property (nonatomic,retain) NSString *feedUsername;//回复人名称

-(id)initWithFeedId:(NSString *)feedId andFeedUserName:(NSString *)feedUsername;
@end

@protocol CommentDelegate <NSObject>

-(void)sendComment:(NSString *)comment feedId:(NSString *)fid;

@end
