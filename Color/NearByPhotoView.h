//
//  NearByPhotoView.h
//  Color
//
//  Created by chao han on 12-6-5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EGOImageView;
@class CircleModel;
@interface NearByPhotoView : UIView <UIScrollViewDelegate>{
    NSString *_currentMediaId;//当前显示图片的id
}

@property (nonatomic,retain) IBOutlet UIScrollView *memberScrollView;//成员scrollView

@property (nonatomic,retain) IBOutlet UIScrollView *photoScrollView;//图片scrollView
@property (nonatomic,retain) IBOutlet EGOImageView *photoImageView;
@property (nonatomic,retain) IBOutlet UILabel *dateLabel;

@property (nonatomic,retain) CircleModel *mCircleModel;
@property (nonatomic,retain) NSMutableArray *nearByUsersArray;//附近所有用户

@property (nonatomic,retain) IBOutlet UIView *noMediaViewGroup;
@property (nonatomic,retain) IBOutlet UIScrollView *peopleScrollView;//最上面头像scrollView

-(void)updateMembers;//更新圈子成员
-(void)updateMedias;//更新照片

@end
