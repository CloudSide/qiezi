//
//  NearByUIViewController.h
//  Color
//  附近主界面
//  Created by chao han on 12-5-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CircleByTimestampHeartbeatInterface.h"
#import "MediaByCircleidsAndTimestampHeartbeatInterface.h"
#import "UserListByCircleidsHeartbeatInterface.h"
#import "CreateCircleInterface.h"
#import "NearByUsersHeartbeatInterface.h"

@class OperPageControl;
@class NearByShowAllInterface;
@protocol NearByShowAllInterfaceDelegate;

@interface NearByUIViewController : UIViewController <UIScrollViewDelegate 
, NearByShowAllInterfaceDelegate , CircleByTimestampHeartbeatInterfaceDelegate
, MediaByCircleidsAndTimestampHeartbeatInterfaceDelegate , CreateCircleInterfaceDelegate
, UIActionSheetDelegate , UserListByCircleidsHeartbeatInterfaceDelegate
, NearByUsersHeartbeatInterfaceDelegate>{
    NSInteger currentCircleViewIndex;//当前显示的圈子索引
}

@property (nonatomic,retain) NSMutableArray *circleViewArray;//所有圈子对应的view
@property (nonatomic,retain) NSMutableArray *circleArray;//所有圈子数组
@property (nonatomic,retain) NSMutableArray *nearByUsersArray;//附近所有用户

@property (nonatomic,retain) IBOutlet UIView *parentView;

@property (nonatomic,retain) IBOutlet UIScrollView *operScrollView;//低端操作scrollView
@property (nonatomic,retain) IBOutlet OperPageControl *operPageControl;

@property (nonatomic,retain) IBOutlet UIView *topViewGroup;//当前组ViewGroup
@property (nonatomic,retain) IBOutlet UIView *topViewGroupCoverView;//当前组ViewGroup遮挡view

@property (nonatomic,retain) NearByShowAllInterface *mNearByShowAllInterface;//附近接口

@property (nonatomic,retain) NSTimer *findNewCirclesTimer;//获取附近新圈子心跳定时器
@property (nonatomic,retain) CircleByTimestampHeartbeatInterface *mCircleByTimestampHeartbeatInterface;//获取附近新圈子心跳接口

@property (nonatomic,retain) NSTimer *findNewMediaTimer;//获取附近新圈子心跳定时器
@property (nonatomic,retain) MediaByCircleidsAndTimestampHeartbeatInterface *mMediaByCircleidsAndTimestampHeartbeatInterface;//根据圈子id查找对应media心跳接口

@property (nonatomic,retain) NSTimer *findUserListTimer;//获取附近新圈子心跳定时器
@property (nonatomic,retain) UserListByCircleidsHeartbeatInterface *mUserListByCircleidsHeartbeatInterface;//根据圈子id查找对应media心跳接口

@property (nonatomic,retain) NSTimer *findNearbyUsersTimer;//获取附近用户列表定时器
@property (nonatomic,retain) NearByUsersHeartbeatInterface *mNearByUsersHeartbeatInterface;//获取附近用户列表

@property (nonatomic,retain) CreateCircleInterface *mCreateCircleInterface;//创建圈子接口

-(IBAction)toNextOperAction:(id)sender;//显示下一页
-(IBAction)toPreviousOperAction:(id)sender;//显示上一页
@end
