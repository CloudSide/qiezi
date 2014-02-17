//
//  FindAccountViewController.m
//  QieZi
//
//  Created by hanchao on 14-2-17.
//
//

#import "FindAccountViewController.h"
#import "FindAccountResultViewController.h"

@interface FindAccountViewController ()

@end

@implementation FindAccountViewController

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
    self.nameLabel = nil;
    self.wbUserId = nil;
    
    [super dealloc];
}

-(IBAction)findAccountAction:(id)sender
{
    if (self.nameLabel.text.length == 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"请输入昵称"
                                                            message:nil
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
        [alertView show];
        [alertView release];
    }else{
        FindAccountResultViewController *mFindAccountResultViewController = [[FindAccountResultViewController alloc] initWithNibName:@"FindAccountResultViewController"
                                                                                                               bundle:nil];
        mFindAccountResultViewController.accountName = self.nameLabel.text;
        mFindAccountResultViewController.wbUserId = self.wbUserId;
        [self.navigationController pushViewController:mFindAccountResultViewController animated:YES];
        
        [FindAccountResultViewController release];
    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    // When the user presses return, take focus away from the text field so that the keyboard is dismissed.
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    
    CGRect frame = self.view.frame;
    frame.origin.y += 100;
    self.view.frame = frame;
    
    [UIView commitAnimations];
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    //键盘输入的界面调整
    CGRect frame = self.view.frame;
    frame.origin.y -= 100;
    [UIView beginAnimations:@"Curl"context:nil];//动画开始
    [UIView setAnimationDuration:0.30];
    [UIView setAnimationDelegate:self];
    [self.view setFrame:frame];
    [UIView commitAnimations];
}


@end
