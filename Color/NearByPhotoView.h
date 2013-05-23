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
    NSString *_currentMediaId;
}
@property (nonatomic,retain) IBOutlet UIScrollView *memberScrollView;
@property (nonatomic,retain) IBOutlet UIScrollView *photoScrollView;
@property (nonatomic,retain) IBOutlet EGOImageView *photoImageView;
@property (nonatomic,retain) IBOutlet UILabel *dateLabel;

@property (nonatomic,retain) CircleModel *mCircleModel;
@property (nonatomic,retain) NSMutableArray *nearByUsersArray;

@property (nonatomic,retain) IBOutlet UIView *noMediaViewGroup;
@property (nonatomic,retain) IBOutlet UIScrollView *peopleScrollView;

-(void)updateMembers;
-(void)updateMedias;

@end
