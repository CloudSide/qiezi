//
//  LoginViewController.m
//  Color
//
//  Created by chao han on 12-5-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisteViewController.h"

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

@end
