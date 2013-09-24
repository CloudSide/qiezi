//
//  NotificationCellView.h
//  Color
//  通知主界面cell view
//  Created by chao han on 12-5-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class EGOImageView;
@interface NotificationCellView : UITableViewCell

@property (nonatomic,retain) IBOutlet EGOImageView *avatarImageView;
@property (nonatomic,retain) IBOutlet EGOImageView *thumbnailImageView;
@property (nonatomic,retain) IBOutlet UILabel *contentLabel;
@end
