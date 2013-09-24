//
//  HomePageViewController.m
//  Color
//
//  Created by chao han on 12-6-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "HomePageViewController.h"
#import "DiarySectionView.h"
#import "DiaryHeaderCellView.h"
#import "DiaryItemCellView.h"
#import "FriendListInterface.h"
#import "UserModel.h"
#import "EGOImageView.h"
#import "EGORefreshTableHeaderView.h"
#import "MediaModel.h"
#import "TabBarShareView.h"
#import "CustomTabBarController.h"

@implementation HomePageViewController

@synthesize mtableView = _mtableView , mDiaryHeaderCellView = _mDiaryHeaderCellView 
, mMediaByUserIdInterface = _mMediaByUserIdInterface , diaryList = _diaryList 
, mMediaByUserIdInterfaceForPull = _mMediaByUserIdInterfaceForPull 
, userId = _userId , tabBarView = _tabBarView , mGetUserInfoInterface = _mGetUserInfoInterface;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        _hasMorePage = YES;
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
    self.mDiaryHeaderCellView = nil;
    self.mMediaByUserIdInterface.delegate = nil;
    self.mMediaByUserIdInterface = nil;
    
    self.diaryList = nil;
    
    self.mMediaByUserIdInterfaceForPull.delegate = nil;
    self.mMediaByUserIdInterfaceForPull = nil;
    
    _refreshHeaderView = nil;
    
    self.mGetUserInfoInterface.delegate = nil;
    self.mGetUserInfoInterface = nil;
    
    [super dealloc];
}

#pragma mark - View lifecycle
#pragma mark 初始化头像View
-(void)initDiaryHeaderCellView {
    NSArray *arr1 = [[NSBundle mainBundle] loadNibNamed:@"DiaryHeaderCellView" owner:self options:nil];  
    self.mDiaryHeaderCellView = [arr1 objectAtIndex:0];
    
//    self.mDiaryHeaderCellView.headIconView.imageURL = [NSURL URLWithString:[MySingleton sharedSingleton].avatarUrl];//设置头像
    CALayer *mask = [CALayer layer];
    mask.frame = self.mDiaryHeaderCellView.headIconView.frame;
    mask.contents = (id)[[UIImage imageNamed:@"my_avatar_mask.png"] CGImage];
    self.mDiaryHeaderCellView.headIconView.layer.mask = mask;
    self.mDiaryHeaderCellView.headIconView.layer.masksToBounds = YES;
    
    
//    self.mDiaryHeaderCellView.nameLabel.text = [MySingleton sharedSingleton].name;
    
    self.mDiaryHeaderCellView.friendScrollView.scrollsToTop = NO;
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _hasMorePage = YES;
    
    //处理tab bar
    mCustomTabBarController = (CustomTabBarController *)self.tabBarController;
    
    NSArray *arr1 = [[NSBundle mainBundle] loadNibNamed:@"TabBarShareView" owner:self options:nil];  
    self.tabBarView = (TabBarShareView*)[arr1 objectAtIndex:0];
    [self.tabBarView.backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [self.tabBarView.homeBtn addTarget:self action:@selector(homeAction) forControlEvents:UIControlEventTouchUpInside];
    
    [mCustomTabBarController pushTabBar:self.tabBarView];
    
    
    self.diaryList = [[[NSMutableArray alloc] init] autorelease];//回忆列表
    
    UITableView *_table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.bounds.size.height-54) style:UITableViewStylePlain];
    _table.delegate = self;
    _table.dataSource = self;
    _table.separatorStyle = UITableViewCellSeparatorStyleNone;
    _table.scrollsToTop = YES;
    _table.userInteractionEnabled = YES;
    _table.multipleTouchEnabled = YES;
    
#ifdef __IPHONE_7_0
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1) {
        _table.frame = CGRectMake(0, 20, 320, self.view.bounds.size.height-54-20);
        [_table setContentInset:UIEdgeInsetsMake(-20, 0, 0, 0)];
    }
#endif
    
    [self initDiaryHeaderCellView];//初始化头像View
    _table.tableHeaderView = self.mDiaryHeaderCellView;
    
    self.mtableView = _table;
    [_table release];
    
    //获取历史列表
    self.mMediaByUserIdInterface = [[[MediaByUserIdInterface alloc] init] autorelease];
    self.mMediaByUserIdInterface.delegate = self;
    [self.mMediaByUserIdInterface getMediaByUserIdListByStartTime:0 userId:self.userId];
    _isGettingNextPage = YES;
    
    //下拉刷新
    if (_refreshHeaderView == nil) {
		EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.mtableView.bounds.size.height, self.view.frame.size.width, self.mtableView.bounds.size.height)];
		view.delegate = self;
		[self.mtableView addSubview:view];
		_refreshHeaderView = view;
		[view release];
		
	}
    
    [self.view addSubview:self.mtableView];
    
    //获取用户信息
    self.mGetUserInfoInterface = [[[GetUserInfoInterface alloc] init] autorelease];
    self.mGetUserInfoInterface.delegate = self;
    [self.mGetUserInfoInterface getUserInfoByUserId:self.userId];
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

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [self.diaryList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DiaryItemCellView *cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"cell",[indexPath section],[indexPath row]]];
    if (cell == nil) {    
        cell = [[[DiaryItemCellView alloc] initWithStyle:UITableViewCellStyleDefault
                                         reuseIdentifier:[NSString stringWithFormat:@"cell",[indexPath section],[indexPath row]]] autorelease];
    }
    
    cell.mediaArray = [[self.diaryList objectAtIndex:[indexPath section]] objectForKey:@"mediaArray"];
    
    //获取下一页
    if (_hasMorePage && !_isGettingNextPage && indexPath.row == [self.diaryList count] - 1) {
        _isGettingNextPage = YES;
        
        NSArray *mediaArray = [[self.diaryList lastObject] objectForKey:@"mediaArray"];
        MediaModel *mm = [mediaArray objectAtIndex:mediaArray.count - 1];//照片
        
        self.mMediaByUserIdInterface = [[[MediaByUserIdInterface alloc] init] autorelease];
        self.mMediaByUserIdInterface.delegate = self;
        [self.mMediaByUserIdInterface getMediaByUserIdListByStartTime:mm.ctime.timeIntervalSince1970 - 1 userId:self.userId];
    }
    
    return cell;
    
}

#pragma mark - UITableViewDelegate method
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //当前section的照片数量
    NSInteger count = [[[self.diaryList objectAtIndex:[indexPath section]] objectForKey:@"mediaArray"] count];
    
    CGFloat rowHeight = 80;
    
    if (count <= 7) {
        rowHeight = 80;
    }else if (count <= 11){
        rowHeight = 2 * 80;
    }else {
        rowHeight = 3 * 80;
    }
    
    return rowHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 35;
}

//返回table header
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    NSArray *arr1 = [[NSBundle mainBundle] loadNibNamed:@"DiarySectionView" owner:self options:nil];  
    DiarySectionView *mDiarySectionView = [arr1 objectAtIndex:0];
    
    NSDate *sectionDate = [[self.diaryList objectAtIndex:section] objectForKey:@"date"];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];     
    
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit |     
    NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;    
    
    NSDateComponents *comps = [calendar components:unitFlags fromDate:sectionDate];    
    [calendar release];
    NSString *weekDay = @"";
    switch ([comps weekday])   
    {   
        case 1:   
            weekDay=@"星期日";   
            break;   
        case 2:   
            weekDay=@"星期一";   
            break;   
        case 3:   
            weekDay=@"星期二";   
            break;   
        case 4:   
            weekDay=@"星期三";   
            break;   
        case 5:   
            weekDay=@"星期四";   
            break;   
        case 6:   
            weekDay=@"星期五";   
            break;   
        case 7:   
            weekDay=@"星期六";   
            break;   
    }  
    
    
    mDiarySectionView.dateLabel.text = [NSString stringWithFormat:@"%d",[comps day]];
    mDiarySectionView.monthYearLabel.text = [NSString stringWithFormat:@"%d月.'%02d",[comps month],[comps year]];
    mDiarySectionView.weekLabel.text = weekDay;
    
    return mDiarySectionView;
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
-(void)getMediaByUserIdListDidFinished:(NSArray *)mediaArray
{
    if ([mediaArray count] == 0) {
        _hasMorePage = NO;
    }else{
        [self.diaryList addObjectsFromArray:mediaArray];
        [self.mtableView reloadData];
    }
    
    self.mMediaByUserIdInterface.delegate = nil;
    self.mMediaByUserIdInterface = nil;
    
    _isGettingNextPage = NO;
}

-(void)getMediaByUserIdListDidFailed:(NSString *)errorMsg
{
    //TODO 获取回忆列表失败
    UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:@"获取回忆列表失败" 
													   message:errorMsg 
													  delegate:nil
											 cancelButtonTitle:@"确定" 
											 otherButtonTitles:nil];
	[alertView show];
	[alertView release];
    
    self.mMediaByUserIdInterface.delegate = nil;
    self.mMediaByUserIdInterface = nil;
    
    _isGettingNextPage = NO;
}


//根据圈子添加历史列表--用于下拉刷新
-(void)insertDiaryListByDate:(NSArray *)mediaArray{
    NSInteger count = mediaArray.count;
    for (NSInteger i = count - 1 ; i >= 0 ; --i) {
        NSMutableDictionary *days = [mediaArray objectAtIndex:i];
        if (days) {
            NSDate *date = [days objectForKey:@"date"];//返回的时间
            
            BOOL foundedFlag = NO;//是否找到对应时间标志
            for (NSMutableDictionary *oldDay in self.diaryList) {
                NSDate *dateInOldArray = [oldDay objectForKey:@"date"];//已有集合的时间
                
                if ([date isSameDay:dateInOldArray]) {//找到相同时间
                    NSMutableArray *picArray = [oldDay objectForKey:@"mediaArray"];
                    [picArray insertObjects:[days objectForKey:@"mediaArray"]
                                  atIndexes:[NSMutableIndexSet indexSetWithIndexesInRange:NSMakeRange(0, [[days objectForKey:@"mediaArray"] count])]];
                    
                    foundedFlag = YES;
                    break;
                }
            }
            
            if (!foundedFlag) {
                [self.diaryList insertObject:days atIndex:0];
            }
        }
    }
}

//用于下拉刷新的delegate
-(void)getMediaByUserIdListByTimeDidFinished:(NSArray *)mediaArray
{
    if (mediaArray.count > 0) {
        [self insertDiaryListByDate:mediaArray];
        [self.mtableView reloadData];
    }
    
    self.mMediaByUserIdInterface.delegate = nil;
    self.mMediaByUserIdInterface = nil;
    
    [self doneLoadingTableViewData];
}

-(void)getMediaByUserIdListByTimeDidFailed:(NSString *)errorMsg
{
    //TODO 获取回忆列表失败
    UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:@"获取回忆列表失败" 
													   message:errorMsg 
													  delegate:nil
											 cancelButtonTitle:@"确定" 
											 otherButtonTitles:nil];
	[alertView show];
	[alertView release];
    
    self.mMediaByUserIdInterfaceForPull.delegate = nil;
    self.mMediaByUserIdInterfaceForPull = nil;
    
    [self doneLoadingTableViewData];
}

#pragma mark -
#pragma mark Data Source Loading / Reloading Methods
//下拉刷新
- (void)reloadTableViewDataSource{
	
	//  should be calling your tableviews data source model to reload
	//  put here just for demo
	_reloading = YES;
    
    self.mMediaByUserIdInterfaceForPull = [[[MediaByUserIdInterface alloc] init] autorelease];
    self.mMediaByUserIdInterfaceForPull.delegate = self;
    NSTimeInterval time = 0;
    if ([self.diaryList count]>0) {
        NSArray *mediaArray = [[self.diaryList objectAtIndex:0] objectForKey:@"mediaArray"];
        MediaModel *mm = [mediaArray objectAtIndex:0];//照片
        time = mm.ctime.timeIntervalSince1970 + 1;
    }
    
    [self.mMediaByUserIdInterfaceForPull getMediaByUserIdListByEndTime:time userId:self.userId];
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

#pragma mark - TabBar button action
-(void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
    
    //移除当前tabbar
    [mCustomTabBarController popTabBar];//移除当前tabbar
}

-(void)homeAction{
    [self.navigationController popToRootViewControllerAnimated:YES];
    
    //    CustomTabBarController *mCustomTabBarController = (CustomTabBarController *)self.tabBarController;
    //移除当前tabbar
    [mCustomTabBarController popToRootTabBar];//移除当前tabbar
    
}

- (void)animationDidStop:(NSString *) animationID finished:(NSNumber *) finished context:(void *) context {
	[self.tabBarView removeFromSuperview];
}

#pragma mark - GetUserInfoInterfaceDelegate 
-(void)getUserInfoByUserIdDidFinished:(UserModel *)userModel{
    self.mDiaryHeaderCellView.headIconView.imageURL = [NSURL URLWithString:userModel.avatarUrl];
    self.mDiaryHeaderCellView.nameLabel.text = userModel.name;
    
    self.mGetUserInfoInterface.delegate = nil;
    self.mGetUserInfoInterface = nil;
}
-(void)getUserInfoByUserIdDidFailed:(NSString *)errorMsg{
    //TODO 获取回忆列表失败
    UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:@"获取回忆列表失败" 
													   message:errorMsg 
													  delegate:nil
											 cancelButtonTitle:@"确定" 
											 otherButtonTitles:nil];
	[alertView show];
	[alertView release];
    
    self.mGetUserInfoInterface.delegate = nil;
    self.mGetUserInfoInterface = nil;
}

//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//        // Custom initialization
//    }
//    return self;
//}
//
//- (void)didReceiveMemoryWarning
//{
//    // Releases the view if it doesn't have a superview.
//    [super didReceiveMemoryWarning];
//    
//    // Release any cached data, images, etc that aren't in use.
//}
//
//#pragma mark - View lifecycle
//
///*
//// Implement loadView to create a view hierarchy programmatically, without using a nib.
//- (void)loadView
//{
//}
//*/
//
///*
//// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
//- (void)viewDidLoad
//{
//    [super viewDidLoad];
//}
//*/
//
//- (void)viewDidUnload
//{
//    [super viewDidUnload];
//    // Release any retained subviews of the main view.
//    // e.g. self.myOutlet = nil;
//}
//
//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
//{
//    // Return YES for supported orientations
//    return (interfaceOrientation == UIInterfaceOrientationPortrait);
//}

@end
