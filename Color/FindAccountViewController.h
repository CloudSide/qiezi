//
//  FindAccountViewController.h
//  QieZi
//
//  找回账号
//
//  Created by hanchao on 14-2-17.
//

#import <UIKit/UIKit.h>

@interface FindAccountViewController : UIViewController <UITextFieldDelegate>

@property (nonatomic,retain) IBOutlet UITextField *nameLabel;
@property (nonatomic,retain) NSString *wbUserId;


-(IBAction)findAccountAction:(id)sender;


@end
