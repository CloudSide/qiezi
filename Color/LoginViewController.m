//
//  LoginViewController.m
//  Color
//
//  Created by chao han on 12-5-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisteViewController.h" 
#import "FindAccountViewController.h"

@implementation LoginViewController

@synthesize dateLabel = _dateLabel , monthYearLabel = _monthYearLabel
, weekLable = _weekLable;

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

-(void)dealloc{
    self.dateLabel = nil;
    self.weekLable = nil;
    self.monthYearLabel = nil;
    
    [super dealloc];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    NSDate *date = [NSDate date];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];     
    
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit |     
    NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;    
    
    NSDateComponents *comps = [calendar components:unitFlags fromDate:date];    
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
    
    
    self.dateLabel.text = [NSString stringWithFormat:@"%d",[comps day]];
    self.monthYearLabel.text = [NSString stringWithFormat:@"%d月.'%02d",[comps month],[comps year]];
    self.weekLable.text = weekDay;
    
    [self.findAccountImg setUserInteractionEnabled:YES];
    UITapGestureRecognizer *tap = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(findAccountAction:)] autorelease];
    [self.findAccountImg addGestureRecognizer:tap];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wbAuthorizeResult:) name:@"WBAuthorizeResponse" object:nil];
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

#pragma mark - button action
-(IBAction)startAction:(id)sender {
    RegisteViewController *mRegisteViewController = [[RegisteViewController alloc] initWithNibName:@"RegisteViewController" bundle:nil];
    [self.navigationController pushViewController:mRegisteViewController animated:YES];
    [mRegisteViewController release];
}

-(void)findAccountAction:(id)sender
{
    //微博登录
    WBAuthorizeRequest *request = [WBAuthorizeRequest request];
    request.redirectURI = kRedirectURI;
    request.scope = @"all";
    request.userInfo = @{@"SSO_From": @"LoginViewController",
//                         @"Other_Info_1": [NSNumber numberWithInt:123],
//                         @"Other_Info_2": @[@"obj1", @"obj2"],
//                         @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}
                         };
    [WeiboSDK sendRequest:request];
}


#pragma mark - NSNotification selector
-(void)wbAuthorizeResult:(NSNotification*) aNotification
{
    NSDictionary *userInfo = [aNotification object];
    
    NSString *result = [userInfo objectForKey:@"result"];
    if ([result isEqualToString:@"succeed"]) {
        //TODO:授权成功
        NSString *wbUserId = [userInfo objectForKey:@"wbUserId"];
        NSLog(@"==========授权成功=======%@",wbUserId);
        
        FindAccountViewController *mFindAccountViewController = [[FindAccountViewController alloc] initWithNibName:@"FindAccountViewController" bundle:nil];
        mFindAccountViewController.wbUserId = wbUserId;
        [self.navigationController pushViewController:mFindAccountViewController animated:YES];
        [mFindAccountViewController release];
    }
}

@end
