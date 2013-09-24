//
//  HomePageViewController.h
//  Color
//  朋友主页
//  Created by chao han on 12-6-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MediaByUserIdInterface.h"
#import "GetUserInfoInterface.h"

@class EGORefreshTableHeaderView;
@protocol EGORefreshTableHeaderDelegate;
@class DiaryHeaderCellView;
@class TabBarShareView;
@class CustomTabBarController;

@interface HomePageViewController : UIViewController <UITableViewDelegate
,UITableViewDataSource,UIScrollViewDelegate , MediaByUserIdInterfaceDelegate
, EGORefreshTableHeaderDelegate , GetUserInfoInterfaceDelegate>{
    
    EGORefreshTableHeaderView *_refreshHeaderView;
	//  Reloading var should really be your tableviews datasource
	//  Putting it here for demo purposes 
	BOOL _reloading;
    
    BOOL _isGettingNextPage;
    BOOL _hasMorePage;
    
    CustomTabBarController *mCustomTabBarController;
}

@property (nonatomic,retain) UITableView *mtableView;

@property (nonatomic,retain) DiaryHeaderCellView *mDiaryHeaderCellView;//回忆页面 头像view

@property (nonatomic,retain) MediaByUserIdInterface *mMediaByUserIdInterface;//历史列表接口
@property (nonatomic,retain) MediaByUserIdInterface *mMediaByUserIdInterfaceForPull;//历史列表接口--下拉刷新

@property (nonatomic,retain) NSMutableArray *diaryList;//回忆列表

@property (nonatomic,retain) NSString *userId;

@property (nonatomic,retain) TabBarShareView *tabBarView;
@property (nonatomic,retain) GetUserInfoInterface *mGetUserInfoInterface;

@end
