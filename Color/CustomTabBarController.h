//
//  CustomTabBarController.h
//  Color
//
//  Created by chao han on 12-5-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UploadImageInterface.h"
#import "UploadVideoInterface.h"
#import "NewCommentsHeartbeatInterface.h"
#import "UploadMediaService.h"

@class Reachability;
@interface CustomTabBarController : UITabBarController <UINavigationControllerDelegate ,UIImagePickerControllerDelegate
//, UploadImageInterfaceDelegate , UploadVideoInterfaceDelegate
, NewCommentsHeartbeatInterfaceDelegate>{
    NSMutableArray *buttons;
    int currentSelectedIndex;
    
    Reachability  *hostReach;
}

@property (nonatomic,retain) UploadMediaService *mUploadMediaService;
@property (nonatomic,retain) NSArray *iconNameArray;
@property (nonatomic,retain) NSArray *iconSelectedNameArray;
@property (nonatomic,assign) int currentSelectedIndex;
@property (nonatomic,retain) NSMutableArray *buttons;
@property (nonatomic,retain) UIView *baseBtnGroup;
@property (nonatomic,retain) UIImagePickerController * picker;
@property (nonatomic,retain) UIView *cameraAimView;
@property (nonatomic,retain) UIView *previewOverlayView;
@property (nonatomic,retain) UIView *PLCameraView;
@property (nonatomic,retain) UIView *PLTileContainerView;

//@property (nonatomic,retain) UploadImageInterface *mUploadImageInterface;//照片上传接口
//@property (nonatomic,retain) UploadVideoInterface *mUploadVideoInterface;//视频上传接口

@property (nonatomic,retain) NSMutableArray *tabBarStack;
@property (nonatomic,retain) NewCommentsHeartbeatInterface *mNewCommentsHeartbeatInterface;
@property (nonatomic,retain) NSTimer *newCommentAmountTimer;

- (void)hideRealTabBar;
- (void)customTabBar;
- (void)selectedTab:(UIButton *)button;

#pragma mark - 处理tabbar 
-(void)pushTabBar:(UIView *)tabBarView;//push tabbar
-(void)popTabBar;//pop tabbar
-(void)popToRootTabBar;//pop to root tabbar


@end
