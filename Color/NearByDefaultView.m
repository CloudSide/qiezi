//
//  NearByDefaultView.m
//  Color
//
//  Created by chao han on 12-6-5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "NearByDefaultView.h"
#import "CircleModel.h"
#import "UserModel.h"
#import "MediaModel.h"
#import "EGOImageView.h"
#import "AppDelegate.h"
#import "HomePageViewController.h"

@implementation NearByDefaultView

@synthesize peopleScrollView = _peopleScrollView , mCircleModel = _mCircleModel;

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

-(void)setMCircleModel:(CircleModel *) cm{
    [_mCircleModel release];
    _mCircleModel = [cm retain];
    
    //设置圈子成员
    NSInteger i = 0;
    for (UserModel *user in self.mCircleModel.usersArray) {
        EGOImageView *imageView = [[EGOImageView alloc] init];
        imageView.frame = CGRectMake(40 * i, 0, 40, 40);
        imageView.imageURL = [NSURL URLWithString:user.avatarUrl];
        imageView.userInteractionEnabled = YES;
        imageView.tag = i;
        //TODO 点击事件，自定义tag
        //朋友头像点击事件
        UITapGestureRecognizer *headerTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goHomePage:)];
        [headerTap setNumberOfTapsRequired:1];
        [imageView addGestureRecognizer:headerTap];
        [headerTap release];
        
        [self.peopleScrollView addSubview:imageView];
        [imageView release];
        
        ++i;
    }
    self.peopleScrollView.contentSize = CGSizeMake(i * 40, self.peopleScrollView.frame.size.height);
    
}


//初始化头像scroll view
-(void)initPeopleScrollView{
    for (int i = 0; i<3; i++) {
        UIImageView *peopleIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%d.jpg",i]]];
        peopleIcon.frame = CGRectMake(i*self.peopleScrollView.frame.size.height + i * 1
                                      , 0
                                      , self.peopleScrollView.frame.size.height
                                      , self.peopleScrollView.frame.size.height);
        
        [self.peopleScrollView addSubview:peopleIcon];
        [peopleIcon release];
    }
    
    self.peopleScrollView.contentSize = CGSizeMake(self.peopleScrollView.frame.size.width
                                                   , self.peopleScrollView.frame.size.height);
}

-(void)dealloc{
    self.peopleScrollView = nil;
    self.mCircleModel = nil;
    
    [super dealloc];
}
@end
