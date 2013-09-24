//
//  NotificationUIViewController.h
//  Color
//  通知主界面
//  Created by chao han on 12-5-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"

@class AllCommentListInterface;
@protocol AllCommentListInterfaceDelegate;
@interface NotificationUIViewController : UIViewController <UITableViewDelegate
, UITableViewDataSource , AllCommentListInterfaceDelegate , EGORefreshTableHeaderDelegate>{
    
    EGORefreshTableHeaderView *_refreshHeaderView;
	//  Reloading var should really be your tableviews datasource
	//  Putting it here for demo purposes 
	BOOL _reloading;
    
    BOOL _isGettingNextPage;
    BOOL _hasMorePage;
    
    BOOL _needAutoRefreshFlag;//用于每次切换至该页面时，判断时候需要自动做下拉刷新
}

@property (nonatomic,retain) NSMutableArray *commentList;//动态列表

@property (nonatomic,retain) AllCommentListInterface *mAllCommentListInterface;
@property (nonatomic,retain) AllCommentListInterface *mAllCommentListInterfaceForPull;//动态接口--用于下拉刷新
@property (nonatomic,retain) UITableView *mtableView;

@end
