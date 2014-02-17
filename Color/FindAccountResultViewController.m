//
//  FindAccountResultViewController.m
//  QieZi
//
//  Created by hanchao on 14-2-17.
//
//

#import "FindAccountResultViewController.h"

@interface FindAccountResultViewController ()

@end

@implementation FindAccountResultViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    self.wbUserId = nil;
    self.accountName = nil;
    
    [super dealloc];
}

@end
