//
//  NearByPhotoView.m
//  Color
//
//  Created by chao han on 12-6-5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "NearByPhotoView.h"
#import "EGOImageView.h"
#import "CircleModel.h"
#import "UserModel.h"
#import "MediaModel.h"
#import "HomePageViewController.h"
#import "AppDelegate.h"
#import "NSDate+DynamicDateString.h"
#import "PhotoListViewController.h"

@implementation NearByPhotoView

@synthesize memberScrollView = _memberScrollView , photoImageView = _photoImageView
 , photoScrollView = _photoScrollView , dateLabel = _dateLabel 
 , mCircleModel = _mCircleModel , noMediaViewGroup = _noMediaViewGroup
 , nearByUsersArray = _nearByUsersArray , peopleScrollView = _peopleScrollView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(void)removeNoMediaView
{
    if (self.noMediaViewGroup) {
        [self.noMediaViewGroup removeFromSuperview];
        self.noMediaViewGroup = nil;
    }
}

-(void)goHomePage:(UIGestureRecognizer *) sender {
    NSInteger idx = sender.view.tag;
    if (idx < [self.mCircleModel.usersArray count]) {
        UserModel *user = [self.mCircleModel.usersArray objectAtIndex:idx];
        
        HomePageViewController *mHomePageViewController = [[HomePageViewController alloc] init];
        mHomePageViewController.userId = user.userId;
        AppDelegate *mainDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
        UINavigationController *currentController = (UINavigationController *)mainDelegate.tabBarController.selectedViewController;
        
        [currentController pushViewController:mHomePageViewController animated:YES];
        [mHomePageViewController release];
    }
}

-(void)goHomePageForNearByUser:(UIGestureRecognizer *) sender {
    NSInteger idx = sender.view.tag;
    if (idx < [self.nearByUsersArray count]) {
        UserModel *user = [self.nearByUsersArray objectAtIndex:idx];
        
        HomePageViewController *mHomePageViewController = [[HomePageViewController alloc] init];
        mHomePageViewController.userId = user.userId;
        AppDelegate *mainDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
        UINavigationController *currentController = (UINavigationController *)mainDelegate.tabBarController.selectedViewController;
        
        [currentController pushViewController:mHomePageViewController animated:YES];
        [mHomePageViewController release];
    }
}

//初始化头像scroll view
-(void)initPeopleScrollView{
    for (int i = 0; i<self.nearByUsersArray.count; i++) {
        UserModel *user = [self.nearByUsersArray objectAtIndex:i];
        EGOImageView *peopleIcon = [[EGOImageView alloc] init];
        peopleIcon.userInteractionEnabled = YES;
        peopleIcon.tag = i;
        peopleIcon.imageURL = [NSURL URLWithString:user.avatarUrl];
        peopleIcon.frame = CGRectMake(i*self.peopleScrollView.frame.size.height + i * 1
                                      , 0
                                      , self.peopleScrollView.frame.size.height
                                      , self.peopleScrollView.frame.size.height);
        UITapGestureRecognizer *headerTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goHomePageForNearByUser:)];
        [headerTap setNumberOfTapsRequired:1];
        [peopleIcon addGestureRecognizer:headerTap];
        [headerTap release];
        
        [self.peopleScrollView addSubview:peopleIcon];
        [peopleIcon release];
    }
    self.peopleScrollView.contentSize = CGSizeMake(self.peopleScrollView.frame.size.width
                                                   , self.peopleScrollView.frame.size.height);
}

-(void)setNearByUsersArray:(NSMutableArray *)nearByUsersArray{
    [_nearByUsersArray release];
    _nearByUsersArray = [nearByUsersArray retain];
    
    if (self.nearByUsersArray) {
        [self initPeopleScrollView];
    }
}

-(void)setMCircleModel:(CircleModel *) cm{
    [_mCircleModel release];
    _mCircleModel = [cm retain];
    
    if (self.mCircleModel) {
        if (self.mCircleModel.mediasArray.count > 0 || ![self.mCircleModel.cId isEqualToString:[NSString stringWithFormat:@"%d",[MySingleton sharedSingleton].currentCircleId]]) 
        {
            [self removeNoMediaView];
        } 
        NSInteger i = 0;
        for (UserModel *user in self.mCircleModel.usersArray) {
            EGOImageView *imageView = [[EGOImageView alloc] init];
            imageView.frame = CGRectMake(40 * i, 0, 40, 40);
            imageView.imageURL = [NSURL URLWithString:user.avatarUrl];
            imageView.userInteractionEnabled = YES;
            imageView.tag = i;
            //TODO 点击事件，自定义tag
            UITapGestureRecognizer *headerTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goHomePage:)];
            [headerTap setNumberOfTapsRequired:1];
            [imageView addGestureRecognizer:headerTap];
            [headerTap release];
            
            [self.memberScrollView addSubview:imageView];
            [imageView release];
            
            ++i;
        }
        self.memberScrollView.contentSize = CGSizeMake(i * 40, self.memberScrollView.frame.size.height);
        i = 0;
        for (MediaModel *media in self.mCircleModel.mediasArray) {
            EGOImageView *imageView = [[EGOImageView alloc] init];
            imageView.frame = CGRectMake(0, i * 80, 80, 80);
            
            CGRect scrollViewFrame = CGRectMake(0, 0, 
                                                self.photoScrollView.frame.size.width,
                                                self.photoScrollView.frame.size.height * 2);
            
            if (CGRectIntersectsRect(scrollViewFrame, imageView.frame)) {
                if (media.mediaType == 0) {
                    imageView.imageURL = [NSURL URLWithString:media.originalUrl];
                }else{
                    imageView.imageURL = [NSURL URLWithString:media.thumbnailUrl];
                }
            }
            imageView.userInteractionEnabled = YES;
            imageView.tag = i;
            //TODO 点击事件，自定义tag
            [self.photoScrollView addSubview:imageView];
            [imageView release];
            
            ++i;
        }
        self.photoScrollView.contentSize = CGSizeMake(self.photoScrollView.frame.size.width,i * 80 + 160);
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        [[NSNotificationCenter defaultCenter] addObserver:self 
                                                 selector:@selector(addMyMedia:) 
                                                     name:[NSString stringWithFormat:@"circleid_%@",self.mCircleModel.cId] 
                                                   object:nil];
        self.photoImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *singleTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(photoTaped:)];
        [self.photoImageView addGestureRecognizer:singleTap];
        [singleTap release];
        
        [self showCurrentPic];
    }
}
-(void)addMyMedia:(NSNotification *)notification{
    NSString *mediaPath = [notification.userInfo objectForKey:@"imageFilePath"];
    NSString *mediaType = [notification.userInfo objectForKey:@"mediaType"];//1:video
    if (mediaPath) {
        MediaModel *myMediaModel = [[MediaModel alloc] init];
        myMediaModel.mid = 0;
        myMediaModel.ctime = [NSDate date];
        myMediaModel.mediaType = [@"0" isEqualToString:mediaType] ? 0 : 1;
        myMediaModel.circleId = self.mCircleModel.cId;
        myMediaModel.originalUrl = mediaPath;//[NSURL fileURLWithPath:mediaPath];
        myMediaModel.thumbnailUrl = mediaPath;//[NSURL fileURLWithPath:mediaPath];
        myMediaModel.comCount = 0;
        myMediaModel.goodCount = 0;
        
        UserModel *user = [[UserModel alloc] init];
        user.userId = [MySingleton sharedSingleton].userId;
        myMediaModel.owner = user;
        [user release];
        
        [self.mCircleModel.mediasArray insertObject:myMediaModel atIndex:0];
        [myMediaModel release];
        
        [self updateMedias];
    }
    
}

-(void)showCurrentPic{
    NSInteger i = 0;
    for(UIView *view in [self.photoScrollView subviews]){
        if ([view isMemberOfClass:[EGOImageView class]]) {
            CGRect viewFrame = view.frame;
            viewFrame.origin.y -= self.photoScrollView.contentOffset.y;
            if (CGRectIntersectsRect(CGRectMake(0, 0, 80, 40), viewFrame)) {
                if (![((EGOImageView *)view).imageURL.absoluteString isEqualToString:self.photoImageView.imageURL.absoluteString]) {
                    self.photoImageView.imageURL = ((EGOImageView *)view).imageURL;
                    
                    if (i < self.mCircleModel.mediasArray.count) {
                        MediaModel *media = [self.mCircleModel.mediasArray objectAtIndex:i];
                        
                        self.dateLabel.text = [media.ctime getDynamicDateStringFromNow];
                        [_currentMediaId release];
                        _currentMediaId = [media.mid retain];
                        
                    }
                }
                
//                break;
            }
            EGOImageView *photo = (EGOImageView *)view;
//            CGRect frame = photo.frame;
//            viewFrame.origin.y -= self.photoScrollView.contentOffset.y;
            CGRect scrollViewFrame = CGRectMake(0, - self.photoScrollView.frame.size.height, 
                                                self.photoScrollView.frame.size.width,
                                                self.photoScrollView.frame.size.height * 3);
            if (CGRectIntersectsRect(scrollViewFrame, viewFrame) && photo.imageURL == nil) {//相交，显示图片
                MediaModel *media = [self.mCircleModel.mediasArray objectAtIndex:i];
                photo.imageURL = [NSURL URLWithString:media.originalUrl];
                //                [photo cancelImageLoad];
                //                photo.image = nil;
                //                photo.imageURL = nil;
            }
            ++i;
        }
        
        
    }
}

-(void)updateMembers{
    for (UIView *view in [self.memberScrollView subviews]) {
        if ([view isMemberOfClass:[EGOImageView class]]) {
            [view removeFromSuperview];
        }
    }
    NSInteger i = 0;
    for (UserModel *user in self.mCircleModel.usersArray) {
        EGOImageView *imageView = [[EGOImageView alloc] init];
        imageView.frame = CGRectMake(40 * i, 0, 40, 40);
        imageView.imageURL = [NSURL URLWithString:user.avatarUrl];
        imageView.userInteractionEnabled = YES;
        imageView.tag = i;
        //TODO 点击事件，自定义tag
        UITapGestureRecognizer *headerTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goHomePage:)];
        [headerTap setNumberOfTapsRequired:1];
        [imageView addGestureRecognizer:headerTap];
        [headerTap release];
        
        [self.memberScrollView addSubview:imageView];
        [imageView release];
        ++i;
    }
    self.memberScrollView.contentSize = CGSizeMake(i * 40, self.memberScrollView.frame.size.height);
}

-(void)updateMedias
{   
    [self removeNoMediaView];
    
    NSInteger lastAmount = 0;
    for (UIView *view in [self.photoScrollView subviews]) {
        if ([view isMemberOfClass:[EGOImageView class]]) {
            [view removeFromSuperview];
            ++lastAmount;
        }
    }
    
    NSInteger i = 0;//self.mCircleModel.mediasArray.count - lastAmount - 1;
//    for (;i >= 0 ; --i) {
    for (; i < self.mCircleModel.mediasArray.count; ++i) {
        MediaModel *media = [self.mCircleModel.mediasArray objectAtIndex:i];
        
        EGOImageView *imageView = [[EGOImageView alloc] init];
        imageView.frame = CGRectMake(0, i * 80, 80, 80);
        if (media.mediaType == 0) {
            imageView.imageURL = [media.originalUrl hasPrefix:@"http"] ? [NSURL URLWithString:media.originalUrl]:[NSURL fileURLWithPath:media.originalUrl];
        }else
        {
            imageView.imageURL = [media.thumbnailUrl hasPrefix:@"http"] ? [NSURL URLWithString:media.thumbnailUrl]:[NSURL fileURLWithPath:media.thumbnailUrl];
        }
        imageView.userInteractionEnabled = YES;
        imageView.tag = i;
        //TODO 点击事件，自定义tag
        
        [self.photoScrollView addSubview:imageView];
        [imageView release];
    }
    self.photoScrollView.contentSize = CGSizeMake(self.photoScrollView.frame.size.width,i * 80 + 160);
    
    [self showCurrentPic];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    self.memberScrollView = nil;
    self.photoScrollView = nil;
    self.photoImageView = nil;
    self.dateLabel = nil;
    self.mCircleModel = nil;
    self.nearByUsersArray = nil;
    
    [_currentMediaId release];
    _currentMediaId = nil;
    
    self.noMediaViewGroup = nil;
    self.peopleScrollView = nil;
    
    [super dealloc];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self showCurrentPic];
}
-(void)photoTaped:(UIGestureRecognizer *)gesture{
    if (self.photoImageView.image) {
        PhotoListViewController *_photoListViewController = [[PhotoListViewController alloc] init];
        _photoListViewController.circleId = self.mCircleModel.cId;
        _photoListViewController.mediaId = _currentMediaId;
        
        AppDelegate *mainDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
        UINavigationController *currentController = (UINavigationController *)mainDelegate.tabBarController.selectedViewController;
        [currentController pushViewController:_photoListViewController animated:YES];
        [_photoListViewController release];
    }
    
}

@end
