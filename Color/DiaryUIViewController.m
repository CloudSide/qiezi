//
//  DiaryUIViewController.m
//  Color
//
//  Created by chao han on 12-5-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "DiaryUIViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "DiarySectionView.h"
#import "DiaryHeaderCellView.h"
#import "DiaryItemCellView.h"
#import "FriendListInterface.h"
#import "UserModel.h"
#import "EGOImageView.h"
#import "EGORefreshTableHeaderView.h"
#import "MediaModel.h"
#import "HomePageViewController.h"
#import "AppDelegate.h"
#import "NSDate+DynamicDateString.h"
#import "MyAccountViewController.h"

@implementation DiaryUIViewController

@synthesize mtableView = _mtableView , mDiaryHeaderCellView = _mDiaryHeaderCellView 
 , mHistoryInterface = _mHistoryInterface , diaryList = _diaryList 
 , mFriendListInterface = _mFriendListInterface , friendList = _friendList
 , mHistoryInterfaceForPull = _mHistoryInterfaceForPull;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.friendList = [[[NSMutableArray alloc] init] autorelease];
        
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
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    self.friendList = nil;
    self.mtableView = nil;
    self.mDiaryHeaderCellView = nil;
    self.mHistoryInterface.delegate = nil;
    self.mHistoryInterface = nil;
    
    self.mFriendListInterface.delegate = nil;
    self.mFriendListInterface = nil;
    self.diaryList = nil;
    
    self.mHistoryInterfaceForPull.delegate = nil;
    self.mHistoryInterfaceForPull = nil;
    
    _refreshHeaderView = nil;
    
    [super dealloc];
}

#pragma notification 调用方法
-(void)updateName:(NSNotification *)notification{
    self.mDiaryHeaderCellView.nameLabel.text = [MySingleton sharedSingleton].name;
    
}

-(void)updateAvatar:(NSNotification *)notification{
    self.mDiaryHeaderCellView.headIconView.imageURL = [NSURL URLWithString:[MySingleton sharedSingleton].avatarUrl];
}

#pragma mark - View lifecycle
#pragma mark 初始化头像View
-(void)goMyAccountView:(UIGestureRecognizer *) sender
{
    MyAccountViewController *mavc = [[MyAccountViewController alloc] initWithNibName:@"MyAccountViewController" bundle:nil];
    [self.navigationController pushViewController:mavc animated:YES];
    [mavc release];
}

-(void)initDiaryHeaderCellView {
    NSArray *arr1 = [[NSBundle mainBundle] loadNibNamed:@"DiaryHeaderCellView" owner:self options:nil];  
    self.mDiaryHeaderCellView = [arr1 objectAtIndex:0];
    
    self.mDiaryHeaderCellView.headIconView.imageURL = [NSURL URLWithString:[MySingleton sharedSingleton].avatarUrl];
    CALayer *mask = [CALayer layer];
    mask.frame = self.mDiaryHeaderCellView.headIconView.frame;
    mask.contents = (id)[[UIImage imageNamed:@"my_avatar_mask.png"] CGImage];
    self.mDiaryHeaderCellView.headIconView.layer.mask = mask;
    self.mDiaryHeaderCellView.headIconView.layer.masksToBounds = YES;
    
    
    UITapGestureRecognizer *headerTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goMyAccountView:)];
    [headerTap setNumberOfTapsRequired:1];
    self.mDiaryHeaderCellView.headIconView.userInteractionEnabled = YES;
    [self.mDiaryHeaderCellView.headIconView addGestureRecognizer:headerTap];
    [headerTap release];
    
    self.mDiaryHeaderCellView.nameLabel.text = [MySingleton sharedSingleton].name;
    
    self.mDiaryHeaderCellView.friendScrollView.scrollsToTop = NO;
    
    self.mFriendListInterface = [[[FriendListInterface alloc] init] autorelease];
    self.mFriendListInterface.delegate = self;
    [self.mFriendListInterface getFriendList];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _hasMorePage = YES;
    
    self.diaryList = [[[NSMutableArray alloc] init] autorelease];
    
    UITableView *_table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 406) style:UITableViewStylePlain];
    _table.delegate = self;
    _table.dataSource = self;
    _table.separatorStyle = UITableViewCellSeparatorStyleNone;
    _table.scrollsToTop = YES;
    _table.userInteractionEnabled = YES;
    _table.multipleTouchEnabled = YES;
    
    [self initDiaryHeaderCellView];
    _table.tableHeaderView = self.mDiaryHeaderCellView;
    
    self.mtableView = _table;
    [_table release];
    
    
    self.mHistoryInterface = [[[HistoryInterface alloc] init] autorelease];
    self.mHistoryInterface.delegate = self;
    [self.mHistoryInterface getHistoryListByStartTime:0];
    _isGettingNextPage = YES;
    
    
    if (_refreshHeaderView == nil) {
		EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.mtableView.bounds.size.height, self.view.frame.size.width, self.mtableView.bounds.size.height)];
		view.delegate = self;
		[self.mtableView addSubview:view];
		_refreshHeaderView = view;
		[view release];
		
	}
    
    [self.view addSubview:self.mtableView];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(updateName:) 
                                                 name:@"name has changed" 
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(updateAvatar:) 
                                                 name:@"avatar has changed" 
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(removeMedia:) 
                                                 name:@"removeMedia" 
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


-(void)removeMedia:(NSNotification *)notification{
    NSString *mediaId = [notification.userInfo objectForKey:@"mediaId"];
    if (mediaId) {
        
        NSMutableArray *toDelete = [NSMutableArray array];

        for (NSDictionary *dict in self.diaryList) {
            NSMutableArray *mediaArray = [dict objectForKey:@"mediaArray"];
            for (MediaModel *media in mediaArray) {
                if ([mediaId isEqualToString:media.mid]) {
                    [mediaArray removeObject:media];
                    
                    if (mediaArray.count == 0) {
                        [toDelete addObject:dict];
                    }
                    
                    break;
                }
            }
        }
        
        if (toDelete) {
            [self.diaryList removeObjectsInArray:toDelete];
        }
        
        [self.mtableView reloadData];
    }
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

    
    if (_hasMorePage && !_isGettingNextPage && indexPath.section == [self.diaryList count] - 1) {
        _isGettingNextPage = YES;
        
        NSArray *mediaArray = [[self.diaryList lastObject] objectForKey:@"mediaArray"];
        MediaModel *mm = [mediaArray objectAtIndex:mediaArray.count - 1];
        
        self.mHistoryInterface = [[[HistoryInterface alloc] init] autorelease];
        self.mHistoryInterface.delegate = self;
        [self.mHistoryInterface getHistoryListByStartTime:mm.ctime.timeIntervalSince1970 - 1];
    }
    
    return cell;
    
}

#pragma mark - UITableViewDelegate method
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
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
-(void)getHistoryListDidFinished:(NSArray *)mediaArray{
    if ([mediaArray count] == 0) {
        _hasMorePage = NO;
    }else{
        [self.diaryList addObjectsFromArray:mediaArray];
        [self.mtableView reloadData];
    }
    
    self.mHistoryInterface.delegate = nil;
    self.mHistoryInterface = nil;
    
    _isGettingNextPage = NO;
}

-(void)getHistoryListDidFailed:(NSString *)errorMsg{
    
    UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:@"获取回忆列表失败" 
													   message:errorMsg 
													  delegate:nil
											 cancelButtonTitle:@"确定" 
											 otherButtonTitles:nil];
	[alertView show];
	[alertView release];
    
    self.mHistoryInterface.delegate = nil;
    self.mHistoryInterface = nil;
    
    _isGettingNextPage = NO;
}


-(void)insertDiaryListByDate:(NSArray *)mediaArray{
    NSInteger count = mediaArray.count;
    for (NSInteger i = count - 1 ; i >= 0 ; --i) {
        NSMutableDictionary *days = [mediaArray objectAtIndex:i];
        if (days) {
            NSDate *date = [days objectForKey:@"date"];
            
            BOOL foundedFlag = NO;
            for (NSMutableDictionary *oldDay in self.diaryList) {
                NSDate *dateInOldArray = [oldDay objectForKey:@"date"];
                
                if ([date isSameDay:dateInOldArray]) {
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


-(void)getHistoryListByTimeDidFinished:(NSArray *)mediaArray{
    if (mediaArray.count > 0) {
        [self insertDiaryListByDate:mediaArray];
        [self.mtableView reloadData];
    }
    
    self.mHistoryInterfaceForPull.delegate = nil;
    self.mHistoryInterfaceForPull = nil;
    
    [self doneLoadingTableViewData];
}

-(void)getHistoryListByTimeDidFailed:(NSString *)errorMsg{
    
    UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:@"获取回忆列表失败" 
													   message:errorMsg 
													  delegate:nil
											 cancelButtonTitle:@"确定" 
											 otherButtonTitles:nil];
	[alertView show];
	[alertView release];
    
    self.mHistoryInterfaceForPull.delegate = nil;
    self.mHistoryInterfaceForPull = nil;
    
    [self doneLoadingTableViewData];
}

#pragma mark - 朋友头像点击事件
-(void)goHomePage:(UIGestureRecognizer *) sender {
    NSInteger idx = sender.view.tag;
    if (idx < [self.friendList count]) {
        UserModel *user = [self.friendList objectAtIndex:idx];
        
        HomePageViewController *mHomePageViewController = [[HomePageViewController alloc] init];
        mHomePageViewController.userId = user.userId;
        AppDelegate *mainDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
        UINavigationController *currentController = (UINavigationController *)mainDelegate.tabBarController.selectedViewController;
        
        [currentController pushViewController:mHomePageViewController animated:YES];
        [mHomePageViewController release];
    }
}

#pragma mark - FriendListInterfaceDelegate 
-(void)getFriendListDidFinished:(NSArray *)friendArray{
    if (friendArray.count > 0) {
        self.friendList = [NSMutableArray arrayWithArray:friendArray];
        for (UIView *view in [self.mDiaryHeaderCellView.friendScrollView subviews]) {
            if ([view isMemberOfClass:[EGOImageView class]]) {
                [view removeFromSuperview];
            }
        }
        
        NSInteger i = 0;
        for (UserModel *user in self.friendList) {
            EGOImageView *icon = [[EGOImageView alloc] initWithPlaceholderImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"0" ofType:@"jpg"]]];
            icon.frame = CGRectMake(i*self.mDiaryHeaderCellView.friendScrollView.frame.size.height + i*1, 0, 
                                    self.mDiaryHeaderCellView.friendScrollView.frame.size.height, 
                                    self.mDiaryHeaderCellView.friendScrollView.frame.size.height);
            icon.imageURL = [NSURL URLWithString:user.avatarUrl];
            icon.userInteractionEnabled = YES;
            icon.tag = i;
            
            
            UITapGestureRecognizer *headerTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goHomePage:)];
            [headerTap setNumberOfTapsRequired:1];
            [icon addGestureRecognizer:headerTap];
            [headerTap release];
            
            [self.mDiaryHeaderCellView.friendScrollView addSubview:icon];
            
            [icon release];
            
            ++i;
        }
        self.mDiaryHeaderCellView.friendScrollView.contentSize = CGSizeMake([self.friendList count]*self.mDiaryHeaderCellView.friendScrollView.frame.size.height + ([self.friendList count]-1) * 1,
                                                                            self.mDiaryHeaderCellView.friendScrollView.frame.size.height);    
    }
    
    self.mFriendListInterface.delegate = nil;
    self.mFriendListInterface = nil;
}

-(void)getFriendListDidFailed:(NSString *)errorMsg{
    UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:@"获取朋友列表失败" 
													   message:errorMsg 
													  delegate:nil
											 cancelButtonTitle:@"确定" 
											 otherButtonTitles:nil];
	[alertView show];
	[alertView release];
    
    self.mFriendListInterface.delegate = nil;
    self.mFriendListInterface = nil;
}

#pragma mark -
#pragma mark Data Source Loading / Reloading Methods

- (void)reloadTableViewDataSource{
	
	//  should be calling your tableviews data source model to reload
	//  put here just for demo
	_reloading = YES;
    
    self.mHistoryInterfaceForPull = [[[HistoryInterface alloc] init] autorelease];
    self.mHistoryInterfaceForPull.delegate = self;
    NSTimeInterval time = 0;
    if ([self.diaryList count]>0) {
        NSArray *mediaArray = [[self.diaryList objectAtIndex:0] objectForKey:@"mediaArray"];
        MediaModel *mm = [mediaArray objectAtIndex:0];
        time = mm.ctime.timeIntervalSince1970 + 1;
    }
    
    [self.mHistoryInterfaceForPull getHistoryListByEndTime:time];
    
    
    self.mFriendListInterface = [[[FriendListInterface alloc] init] autorelease];
    self.mFriendListInterface.delegate = self;
    [self.mFriendListInterface getFriendList];
}


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
