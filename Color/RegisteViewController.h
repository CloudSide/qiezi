//
//  RegisteViewController.h
//  Color
//
//  Created by chao han on 12-5-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisteViewController : UIViewController <UITextFieldDelegate>

@property (nonatomic,retain) IBOutlet UITextField *nameLabel;

-(IBAction)nextAction:(id)sender;

@end
