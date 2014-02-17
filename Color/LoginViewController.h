//
//  LoginViewController.h
//  Color
//
//  Created by chao han on 12-5-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController

@property (nonatomic,retain) IBOutlet UILabel *dateLabel;
@property (nonatomic,retain) IBOutlet UILabel *monthYearLabel;
@property (nonatomic,retain) IBOutlet UILabel *weekLable;
@property (nonatomic,retain) IBOutlet UIImageView *findAccountImg;

-(IBAction)startAction:(id)sender;
@end
