//
//  PhotoListViewController.m
//  Color
//  图片列表页面
//  Created by chao han on 12-5-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "PhotoListViewController.h"

#import "PhotoListCellView.h"
#import "CustomTabBarController.h"
#import "TabBarShareView.h"
#import "MediaByCircleIdInterface.h"
#import "MediaModel.h"
#import "UserModel.h"
#import "EGOImageView.h"
#import "NSDate+DynamicDateString.h"
#import "EGORefreshTableHeaderView.h"
#import "CreateCommentInterface.h"
#import "CommentModel.h"

@implementation PhotoListViewController

@synthesize mscrollView = _mscrollView , tabBarView = _tabBarView 
, mMediaByCircleIdInterface = _mMediaByCircleIdInterface , circleId = _circleId
, mediaList = _mediaList , mMediaByCircleIdInterfaceForPull = _mMediaByCircleIdInterfaceForPull
, mediaId = _mediaId , mRemoveMediaInterface = _mRemoveMediaInterface;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.mediaList = [[[NSMutableArray alloc] init] autorelease];
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    self.mscrollView = nil;
    self.tabBarView = nil;
    
    self.mMediaByCircleIdInterface.delegate = nil;
    self.mMediaByCircleIdInterface = nil;
    
    self.mediaList = nil;
    self.circleId = nil;
    
    self.mMediaByCircleIdInterfaceForPull.delegate = nil;
    self.mMediaByCircleIdInterfaceForPull = nil;
    
    self.mRemoveMediaInterface.delegate = nil;
    self.mRemoveMediaInterface = nil;
    
    self.mediaId = nil;
    
    _refreshHeaderView = nil;
    
    [super dealloc];
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

//- (void)onLikeBtnClick:(id)sender{
//    [self sendGoodByMediaId:<#(NSString *)#> good:sender.tag];
//}

-(void)addPhoto:(NSArray *)mediaList{
    CGFloat contentHeight = self.mscrollView.contentSize.height;
    
//    CGPoint indexPoint = CGPointMake(0, 0);
    NSInteger idx = 0;
    for (MediaModel *mm in mediaList) {
        NSArray *arr1 = [[NSBundle mainBundle] loadNibNamed:@"PhotoListCellView" owner:self options:nil];  
        PhotoListCellView *cell = [arr1 objectAtIndex:0];
        cell.frame = CGRectMake(0,
                                contentHeight + 0.5f,
                                cell.frame.size.width,
                                cell.frame.size.height);
        
        cell.mediaModel = mm;
        
        cell.trashBtn.tag = idx;
        [cell.trashBtn addTarget:self 
                          action:@selector(onTrashBtnClick:) 
                forControlEvents:UIControlEventTouchUpInside];
        
        [self.mscrollView addSubview:cell];
        
        contentHeight += cell.frame.size.height;
        
        if (mm.mid && [mm.mid isEqualToString:self.mediaId]) {
//            indexPoint = cell.frame.origin;
            [self.mscrollView setContentOffset:cell.frame.origin];
        }
        
        ++idx;
    }
    
    self.mscrollView.contentSize = CGSizeMake(self.mscrollView.frame.size.width, contentHeight);
    
//    [self.mscrollView setContentOffset:indexPoint];
    self.mediaId = nil;//根据mediaId定位只使用一次
}

-(void)insertPhotoForRefresh:(NSArray *)mediaList{
    CGFloat contentHeight = self.mscrollView.contentSize.height;
    for (NSInteger i = mediaList.count - 1; i>=0; --i) {
        MediaModel *mm = [mediaList objectAtIndex:i];
        
        NSArray *arr1 = [[NSBundle mainBundle] loadNibNamed:@"PhotoListCellView" owner:self options:nil];  
        PhotoListCellView *cell = [arr1 objectAtIndex:0];
        cell.frame = CGRectMake(0,
                                0,
                                cell.frame.size.width,
                                cell.frame.size.height);

        cell.mediaModel = mm;
        
        //移动所有已存在的photo
        for (UIView *view in [self.mscrollView subviews]) {
            if ([view isMemberOfClass:[PhotoListCellView class]]) {
                view.frame = CGRectMake(0,
                                        view.frame.origin.y + cell.frame.size.height + 0.5f,
                                        view.frame.size.width,
                                        view.frame.size.height);
            }
        }
        
        [self.mscrollView insertSubview:cell atIndex:0];

        contentHeight += cell.frame.size.height;
    }
    
    self.mscrollView.contentSize = CGSizeMake(self.mscrollView.frame.size.width, contentHeight);
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _hasMorePage = YES;
    
    //处理tab bar
    mCustomTabBarController = (CustomTabBarController *)self.tabBarController;
    
    NSArray *arr1 = [[NSBundle mainBundle] loadNibNamed:@"TabBarShareView" owner:self options:nil];  
    self.tabBarView = (TabBarShareView*)[arr1 objectAtIndex:0];
    [self.tabBarView.backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [self.tabBarView.homeBtn addTarget:self action:@selector(homeAction) forControlEvents:UIControlEventTouchUpInside];
    
    [mCustomTabBarController pushTabBar:self.tabBarView];
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIScrollView *_scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 406)];
    _scrollView.delegate = self;
    _scrollView.scrollsToTop = YES;
    _scrollView.alwaysBounceVertical = YES;
    
    self.mscrollView = _scrollView;
    [_scrollView release];
    
    [self.view addSubview:self.mscrollView];
    
    //下拉刷新
    if (_refreshHeaderView == nil) {
		
		EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.mscrollView.bounds.size.height, self.view.frame.size.width, self.mscrollView.bounds.size.height)];
		view.delegate = self;
		[self.mscrollView addSubview:view];
		_refreshHeaderView = view;
		[view release];
		
	}
	
	//  update the last update date
	[_refreshHeaderView refreshLastUpdatedDate];
    
    //网络连接
    self.mMediaByCircleIdInterface = [[[MediaByCircleIdInterface alloc] init] autorelease];
    self.mMediaByCircleIdInterface.delegate = self;
    [self.mMediaByCircleIdInterface getMediaByCircleId:self.circleId startTime:0];
    _isGettingNextPage = YES;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(showMyComment:) 
                                                 name:@"addComment" 
                                               object:nil];
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


-(void)showMyComment:(NSNotification *)notification{
    NSString *content = [notification.userInfo objectForKey:@"content"];
    NSString *mediaId = [notification.userInfo objectForKey:@"mediaId"];
    if (mediaId && content) {
        for (MediaModel *mm in self.mediaList) {
            if ([mm.mid isEqualToString:mediaId]) {
                CommentModel *cm = [[CommentModel alloc] init];
                cm.ownerName = [MySingleton sharedSingleton].name;
                cm.content = content;
                [mm.commentArray insertObject:cm atIndex:0];
                
                break;
            }
        }
        
        for (UIView *view in self.mscrollView.subviews) {
            if ([view isMemberOfClass:[PhotoListCellView class]]) {
                [view removeFromSuperview];
            }
        }
        
        CGPoint offset = self.mscrollView.contentOffset;
        self.mscrollView.contentSize = CGSizeMake(self.view.frame.size.width, 0);
        [self addPhoto:self.mediaList];
        [self.mscrollView setContentOffset:offset];
        
    }
    
}

#pragma mark - TabBar button action
-(void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
    
    [mCustomTabBarController popTabBar];

}

-(void)homeAction{
    [self.navigationController popToRootViewControllerAnimated:YES];
    
//    CustomTabBarController *mCustomTabBarController = (CustomTabBarController *)self.tabBarController;
    
    [mCustomTabBarController popToRootTabBar];
    
}

- (void)animationDidStop:(NSString *) animationID finished:(NSNumber *) finished context:(void *) context {
	[self.tabBarView removeFromSuperview];
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{	
	[_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    
    if (_hasMorePage && !_isGettingNextPage && scrollView.contentOffset.y > scrollView.contentSize.height - self.view.frame.size.height / 2) {
        
        self.mMediaByCircleIdInterface = [[[MediaByCircleIdInterface alloc] init] autorelease];
        self.mMediaByCircleIdInterface.delegate = self;
        MediaModel *mm = [self.mediaList lastObject];
        [self.mMediaByCircleIdInterface getMediaByCircleId:self.circleId startTime:mm.ctime.timeIntervalSince1970 - 1];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	[_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
}

#pragma mark - MediaByCircleIdInterfaceDelegate
-(void)getMediaByCircleIdDidFinished:(NSArray *)mediaArray{
    if ([mediaArray count] == 0) {
        _hasMorePage = NO;
    }else {
        [self.mediaList addObjectsFromArray:mediaArray];
        [self addPhoto:mediaArray];
    }
    
    self.mMediaByCircleIdInterface.delegate = nil;
    self.mMediaByCircleIdInterface = nil;
    
    _isGettingNextPage = NO;
}

-(void)getMediaByCircleIdDidFailed:(NSString *)errorMsg{
    UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:@"获取照片列表失败" 
													   message:errorMsg 
													  delegate:nil
											 cancelButtonTitle:@"确定" 
											 otherButtonTitles:nil];
	[alertView show];
	[alertView release];
    
    self.mMediaByCircleIdInterface.delegate = nil;
    self.mMediaByCircleIdInterface = nil;
    
    _isGettingNextPage = NO;
}


-(void)getMediaByTimeDidFinished:(NSArray *)mediaArray{
    if (mediaArray.count > 0) {
        [self.mediaList insertObjects:mediaArray
                            atIndexes:[NSMutableIndexSet indexSetWithIndexesInRange:NSMakeRange(0, [mediaArray count])]];
        [self insertPhotoForRefresh:mediaArray];
    }
        
    self.mMediaByCircleIdInterfaceForPull.delegate = nil;
    self.mMediaByCircleIdInterfaceForPull = nil;
    
    [self doneLoadingTableViewData];

}

-(void)getMediaByTimeDidFailed:(NSString *)errorMsg{
    UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:@"刷新照片列表失败" 
													   message:errorMsg 
													  delegate:nil
											 cancelButtonTitle:@"确定" 
											 otherButtonTitles:nil];
	[alertView show];
	[alertView release];
    
    self.mMediaByCircleIdInterfaceForPull.delegate = nil;
    self.mMediaByCircleIdInterfaceForPull = nil;
    
    [self doneLoadingTableViewData];
}

#pragma mark -
#pragma mark Data Source Loading / Reloading Methods

- (void)reloadTableViewDataSource{
	
	//  should be calling your tableviews data source model to reload
	//  put here just for demo
	_reloading = YES;
    
    self.mMediaByCircleIdInterfaceForPull = [[[MediaByCircleIdInterface alloc] init] autorelease];
    self.mMediaByCircleIdInterfaceForPull.delegate = self;
    
    if (self.mediaList.count > 0) {
        MediaModel *mm = [self.mediaList objectAtIndex:0];
        [self.mMediaByCircleIdInterfaceForPull getMediaByCircleId:self.circleId
                                                          endTime:mm.ctime.timeIntervalSince1970 + 1];
    }else{
        [self.mMediaByCircleIdInterfaceForPull getMediaByCircleId:self.circleId
                                                   endTime:0];
    }
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

#pragma mark - 删除按钮事件
-(void)onTrashBtnClick:(id)sender{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] 
                                  initWithTitle:@"删除此照片？"
                                  delegate:self 
                                  cancelButtonTitle: @"取消"
                                  destructiveButtonTitle:nil 
                                  otherButtonTitles:@"删除",nil];
    
    actionSheet.tag = ((UIView*)sender).tag;
    [actionSheet showInView:self.view];
    [actionSheet release];
}

#pragma mark - ActionSheet Delegate Methods
- (void) actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        MediaModel *mediaModel = [self.mediaList objectAtIndex:actionSheet.tag];
        self.mRemoveMediaInterface = [[RemoveMediaInterface alloc] init];
        self.mRemoveMediaInterface.delegate = self;
        [self.mRemoveMediaInterface removeMediaById:mediaModel.mid];
    
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"removeMedia" 
                                                            object:nil 
                                                          userInfo:[NSDictionary dictionaryWithObjectsAndKeys:mediaModel.mid,@"mediaId",nil]];
    }
}

#pragma mark - RemoveMediaInterfaceDelegate
-(void)removeMediaByIdDidFinished:(NSString *)mediaId
{
    for (MediaModel *mediaModel in self.mediaList) {
        if ([mediaId isEqualToString:mediaModel.mid]) {
            [self.mediaList removeObject:mediaModel];
            for (UIView *view in self.mscrollView.subviews) {
                if ([view isMemberOfClass:[PhotoListCellView class]]) {
                    [view removeFromSuperview];
                }
            }
            
            self.mscrollView.contentSize = CGSizeMake(self.view.frame.size.width, 0);
            
            [self addPhoto:self.mediaList];
            
            break;
        }
    }
    
    self.mRemoveMediaInterface.delegate = nil;
    self.mRemoveMediaInterface = nil;
}

-(void)removeMediaByIdDidFailed:(NSString *)errorMsg
{
    self.mRemoveMediaInterface.delegate = nil;
    self.mRemoveMediaInterface = nil;
}
@end
