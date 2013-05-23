//
//  NearByDefaultView.h
//  Color
//
//  Created by chao han on 12-6-5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CircleModel;
@interface NearByDefaultView : UIView

@property (nonatomic,retain) IBOutlet UIScrollView *peopleScrollView;//scrollView
@property (nonatomic,retain) CircleModel *mCircleModel;

@end
