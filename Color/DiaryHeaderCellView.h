//
//  DiaryHeaderCellView.h
//  Color
//
//  Created by chao han on 12-5-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class EGOImageView;

@interface DiaryHeaderCellView : UIView

@property (nonatomic,retain) IBOutlet EGOImageView *headIconView;
@property (nonatomic,retain) IBOutlet UILabel *nameLabel;
@property (nonatomic,retain) IBOutlet UIScrollView *friendScrollView;
@end
