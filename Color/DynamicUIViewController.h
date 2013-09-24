//
//  DynamicUIViewController.h
//  Color
//  动态主界面
//  Created by chao han on 12-5-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EGORefreshTableHeaderView;
@protocol EGORefreshTableHeaderDelegate;
@class DynamicInterface;
@protocol DynamicInterfaceDelegate;
@interface DynamicUIViewController : UIViewController <UITableViewDelegate
,UITableViewDataSource , DynamicInterfaceDelegate , EGORefreshTableHeaderDelegate>{
    
    EGORefreshTableHeaderView *_refreshHeaderView;
	//  Reloading var should really be your tableviews datasource
	//  Putting it here for demo purposes 
	BOOL _reloading;
    
    BOOL _isGettingNextPage;
    BOOL _hasMorePage;
}

@property (nonatomic,retain) UITableView *mtableView;
@property (nonatomic,retain) NSMutableArray *dynamicList;//动态列表

@property (nonatomic,retain) DynamicInterface *mDynamicInterface;//动态接口
@property (nonatomic,retain) DynamicInterface *mDynamicInterfaceForPull;//动态接口--用于下拉刷新
@end
