//
//  CustomTabBarController.m
//  Color
//
//  Created by chao han on 12-5-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CustomTabBarController.h"

#import <QuartzCore/QuartzCore.h>
#import <MediaPlayer/MediaPlayer.h>
#import "UIImage+UIImageScale.h"
//#import "UIImage+Resize.h"
#import "UIUtil.h"
#import "UploadImageInterface.h"
#import "UIButton+BPBadgeButton.h"
#import "PendingUploadDao.h"
#import "PendingUploadTaskDTO.h"
#import "Reachability.h"
#import "NearByUIViewController.h"
#import "OperPageControl.h"
#import "CircleModel.h"
#import "NearByPhotoView.h"


@implementation CustomTabBarController

@synthesize currentSelectedIndex;
@synthesize buttons;
@synthesize iconNameArray = _iconNameArray , iconSelectedNameArray = _iconSelectedNameArray 
 , baseBtnGroup = _baseBtnGroup , picker = _picker , cameraAimView = _cameraAimView
 , previewOverlayView = _previewOverlayView , PLCameraView = _PLCameraView 
 , PLTileContainerView = _PLTileContainerView //, mUploadImageInterface = _mUploadImageInterface
// , mUploadVideoInterface = _mUploadVideoInterface 
 , tabBarStack = _tabBarStack
 , mNewCommentsHeartbeatInterface = _mNewCommentsHeartbeatInterface 
 , newCommentAmountTimer = _newCommentAmountTimer , mUploadMediaService = _mUploadMediaService;

//- (void)viewDidAppear:(BOOL)animated{
-(void)viewDidLoad{
    self.mUploadMediaService = [[[UploadMediaService alloc] init] autorelease];//初始化上传线程池
    
    // 监测网络情况
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityChanged:)
                                                 name: kReachabilityChangedNotification
                                               object: nil];
    hostReach = [[Reachability reachabilityWithHostName:@"www.baidu.com"] retain];
    [hostReach startNotifier];
    
//    slideBg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bottomfocus.png"]];
    NSArray *_array = [[NSArray alloc] initWithObjects:@"multiLensIcon",@"feedIcon",@"logo",@"diaryIcon",@"notificationsIcon", nil];
    self.iconNameArray = _array;
    [_array release];
    
    NSArray *_selectedArray = [[NSArray alloc] initWithObjects:@"multiLensIconSelected",@"feedIconSelected",@"logoPressed",@"diaryIconSelected",@"notificationsIconSelected", nil];
    self.iconSelectedNameArray = _selectedArray;
    [_selectedArray release];
    
    [self hideRealTabBar];
    [self customTabBar];
    
    self.cameraAimView = [[[UIView alloc] initWithFrame:CGRectMake(8, 60, self.view.frame.size.width-16,self.view.frame.size.width-16)] autorelease];
    self.cameraAimView.backgroundColor = [UIColor clearColor];
    self.cameraAimView.layer.borderWidth = 0.5;
    self.cameraAimView.layer.borderColor = [[UIColor whiteColor] CGColor];
    
    self.previewOverlayView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,self.view.frame.size.width)] autorelease];//(8, 60, self.view.frame.size.width-16,self.view.frame.size.width-16)] autorelease];
//    self.previewOverlayView.backgroundColor = [UIColor blackColor];
    
//    CALayer *mask = [CALayer layer];
//    mask.frame = self.previewOverlayView.frame;
//    mask.contents = (id)[[UIImage imageNamed:@"camera_overlay.png"] CGImage];
//    self.previewOverlayView.layer.mask = mask;
//    self.previewOverlayView.layer.masksToBounds = YES;
    
    //评论心跳定时器
    self.newCommentAmountTimer = [NSTimer scheduledTimerWithTimeInterval:20 target:self selector:@selector(loadNewCommentsAmount) userInfo:nil repeats:YES];
    [self.newCommentAmountTimer fire];
}

- (void)hideRealTabBar{
    for(UIView *view in self.view.subviews){
        if([view isKindOfClass:[UITabBar class]]){
            view.hidden = YES;
            break;
        }
    }
}

- (void)customTabBar{
    self.tabBarStack = [[[NSMutableArray alloc] init] autorelease];
    
    //背景颜色
    UIImageView *imgView = [[UIImageView alloc] initWithImage: [UIImage imageNamed:@"tabBarBackground"]];
    imgView.frame = CGRectMake(0, 
                               self.view.frame.size.height - imgView.frame.size.height,
                               imgView.frame.size.width, 
                               imgView.frame.size.height);
                    //CGRectMake(0, 425, imgView.image.size.width, imgView.image.size.height);
    [self.view addSubview:imgView];
    
    //创建按钮
    UIView *_viewGroup = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - imgView.frame.size.height + 8,
                                                                  imgView.frame.size.width, imgView.frame.size.height - 8)];
    self.baseBtnGroup = _viewGroup;
    self.baseBtnGroup.userInteractionEnabled = YES;
    [_viewGroup release];
    [self.view addSubview:self.baseBtnGroup];
    [self.tabBarStack addObject:self.baseBtnGroup];//将tabbar添加到tabbar栈中
    
    int viewCount = 5;//self.viewControllers.count > 5 ? 5 : self.viewControllers.count;
    self.buttons = [NSMutableArray arrayWithCapacity:viewCount];
    double _width = self.baseBtnGroup.frame.size.width / viewCount;
    double _height = self.baseBtnGroup.frame.size.height;
    for (int i = 0; i < viewCount; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *icon = [UIImage imageNamed:[self.iconNameArray objectAtIndex:i]];
        UIImage *iconSelected = [UIImage imageNamed:[self.iconSelectedNameArray objectAtIndex:i]];
        [btn setImage:iconSelected forState:UIControlStateHighlighted];
        [btn setImage:iconSelected forState:UIControlStateSelected];
        [btn setImage:icon forState:UIControlStateNormal];
        btn.frame = CGRectMake(i*_width + (_width - icon.size.width) / 2
                               , (_height - icon.size.height) / 2
                               , icon.size.width
                               , icon.size.height);
        [btn addTarget:self action:@selector(selectedTab:) forControlEvents:UIControlEventTouchDown];
        [btn addTarget:self action:@selector(setSelectedTab:) forControlEvents:UIControlEventTouchUpInside];
        [btn addTarget:self action:@selector(setSelectedTab:) forControlEvents:UIControlEventTouchUpOutside];
        
        if (i==2) {
            btn.tag = 9;
        }else if(i>2){
            btn.tag = i - 1;
        }else{
            btn.tag = i;
        }
        
        btn.titleLabel.text = @"动态";
        [self.buttons addObject:btn];
        [self.baseBtnGroup  addSubview:btn];
    }

    [imgView release];
//    [self selectedTab:[self.buttons objectAtIndex:0]];
    
}

#pragma mark - tabbar 按钮点击事件
- (void)setSelectedTab:(UIButton *)button{
    button.selected = YES;
}

- (void)selectedTab:(UIButton *)button{
    //当点击某个按钮时，先将附近页面的当前圈子跳转至当前圈子位置
    NearByUIViewController *nearByController = (NearByUIViewController *)[((UINavigationController *)[self.viewControllers objectAtIndex:0]).viewControllers objectAtIndex:0];
    NSMutableArray *circleViewArray = nearByController.circleViewArray;
    
    NSInteger idx = 0;
    for (NearByPhotoView *view in circleViewArray) {
        if ([MySingleton sharedSingleton].currentCircleId == [view.mCircleModel.cId intValue]) {
            [nearByController.operScrollView setContentOffset:CGPointMake(idx * nearByController.operScrollView.frame.size.width, 0) animated:NO];
        }
        
        ++idx;
    }
    
    self.currentSelectedIndex = button.tag;
    
    if (self.currentSelectedIndex == 9) {
        self.selectedIndex = 0;
        
        [self performSelector:@selector(addPicEvent)];
    }else{
        self.selectedIndex = self.currentSelectedIndex;
    }
    
    [self performSelector:@selector(slideTabBg:) withObject:button];
}

- (void)slideTabBg:(UIButton *)btn{
    
    for (UIButton *_btn in self.buttons) {
        _btn.selected = NO;
    }
    btn.selected = YES;
}

- (void) dealloc{
    [hostReach stopNotifier];
    [hostReach release];
    hostReach = nil;
    
    [buttons release];
    self.iconNameArray = nil;
    self.iconSelectedNameArray = nil;
    self.baseBtnGroup = nil;
    
    self.picker = nil;
    
    self.cameraAimView = nil;
    self.previewOverlayView = nil;
    self.PLTileContainerView = nil;
    
//    self.mUploadImageInterface.delegate = nil;
//    self.mUploadImageInterface = nil;
//    
//    self.mUploadVideoInterface.delegate = nil;
//    self.mUploadVideoInterface = nil;
    
    self.tabBarStack = nil;
    
    self.mNewCommentsHeartbeatInterface.delegate = nil;
    self.mNewCommentsHeartbeatInterface = nil;
    
    [self.newCommentAmountTimer invalidate];
    self.newCommentAmountTimer = nil;
    
    [super dealloc];
}

#pragma mark - 网络监听回调方法
- (void)reachabilityChanged:(NSNotification *)note {
    Reachability* curReach = [note object];
    NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
    NetworkStatus status = [curReach currentReachabilityStatus];
    
    if (status != NotReachable) {//有网
//        NSLog(@"--------------- upload all waiting uploading media ------------------status %d",status);
        
        //上传所有待上传media
        PendingUploadDao *dao = [[PendingUploadDao alloc] init];
        [dao repairAllTask];
        NSArray *taskArray = [dao getAllWaitUploadPendingUploadTaskDTO];
        for (PendingUploadTaskDTO *dto in taskArray) {
            [self.mUploadMediaService addOperation:dto.pid];
        }
        [dao release];
    }
}

#pragma mark - 处理tabbar 
-(void)pushTabBar:(UIView *)tabBarView//push tabbar
{
    if (tabBarView) {
        [self.tabBarStack addObject:tabBarView];
        UIView *lastTabBar = [self.baseBtnGroup retain];//当前还未隐藏的tabbar
        self.baseBtnGroup = tabBarView;
        
        CGRect groupFrame = lastTabBar.frame;
        tabBarView.frame = CGRectMake(groupFrame.size.width, 
                                           groupFrame.origin.y, 
                                           tabBarView.frame.size.width, 
                                           tabBarView.frame.size.height);
        
        [self.view addSubview:tabBarView];
        
        [UIView beginAnimations:nil context:nil];
        //    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        [UIView setAnimationDuration:0.38];
        lastTabBar.alpha = 0;
        lastTabBar.frame = CGRectMake(-self.view.frame.size.width / 2,
                                                                lastTabBar.frame.origin.y, 
                                                                lastTabBar.frame.size.width, 
                                                                lastTabBar.frame.size.height);
        
        tabBarView.frame = CGRectMake(0, 
                                      groupFrame.origin.y, 
                                      tabBarView.frame.size.width, 
                                      tabBarView.frame.size.height);
        
        tabBarView.frame = groupFrame;
        tabBarView.alpha = 1;
        
        [UIView commitAnimations];
        
        [lastTabBar release];
    }
}

-(void)popTabBar//pop tabbar
{
    if ([self.tabBarStack count]>1) {
        UIView *currentTabBar = [self.baseBtnGroup retain];//当前即将退出的tabbar
        UIView *needShowTabBar = [self.tabBarStack objectAtIndex:self.tabBarStack.count - 2];//即将显示的tabbar
        self.baseBtnGroup = needShowTabBar;
        
        [UIView beginAnimations:nil context:nil];
        //    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        [UIView setAnimationDuration:0.38];
        currentTabBar.alpha = 0;
        currentTabBar.frame = CGRectMake(self.view.frame.size.width / 2,
                                      currentTabBar.frame.origin.y, 
                                      currentTabBar.frame.size.width, 
                                      currentTabBar.frame.size.height);
        
        needShowTabBar.frame = CGRectMake(0,
                                          needShowTabBar.frame.origin.y, 
                                          needShowTabBar.frame.size.width, 
                                          needShowTabBar.frame.size.height);
        needShowTabBar.alpha = 1;
        
        [UIView commitAnimations];
        
        [currentTabBar release];
        [self.tabBarStack removeObjectAtIndex:self.tabBarStack.count - 1];
    }
}

-(void)popToRootTabBar
{
    if ([self.tabBarStack count]>1) {
        UIView *currentTabBar = [self.baseBtnGroup retain];//当前即将退出的tabbar
        UIView *needShowTabBar = [self.tabBarStack objectAtIndex:0];//即将显示的tabbar
        self.baseBtnGroup = needShowTabBar;
        
        [UIView beginAnimations:nil context:nil];
        //    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        [UIView setAnimationDuration:0.38];
        currentTabBar.alpha = 0;
        currentTabBar.frame = CGRectMake(self.view.frame.size.width / 2,
                                         currentTabBar.frame.origin.y, 
                                         currentTabBar.frame.size.width, 
                                         currentTabBar.frame.size.height);
        
        needShowTabBar.frame = CGRectMake(0,
                                          needShowTabBar.frame.origin.y, 
                                          needShowTabBar.frame.size.width, 
                                          needShowTabBar.frame.size.height);
        needShowTabBar.alpha = 1;
        
        [UIView commitAnimations];
        
        [currentTabBar release];

        [self.tabBarStack removeAllObjects];
        [self.tabBarStack addObject:self.baseBtnGroup];
    }
}

#pragma mark - camera method
-(void)addPicEvent{
    UIImagePickerControllerSourceType sourceType=UIImagePickerControllerSourceTypeCamera;
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    UIImagePickerController * picker = [[UIImagePickerController alloc]init];
    
    picker.delegate = self;
    picker.sourceType=sourceType;
    picker.videoMaximumDuration = 10;
    picker.videoQuality = UIImagePickerControllerQualityTypeMedium;
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        picker.cameraFlashMode = [MySingleton sharedSingleton].lastCameraFlashMode;//使用上次闪光灯状态
    }
    
    NSArray *temp_MediaTypes = [UIImagePickerController availableMediaTypesForSourceType:picker.sourceType];
    picker.mediaTypes = temp_MediaTypes;
    
    self.picker = picker;
    [picker release];
    
//    [self presentModalViewController:self.picker animated:YES];
    [self presentViewController:self.picker animated:YES completion:nil];
}

#pragma mark - save image video method 
-(void)saveImage:(UIImage*)image
{
    BOOL success;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *pendingUploadsPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"PendingUploads"];
    
    BOOL isDirectory = NO;
    BOOL exists = [fileManager fileExistsAtPath:pendingUploadsPath isDirectory:&isDirectory];
    if (!exists || !isDirectory) {
        [fileManager removeItemAtPath:pendingUploadsPath error:nil];

        //创建目录
        [fileManager createDirectoryAtPath:pendingUploadsPath withIntermediateDirectories:NO attributes:nil error:nil];
    }
    
    UIImage *tmpImage = [[UIUtil scaleAndRotateImage:image] retain];//[[image resizedImage:CGSizeMake(640, 640) interpolationQuality:kCGInterpolationLow] retain];//[[UIUtil scaleAndRotateImage:image] retain];
    CGFloat width = CGImageGetWidth(tmpImage.CGImage); 
    CGFloat height = CGImageGetHeight(tmpImage.CGImage);
    CGFloat smallerWidth = width < height ? width : height;
    
    UIImage *clipedImage ;
    if (width < height) {//宽小
        clipedImage = [[tmpImage getSubImage:CGRectMake(0, (height - smallerWidth) / 2, smallerWidth, smallerWidth)] retain];
    }else{//高小
        clipedImage = [[tmpImage getSubImage:CGRectMake((width - smallerWidth) / 2, 0, smallerWidth, smallerWidth)] retain];
    }
    [tmpImage release];
    
    NSDate *now = [NSDate date];
    NSString *imageFile = [pendingUploadsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%d.jpg",(NSInteger)[now timeIntervalSince1970]]];
    
    success = [fileManager fileExistsAtPath:imageFile];
    if(success) {
        success = [fileManager removeItemAtPath:imageFile error:&error];
    }
    
//    //保存图片至相册
//    UIImageWriteToSavedPhotosAlbum(clipedImage, self,  nil, nil);  
    
    [UIImageJPEGRepresentation(clipedImage, 0.5f) writeToFile:imageFile atomically:YES];

    [[NSNotificationCenter defaultCenter] postNotificationName:[NSString stringWithFormat:@"circleid_%d",[MySingleton sharedSingleton].currentCircleId] 
                                                        object:nil 
                                                      userInfo:[NSDictionary dictionaryWithObjectsAndKeys:imageFile,@"imageFilePath",@"0",@"mediaType",nil]];
    
    //保存上传任务
    PendingUploadDao *dao = [[PendingUploadDao alloc] init];
    PendingUploadTaskDTO *dto = [[PendingUploadTaskDTO alloc] init];
    dto.filePath = imageFile;
    dto.mediaType = 0;
    dto.retryTimes = 0;
    dto.errorCode = 0;
    dto.lon = [MySingleton sharedSingleton].lon;
    dto.lat = [MySingleton sharedSingleton].lat;
    dto.circleId = [NSString stringWithFormat:@"%d",[MySingleton sharedSingleton].currentCircleId];
    dto.description = @"";
    dto.pendingState = 0;
    long long int taskId = [dao addPendingUploadTaskDTO:dto];
    
    [self.mUploadMediaService addOperation:taskId];
    
    [dto release];
    [dao release];
    
//    //上传照片
//    self.mUploadImageInterface = [[UploadImageInterface alloc] init];
//    self.mUploadImageInterface.delegate = self;
//    [self.mUploadImageInterface doUploadImage:clipedImage description:@"评论" circleId:[MySingleton sharedSingleton].currentCircleId];
    
    [clipedImage release];
}

-(void)saveVideo:(NSURL *)videoURL
{
    BOOL success;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *pendingUploadsPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"PendingUploads"];
    
    BOOL isDirectory = NO;
    BOOL exists = [fileManager fileExistsAtPath:pendingUploadsPath isDirectory:&isDirectory];
    if (!exists || !isDirectory) {
        [fileManager removeItemAtPath:pendingUploadsPath error:nil];
        
        //创建目录
        [fileManager createDirectoryAtPath:pendingUploadsPath withIntermediateDirectories:NO attributes:nil error:nil];
    }
    
    NSData *videoData = [[NSData dataWithContentsOfURL:videoURL] retain];
    NSDate *now = [NSDate date];
    NSString *videoFile = [pendingUploadsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%d.mov",(NSInteger)[now timeIntervalSince1970]]];
    
    success = [fileManager fileExistsAtPath:videoFile];
    if(success) {
        success = [fileManager removeItemAtPath:videoFile error:&error];
    }
    [videoData writeToFile:videoFile atomically:YES];
    
    //视频截图
//    MPMoviePlayerViewController *mpviemController =[[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL fileURLWithPath:videoFile]];
    MPMoviePlayerController *mp = [[MPMoviePlayerController alloc] initWithContentURL: [NSURL fileURLWithPath:videoFile]];//[mpviemController moviePlayer];
    UIImage *image=[mp thumbnailImageAtTime:(NSTimeInterval)1 timeOption:MPMovieTimeOptionNearestKeyFrame];
//    [mpviemController release];
    
    //等比缩放操作
    UIImage *tmpImage = [[UIUtil scaleAndRotateImage:image] retain];//[[image resizedImage:CGSizeMake(640, 640) interpolationQuality:kCGInterpolationLow] retain];//[[UIUtil scaleAndRotateImage:image] retain];
    [mp stop];
    [mp release];
    CGFloat width = CGImageGetWidth(tmpImage.CGImage); 
    CGFloat height = CGImageGetHeight(tmpImage.CGImage);
    CGFloat smallerWidth = width < height ? width : height;
    
    //截取正方形图片
    UIImage *thumbnailImage ;
    if (width < height) {//宽小
        thumbnailImage = [[tmpImage getSubImage:CGRectMake(0, (height - smallerWidth) / 2, smallerWidth, smallerWidth)] retain];
    }else{//高小
        thumbnailImage = [[tmpImage getSubImage:CGRectMake((width - smallerWidth) / 2, 0, smallerWidth, smallerWidth)] retain];
    }
    [tmpImage release];
    
    //创建截屏地址
    NSString *imageFile = [pendingUploadsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"shortcut_%d.jpg",(NSInteger)[now timeIntervalSince1970]]];
    
    //处理已存在文件
    success = [fileManager fileExistsAtPath:imageFile];
    if(success) {
        success = [fileManager removeItemAtPath:imageFile error:&error];
    }
    
    //保存截屏文件
    [UIImageJPEGRepresentation(thumbnailImage, 1.0f) writeToFile:imageFile atomically:YES];
    
    
    //保存上传任务
    PendingUploadDao *dao = [[PendingUploadDao alloc] init];
    PendingUploadTaskDTO *dto = [[PendingUploadTaskDTO alloc] init];
    dto.filePath = videoFile;
    dto.thumbnailPath = imageFile;
    dto.mediaType = 1;
    dto.retryTimes = 0;
    dto.errorCode = 0;
    dto.lon = [MySingleton sharedSingleton].lon;
    dto.lat = [MySingleton sharedSingleton].lat;
    dto.circleId = [NSString stringWithFormat:@"%d",[MySingleton sharedSingleton].currentCircleId];
    dto.description = @"";
    dto.pendingState = 0;
    long long int taskId = [dao addPendingUploadTaskDTO:dto];
    
    [self.mUploadMediaService addOperation:taskId];
    
    [dto release];
    [dao release];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:[NSString stringWithFormat:@"circleid_%d",[MySingleton sharedSingleton].currentCircleId] 
                                                        object:nil 
                                                      userInfo:[NSDictionary dictionaryWithObjectsAndKeys:imageFile,@"imageFilePath",@"1",@"mediaType",nil]];
    
//    self.mUploadVideoInterface = [[UploadVideoInterface alloc] init];
//    [self.mUploadVideoInterface doUploadVideo:videoData thumbnail:thumbnailImage description:@"评论" circleId:[MySingleton sharedSingleton].currentCircleId];
    
    [thumbnailImage release];
    [videoData release];
}

#pragma mark - UIImagePickerControllerDelegate method
-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        //保存上次闪光灯状态
        [MySingleton sharedSingleton].lastCameraFlashMode = picker.cameraFlashMode;
    }
    
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    
    if ([mediaType isEqualToString:@"public.image"]){
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        
        //保存图片至相册
        UIImageWriteToSavedPhotosAlbum(image, self,  nil, nil);  
        
        //后台处理照片
        [self performSelectorInBackground:@selector(saveImage:) withObject:image];
    }
    else if([mediaType isEqualToString:@"public.movie"]){
        NSURL *videoURL = [info objectForKey:UIImagePickerControllerMediaURL];
        
        //保存视频至相册
        UISaveVideoAtPathToSavedPhotosAlbum([videoURL path], self, nil, nil);
        
        //后台处理照片
//        [self performSelectorInBackground:@selector(saveVideo:) withObject:videoURL];
        [self saveVideo:videoURL];
    }
    
//    [picker dismissModalViewControllerAnimated:YES];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

-(void)imagePickerControllerDIdCancel:(UIImagePickerController*)picker
{
//    [picker dismissModalViewControllerAnimated:YES];
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}

#pragma mark get/show the UIView we want
//Find the view we want in camera structure.
-(UIView *)findView:(UIView *)aView withName:(NSString *)name{
	Class cl = [aView class];
	NSString *desc = [cl description];
	
	if ([name isEqualToString:desc])
		return aView;
	
	for (NSUInteger i = 0; i < [aView.subviews count]; i++)
	{
		UIView *subView = [aView.subviews objectAtIndex:i];
		subView = [self findView:subView withName:name];
		if (subView)
			return subView;
	}
	return nil;	
}

#pragma mark addSomeElements
-(void)addSomeElements:(UIViewController *)viewController{
	//Add the motion view here, PLCameraView and picker.view are both OK
//	UIView *PLCameraView=[self findView:viewController.view withName:@"PLCameraView"];
    self.PLCameraView = [self findView:viewController.view withName:@"PLCameraView"];
    
    [self.PLCameraView insertSubview:self.cameraAimView  atIndex:1];
	
	//Get Bottom Bar
	UIView *bottomBar=[self findView:self.PLCameraView withName:@"PLCropOverlayBottomBar"];
    
//    for (UIView *view in [bottomBar subviews]) {
//        NSLog(@"%@",view);
//        for (UIView *v in [view subviews]) {
//            NSLog(@"-----%@",v);
//            
//        }
//    }
    
//    NSLog(@"-----%d",((UISwitch *)[[[[bottomBar subviews]objectAtIndex:1] subviews] objectAtIndex:2]).on);
    
	
	//Get ImageView For Save
	UIImageView *bottomBarImageForSave = [bottomBar.subviews objectAtIndex:0];
	
	//Get Button 0 重拍按钮
	UIButton *retakeButton=[bottomBarImageForSave.subviews objectAtIndex:0];
    [retakeButton addTarget:self
                     action:@selector(hidePreviewOverlayView)
           forControlEvents:UIControlEventTouchUpInside];
	
	//Get Button 1
	UIButton *useButton=[bottomBarImageForSave.subviews objectAtIndex:1];
	[useButton setTitle:@"发布" forState:UIControlStateNormal];
	
    
    
//	//Get ImageView For Camera
//	UIImageView *bottomBarImageForCamera = [bottomBar.subviews objectAtIndex:1];
////	
////	//Set Bottom Bar Image
////	UIImage *image=[[UIImage alloc] initWithContentsOfFile:[[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"BottomBar.png"]];
////	bottomBarImageForCamera.image=image;
////	[image release];
////	
//	//Get Button 0(The Capture Button) 拍照按钮
//	UIButton *cameraButton=[bottomBarImageForCamera.subviews objectAtIndex:0];
//	[cameraButton addTarget:self
//                     action:@selector(showPreviewOverlayViewDelay)
//           forControlEvents:UIControlEventTouchUpInside];
    
    
    
    
//
//	//Get Button 1
//	UIButton *cancelButton=[bottomBarImageForCamera.subviews objectAtIndex:1];	
//	[cancelButton setTitle:@"取消" forState:UIControlStateNormal];
//	[cancelButton addTarget:self action:@selector(hideTouchView) forControlEvents:UIControlEventTouchUpInside];
}

//稍后显示预览遮罩
-(void)showPreviewOverlayViewDelay{
    [NSTimer scheduledTimerWithTimeInterval: 2
									 target: self
								   selector: @selector(showPreviewOverlayView)
								   userInfo: nil
									repeats: NO];
}

//显示预览遮罩
-(void)showPreviewOverlayView{
//    NSLog(@"--------- %d",[[self.PLCameraView subviews] count]-1);
    
    self.PLTileContainerView =[self findView:self.PLCameraView withName:@"PLTileContainerView"];
    [self.PLTileContainerView addSubview:self.previewOverlayView];
//    [self.PLCameraView insertSubview:self.previewOverlayView atIndex:[[self.PLCameraView subviews] count]-2];
    
//<UIView: 0x733dcc0; frame = (0 0; 320 480); autoresize = W+H; userInteractionEnabled = NO; layer = <CALayer: 0x733dcf0>>
//    -----<PLCameraPreviewView: 0x733cd00; frame = (0 1; 320 426); transform = [0.5, 0, 0, 0.5, 0, 0]; autoresize = BM; layer = <CALayer: 0x733cea0>>
//    -----<UIView: 0x735a6d0; frame = (0 0; 320 1); layer = <CALayer: 0x735a700>>
//
//<UIView: 0x1f95c0; frame = (8 60; 304 304); layer = <CALayer: 0x1f95f0>>
//
//<UIImageView: 0x735b7b0; frame = (0 422; 320 5); opaque = NO; autoresize = W+TM; userInteractionEnabled = NO; layer = <CALayer: 0x735b9a0>>
//
//<PLPreviewOverlayView: 0x733deb0; frame = (0 0; 320 427); transform = [0.5, 0, 0, 0.5, 0, 0]; autoresize = W+H; userInteractionEnabled = NO; layer = <CALayer: 0x733df40>>
//    -----<UIView: 0x7343490; frame = (320 819.5; 0 29); autoresize = LM+RM+TM; layer = <CALayer: 0x73434c0>>
//    -----<PLCameraFlashButton: 0x733e2f0; baseClass = UIButton; frame = (20 20; 155 70); clipsToBounds = YES; opaque = NO; autoresize = RM; layer = <CALayer: 0x733e460>>
//    -----<PLCameraToggleButton: 0x7341370; baseClass = UIButton; frame = (480 20; 140 70); opaque = NO; autoresize = LM; layer = <CALayer: 0x7341460>>
//3
//<PLTileContainerView: 0x7378140; frame = (0 1; 320 426); autoresize = W+H; layer = <CALayer: 0x73781c0>>
//    -----<PLImageScrollView: 0x7377ce0; baseClass = UIScrollView; frame = (0 0; 320 426); clipsToBounds = YES; autoresize = W+H; userInteractionEnabled = NO; layer = <CALayer: 0x7375860>; contentOffset: {-0, -0}>
//2
//<UIImageView: 0x732b870; frame = (0 0; 320 480); hidden = YES; opaque = NO; autoresize = W+H; userInteractionEnabled = NO; layer = <CALayer: 0x732b8b0>>
//1
//<PLCropOverlay: 0x732cbd0; frame = (0 0; 320 480); autoresize = W+H; layer = <CALayer: 0x732c070>>
//    -----<PLCameraIrisAnimationView: 0x7337730; frame = (0 0; 320 480); autoresize = W+H; userInteractionEnabled = NO; layer = <CALayer: 0x73377d0>>
//    -----<PLCropOverlayBottomBar: 0x732ce60; frame = (0 427; 320 53); autoresize = W+TM; layer = <CALayer: 0x732cf20>>

//    for (UIView *view in [self.PLCameraView  subviews]) {
//        NSLog(@"%@",view);
//        for (UIView *v in [view subviews]) {
//            NSLog(@"-----%@",v);
//            
//        }
//    }
}

//隐藏预览遮罩
-(void)hidePreviewOverlayView{
    [self.previewOverlayView removeFromSuperview];
}

#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    
#ifndef __IPHONE_7_0
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
        [self addSomeElements:viewController];
    }
#endif

}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated{

}

//#pragma mark - UploadImageInterfaceDelegate
//-(void)uploadImageDidFinished{
//    NSLog(@"=======uploadImageDidFinished========");
//    
//    self.mUploadImageInterface.delegate = nil;
//    self.mUploadImageInterface = nil;
//}
//-(void)uploadImageDidFailed:(NSString *)errorMsg{
//    NSLog(@"%@",errorMsg);
//    
//    self.mUploadImageInterface.delegate = nil;
//    self.mUploadImageInterface = nil;
//}

//#pragma mark - UploadVideoInterfaceDelegate
//-(void)uploadVideoDidFinished{
//    NSLog(@"=======uploadVideoDidFinished========");
//    
//    self.mUploadVideoInterface.delegate = nil;
//    self.mUploadVideoInterface = nil;
//}
//-(void)uploadVideoDidFailed:(NSString *)errorMsg{
//    NSLog(@"%@",errorMsg);
//    
//    self.mUploadVideoInterface.delegate = nil;
//    self.mUploadVideoInterface = nil;
//}

#pragma mark - NewCommentsHeartbeatInterfaceDelegate
-(void)getNewCommentsAmountDidFinished:(NSInteger )newCommentsAmount{
    if (self.buttons.count > 0) {
        UIButton *commentBtn = (UIButton *)[self.buttons lastObject];
        commentBtn.badge = newCommentsAmount;
    }
    
    self.mNewCommentsHeartbeatInterface.delegate = nil;
    self.mNewCommentsHeartbeatInterface = nil;
}
-(void)getNewCommentsAmountDidFailed:(NSString *)errorMsg{
    NSLog(@"=======getNewCommentsAmountDidFailed======== %@",errorMsg);
    
    self.mNewCommentsHeartbeatInterface.delegate = nil;
    self.mNewCommentsHeartbeatInterface = nil;
}

#pragma mark - 未读评论数 心跳方法
-(void)loadNewCommentsAmount
{
    self.mNewCommentsHeartbeatInterface = [[[NewCommentsHeartbeatInterface alloc] init] autorelease];
    self.mNewCommentsHeartbeatInterface.delegate = self;
    [self.mNewCommentsHeartbeatInterface getNewCommentsAmount];
}

@end
