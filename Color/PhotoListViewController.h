//
//  PhotoListViewController.h
//  Color
//
//  Created by chao han on 12-5-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RemoveMediaInterface.h"

@class EGORefreshTableHeaderView;
@protocol EGORefreshTableHeaderDelegate;
@class TabBarShareView;
@class CustomTabBarController;
@class MediaByCircleIdInterface;
@protocol MediaByCircleIdInterfaceDelegate;

@interface PhotoListViewController : UIViewController<UIScrollViewDelegate
, MediaByCircleIdInterfaceDelegate , EGORefreshTableHeaderDelegate 
, RemoveMediaInterfaceDelegate , UIActionSheetDelegate>{
    CustomTabBarController *mCustomTabBarController;
    
    EGORefreshTableHeaderView *_refreshHeaderView;
	//  Reloading var should really be your tableviews datasource
	//  Putting it here for demo purposes 
	BOOL _reloading;
    
    BOOL _isGettingNextPage;
    BOOL _hasMorePage;
}

@property (nonatomic,retain) NSString *circleId;
@property (nonatomic,retain) NSString *mediaId;

@property (nonatomic,retain) NSMutableArray *mediaList;

@property (nonatomic,retain) UIScrollView *mscrollView;

@property (nonatomic,retain) TabBarShareView *tabBarView;

@property (nonatomic,retain) RemoveMediaInterface *mRemoveMediaInterface;

@property (nonatomic,retain) MediaByCircleIdInterface *mMediaByCircleIdInterface;
@property (nonatomic,retain) MediaByCircleIdInterface *mMediaByCircleIdInterfaceForPull;
@end
