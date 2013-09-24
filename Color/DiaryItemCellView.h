//
//  DiaryItemCellView.h
//  Color
//  回忆主界面 图片cell view
//  Created by chao han on 12-5-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EGOImageViewDelegate;
@interface DiaryItemCellView : UITableViewCell <UIScrollViewDelegate,EGOImageViewDelegate>

@property (nonatomic,retain) UIScrollView *mscrollView;

@property (nonatomic,retain) NSArray *mediaArray;
@property (nonatomic,assign) NSInteger lineCount;//当前显示几行


@end
