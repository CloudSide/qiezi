//
//  NearByUIViewController.m
//  Color
//
//  Created by chao han on 12-5-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "NearByUIViewController.h"
#import "OperPageControl.h"
#import "NearByDefaultView.h"
#import "NearByPhotoView.h"
#import "CircleModel.h"
#import "NearByShowAllInterface.h"
#import "CustomTabBarController.h"

@implementation NearByUIViewController

@synthesize operScrollView = _operScrollView
, operPageControl = _operPageControl , topViewGroup = _topViewGroup
, circleViewArray = _circleViewArray , circleArray = _circleArray , nearByUsersArray = _nearByUsersArray
, topViewGroupCoverView = _topViewGroupCoverView 
, mNearByShowAllInterface = _mNearByShowAllInterface 
, findNewCirclesTimer = _findNewCirclesTimer 
, mCircleByTimestampHeartbeatInterface = _mCircleByTimestampHeartbeatInterface
, findNewMediaTimer = _findNewMediaTimer
, mMediaByCircleidsAndTimestampHeartbeatInterface = _mMediaByCircleidsAndTimestampHeartbeatInterface
, mCreateCircleInterface = _mCreateCircleInterface 
, mUserListByCircleidsHeartbeatInterface = _mUserListByCircleidsHeartbeatInterface
, findUserListTimer = _findUserListTimer , findNearbyUsersTimer = _findNearbyUsersTimer
, mNearByUsersHeartbeatInterface = _mNearByUsersHeartbeatInterface;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


-(void)initTopViewGroup{
    [self.circleViewArray removeAllObjects];
    
    for (CircleModel *cm in self.circleArray) {
        NSArray *arr1 = [[NSBundle mainBundle] loadNibNamed:@"NearByPhotoView" owner:self options:nil];  
        NearByPhotoView *mNearByPhotoView = [arr1 objectAtIndex:0];
        mNearByPhotoView.mCircleModel = cm;

        [self.circleViewArray addObject:mNearByPhotoView];

    }
    
    [self initOperScrollView];
}


-(void)addCircleToTopViewGroup:(NSArray *)newCircles{
    for (CircleModel *cm in newCircles) {
        NSArray *arr1 = [[NSBundle mainBundle] loadNibNamed:@"NearByPhotoView" owner:self options:nil];  
        NearByPhotoView *mNearByPhotoView = [arr1 objectAtIndex:0];
        mNearByPhotoView.mCircleModel = cm;
        if (cm.mediasArray.count == 0 && [cm.cId isEqualToString:[NSString stringWithFormat:@"%d",[MySingleton sharedSingleton].currentCircleId ]]) {
            mNearByPhotoView.nearByUsersArray = self.nearByUsersArray;
        }
        [self.circleViewArray insertObject:mNearByPhotoView atIndex:0];
    }
    
    [self initOperScrollView];
}



-(void)initOperScrollView{
    for (UIView *view in [self.operScrollView subviews]) {
        [view removeFromSuperview];
    }
    
    
    self.operScrollView.contentSize = CGSizeMake(([self.circleArray count] + 1) * self.operScrollView.frame.size.width,
                                                 self.operScrollView.frame.size.height);
    
    
    self.operPageControl.numberOfPages = [self.circleArray count] + 1;
    
    for (int i=0; i< [self.circleArray count]; i++) {
        CircleModel *circleModel = [self.circleArray objectAtIndex:i];
        
        UIView *operItem = [[UIView alloc] initWithFrame:CGRectMake(i*self.operScrollView.frame.size.width,
                                                                    0,
                                                                    self.operScrollView.frame.size.width ,
                                                                    self.operScrollView.frame.size.height)];
        
        UILabel *countLabel = [[UILabel alloc] init];
        countLabel.textColor = [UIColor whiteColor];
        countLabel.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
        countLabel.font = [UIFont boldSystemFontOfSize:14];//
        NSString *count = [NSString stringWithFormat:@"%d",[[circleModel mediasArray] count]];
        CGSize countLabelFontSize = [count sizeWithFont:countLabel.font constrainedToSize:CGSizeMake(999, 999) lineBreakMode:UILineBreakModeClip];
        countLabel.text = count;
        countLabel.frame = CGRectMake(0, 0,
                                      countLabelFontSize.width,
                                      countLabelFontSize.height);
        
        UIImageView *cameraIcon = [[UIImageView alloc] initWithImage:
                                   [UIImage imageNamed:@"camera_icon_white.png"]];
        
        UILabel *namesLabel = [[UILabel alloc] init];
        namesLabel.textColor = [UIColor whiteColor];
        namesLabel.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
        namesLabel.font = [UIFont boldSystemFontOfSize:14];
        
        NSMutableString *names = [NSMutableString stringWithFormat:@""];

        NSInteger usersArrayCount = circleModel.usersArray.count;
        for(NSInteger i = 0 ; i < usersArrayCount ; ++i){
            UserModel *user = [circleModel.usersArray objectAtIndex:i];
            if (i < usersArrayCount -2) {
                [names appendString:[NSString stringWithFormat:@"%@, ",user.name]];
            }else{
                [names appendString:[NSString stringWithFormat:@"%@ & ",user.name]];
            }
            
        }
        
        NSString *nameStr = [names length]>0?[names substringToIndex:[names length] - 2] : @"";

        CGSize namesLabelFontSize = [nameStr sizeWithFont:namesLabel.font];
        namesLabel.text = nameStr;
        namesLabel.frame = CGRectMake(0, 0,
                                      namesLabelFontSize.width,
                                      namesLabelFontSize.height);
        
        
        CGFloat width = countLabel.frame.size.width + 4 + cameraIcon.frame.size.width + 4 + namesLabel.frame.size.width;
        CGFloat height = cameraIcon.frame.size.height;
        CGFloat beginX = (self.operScrollView.frame.size.width - width) / 2;
        CGFloat beginY = (self.operScrollView.frame.size.height - height) / 2;
        
        
        countLabel.frame = CGRectMake(beginX , beginY - 2, 
                                      countLabelFontSize.width,
                                      countLabelFontSize.height);
        [operItem addSubview:countLabel];
        
        cameraIcon.frame = CGRectMake(beginX + countLabel.frame.size.width + 4 , beginY, 
                                      cameraIcon.frame.size.width,
                                      cameraIcon.frame.size.height);
        [operItem addSubview:cameraIcon];
        
        namesLabel.frame = CGRectMake(beginX + countLabel.frame.size.width + 4 + cameraIcon.frame.size.width + 4,
                                      beginY - 2, 
                                      namesLabel.frame.size.width,
                                      namesLabel.frame.size.height);
        [operItem addSubview:namesLabel];
        
        [self.operScrollView addSubview:operItem];
        
        [namesLabel release];
        [cameraIcon release];
        [countLabel release];
        [operItem release];
    }
    
    UIButton *newGroupBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.operScrollView.contentSize.width - self.operScrollView.frame.size.width + (self.operScrollView.frame.size.width - 150)/2,
                                                                       (self.operScrollView.contentSize.height - 30) / 2 + 2, 
                                                                       150, 30)];
//    [newGroupBtn   UIButtonTypeCustom];
    [newGroupBtn setBackgroundImage:[[UIImage imageNamed:@"button.png"]stretchableImageWithLeftCapWidth:3 topCapHeight:3] forState:UIControlStateNormal];
    [newGroupBtn setBackgroundImage:[UIImage imageNamed:@"buttonHighlighted.png"] forState:UIControlStateSelected];
    newGroupBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
//    newGroupBtn.titleLabel.text = @"新团体";
    [newGroupBtn setTitle:@"新团体" forState:UIControlStateNormal];
    
    
    [newGroupBtn addTarget:self 
                    action:@selector(createNewCircle:) 
          forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.operScrollView addSubview:newGroupBtn];
    [newGroupBtn release];

    
    [self scrollViewDidScroll:self.operScrollView];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    self.operPageControl = nil;
    self.operScrollView = nil;
    self.topViewGroup = nil;
    self.circleArray = nil;
    self.topViewGroupCoverView = nil;
    
    self.mNearByShowAllInterface.delegate = nil;
    self.mNearByShowAllInterface = nil;
    
    [self.findNewCirclesTimer invalidate];
    self.findNewCirclesTimer = nil;
    
    self.mCircleByTimestampHeartbeatInterface.delegate = nil;
    self.mCircleByTimestampHeartbeatInterface = nil;
    
    [self.findNewMediaTimer invalidate];
    self.findNewMediaTimer = nil;
    
    [self.findNearbyUsersTimer invalidate];
    self.findNearbyUsersTimer = nil;
    
    self.mNearByUsersHeartbeatInterface.delegate = nil;
    self.mNearByUsersHeartbeatInterface = nil;
    
    self.mMediaByCircleidsAndTimestampHeartbeatInterface.delegate = nil;
    self.mMediaByCircleidsAndTimestampHeartbeatInterface = nil;
    
    [self.findUserListTimer invalidate];
    self.findUserListTimer = nil;
    
    self.mUserListByCircleidsHeartbeatInterface.delegate = nil;
    self.mUserListByCircleidsHeartbeatInterface = nil;
    
    self.mCreateCircleInterface.delegate = nil;
    self.mCreateCircleInterface = nil;
    
    self.nearByUsersArray = nil;
    
    [super dealloc];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.circleViewArray = [[[NSMutableArray alloc] init] autorelease];
    self.circleArray = [[[NSMutableArray alloc] init] autorelease];
    currentCircleViewIndex = -1;
    
    self.operPageControl.currentPage = 0;
    
    
    NSArray *arr1 = [[NSBundle mainBundle] loadNibNamed:@"NearByDefaultView" owner:self options:nil];  
    NearByDefaultView *mNearByDefaultView = [arr1 objectAtIndex:0];
    for (UIView *view in [self.topViewGroup subviews]) {
        [view removeFromSuperview];
    }
    [self.topViewGroup addSubview:mNearByDefaultView];
    
    
    if ([MySingleton sharedSingleton].lon != 0 && [MySingleton sharedSingleton].lat != 0) {
        [self getNearByShowAllInterface];
    }else{
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getNearByShowAllInterface) name:kCLLocationManagerDidStarted object:nil];
    }
    
}


-(void)getNearByShowAllInterface{
    self.mNearByShowAllInterface = [[[NearByShowAllInterface alloc] init] autorelease];
    self.mNearByShowAllInterface.delegate = self;
    [self.mNearByShowAllInterface getAll];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Button action
-(IBAction)toNextOperAction:(id)sender{
    
}

-(IBAction)toPreviousOperAction:(id)sender{
    
}

#pragma mark - change circle btn method
- (void)changeCircleAction:(UIButton *)button{
//    UIActionSheet *actionSheet = [[UIActionSheet alloc] 
//                                  initWithTitle:@"加入此团体?"
//                                  delegate:self 
//                                  cancelButtonTitle: @"取消"
//                                  destructiveButtonTitle:nil 
//                                  otherButtonTitles:@"加入团体",nil];
//    
//    [actionSheet showInView:self.view];
//    [actionSheet release];
//}
//
//#pragma mark - ActionSheet Delegate Methods
//- (void) actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
//{

//    {
        CGFloat pageWidth = self.operScrollView.frame.size.width;
        int currPage = floor((self.operScrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
        
        if (currPage < [self.circleViewArray count]){
            CircleModel *cm = [self.circleArray objectAtIndex:currPage];
            [MySingleton sharedSingleton].currentCircleId = [cm.cId intValue];
        }
        
        
        CustomTabBarController *tabbar = (CustomTabBarController *)self.tabBarController;
        UIButton *takePicBtn = (UIButton *)[tabbar.baseBtnGroup viewWithTag:9];
        
        [takePicBtn setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"logo" ofType:@"png"]] forState:UIControlStateNormal];
        [takePicBtn setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"logoPressed" ofType:@"png"]] forState:UIControlStateHighlighted];
        [takePicBtn setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"logoPressed" ofType:@"png"]] forState:UIControlStateSelected];
        takePicBtn.alpha = 1;
        
        [takePicBtn removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
        [takePicBtn addTarget:tabbar action:@selector(selectedTab:) forControlEvents:UIControlEventTouchDown];
        [takePicBtn addTarget:tabbar action:@selector(setSelectedTab:) forControlEvents:UIControlEventTouchUpInside];
        [takePicBtn addTarget:tabbar action:@selector(setSelectedTab:) forControlEvents:UIControlEventTouchUpOutside];

}

#pragma mark - create new circle btn method
-(void)createNewCircle:(UIButton *)button
{
    
    
    
    self.mCreateCircleInterface = [[CreateCircleInterface alloc] init];
    self.mCreateCircleInterface.delegate = self;
    [self.mCreateCircleInterface createCircle];
    
    
}

#pragma mark - UIScrollViewDelegate method
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView == self.operScrollView) {
//        self.operScrollView.contentOffset
        CGFloat pageWidth = self.operScrollView.frame.size.width;
        int currPage = floor((self.operScrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
        self.operPageControl.currentPage = currPage;
        
        
        if (currentCircleViewIndex != currPage) {
            currentCircleViewIndex = currPage;
            
            if (currentCircleViewIndex < [self.circleViewArray count]) {
                for (UIView *view in [self.topViewGroup subviews]) {
                    [view removeFromSuperview];
                }
            
                [self.topViewGroup addSubview:[self.circleViewArray objectAtIndex:currentCircleViewIndex]];
            }
            
            
            CustomTabBarController *tabbar = (CustomTabBarController *)self.tabBarController;
            UIButton *takePicBtn = (UIButton *)[tabbar.baseBtnGroup viewWithTag:9];
            if (currentCircleViewIndex >= [self.circleViewArray count]) {
                [takePicBtn setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"logoJoinGroup@2x" ofType:@"png"]] forState:UIControlStateNormal];
                [takePicBtn setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"logoJoinGroupPressed@2x" ofType:@"png"]] forState:UIControlStateHighlighted];
                [takePicBtn setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"logoJoinGroupPressed@2x" ofType:@"png"]] forState:UIControlStateSelected];
                takePicBtn.alpha = 0.5f;
                
                [takePicBtn removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
//                [takePicBtn addTarget:tabbar action:@selector(selectedTab:) forControlEvents:UIControlEventTouchDown];
//                [takePicBtn addTarget:tabbar action:@selector(setSelectedTab:) forControlEvents:UIControlEventTouchUpInside];
//                [takePicBtn addTarget:tabbar action:@selector(setSelectedTab:) forControlEvents:UIControlEventTouchUpOutside];
            }else{
                CircleModel *cm = [self.circleArray objectAtIndex:currPage];
                //当前所在圈子
                if ([cm.cId isEqualToString:[NSString stringWithFormat:@"%d",[MySingleton sharedSingleton].currentCircleId]]) {
                    [takePicBtn setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"logo" ofType:@"png"]] forState:UIControlStateNormal];
                    [takePicBtn setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"logoPressed" ofType:@"png"]] forState:UIControlStateHighlighted];
                    [takePicBtn setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"logoPressed" ofType:@"png"]] forState:UIControlStateSelected];
                    takePicBtn.alpha = 1;
                    
                    [takePicBtn removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
                    [takePicBtn addTarget:tabbar action:@selector(selectedTab:) forControlEvents:UIControlEventTouchDown];
                    [takePicBtn addTarget:tabbar action:@selector(setSelectedTab:) forControlEvents:UIControlEventTouchUpInside];
                    [takePicBtn addTarget:tabbar action:@selector(setSelectedTab:) forControlEvents:UIControlEventTouchUpOutside];
                }else{//其他圈子
                    [takePicBtn setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"logoJoinGroup@2x" ofType:@"png"]] forState:UIControlStateNormal];
                    [takePicBtn setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"logoJoinGroupPressed@2x" ofType:@"png"]] forState:UIControlStateHighlighted];
                    [takePicBtn setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"logoJoinGroupPressed@2x" ofType:@"png"]] forState:UIControlStateSelected];
                    takePicBtn.alpha = 1;
                    
                    [takePicBtn removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
//                    [takePicBtn addTarget:tabbar action:@selector(selectedTab:) forControlEvents:UIControlEventTouchDown];
                    [takePicBtn addTarget:self action:@selector(changeCircleAction:) forControlEvents:UIControlEventTouchDown];
//                    [takePicBtn addTarget:tabbar action:@selector(setSelectedTab:) forControlEvents:UIControlEventTouchUpInside];
//                    [takePicBtn addTarget:tabbar action:@selector(setSelectedTab:) forControlEvents:UIControlEventTouchUpOutside];
                }
            }
            
        }
        
        NSInteger alphaOffset = (NSInteger)scrollView.contentOffset.x % ((NSInteger)scrollView.frame.size.width);
        if (currentCircleViewIndex < [self.circleViewArray count]) {    
            if (alphaOffset <= self.view.frame.size.width / 2) {
                self.topViewGroupCoverView.alpha = (CGFloat)alphaOffset / (self.view.frame.size.width / 2);
            }else{
                CGFloat alpha = (self.view.frame.size.width - (CGFloat)alphaOffset) / (self.view.frame.size.width / 2);
                self.topViewGroupCoverView.alpha = alpha;
            }
        }else{
            self.topViewGroupCoverView.alpha = 0.5f;
        }
//        NSLog(@"%d %f",alphaOffset,self.view.frame.size.width * 2);
        
        //更改cover透明度
//        self.topViewGroupCoverView.alpha = ((NSInteger)scrollView.contentOffset.x / (NSInteger)scrollView.contentSize.width / 2) / scrollView.contentSize.width / 2;
        
        
    }
}





#pragma mark - NearByShowAllInterfaceDelegate
-(void)getAllDidFinished:(NSArray *)circleArray users:(NSArray *)usersArray{
    [self.circleArray removeAllObjects];//清空所有数据
    
    [self.circleArray addObjectsFromArray:circleArray];
    self.nearByUsersArray = [NSMutableArray arrayWithArray:usersArray];
    
    [self initTopViewGroup];
    
//    [self.operScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    
    BOOL foundFlag = NO;
    NSInteger i = 0;
    for (CircleModel *cm in self.circleArray) {
        if ([cm.cId isEqualToString:[NSString stringWithFormat:@"%d",[MySingleton sharedSingleton].currentCircleId]]) {
            [self.operScrollView setContentOffset:CGPointMake(i * self.view.frame.size.width, 0) animated:NO];
            foundFlag = YES;
            break;
        }

        ++i;
    }
    
    if (!foundFlag) {
        [self createNewCircle:nil];
    }
    
    self.mNearByShowAllInterface.delegate = nil;
    self.mNearByShowAllInterface = nil;
    
    [self performSelector:@selector(initFindNewCircleListTimer) withObject:nil afterDelay:10];
    [self performSelector:@selector(initFindNewMediaListTimer) withObject:nil afterDelay:12];
    [self performSelector:@selector(initFindUserListTimer) withObject:nil afterDelay:14];
    [self performSelector:@selector(initFindNearbyUsersTimer) withObject:nil afterDelay:14];
    
    [self performSelector:@selector(getNearByShowAllInterface) withObject:nil afterDelay:60*60];
    
}
-(void)getAllDidFailed:(NSString *)errorMsg{
    
    self.mNearByShowAllInterface.delegate = nil;
    self.mNearByShowAllInterface = nil;
    
    [self performSelector:@selector(initFindNewCircleListTimer) withObject:nil afterDelay:9];
    [self performSelector:@selector(initFindNewMediaListTimer) withObject:nil afterDelay:10];
    [self performSelector:@selector(initFindUserListTimer) withObject:nil afterDelay:11];

}

#pragma mark - init find new Circle list Timer
-(void)initFindNewCircleListTimer
{
    if (!self.findNewCirclesTimer) {
        //评论心跳定时器
        self.findNewCirclesTimer = [NSTimer scheduledTimerWithTimeInterval:30 target:self selector:@selector(findNewCircles) userInfo:nil repeats:YES];
        [self.findNewCirclesTimer fire];
    }
}

//查找附近新圈子心跳方法
-(void)findNewCircles
{
    self.mCircleByTimestampHeartbeatInterface = [[[CircleByTimestampHeartbeatInterface alloc] init] autorelease];
    self.mCircleByTimestampHeartbeatInterface.delegate = self;
    if (self.circleArray.count > 0) {
        CircleModel *circle = (CircleModel *)[self.circleArray objectAtIndex:0];
        [self.mCircleByTimestampHeartbeatInterface getCircleByTimestamp:[circle.ctime timeIntervalSince1970]+1];
    }else{
        [self.mCircleByTimestampHeartbeatInterface getCircleByTimestamp:0];
    }
}

#pragma mark - CircleByTimestampHeartbeatInterfaceDelegate
-(void)getCircleByTimestampDidFinished:(NSArray *)circleArray{
    if (circleArray.count > 0) {
        [self.circleArray insertObjects:circleArray 
                              atIndexes:[NSMutableIndexSet indexSetWithIndexesInRange:NSMakeRange(0, [circleArray count])]];
        
        [self addCircleToTopViewGroup:circleArray];
        
        //添加新圈子后，保留当前看到的圈子的位置
        CGPoint offsetPoint = self.operScrollView.contentOffset;
        offsetPoint.x += circleArray.count * self.view.frame.size.width;
        [self.operScrollView setContentOffset:offsetPoint 
                                     animated:NO];
    }
    
    self.mCircleByTimestampHeartbeatInterface.delegate = nil;
    self.mCircleByTimestampHeartbeatInterface = nil;
}

-(void)getCircleByTimestampDidFailed:(NSString *)errorMsg{
    NSLog(@"--getCircleByTimestampDidFailed--- %@",errorMsg);
    
    self.mCircleByTimestampHeartbeatInterface.delegate = nil;
    self.mCircleByTimestampHeartbeatInterface = nil;
}

#pragma mark - init find new Media list Timer
-(void)initFindNewMediaListTimer
{
    if (!self.findNewMediaTimer) {
        
        self.findNewMediaTimer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(findNewMedia) userInfo:nil repeats:YES];
        [self.findNewMediaTimer fire];
    }
}


-(void)findNewMedia
{
    if (self.circleArray.count > 0 && self.operPageControl.currentPage < self.circleArray.count) {
        self.mMediaByCircleidsAndTimestampHeartbeatInterface = [[[MediaByCircleidsAndTimestampHeartbeatInterface alloc] init] autorelease];
        self.mMediaByCircleidsAndTimestampHeartbeatInterface.delegate = self;
//        NSMutableString *cirIds = [[NSMutableString alloc] init];
//        for (CircleModel *circle in self.circleArray) {
//            [cirIds appendString:[NSString stringWithFormat:@"%@,",circle.cId]];
//        }
        CircleModel *circle = [self.circleArray objectAtIndex:self.operPageControl.currentPage];
        MediaModel *media = circle.mediasArray.count > 0 ?(MediaModel *)[circle.mediasArray objectAtIndex:0] : nil;
        [self.mMediaByCircleidsAndTimestampHeartbeatInterface getMediaByCircleids:circle.cId
                                                                        timestamp:media.ctime == nil? 0 : ([media.ctime timeIntervalSince1970]+1)];
        
//        [cirIds release];
    }
}

#pragma mark -  MediaByCircleidsAndTimestampHeartbeatInterfaceDelegate
-(void)getMediaByCircleidsAndTimestampDidFinished:(NSDictionary *)mediaArray
{
    self.mMediaByCircleidsAndTimestampHeartbeatInterface.delegate = nil;
    self.mMediaByCircleidsAndTimestampHeartbeatInterface = nil;
    
    for (CircleModel *circle in self.circleArray) {
        NSArray *picArray = [mediaArray objectForKey:circle.cId];
        if (picArray.count > 0) {
            if(circle.mediasArray == nil){
                circle.mediasArray = [NSMutableArray array];
            }
            
            [circle.mediasArray insertObjects:picArray
                                    atIndexes:[NSMutableIndexSet indexSetWithIndexesInRange:NSMakeRange(0, [picArray count])]];
        }
    }
    
    for (UIView *view in self.circleViewArray) {
        if ([view isMemberOfClass:[NearByPhotoView class]]) {
            NearByPhotoView * nbpv = (NearByPhotoView *)view;
            CircleModel *circle = nbpv.mCircleModel;
            NSArray *picArray = [mediaArray objectForKey:circle.cId];
            if (picArray.count > 0) {
//                [circle.mediasArray insertObjects:picArray
//                                        atIndexes:[NSMutableIndexSet indexSetWithIndexesInRange:NSMakeRange(0, [picArray count])]];
                
                [nbpv updateMedias];
            }
        }
    }
}

-(void)getMediaByCircleidsAndTimestampDidFailed:(NSString *)errorMsg
{
    NSLog(@"=============== getMediaByCircleidsAndTimestampDidFailed ================ %@",errorMsg);
    
    self.mMediaByCircleidsAndTimestampHeartbeatInterface.delegate = nil;
    self.mMediaByCircleidsAndTimestampHeartbeatInterface = nil;
}

#pragma mark - init find nearby users Timer
-(void)initFindNearbyUsersTimer
{
    if (!self.findNearbyUsersTimer) {
        
        self.findNearbyUsersTimer = [NSTimer scheduledTimerWithTimeInterval:14 target:self selector:@selector(findNearbyUsers) userInfo:nil repeats:YES];
        [self.findNearbyUsersTimer fire];
    }
}


-(void)findNearbyUsers
{
    self.mNearByUsersHeartbeatInterface = [[[NearByUsersHeartbeatInterface alloc] init] autorelease];
    self.mNearByUsersHeartbeatInterface.delegate = self;
    [self.mNearByUsersHeartbeatInterface getNearByUsers];
}

#pragma mark - NearByUsersHeartbeatInterfaceDelegate
-(void)getUsersDidFinished:(NSArray *)userArray
{
    [self.nearByUsersArray removeAllObjects];
    self.nearByUsersArray = [NSMutableArray arrayWithArray:userArray];
    
    
    for (UIView *view in self.circleViewArray) {
        if ([view isMemberOfClass:[NearByPhotoView class]]) {
            NearByPhotoView * nbpv = (NearByPhotoView *)view;
            nbpv.nearByUsersArray = self.nearByUsersArray;
        }
    }
    
    self.mNearByUsersHeartbeatInterface.delegate = nil;
    self.mNearByUsersHeartbeatInterface = nil;
}

-(void)getUsersDidFailed:(NSString *)errorMsg
{
    NSLog(@"=============== getUsersDidFailed ================ %@",errorMsg);
    
    self.mNearByUsersHeartbeatInterface.delegate = nil;
    self.mNearByUsersHeartbeatInterface = nil;
}

#pragma mark - init find user list Timer
-(void)initFindUserListTimer
{
    if (!self.findUserListTimer) {
        
        self.findUserListTimer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(findNewUserList) userInfo:nil repeats:YES];
        [self.findUserListTimer fire];
    }
}


-(void)findNewUserList
{
    if (self.circleArray.count > 0 && self.operPageControl.currentPage < self.circleArray.count) {
        self.mUserListByCircleidsHeartbeatInterface = [[[UserListByCircleidsHeartbeatInterface alloc] init] autorelease];
        self.mUserListByCircleidsHeartbeatInterface.delegate = self;
        CircleModel *circle = [self.circleArray objectAtIndex:self.operPageControl.currentPage];
        [self.mUserListByCircleidsHeartbeatInterface getUserListByCircleids:circle.cId];

    }
}

#pragma mark - UserListByCircleidsHeartbeatInterfaceDelegate
-(void)getUserListByCircleidsDidFinished:(NSArray *)userArray circleId:(NSString *)cid
{   
    if (userArray.count > 0) {
        for (CircleModel *circle in self.circleArray) {
            if ([cid isEqualToString:circle.cId]) {
                circle.usersArray = [NSMutableArray arrayWithArray:userArray];
            }
        }
        
        
        for (UIView *view in self.circleViewArray) {
            if ([view isMemberOfClass:[NearByPhotoView class]]) {
                NearByPhotoView * nbpv = (NearByPhotoView *)view;
                CircleModel *circle = nbpv.mCircleModel;
                if ([cid isEqualToString:circle.cId]) {
                    [nbpv updateMembers];
                }
            }
        }
        
        [self initOperScrollView];
    }    
    
    self.mUserListByCircleidsHeartbeatInterface.delegate = nil;
    self.mUserListByCircleidsHeartbeatInterface = nil;
}

-(void)getUserListByCircleidsDidFailed:(NSString *)errorMsg
{
    NSLog(@"=============== getUserListByCircleidsDidFailed ================ %@",errorMsg);
    
    self.mUserListByCircleidsHeartbeatInterface.delegate = nil;
    self.mUserListByCircleidsHeartbeatInterface = nil;
}

#pragma mark -  CreateCircleInterfaceDelegate
-(void)createCircleDidFinished:(CircleModel *)circleModel
{
    currentCircleViewIndex = -1;
    
    UserModel *userModel = [[[UserModel alloc] init] autorelease];
    userModel.userId = [MySingleton sharedSingleton].userId;
    userModel.name = [MySingleton sharedSingleton].name;
    userModel.avatarUrl = [MySingleton sharedSingleton].avatarUrl;
    circleModel.usersArray = [NSArray arrayWithObjects:userModel, nil];
    circleModel.mediasArray = [NSMutableArray array];
    
    [self.circleArray insertObject:circleModel atIndex:0];
    [self addCircleToTopViewGroup:[NSArray arrayWithObjects:circleModel, nil]];
    
    self.mCreateCircleInterface.delegate = nil;
    self.mCreateCircleInterface = nil;
    
    [self.operScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    
}

-(void)createCircleDidFailed:(NSString *)errorMsg
{
    NSLog(@"============ createCircleDidFailed ============== %@",errorMsg);
    
//    UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:@"创建圈子失败" 
//													   message:errorMsg 
//													  delegate:nil
//											 cancelButtonTitle:@"确定" 
//											 otherButtonTitles:nil];
//	[alertView show];
//	[alertView release];

    self.mCreateCircleInterface.delegate = nil;
    self.mCreateCircleInterface = nil;
}

@end
