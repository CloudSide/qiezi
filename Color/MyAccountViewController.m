//
//  MyAccountViewController.m
//  Color
//
//  Created by chao han on 12-6-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MyAccountViewController.h"

@implementation MyAccountViewController
@synthesize avatarImageView = _avatarImageView , nameTextField = _nameTextField
, telTextField = _telTextField , mscrollView = _mscrollView
, mChangeAccountAvatarInterface = _mChangeAccountAvatarInterface
, picker = _picker , mChangeAccountInfoInterface = _mChangeAccountInfoInterface
, navigationBar = _navigationBar;

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

-(void)cancelAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)updateAccount
{
    ((UINavigationItem *)[self.navigationBar.items objectAtIndex:0]).rightBarButtonItem.enabled = NO;
    
    self.mChangeAccountInfoInterface = [[ChangeAccountInfoInterface alloc] init];
    self.mChangeAccountInfoInterface.delegate = self;
    [self.mChangeAccountInfoInterface changeAccountInfo:self.nameTextField.text tel:self.telTextField.text];
}

//拍摄头像
-(void) takePhotoAction:(id) sender
{
    [self takePhoto];
}

#pragma mark - camera method
-(void)takePhoto{
    UIImagePickerControllerSourceType sourceType=UIImagePickerControllerSourceTypeCamera;
    
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
        
    }
    
    UIImagePickerController * picker = [[UIImagePickerController alloc]init];
    
    picker.delegate = self;
    picker.sourceType=sourceType;
    picker.videoMaximumDuration = 10;
    picker.allowsEditing = YES;
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        picker.cameraDevice = UIImagePickerControllerCameraDeviceFront;
    }
    
    NSArray *temp_MediaTypes = [UIImagePickerController availableMediaTypesForSourceType:picker.sourceType];
    picker.mediaTypes = temp_MediaTypes;
    
    self.picker = picker;
    [picker release];
    
    [self presentModalViewController:self.picker animated:YES];
    
}

-(void)saveImage:(UIImage*)image
{
    self.avatarImageView.image = image;
    
    self.mChangeAccountAvatarInterface = [[ChangeAccountAvatarInterface alloc] init];
    self.mChangeAccountAvatarInterface.delegate = self;
    [self.mChangeAccountAvatarInterface changeMyAvatar:image];
}

#pragma mark - UIImagePickerControllerDelegate
-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissModalViewControllerAnimated:YES];
    
    UIImage * image=[info objectForKey:UIImagePickerControllerEditedImage];
    
    [self performSelector:@selector(saveImage:) withObject:image afterDelay:0.5];
}

-(void)imagePickerControllerDIdCancel:(UIImagePickerController*)picker
{
    [picker dismissModalViewControllerAnimated:YES];
}

-(IBAction) slideFrameUp:(id) sender
{
    [self.mscrollView setContentOffset:CGPointMake(0.0, 50.0)];
}

-(IBAction) slideFrameDown:(id) sender
{
    [self.mscrollView setContentOffset:CGPointMake(0.0, 0.0)];
    [self.nameTextField resignFirstResponder];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return NO;
}

#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 44.0)];
    [self.navigationBar setBarStyle:UIBarStyleBlack];
    
    UINavigationItem *aNavigationItem = [[UINavigationItem alloc] init];
    [aNavigationItem setLeftBarButtonItem:[[[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelAction)] autorelease]];
    [aNavigationItem setRightBarButtonItem:[[[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(updateAccount)] autorelease]];
    
    [self.navigationBar setItems:[NSArray arrayWithObject:aNavigationItem]];
    
    [aNavigationItem release];
    
    [[self view] addSubview:self.navigationBar];
    
    self.avatarImageView.imageURL = [NSURL URLWithString:[MySingleton sharedSingleton].avatarUrl];
    self.nameTextField.text = [MySingleton sharedSingleton].name;
    
    self.mscrollView.contentSize = self.mscrollView.frame.size;
    self.mscrollView.alwaysBounceVertical = YES;
    
    //头像点击事件
    UITapGestureRecognizer *headerTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(takePhotoAction:)];
    [headerTap setNumberOfTapsRequired:1];
    self.avatarImageView.userInteractionEnabled = YES;
    [self.avatarImageView addGestureRecognizer:headerTap];
    [headerTap release];

    
#ifdef __IPHONE_7_0
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1) {
        
        self.navigationBar.frame = CGRectMake(0.0, 10.0, 320.0, 44.0);
        
        self.mscrollView.frame = CGRectMake(0, 54, 320, self.view.bounds.size.height-54-54);
        
    }
#endif
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

-(void)dealloc
{
    self.mChangeAccountAvatarInterface.delegate = nil;
    self.mChangeAccountAvatarInterface = nil;
    
    self.mChangeAccountInfoInterface.delegate = nil;
    self.mChangeAccountInfoInterface = nil;
    
    self.avatarImageView = nil;
    self.nameTextField = nil;
    self.telTextField = nil;
    self.mscrollView = nil;
    
    self.navigationBar = nil;
    
    [super dealloc];
}

#pragma mark - ChangeAccountAvatarInterfaceDelegate
-(void)changeMyAvatarDidFinished
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"avatar has changed" 
                                                        object:nil 
                                                      userInfo:nil];
    
    self.mChangeAccountAvatarInterface.delegate = nil;
    self.mChangeAccountAvatarInterface = nil;
}

-(void)changeMyAvatarDidFailed:(NSString *)errorMsg
{
    UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:@"修改头像失败" 
													   message:errorMsg 
													  delegate:nil
											 cancelButtonTitle:@"确定" 
											 otherButtonTitles:nil];
	[alertView show];
	[alertView release];
    
    self.mChangeAccountAvatarInterface.delegate = nil;
    self.mChangeAccountAvatarInterface = nil;
}

#pragma mark - ChangeAccountInfoInterfaceDelegate
-(void)changeAccountInfoDidFinished
{
    [MySingleton sharedSingleton].name = self.nameTextField.text;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"name has changed" 
                                                        object:nil 
                                                      userInfo:nil];
    
    self.mChangeAccountInfoInterface.delegate = nil;
    self.mChangeAccountInfoInterface = nil;
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)changeAccountInfoDidFailed:(NSString *)errorMsg
{
    UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:@"修改账户信息失败" 
													   message:errorMsg 
													  delegate:nil
											 cancelButtonTitle:@"确定" 
											 otherButtonTitles:nil];
	[alertView show];
	[alertView release];
    
    ((UINavigationItem *)[self.navigationBar.items objectAtIndex:0]).rightBarButtonItem.enabled = YES;
    
    self.mChangeAccountInfoInterface.delegate = nil;
    self.mChangeAccountInfoInterface = nil;
}

@end
