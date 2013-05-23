//
//  RegisteViewController.m
//  Color
//
//  Created by chao han on 12-5-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "RegisteViewController.h"
#import "RegistePhotoViewcontroller.h"

@implementation RegisteViewController

@synthesize nameLabel = _nameLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        self.nameLabel.delegate = self;
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
    self.nameLabel = nil;
    
    
    [super dealloc];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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

-(IBAction)nextAction:(id)sender{
    if (self.nameLabel.text.length == 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"请输入昵称"
                                                            message:nil
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
        [alertView show];
        [alertView release];
    }else{
        RegistePhotoViewcontroller *mRegistePhotoViewcontroller = [[RegistePhotoViewcontroller alloc] initWithNibName:@"RegistePhotoViewcontroller" 
                                                                                                               bundle:nil];
        mRegistePhotoViewcontroller.firstName = self.nameLabel.text;
        [self.navigationController pushViewController:mRegistePhotoViewcontroller animated:YES];
        
        [mRegistePhotoViewcontroller release];
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
    CGRect frame = self.view.frame;          
    frame.origin.y -= 100;
    [UIView beginAnimations:@"Curl"context:nil];//动画开始            
    [UIView setAnimationDuration:0.30];             
    [UIView setAnimationDelegate:self];            
    [self.view setFrame:frame];           
    [UIView commitAnimations];  
}  

@end
