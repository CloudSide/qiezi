//
//  DynamicUIViewController.h
//  Color
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
@property (nonatomic,retain) NSMutableArray *dynamicList;

@property (nonatomic,retain) DynamicInterface *mDynamicInterface;
@property (nonatomic,retain) DynamicInterface *mDynamicInterfaceForPull;
@end
