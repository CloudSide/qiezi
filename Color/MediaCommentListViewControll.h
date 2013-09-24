//
//  MediaCommentListViewControll.h
//  Color
//
//  Created by chao han on 12-6-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomTabBarController.h"
#import "TabBarCommentView.h"
#import "EGOImageView.h"
#import "MediaModel.h"
#import "UserModel.h"
#import "CreateCommentInterface.h"
#import "CommentViewController.h"

#import "CommentShowInterface.h"
#import "EGORefreshTableHeaderView.h"

@interface MediaCommentListViewControll : UIViewController <CreateCommentInterfaceDelegate 
, CommentDelegate , CommentShowInterfaceDelegate , EGORefreshTableHeaderDelegate>{
    
    EGORefreshTableHeaderView *_refreshHeaderView;
	//  Reloading var should really be your tableviews datasource
	//  Putting it here for demo purposes 
	BOOL _reloading;
    
    BOOL _isGettingNextPage;
    BOOL _hasMorePage;
    
    CustomTabBarController *mCustomTabBarController;
}

@property (nonatomic,retain) TabBarCommentView *tabBarView;

@property (nonatomic,retain) MediaModel *media;
@property (nonatomic,retain) NSMutableArray *commentList;//评论列表

@property (nonatomic,retain) CreateCommentInterface *mCreateCommentInterface;
@property (nonatomic,retain) CommentViewController *mCommentViewController;

@property (nonatomic,retain) CommentShowInterface *mCommentShowInterface;//获取评论列表接口
@property (nonatomic,retain) CommentShowInterface *mCommentShowInterfaceForPull;//获取评论列表接口--下拉刷新

@property (nonatomic,retain) IBOutlet UIScrollView *mscrollView;
@property (nonatomic,retain) IBOutlet UILabel *nameLabel;
@property (nonatomic,retain) IBOutlet UILabel *dateLabel;
@property (nonatomic,retain) IBOutlet EGOImageView *avatarImageView;
@property (nonatomic,retain) IBOutlet EGOImageView *photoImageView;
@property (nonatomic,retain) IBOutlet UIView *headerViewGroup;
@property (nonatomic,retain) IBOutlet UILabel *someLikeThis;

@end
