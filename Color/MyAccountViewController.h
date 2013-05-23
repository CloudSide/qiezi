//
//  MyAccountViewController.h
//  Color
//
//  Created by chao han on 12-6-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGOImageView.h"
#import "ChangeAccountAvatarInterface.h"
#import "ChangeAccountInfoInterface.h"

@interface MyAccountViewController : UIViewController <UITextFieldDelegate 
 , ChangeAccountAvatarInterfaceDelegate , UIImagePickerControllerDelegate
 , UINavigationControllerDelegate,ChangeAccountInfoInterfaceDelegate>

@property (nonatomic,retain) IBOutlet EGOImageView *avatarImageView;
@property (nonatomic,retain) IBOutlet UITextField *nameTextField;
@property (nonatomic,retain) IBOutlet UITextField *telTextField;
@property (nonatomic,retain) IBOutlet UIScrollView *mscrollView;

@property (nonatomic,retain) ChangeAccountAvatarInterface *mChangeAccountAvatarInterface;
@property (nonatomic,retain) ChangeAccountInfoInterface *mChangeAccountInfoInterface;

@property (nonatomic,retain) UINavigationBar *navigationBar;

@property (nonatomic,retain) UIImagePickerController * picker;

-(IBAction) slideFrameUp:(id) sender;
-(IBAction) slideFrameDown:(id) sender;

@end
