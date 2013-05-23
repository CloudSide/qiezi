//
//  DynamicUIViewController.m
//  Color
//
//  Created by chao han on 12-5-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "DynamicCellView.h"

#import "PhotoListViewController.h"
#import "DynamicInterface.h"
#import "MediaModel.h"
#import "EGORefreshTableHeaderView.h"
#import "DynamicUIViewController.h"

@implementation DynamicUIViewController
@synthesize mtableView = _mtableView , mDynamicInterface = _mDynamicInterface 
 , dynamicList = _dynamicList , mDynamicInterfaceForPull = _mDynamicInterfaceForPull;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.dynamicList = [[[NSMutableArray alloc] init] autorelease];
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
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    self.mtableView = nil;
    self.mDynamicInterface.delegate = nil;
    self.mDynamicInterface = nil;
    self.dynamicList = nil;
    
    self.mDynamicInterfaceForPull.delegate = nil;
    self.mDynamicInterfaceForPull = nil;
    
    _refreshHeaderView = nil;
    
    [super dealloc];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _hasMorePage = YES;
    
    UITableView *_table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 406) style:UITableViewStylePlain];
    _table.delegate = self;
    _table.dataSource = self;
    _table.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.mtableView = _table;
    [_table release];
    
    [self.view addSubview:self.mtableView];
    
    
    if (_refreshHeaderView == nil) {
		
		EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.mtableView.bounds.size.height, self.view.frame.size.width, self.mtableView.bounds.size.height)];
		view.delegate = self;
		[self.mtableView addSubview:view];
		_refreshHeaderView = view;
		[view release];
		
	}
	
	//  update the last update date
	[_refreshHeaderView refreshLastUpdatedDate];
    
    self.mDynamicInterface = [[DynamicInterface alloc] init];
    self.mDynamicInterface.delegate = self;
    [self.mDynamicInterface getDynamicListByStartTime:0];
    _isGettingNextPage = YES;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
        
        for (NSDictionary *dict in self.dynamicList) {
            NSMutableArray *mediaArray = [dict objectForKey:@"picArray"];
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
            [self.dynamicList removeObjectsInArray:toDelete];
        }
        
        [self.mtableView reloadData];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.dynamicList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DynamicCellView *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {    
        NSArray *arr1 = [[NSBundle mainBundle] loadNibNamed:@"DynamicCellView" owner:self options:nil];  
        cell = [arr1 objectAtIndex:0];
    }
    
    NSDictionary *dynamic = [self.dynamicList objectAtIndex:indexPath.row];
    cell.dynamicDict = dynamic;
    
    
    if (_hasMorePage && !_isGettingNextPage && indexPath.row == [self.dynamicList count] - 1) {
        _isGettingNextPage = YES;
        NSDictionary *dynamic = [self.dynamicList lastObject];
        NSArray *picArray = [dynamic objectForKey:@"picArray"];
        MediaModel *mm = [picArray objectAtIndex:picArray.count - 1];
        
        self.mDynamicInterface = [[[DynamicInterface alloc] init] autorelease];
        self.mDynamicInterface.delegate = self;
        [self.mDynamicInterface getDynamicListByStartTime:[mm.ctime timeIntervalSince1970] -1];
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate method
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    PhotoListViewController *_photoListViewController = [[PhotoListViewController alloc] init];
    NSDictionary *dynamic = [self.dynamicList objectAtIndex:indexPath.row];
    NSArray *picArray = [dynamic objectForKey:@"picArray"];
    MediaModel *mm = [picArray objectAtIndex:0];
    _photoListViewController.circleId = mm.circleId;
    
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

#pragma mark - DynamicInterfaceDelegate <NSObject>
-(void)getDynamicListDidFinished:(NSArray *)mediaArray{
    if ([mediaArray count] == 0) {
        _hasMorePage = NO;
    }else{
        [self.dynamicList addObjectsFromArray:mediaArray];
        [self.mtableView reloadData];
    }
    
    self.mDynamicInterface.delegate = nil;
    self.mDynamicInterface = nil;
    
    _isGettingNextPage = NO;
}
-(void)getDynamicListDidFailed:(NSString *)errorMsg{
    UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:@"获取动态列表失败" 
													   message:errorMsg 
													  delegate:nil
											 cancelButtonTitle:@"确定" 
											 otherButtonTitles:nil];
	[alertView show];
	[alertView release];
    
    self.mDynamicInterface.delegate = nil;
    self.mDynamicInterface = nil;
    
    _isGettingNextPage = NO;
}


-(void)insertDynamicListByCircle:(NSArray *)mediaArray{
    NSInteger count = mediaArray.count;
    for (NSInteger i = count - 1 ; i >= 0 ; --i) {
        NSMutableDictionary *dict = [mediaArray objectAtIndex:i];
        if (dict) {
            NSString *cIdInNewArray = [dict objectForKey:@"circleId"];
            
            BOOL foundedFlag = NO;
            for (NSMutableDictionary *oldDict in self.dynamicList) {
                NSString *cIdInOldArray = [oldDict objectForKey:@"circleId"];
                
                if ([cIdInNewArray isEqualToString:cIdInOldArray]) {
                    [oldDict setObject:[dict objectForKey:@"userNames"] forKey:@"userNames"];
                    [oldDict setObject:[dict objectForKey:@"num"] forKey:@"num"];
                    [oldDict setObject:[dict objectForKey:@"date"] forKey:@"date"];
                    
                    NSMutableArray *picArray = [oldDict objectForKey:@"picArray"];
                    [picArray insertObjects:[dict objectForKey:@"picArray"]
                                          atIndexes:[NSMutableIndexSet indexSetWithIndexesInRange:NSMakeRange(0, [[dict objectForKey:@"picArray"] count])]];
                    
                    foundedFlag = YES;
                    break;
                }
            }
            
            if (!foundedFlag) {
                [self.dynamicList insertObject:dict atIndex:0];
            }
        }
    }
}


-(void)getDynamicListByTimeDidFinished:(NSArray *)mediaArray{
    if (mediaArray.count > 0) {
        [self insertDynamicListByCircle:mediaArray];
        [self.mtableView reloadData];
    }
    
    self.mDynamicInterfaceForPull.delegate = nil;
    self.mDynamicInterfaceForPull = nil;
    
    [self doneLoadingTableViewData];

}

-(void)getDynamicListByTimeDidFailed:(NSString *)errorMsg{
    UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:@"刷新动态列表失败" 
													   message:errorMsg 
													  delegate:nil
											 cancelButtonTitle:@"确定" 
											 otherButtonTitles:nil];
	[alertView show];
	[alertView release];
    
    self.mDynamicInterfaceForPull.delegate = nil;
    self.mDynamicInterfaceForPull = nil;
    
    [self doneLoadingTableViewData];
}


#pragma mark -
#pragma mark Data Source Loading / Reloading Methods

- (void)reloadTableViewDataSource{
	
	//  should be calling your tableviews data source model to reload
	//  put here just for demo
	_reloading = YES;
    
    self.mDynamicInterfaceForPull = [[[DynamicInterface alloc] init] autorelease];
    self.mDynamicInterfaceForPull.delegate = self;

    NSTimeInterval time = 0;
    if ([self.dynamicList count]>0) {
        NSDictionary *dynamic = [self.dynamicList objectAtIndex:0];
        NSArray *picArray = [dynamic objectForKey:@"picArray"];
        MediaModel *mm = [picArray objectAtIndex:0];
        time = mm.ctime.timeIntervalSince1970 + 1;
    }
    
    [self.mDynamicInterfaceForPull getDynamicListByEndTime:time];
	
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
