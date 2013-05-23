//
//  MediaCommentListViewControll.m
//  Color
//
//  Created by chao han on 12-6-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MediaCommentListViewControll.h"
#import "NSDate+DynamicDateString.h"
#import "HomePageViewController.h"
#import "CommentModel.h"
#import <QuartzCore/QuartzCore.h>
#import "AppDelegate.h"

@implementation MediaCommentListViewControll

@synthesize tabBarView = _tabBarView , mscrollView = _mscrollView
, nameLabel = _nameLabel , dateLabel = _dateLabel , avatarImageView = _avatarImageView
, photoImageView = _photoImageView , headerViewGroup = _headerViewGroup
, media = _media , someLikeThis = _someLikeThis 
, mCommentViewController = _mCommentViewController 
, mCreateCommentInterface = _mCreateCommentInterface
, mCommentShowInterface = _mCommentShowInterface 
, mCommentShowInterfaceForPull = _mCommentShowInterfaceForPull 
, commentList = _commentList;

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

#pragma mark - TabBar button action
-(void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
    
    [mCustomTabBarController popTabBar];//移除当前tabbar
    
}

-(void)homeAction{
    [self.navigationController popToRootViewControllerAnimated:YES];
    
    //    CustomTabBarController *mCustomTabBarController = (CustomTabBarController *)self.tabBarController;
    //移除当前tabbar
    [mCustomTabBarController popToRootTabBar];//移除当前tabbar
    
}


//评论
-(void)commentActionFeedId:(NSString *)feedId feedUserName:(NSString *)feedUserName
{
    self.mCommentViewController = [[[CommentViewController alloc] initWithFeedId:feedId andFeedUserName:feedUserName] autorelease];
    self.mCommentViewController.view.frame = CGRectMake(0, 0, 320, 265);
    self.mCommentViewController.delegate = self;
    
    AppDelegate *mainDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    UINavigationController *currentController = (UINavigationController *)mainDelegate.tabBarController.selectedViewController;
    
    [currentController pushViewController:self.mCommentViewController animated:YES];
}

//评论按钮事件
-(void)commentAction
{
    [self commentActionFeedId:nil feedUserName:nil];
}

- (void)animationDidStop:(NSString *) animationID finished:(NSNumber *) finished context:(void *) context {
	[self.tabBarView removeFromSuperview];
}

#pragma mark header tap method
-(void)goHomePage:(UITapGestureRecognizer *)sender
{
    HomePageViewController *mHomePageViewController = [[HomePageViewController alloc] init];
    
    NSInteger idx = sender.view.tag;
    if (idx == -1) {
        mHomePageViewController.userId = self.media.owner.userId;
    }else{
        mHomePageViewController.userId = ((CommentModel *)[self.commentList objectAtIndex:idx]).owner.userId;
    }
    
    [self.navigationController pushViewController:mHomePageViewController animated:YES];
    [mHomePageViewController release];
}

-(void)createComment:(UITapGestureRecognizer *)sender
{
    UIView *imageView = nil;
    for (UIView *v in [sender.view subviews]) {
        if ([v isMemberOfClass:[EGOImageView class]]) {
            imageView = v;
            break;
        }
    }
    
    if (imageView != nil) {
        NSInteger idx = imageView.tag;
        if (idx > -1) {
            [self commentActionFeedId:((CommentModel *)[self.commentList objectAtIndex:idx]).owner.userId
                         feedUserName:((CommentModel *)[self.commentList objectAtIndex:idx]).owner.name];
        }
        
    }
    
}

#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _hasMorePage = YES;
    self.commentList = [[NSMutableArray alloc] init];
    
    //处理tab bar
    mCustomTabBarController = (CustomTabBarController *)self.tabBarController;
    
    NSArray *arr1 = [[NSBundle mainBundle] loadNibNamed:@"TabBarCommentView" owner:self options:nil];  
    self.tabBarView = (TabBarCommentView*)[arr1 objectAtIndex:0];
    [self.tabBarView.backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [self.tabBarView.homeBtn addTarget:self action:@selector(homeAction) forControlEvents:UIControlEventTouchUpInside];
    [self.tabBarView.commentBtn addTarget:self action:@selector(commentAction) forControlEvents:UIControlEventTouchUpInside];
    
    [mCustomTabBarController pushTabBar:self.tabBarView];
    
    //初始化页面
    if (self.media.mediaType == 0) {
        self.photoImageView.imageURL = [NSURL URLWithString:self.media.originalUrl];//图片
    }else
    {
        self.photoImageView.imageURL = [NSURL URLWithString:self.media.thumbnailUrl];//视频
    }
    
    //头像
    self.avatarImageView.imageURL = [NSURL URLWithString:self.media.owner.avatarUrl];
    self.avatarImageView.userInteractionEnabled = YES;
    self.avatarImageView.tag = 0;
    //头像点击事件
    UITapGestureRecognizer *headerTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goHomePage:)];
    [headerTap setNumberOfTapsRequired:1];
    self.avatarImageView.tag = -1;
    [self.avatarImageView addGestureRecognizer:headerTap];
    [headerTap release];
    //人名
    self.nameLabel.text = self.media.owner.name;    
    //时间
    self.dateLabel.text = [self.media.ctime getDynamicDateStringFromNow];
    
    self.mscrollView.contentSize = CGSizeMake(self.view.frame.size.width , 
                                              self.view.frame.size.height);
    
    //获取历史列表
    self.mCommentShowInterface = [[CommentShowInterface alloc] init];
    self.mCommentShowInterface.delegate = self;
    [self.mCommentShowInterface getCommentListByStartTime:0 mediaId:self.media.mid];
    _isGettingNextPage = YES;
    
    //下拉刷新
    if (_refreshHeaderView == nil) {
		EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.mscrollView.bounds.size.height, self.view.frame.size.width, self.mscrollView.bounds.size.height)];
		view.delegate = self;
		[self.mscrollView addSubview:view];
		_refreshHeaderView = view;
		[view release];
		
	}
}

//刷新评论列表--用于下拉刷新
-(void)refreshCommentList{
    for (UIView *view in self.mscrollView.subviews) {
        if (view.tag == 99) {
            [view removeFromSuperview];
        }
    }
    self.mscrollView.contentSize = CGSizeMake(self.view.frame.size.width , 
                                              self.view.frame.size.height);
    
    if ([self.commentList count] > 0) {
        CGFloat offset = self.someLikeThis.frame.size.height + self.someLikeThis.frame.origin.y;
        NSInteger i = 0;
        for (CommentModel *cm in self.commentList) {
            UIView *commentView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                           offset, 
                                                                           self.view.frame.size.width,
                                                                           40)];
            commentView.tag = 99;
            commentView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.0];
            
            //头像
            EGOImageView *avatar = [[EGOImageView alloc] init];
            avatar.userInteractionEnabled = YES;
            avatar.tag = i;
            avatar.imageURL = [NSURL URLWithString:cm.owner.avatarUrl];
            avatar.frame = CGRectMake(0,0,40,40);
            avatar.layer.borderWidth = 0.5f;
            avatar.layer.borderColor = [UIColor whiteColor].CGColor;
            [commentView addSubview:avatar];
            
            //头像点击事件
            UITapGestureRecognizer *headerTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goHomePage:)];
            [headerTap setNumberOfTapsRequired:1];
            [avatar addGestureRecognizer:headerTap];
            [headerTap release];
            
            //时间
            UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 105,0,
                                                                           100,
                                                                           13)];
            dateLabel.textAlignment = UITextAlignmentRight;
            dateLabel.font = [UIFont fontWithName:@"Helvetica" size:12];
            dateLabel.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.0];
            dateLabel.text = [cm.ctime getDynamicDateStringFromNow];
            [commentView addSubview:dateLabel];
            [dateLabel release];
            
            //人名
            UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(45,0,
                                                                           self.view.frame.size.width,
                                                                           13)];
            nameLabel.font = [UIFont fontWithName:@"Helvetica" size:12];
            nameLabel.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.0];
            nameLabel.text = cm.owner.name;
            [commentView addSubview:nameLabel];
            
            CGRect commentViewFrame = commentView.frame;
            
            [nameLabel release];
            
            //评论
            UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(45,15,
                                                                              self.view.frame.size.width - 45 - 4,
                                                                              13)];
            contentLabel.font = [UIFont fontWithName:@"Helvetica" size:12];
            contentLabel.numberOfLines = 10;
            contentLabel.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.0];
            //计算评论内容的size
            NSString *content = nil;
            if (cm.feedUser != nil) {
                content = [NSString stringWithFormat:@"回复%@:  %@",cm.feedUser.name,cm.content];
            }else
            {
                content = cm.content;
            }
            CGSize countLabelFontSize = [content sizeWithFont:contentLabel.font 
                                               constrainedToSize:CGSizeMake(contentLabel.frame.size.width, 999) 
                                                   lineBreakMode:contentLabel.lineBreakMode];
            CGRect contentLabelFrame = contentLabel.frame;
            contentLabelFrame.size.height = countLabelFontSize.height;
            contentLabel.frame = contentLabelFrame;
            contentLabel.text = content;
            [commentView addSubview:contentLabel];
            
            commentViewFrame.size.height += contentLabel.frame.size.height - 15;
            commentView.frame = commentViewFrame;
            
            [contentLabel release];
            
            
            [self.mscrollView addSubview:commentView];
            offset += avatar.frame.size.height;
            [avatar release];
            
            if (i == 0) {
                self.someLikeThis.text = [NSString stringWithFormat:@"%@ likes this",cm.owner.name];
            }
            
            [commentView release];
            
            ++i;
        }
        
        self.mscrollView.contentSize = CGSizeMake(self.view.frame.size.width , offset);
    }
}


-(void)appendCommentList:(NSArray *)commentArray{
    if ([commentArray count] > 0) {
        CGFloat offset = self.someLikeThis.frame.size.height + self.someLikeThis.frame.origin.y;
        NSInteger i = 0;
        for (CommentModel *cm in commentArray) {
            UIView *commentView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                           offset, 
                                                                           self.view.frame.size.width,
                                                                           40)];
            commentView.tag = 99;
            commentView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.0];
            
            
            UITapGestureRecognizer *commentViewTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(createComment:)];
            [commentViewTap setNumberOfTapsRequired:1];
            [commentView addGestureRecognizer:commentViewTap];
            [commentViewTap release];
            
            
            EGOImageView *avatar = [[EGOImageView alloc] init];
            avatar.userInteractionEnabled = YES;
            avatar.tag = self.commentList.count + i;
            avatar.imageURL = [NSURL URLWithString:cm.owner.avatarUrl];
            avatar.frame = CGRectMake(0,0,40,40);
            avatar.layer.borderWidth = 0.5f;
            avatar.layer.borderColor = [UIColor whiteColor].CGColor;
            [commentView addSubview:avatar];
            
            
            UITapGestureRecognizer *headerTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goHomePage:)];
            [headerTap setNumberOfTapsRequired:1];
            [avatar addGestureRecognizer:headerTap];
            [headerTap release];
            
            
            UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 105,0,
                                                                           100,
                                                                           13)];
            dateLabel.textAlignment = UITextAlignmentRight;
            dateLabel.font = [UIFont fontWithName:@"Helvetica" size:12];
            dateLabel.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.0];
            dateLabel.text = [cm.ctime getDynamicDateStringFromNow];
            [commentView addSubview:dateLabel];
            [dateLabel release];

            
            UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(45,0,
                                                                           self.view.frame.size.width,
                                                                           13)];
            nameLabel.font = [UIFont fontWithName:@"Helvetica" size:12];
            nameLabel.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.0];
            nameLabel.text = cm.owner.name;
            [commentView addSubview:nameLabel];
            
            CGRect commentViewFrame = commentView.frame;
            
            [nameLabel release];
            
            
            UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(45,15,
                                                                              self.view.frame.size.width - 45 - 4,
                                                                              13)];
            contentLabel.numberOfLines = 10;
            contentLabel.font = [UIFont fontWithName:@"Helvetica" size:12];
            contentLabel.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.0];
            
            NSString *content = nil;
            if (cm.feedUser != nil) {
                content = [NSString stringWithFormat:@"回复%@:  %@",cm.feedUser.name,cm.content];
            }else
            {
                content = cm.content;
            }
            CGSize countLabelFontSize = [content sizeWithFont:contentLabel.font 
                                               constrainedToSize:CGSizeMake(contentLabel.frame.size.width, 999) 
                                                   lineBreakMode:contentLabel.lineBreakMode];
            CGRect contentLabelFrame = contentLabel.frame;
            contentLabelFrame.size.height = countLabelFontSize.height;
            contentLabel.frame = contentLabelFrame;
            contentLabel.text = content;
            [commentView addSubview:contentLabel];
            if (contentLabel.frame.size.height > 15) {
                commentViewFrame.size.height += contentLabel.frame.size.height - 15;
            }
            commentView.frame = commentViewFrame;
            
            [contentLabel release];
            
            
            [self.mscrollView addSubview:commentView];
//            offset += avatar.frame.size.height;
            offset += commentView.frame.size.height;
            [avatar release];
            
            if (i == 0) {
                self.someLikeThis.text = [NSString stringWithFormat:@"%@ likes this",cm.owner.name];
            }
            
            [commentView release];
            
            ++i;
        }
        
        self.mscrollView.contentSize = CGSizeMake(self.view.frame.size.width , offset);
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
    _refreshHeaderView=nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)dealloc
{
    self.mCreateCommentInterface.delegate = nil;
    self.mCreateCommentInterface = nil;
    
    self.mCommentViewController.delegate = nil;
    self.mCommentViewController = nil;
    
    self.mCommentShowInterface.delegate = nil;
    self.mCommentShowInterface = nil;
    
    self.mCommentShowInterfaceForPull.delegate = nil;
    self.mCommentShowInterfaceForPull = nil;
    
    self.tabBarView = nil;
    self.mscrollView = nil;
    self.nameLabel = nil;
    self.dateLabel = nil;
    self.avatarImageView = nil;
    self.photoImageView = nil;
    self.headerViewGroup = nil;
    self.media = nil;
    self.someLikeThis = nil;
    
    [super dealloc];
}

#pragma mark - CreateCommentInterfaceDelegate 
-(void)createCommentDidFinished:(NSString *)mediaId content:(NSString *)content{
    self.mCreateCommentInterface.delegate = nil;
    self.mCreateCommentInterface = nil;
}

-(void)createCommentDidFailed:(NSString *)errorMsg{
    UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:@"发表评论失败" 
													   message:errorMsg 
													  delegate:nil
											 cancelButtonTitle:@"确定" 
											 otherButtonTitles:nil];
	[alertView show];
	[alertView release];
    
    self.mCreateCommentInterface.delegate = nil;
    self.mCreateCommentInterface = nil;
}

#pragma mark send comment
//-(void)sendCommentByMediaId:(NSString *)mid content:(NSString *)content{
//    self.mCreateCommentInterface = [[[CreateCommentInterface alloc] init] autorelease];
//    self.mCreateCommentInterface.delegate = self;
//    [self.mCreateCommentInterface createCommentByMediaId:mid content:content];
//}

#pragma mark - CommentDelegate
-(void)sendComment:(NSString *)comment feedId:(NSString *)fid{

//    [self sendCommentByMediaId:self.media.mid content:comment];
    self.mCreateCommentInterface = [[[CreateCommentInterface alloc] init] autorelease];
    self.mCreateCommentInterface.delegate = self;
    [self.mCreateCommentInterface createCommentByMediaId:self.media.mid content:comment feedId:fid];
}


#pragma mark -
#pragma mark UIScrollViewDelegate Methods
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{	
	[_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	[_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
}

#pragma mark -  HistoryInterfaceDelegate method
-(void)getCommentListDidFinished:(NSArray *)mediaArray
{
    if ([mediaArray count] == 0) {
        _hasMorePage = NO;
    }else{
        [self appendCommentList:mediaArray];
        
        [self.commentList addObjectsFromArray:mediaArray];
    }
    
    self.mCommentShowInterface.delegate = nil;
    self.mCommentShowInterface = nil;
    
    _isGettingNextPage = NO;
}

-(void)getCommentListDidFailed:(NSString *)errorMsg
{
    
    UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:@"获取评论列表失败" 
													   message:errorMsg 
													  delegate:nil
											 cancelButtonTitle:@"确定" 
											 otherButtonTitles:nil];
	[alertView show];
	[alertView release];
    
    self.mCommentShowInterface.delegate = nil;
    self.mCommentShowInterface = nil;
    
    _isGettingNextPage = NO;
}


-(void)getCommentListByTimeDidFinished:(NSArray *)mediaArray{
    if (mediaArray.count > 0) {
        [self.commentList insertObjects:mediaArray
                      atIndexes:[NSMutableIndexSet indexSetWithIndexesInRange:NSMakeRange(0, [mediaArray count])]];

        [self refreshCommentList];
    }
    
    self.mCommentShowInterfaceForPull.delegate = nil;
    self.mCommentShowInterfaceForPull = nil;
    
    [self doneLoadingTableViewData];
}

-(void)getCommentListByTimeDidFailed:(NSString *)errorMsg{
    UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:@"刷新评论列表失败" 
													   message:errorMsg 
													  delegate:nil
											 cancelButtonTitle:@"确定" 
											 otherButtonTitles:nil];
	[alertView show];
	[alertView release];
    
    self.mCommentShowInterfaceForPull.delegate = nil;
    self.mCommentShowInterfaceForPull = nil;
    
    [self doneLoadingTableViewData];
}


#pragma mark -
#pragma mark Data Source Loading / Reloading Methods

- (void)reloadTableViewDataSource{
	
	//  should be calling your tableviews data source model to reload
	//  put here just for demo
	_reloading = YES;
    
    self.mCommentShowInterfaceForPull = [[CommentShowInterface alloc] init];
    self.mCommentShowInterfaceForPull.delegate = self;
    NSTimeInterval time = 0;
    if ([self.commentList count]>0) {
        CommentModel *cm = [self.commentList objectAtIndex:0];
        time = cm.ctime.timeIntervalSince1970 + 1;
    }
    
    [self.mCommentShowInterfaceForPull getCommentListByEndTime:time mediaId:self.media.mid];
}


- (void)doneLoadingTableViewData{
	
	//  model should call this when its done loading
	_reloading = NO;
	[_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.mscrollView];
	
}

#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods
- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
	
	[self reloadTableViewDataSource];
	[self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:3.0];
	
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
	
	return _reloading; // should return if data source model is reloading
	
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
	
	return [NSDate date]; // should return date data source was last changed
	
}

@end
