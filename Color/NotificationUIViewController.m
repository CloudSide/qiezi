//
//  NotificationUIViewController.m
//  Color
//
//  Created by chao han on 12-5-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "NotificationUIViewController.h"
#import "NotificationCellView.h"
#import "AllCommentListInterface.h"
#import "CommentModel.h"
#import "EGOImageView.h"
#import "NSDate+DynamicDateString.h"
#import "PhotoListViewController.h"
#import "UILabel+VerticalAlign.h"
#import "HomePageViewController.h"
#import "MediaCommentListViewControll.h"

@implementation NotificationUIViewController

@synthesize mtableView = _mtableView , mAllCommentListInterface = _mAllCommentListInterface
 , commentList = _commentList , mAllCommentListInterfaceForPull = _mAllCommentListInterfaceForPull;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.commentList = [[[NSMutableArray alloc] init] autorelease];
        
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

-(void)dealloc {
    self.mtableView = nil;
    self.commentList = nil;
    self.mAllCommentListInterface.delegate = nil;
    self.mAllCommentListInterface = nil;
    
    self.mAllCommentListInterfaceForPull.delegate = nil;
    self.mAllCommentListInterfaceForPull = nil;
    
    [super dealloc];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _hasMorePage = YES;
    _needAutoRefreshFlag = NO;
    
    UITableView *_table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.bounds.size.height-54) style:UITableViewStylePlain];
    _table.delegate = self;
    _table.dataSource = self;
    
#ifdef __IPHONE_7_0
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1) {
        _table.frame = CGRectMake(0, 20, 320, self.view.bounds.size.height-54-20);
        [_table setContentInset:UIEdgeInsetsMake(-20, 0, 0, 0)];
    }
#endif
    
    self.mtableView = _table;
    [_table release];
    
    [self.view addSubview:self.mtableView];
    
    self.mAllCommentListInterface = [[[AllCommentListInterface alloc] init] autorelease];
    self.mAllCommentListInterface.delegate = self;
    [self.mAllCommentListInterface getAllCommentListByStartTime:0];
    _isGettingNextPage = YES;
    
    //下拉刷新
    if (_refreshHeaderView == nil) {
		EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f,
                                                                                                      0.0f - self.mtableView.bounds.size.height, 
                                                                                                      self.view.frame.size.width, 
                                                                                                      self.mtableView.bounds.size.height)];
		view.delegate = self;
		[self.mtableView addSubview:view];
		_refreshHeaderView = view;
		[view release];
	}

}

- (void)viewDidAppear:(BOOL)animated
{
    _needAutoRefreshFlag = YES;//修改自动刷新标识
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //TODO 调用下拉刷新接口，更新评论列表
    if (_needAutoRefreshFlag) {
        [self.mtableView setContentOffset:CGPointMake(0, -66) animated:NO];
        [_refreshHeaderView egoRefreshScrollViewDidEndDragging:self.mtableView];
    }
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

#pragma mark - 朋友头像点击事件
-(void)goHomePage:(UIGestureRecognizer *) sender {
    NSInteger idx = sender.view.tag;
    if (idx < [self.commentList count]) {
        CommentModel *cm = [self.commentList objectAtIndex:idx];
        UserModel *user = cm.owner;
        
        HomePageViewController *mHomePageViewController = [[HomePageViewController alloc] init];
        mHomePageViewController.userId = user.userId;
        
        [self.navigationController pushViewController:mHomePageViewController animated:YES];
        [mHomePageViewController release];
    }
}

-(void)goCommentList:(UIGestureRecognizer *) sender 
{
    NSInteger idx = sender.view.tag;
    if (idx < [self.commentList count]) {
        CommentModel *cm = [self.commentList objectAtIndex:idx];
        
        MediaCommentListViewControll *mclvc = [[MediaCommentListViewControll alloc]initWithNibName:@"MediaCommentListViewControll" bundle:nil];
        MediaModel *mm = [[MediaModel alloc] init];
        mm.owner = cm.owner;
        mm.mid = cm.mediaId;
        mm.originalUrl = cm.thumbnailUrl;
        mm.ctime = cm.ctime;
        mclvc.media = mm;
        [mm release];
        
        [self.navigationController pushViewController:mclvc animated:YES];
        [mclvc release];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.commentList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NotificationCellView *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {    
        NSArray *arr1 = [[NSBundle mainBundle] loadNibNamed:@"NotificationCellView" owner:self options:nil];  
        cell = [arr1 objectAtIndex:0];
    }
    
    CommentModel *cm = [self.commentList objectAtIndex:indexPath.row];
    cell.avatarImageView.imageURL = [NSURL URLWithString:cm.owner.avatarUrl];
    cell.avatarImageView.userInteractionEnabled = YES;
    cell.avatarImageView.tag = indexPath.row;
    //朋友头像点击事件
    UITapGestureRecognizer *headerTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goHomePage:)];
    [headerTap setNumberOfTapsRequired:1];
    [cell.avatarImageView addGestureRecognizer:headerTap];
    [headerTap release];
    
    cell.thumbnailImageView.imageURL = [NSURL URLWithString:cm.thumbnailUrl];
    cell.thumbnailImageView.userInteractionEnabled = YES;
    cell.thumbnailImageView.tag = indexPath.row;
    //photo点击事件
    UITapGestureRecognizer *photoTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goCommentList:)];
    [photoTap setNumberOfTapsRequired:1];
    [cell.thumbnailImageView addGestureRecognizer:photoTap];
    [photoTap release];
    
    if (cm.content.length > 0) {
        cell.contentLabel.text = [NSString stringWithFormat:@"%@回应了您的照片。「%@」%@" , cm.owner.name , cm.content,[cm.ctime getDynamicDateStringFromNow]];
    }else{
        cell.contentLabel.text = [NSString stringWithFormat:@"%@喜欢您的照片。%@" , cm.owner.name ,[cm.ctime getDynamicDateStringFromNow]];
    }
    [cell.contentLabel alignTop];
    
    return cell;

}

#pragma mark - UITableViewDelegate method
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CommentModel *cm = [self.commentList objectAtIndex:indexPath.row];
    
    PhotoListViewController *_photoListViewController = [[PhotoListViewController alloc] init];
    _photoListViewController.circleId = cm.circleId;
    _photoListViewController.mediaId = cm.mediaId;
    
    [self.navigationController pushViewController:_photoListViewController animated:YES];
    [_photoListViewController release];
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{	
	[_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	[_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
}


#pragma mark - AllCommentListInterfaceDelegate
-(void)getAllCommentListDidFinished:(NSArray *)mediaArray{
    if ([mediaArray count] == 0) {
        _hasMorePage = NO;
    }else{
        [self.commentList addObjectsFromArray:mediaArray];
        [self.mtableView reloadData];
    }
    
    self.mAllCommentListInterface.delegate = nil;
    self.mAllCommentListInterface = nil;
    
    _isGettingNextPage = NO;
}

-(void)getAllCommentListDidFailed:(NSString *)errorMsg{
    UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:@"获取评论列表失败" 
													   message:errorMsg 
													  delegate:nil
											 cancelButtonTitle:@"确定" 
											 otherButtonTitles:nil];
	[alertView show];
	[alertView release];
    
    self.mAllCommentListInterface.delegate = nil;
    self.mAllCommentListInterface = nil;

}

//用于下拉刷新的delegate
-(void)getAllCommentListByTimeDidFinished:(NSArray *)mediaArray;
{
    if (mediaArray.count > 0) {
        [self.commentList insertObjects:mediaArray
                              atIndexes:[NSMutableIndexSet indexSetWithIndexesInRange:NSMakeRange(0, [mediaArray count])]];

        [self.mtableView reloadData];
    }
    
    self.mAllCommentListInterfaceForPull.delegate = nil;
    self.mAllCommentListInterfaceForPull = nil;
    
    [self doneLoadingTableViewData];
}

-(void)getAllCommentListByTimeDidFailed:(NSString *)errorMsg{
    //TODO 获取回忆列表失败
    UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:@"获取评论列表失败" 
													   message:errorMsg 
													  delegate:nil
											 cancelButtonTitle:@"确定" 
											 otherButtonTitles:nil];
	[alertView show];
	[alertView release];
    
    self.mAllCommentListInterfaceForPull.delegate = nil;
    self.mAllCommentListInterfaceForPull = nil;
    
    [self doneLoadingTableViewData];
}

#pragma mark -
#pragma mark Data Source Loading / Reloading Methods
//下拉刷新
- (void)reloadTableViewDataSource{
	
	//  should be calling your tableviews data source model to reload
	//  put here just for demo
	_reloading = YES;
    
    self.mAllCommentListInterfaceForPull = [[[AllCommentListInterface alloc] init] autorelease];
    self.mAllCommentListInterfaceForPull.delegate = self;
    NSTimeInterval time = 0;
    if ([self.commentList count]>0) {
        CommentModel *cm = [self.commentList objectAtIndex:0];//评论
        time = cm.ctime.timeIntervalSince1970 + 1;
    }
    
    [self.mAllCommentListInterfaceForPull getAllCommentListByEndTime:time];
}

//刷新完成后通知下拉刷新view
- (void)doneLoadingTableViewData{
	
	//  model should call this when its done loading
	_reloading = NO;
	[_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.mtableView];
	
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
