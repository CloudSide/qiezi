//
//  RegistePhotoViewcontroller.h
//  Color
//
//  Created by chao han on 12-5-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RegisteInterface.h"

@interface RegistePhotoViewcontroller : UIViewController <UINavigationControllerDelegate 
, UIImagePickerControllerDelegate, RegisteInterfaceDelegate>

@property (nonatomic,retain) NSString *firstName;

@property (nonatomic,retain) RegisteInterface *mRegisteInterface;

@property (nonatomic,retain) UIImagePickerController * picker;

-(IBAction)takePhotoAction:(id)sender;
-(IBAction)backAction:(id)sender;
@end
