//
//  RegistePhotoViewcontroller.m
//  Color
//
//  Created by chao han on 12-5-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "RegistePhotoViewcontroller.h"
#import "UIUtil.h"
#import "RegisteInterface.h"
#import "AppDelegate.h"
#import "UIImage+UIImageScale.h"

@implementation RegistePhotoViewcontroller

@synthesize firstName = _firstName , picker = _picker , mRegisteInterface = _mRegisteInterface;

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
    
    self.firstName = nil;
    self.picker = nil;
    self.mRegisteInterface.delegate = nil;
    self.mRegisteInterface = nil;
    
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
    NSString *base64ImageStr = [image image2String];
    
    self.mRegisteInterface = [[[RegisteInterface alloc] init] autorelease];
    self.mRegisteInterface.delegate = self;
    [self.mRegisteInterface doRegiste:self.firstName avatar:base64ImageStr format:@"JPEG" email:@""];
}

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

#pragma mark get/show the UIView we want
//Find the view we want in camera structure.
-(UIView *)findView:(UIView *)aView withName:(NSString *)name{
	Class cl = [aView class];
	NSString *desc = [cl description];
	
	if ([name isEqualToString:desc])
		return aView;
	
	for (NSUInteger i = 0; i < [aView.subviews count]; i++)
	{
		UIView *subView = [aView.subviews objectAtIndex:i];
		subView = [self findView:subView withName:name];
		if (subView)
			return subView;
	}
	return nil;	
}

-(IBAction)takePhotoAction:(id)sender{
    [self takePhoto];
}

-(IBAction)backAction:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - RegisteInterfaceDelegate method
-(void)registeDidFinished{
    AppDelegate *mainDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    [mainDelegate showMainView];//显示主界面
    
    self.mRegisteInterface.delegate = nil;
    self.mRegisteInterface = nil;
}

-(void)registeDidFailed{
    NSLog(@"===========registeDidFailed==================");
    UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:@"注册失败，请检查网络后重试。" 
													   message:nil 
													  delegate:nil
											 cancelButtonTitle:@"确定" 
											 otherButtonTitles:nil];
	[alertView show];
	[alertView release];
    
    self.mRegisteInterface.delegate = nil;
    self.mRegisteInterface = nil;
}

@end
