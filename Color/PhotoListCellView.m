//
//  PhotoListCellView.m
//  Color
//
//  Created by chao han on 12-5-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "PhotoListCellView.h"
#import "CreateCommentInterface.h"
#import "EGOImageView.h"
#import "MediaModel.h"
#import "UserModel.h"
#import "NSDate+DynamicDateString.h"
#import "CommentViewController.h"
#import "AppDelegate.h"
#import "CommentModel.h"
#import "HomePageViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import "MediaCommentListViewControll.h"

@implementation PhotoListCellView

@synthesize photoImageView = _photoImageView , peopleIconImageView = _peopleIconImageView
, nameLabel = _nameLabel , dateLabel = _dateLabel , btnGroup = _btnGroup 
, likeBtn = _likeBtn , commentBtn = _commentBtn , trashBtn = _trashBtn
, mediaModel = _mediaModel , mCreateCommentInterface = _mCreateCommentInterface
, mCommentViewController = _mCommentViewController , commentViewGroup = _commentViewGroup
, likeNumLabel = _likeNumLabel , mVideoDownloader = _mVideoDownloader 
, player = _player , playVideoOverlay = _playVideoOverlay ;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
-(void)sendGoodByMediaId:(NSString *)mid good:(NSInteger)good{
    self.mCreateCommentInterface = [[[CreateCommentInterface alloc] init] autorelease];
    self.mCreateCommentInterface.delegate = self;
    [self.mCreateCommentInterface createCommentByMediaId:mid good:good];
}

#pragma mark - button action method
-(IBAction)onLikeBtnClick:(id)sender{
    if(self.mediaModel.hasMygood){
        [self sendGoodByMediaId:self.mediaModel.mid good:-1];//取消顶
        self.likeNumLabel.text = [NSString stringWithFormat:@"%d",[self.likeNumLabel.text intValue] - 1];
    }else{
        [self sendGoodByMediaId:self.mediaModel.mid good:1];
        self.likeNumLabel.text = [NSString stringWithFormat:@"%d",[self.likeNumLabel.text intValue] + 1];
    }
    
    self.mediaModel.hasMygood = !self.mediaModel.hasMygood;
}

-(IBAction)onCommentBtnClick:(id)sender{
    self.mCommentViewController = [[[CommentViewController alloc] initWithFeedId:nil andFeedUserName:nil] autorelease];
    self.mCommentViewController.view.frame = CGRectMake(0, 0, 320, 265);
    self.mCommentViewController.delegate = self;
    
    AppDelegate *mainDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    UINavigationController *currentController = (UINavigationController *)mainDelegate.tabBarController.selectedViewController;
    
    [currentController pushViewController:self.mCommentViewController animated:YES];
}

-(void)dealloc{
    self.photoImageView = nil;
    self.peopleIconImageView = nil;
    self.nameLabel = nil;
    self.dateLabel = nil;
    self.btnGroup = nil;
    self.likeBtn = nil;
    self.commentBtn = nil;
    self.trashBtn = nil;
    self.mediaModel = nil;
    self.likeNumLabel = nil;
    
    self.mCreateCommentInterface.delegate = nil;
    self.mCreateCommentInterface = nil;
    
    self.mCommentViewController.delegate = nil;
    self.mCommentViewController = nil;
    
    self.commentViewGroup = nil;
    
    [self.player stop];
    self.player = nil;
    
    self.playVideoOverlay = nil;
    
    [super dealloc];
}

#pragma mark header tap method
-(void)goHomePage{
    HomePageViewController *mHomePageViewController = [[HomePageViewController alloc] init];
    mHomePageViewController.userId = self.mediaModel.owner.userId;
    AppDelegate *mainDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    UINavigationController *currentController = (UINavigationController *)mainDelegate.tabBarController.selectedViewController;
    
    [currentController pushViewController:mHomePageViewController animated:YES];
    [mHomePageViewController release];
}

-(void)videoTapedAction
{
    self.playVideoOverlay.alpha = 0;
    
    NSString * videoPath=[ NSSearchPathForDirectoriesInDomains ( NSDocumentDirectory , NSUserDomainMask , YES ) objectAtIndex : 0 ];
    videoPath=[[videoPath stringByAppendingPathComponent : @"video" ] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mov",self.mediaModel.mid]];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDirectory = NO;
    BOOL exists = [fileManager fileExistsAtPath:videoPath isDirectory:&isDirectory];
    if (exists && !isDirectory) {
        self.player = [[MPMoviePlayerController alloc] initWithContentURL: [NSURL fileURLWithPath:videoPath]];
        [[self.player view] setFrame: [self.photoImageView bounds]];  // frame must match parent view
        self.player.view.frame = self.photoImageView.frame;
        [self addSubview: [self.player view]];
        self.player.view.clipsToBounds = YES;
        self.player.scalingMode = MPMovieScalingModeAspectFill;  
        [self.player play];
    }else{
        self.mVideoDownloader = [[VideoDownloader alloc] init];
        self.mVideoDownloader.delegate = self;
        [self.mVideoDownloader downloadFileByUrl:self.mediaModel.originalUrl fileName:[NSString stringWithFormat:@"%@.mov",self.mediaModel.mid]];
    }
}

-(void)goCommentList
{
    MediaCommentListViewControll *mclvc = [[MediaCommentListViewControll alloc]initWithNibName:@"MediaCommentListViewControll" bundle:nil];
    mclvc.media = self.mediaModel;
    
    AppDelegate *mainDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    UINavigationController *currentController = (UINavigationController *)mainDelegate.tabBarController.selectedViewController;
    [currentController pushViewController:mclvc animated:YES];
    [mclvc release];
}

-(void)setMediaModel:(MediaModel *)mm{
    [_mediaModel release];
    _mediaModel = [mm retain];
    
    if (self.mediaModel.mediaType == 1) {
        self.playVideoOverlay.alpha = 1;
        self.photoImageView.imageURL = [NSURL URLWithString:self.mediaModel.thumbnailUrl];
        self.photoImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *videoTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(videoTapedAction)];
        [videoTap setNumberOfTapsRequired:1];
        [self.photoImageView addGestureRecognizer:videoTap];
        [videoTap release];
        
    }else{
        self.photoImageView.imageURL = [NSURL URLWithString:self.mediaModel.originalUrl];
        self.photoImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *photoTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goCommentList)];
        [photoTap setNumberOfTapsRequired:1];
        [self.photoImageView addGestureRecognizer:photoTap];
        [photoTap release];
    }
    if ([[MySingleton sharedSingleton].userId isEqualToString:self.mediaModel.owner.userId]) {
        self.peopleIconImageView.frame = CGRectMake(280, self.peopleIconImageView.frame.origin.y,
                                                    self.peopleIconImageView.frame.size.width,
                                                    self.peopleIconImageView.frame.size.height);
        self.trashBtn.alpha = 1;
    }else
    {
        self.peopleIconImageView.frame = CGRectMake(0, self.peopleIconImageView.frame.origin.y,
                                                    self.peopleIconImageView.frame.size.width,
                                                    self.peopleIconImageView.frame.size.height);
        self.trashBtn.alpha = 0;
    }
    self.peopleIconImageView.imageURL = [NSURL URLWithString:self.mediaModel.owner.avatarUrl];
    UITapGestureRecognizer *headerTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goHomePage)];
    [headerTap setNumberOfTapsRequired:1];
    [self.peopleIconImageView addGestureRecognizer:headerTap];
    [headerTap release];
    self.nameLabel.text = [NSString stringWithFormat:@"%@\t%@",self.mediaModel.owner.name,self.mediaModel.city];
    self.dateLabel.text = [self.mediaModel.ctime getDynamicDateStringFromNow];
    self.likeNumLabel.text = [NSString stringWithFormat:@"%d",self.mediaModel.goodCount];
    if ([mm.commentArray count] > 0) {
        for (CommentModel *cm in mm.commentArray) {
            UIView *commentView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                           self.commentViewGroup.frame.size.height, 
                                                                           self.frame.size.width,
                                                                           0)];
            commentView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.0];
            //人名
            UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0,
                                                                           self.frame.size.width,
                                                                           13)];
            nameLabel.font = [UIFont fontWithName:@"Helvetica" size:12];
            nameLabel.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.0];
            nameLabel.text = cm.ownerName;
            [commentView addSubview:nameLabel];
            CGRect commentViewFrame = commentView.frame;
            commentViewFrame.size.height = nameLabel.frame.size.height;
            [nameLabel release];
            UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,10,
                                                                           240 - 4,
                                                                           13)];
            contentLabel.font = [UIFont fontWithName:@"Helvetica" size:12];
            contentLabel.numberOfLines = 10;
            contentLabel.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.0];
            NSString *content = nil;
            if (cm.feedUser != nil) {
                content = [NSString stringWithFormat:@"回复%@:  %@",cm.feedUser.name,cm.content];
            }else
            {
                content = cm.content;
            }

            CGSize countLabelFontSize = [content sizeWithFont:contentLabel.font 
                                               constrainedToSize:CGSizeMake(contentLabel.frame.size.width, 999) 
                                                   lineBreakMode:contentLabel.lineBreakMode];
            contentLabel.frame = CGRectMake(0, 15, countLabelFontSize.width, countLabelFontSize.height);
            contentLabel.text = content;
            [commentView addSubview:contentLabel];
            commentViewFrame.size.height += contentLabel.frame.size.height;
            commentView.frame = commentViewFrame;
            [contentLabel release];
            [self.commentViewGroup addSubview:commentView];
            CGRect commentViewGroupFrame = self.commentViewGroup.frame;
            commentViewGroupFrame.size.height += commentView.frame.size.height + 8;
            self.commentViewGroup.frame = commentViewGroupFrame;
            
            CGRect superViewFrame = [self.commentViewGroup superview].frame;
            superViewFrame.size.height += commentView.frame.size.height + 8;
            [self.commentViewGroup superview].frame = superViewFrame;
            
            self.frame = CGRectMake(self.frame.origin.x,
                                    self.frame.origin.y,
                                    self.frame.size.width,
                                    self.frame.size.height + commentView.frame.size.height + 8);
            
            
            [commentView release];
        }
    }
    UITapGestureRecognizer *commentTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goCommentList)];
    [commentTap setNumberOfTapsRequired:1];
    [self.commentViewGroup superview].userInteractionEnabled = YES;
    [[self.commentViewGroup superview] addGestureRecognizer:commentTap];
    [commentTap release];
}

#pragma mark - CreateCommentInterfaceDelegate 
-(void)createCommentDidFinished:(NSString *)mediaId content:(NSString *)content{
    if (content.length>0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"addComment" 
                                                            object:nil 
                                                          userInfo:[NSDictionary dictionaryWithObjectsAndKeys:content,@"content",mediaId,@"mediaId",nil]];
        
    }
    
    self.mCreateCommentInterface.delegate = nil;
    self.mCreateCommentInterface = nil;
}

-(void)createCommentDidFailed:(NSString *)errorMsg{
    UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:@"发表评论失败" 
													   message:errorMsg 
													  delegate:nil
											 cancelButtonTitle:@"确定" 
											 otherButtonTitles:nil];
	[alertView show];
	[alertView release];
    
    self.mCreateCommentInterface.delegate = nil;
    self.mCreateCommentInterface = nil;
}

#pragma mark - CommentDelegate
-(void)sendComment:(NSString *)comment feedId:(NSString *)fid{
    self.mCreateCommentInterface = [[[CreateCommentInterface alloc] init] autorelease];
    self.mCreateCommentInterface.delegate = self;
    [self.mCreateCommentInterface createCommentByMediaId:self.mediaModel.mid content:comment feedId:fid];
}

#pragma mark - VideoDownloaderDelegate
-(void)downloadFileDidFinished{
    NSString * videoPath=[ NSSearchPathForDirectoriesInDomains ( NSDocumentDirectory , NSUserDomainMask , YES ) objectAtIndex : 0 ];
    videoPath=[[videoPath stringByAppendingPathComponent : @"video" ] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mov",self.mediaModel.mid]];
    self.player = [[MPMoviePlayerController alloc] initWithContentURL: [NSURL fileURLWithPath:videoPath]];
    [[self.player view] setFrame: [self.photoImageView bounds]];  // frame must match parent view
    self.player.view.frame = self.photoImageView.frame;
    [self addSubview: [self.player view]];
    self.player.view.clipsToBounds = YES;
    self.player.scalingMode = MPMovieScalingModeAspectFill;  
    [self.player play];

    self.mVideoDownloader.delegate = nil;
    self.mVideoDownloader = nil;
}
@end
