//
//  NotificationUIViewController.h
//  Color
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
    
    BOOL _needAutoRefreshFlag;
}

@property (nonatomic,retain) NSMutableArray *commentList;

@property (nonatomic,retain) AllCommentListInterface *mAllCommentListInterface;
@property (nonatomic,retain) AllCommentListInterface *mAllCommentListInterfaceForPull;
@property (nonatomic,retain) UITableView *mtableView;

@end
