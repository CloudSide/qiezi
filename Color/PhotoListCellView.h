//
//  PhotoListCellView.h
//  Color
//
//  Created by chao han on 12-5-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MediaModel.h"
#import "VideoDownloader.h"
#import <MediaPlayer/MediaPlayer.h>

@class EGOImageView;
@class CreateCommentInterface;
@protocol CreateCommentInterfaceDelegate;
@protocol CommentDelegate;
@class CommentViewController;

@interface PhotoListCellView : UIView <CreateCommentInterfaceDelegate 
, CommentDelegate , VideoDownloaderDelegate>

@property (nonatomic,retain) IBOutlet EGOImageView *photoImageView;
@property (nonatomic,retain) IBOutlet EGOImageView *peopleIconImageView;
@property (nonatomic,retain) IBOutlet UILabel *nameLabel;
@property (nonatomic,retain) IBOutlet UILabel *dateLabel;
@property (nonatomic,retain) IBOutlet UILabel *likeNumLabel;

@property (nonatomic,retain) IBOutlet UIView *btnGroup;
@property (nonatomic,retain) IBOutlet UIButton *likeBtn;
@property (nonatomic,retain) IBOutlet UIButton *commentBtn;
@property (nonatomic,retain) IBOutlet UIButton *trashBtn;

@property (nonatomic,retain) IBOutlet UIImageView *playVideoOverlay;

@property (nonatomic,retain) MediaModel *mediaModel;

@property (nonatomic,retain) CreateCommentInterface *mCreateCommentInterface;

@property (nonatomic,retain) CommentViewController *mCommentViewController;

@property (nonatomic,retain) VideoDownloader *mVideoDownloader;

@property (nonatomic,retain) IBOutlet UIView *commentViewGroup;

@property (nonatomic,retain) MPMoviePlayerController *player;


-(IBAction)onLikeBtnClick:(id)sender;
-(IBAction)onCommentBtnClick:(id)sender;

@end
