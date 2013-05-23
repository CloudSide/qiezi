//
//  NearByUIViewController.h
//  Color
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
    NSInteger currentCircleViewIndex;
}

@property (nonatomic,retain) NSMutableArray *circleViewArray;
@property (nonatomic,retain) NSMutableArray *circleArray;
@property (nonatomic,retain) NSMutableArray *nearByUsersArray;

@property (nonatomic,retain) IBOutlet UIScrollView *operScrollView;
@property (nonatomic,retain) IBOutlet OperPageControl *operPageControl;

@property (nonatomic,retain) IBOutlet UIView *topViewGroup;
@property (nonatomic,retain) IBOutlet UIView *topViewGroupCoverView;

@property (nonatomic,retain) NearByShowAllInterface *mNearByShowAllInterface;

@property (nonatomic,retain) NSTimer *findNewCirclesTimer;
@property (nonatomic,retain) CircleByTimestampHeartbeatInterface *mCircleByTimestampHeartbeatInterface;

@property (nonatomic,retain) NSTimer *findNewMediaTimer;
@property (nonatomic,retain) MediaByCircleidsAndTimestampHeartbeatInterface *mMediaByCircleidsAndTimestampHeartbeatInterface;

@property (nonatomic,retain) NSTimer *findUserListTimer;
@property (nonatomic,retain) UserListByCircleidsHeartbeatInterface *mUserListByCircleidsHeartbeatInterface;

@property (nonatomic,retain) NSTimer *findNearbyUsersTimer;
@property (nonatomic,retain) NearByUsersHeartbeatInterface *mNearByUsersHeartbeatInterface;

@property (nonatomic,retain) CreateCircleInterface *mCreateCircleInterface;

-(IBAction)toNextOperAction:(id)sender;
-(IBAction)toPreviousOperAction:(id)sender;
@end
