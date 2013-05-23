//
//  DynamicCellView.h
//  Color
//  Created by chao han on 12-5-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EGOImageView;
@interface DynamicCellView : UITableViewCell

@property (nonatomic,retain) IBOutlet UIView *imageGroup;
@property (nonatomic,retain) IBOutlet UILabel *numberLabel;
@property (nonatomic,retain) IBOutlet UILabel *peopleLabel;
@property (nonatomic,retain) IBOutlet UILabel *dateTime;
@property (nonatomic,retain) IBOutlet UIImageView *iconView;

@property (nonatomic,retain) NSDictionary *dynamicDict;

@end
