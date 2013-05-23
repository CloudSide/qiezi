//
//  DiaryUIViewController.h
//  Color
//  Created by chao han on 12-5-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HistoryInterface.h"

@class EGORefreshTableHeaderView;
@protocol EGORefreshTableHeaderDelegate;
@class FriendListInterface;
@protocol FriendListInterfaceDelegate;
@class DiaryHeaderCellView;

@interface DiaryUIViewController : UIViewController <UITableViewDelegate
,UITableViewDataSource,UIScrollViewDelegate , HistoryInterfaceDelegate
, FriendListInterfaceDelegate , EGORefreshTableHeaderDelegate>{

    EGORefreshTableHeaderView *_refreshHeaderView;
	//  Reloading var should really be your tableviews datasource
	//  Putting it here for demo purposes 
	BOOL _reloading;
    
    BOOL _isGettingNextPage;
    BOOL _hasMorePage;
}

@property (nonatomic,retain) UITableView *mtableView;

@property (nonatomic,retain) DiaryHeaderCellView *mDiaryHeaderCellView;

@property (nonatomic,retain) HistoryInterface *mHistoryInterface;
@property (nonatomic,retain) HistoryInterface *mHistoryInterfaceForPull;

@property (nonatomic,retain) NSMutableArray *diaryList;

@property (nonatomic,retain) FriendListInterface *mFriendListInterface;
@property (nonatomic,retain) NSMutableArray *friendList;

@end
