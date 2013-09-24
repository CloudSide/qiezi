//
//  DiaryItemCellView.m
//  Color
//
//  Created by chao han on 12-5-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "DiaryItemCellView.h"
#import "MediaModel.h"
#import "EGOImageView.h"
#import <QuartzCore/QuartzCore.h>
#import "PhotoListViewController.h"
#import "AppDelegate.h"

@implementation DiaryItemCellView

@synthesize mscrollView = _mscrollView , mediaArray = _mediaArray , lineCount = _lineCount;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
//        self.frame = CGRectMake(0, 0, self.frame.size.width, 80);
        
        UIScrollView *_sv = [[UIScrollView alloc] initWithFrame:self.frame];
//        _sv.delegate = self;
        _sv.alwaysBounceHorizontal = YES;
        _sv.scrollsToTop = NO;
        _sv.alwaysBounceVertical = NO;
        _sv.delegate = self;
        
        self.mscrollView = _sv;
        [self addSubview:self.mscrollView];
        
        [_sv release];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
//    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)initScrollView{
    
    for (UIView *view in [self.mscrollView subviews]) {
        if ([view isMemberOfClass:[EGOImageView class]]) {
            [view removeFromSuperview];
        }
    }
    
    NSInteger i = 0;
    
    CGFloat contentWidth = 0;
    NSInteger mediaCount = [self.mediaArray count];//照片总数
    
    NSInteger currentLine = 1;
    CGFloat x = 0;
    CGFloat y = 0;//i <= 6? 0 :((i <= 10) ? 2 * 80 : 3 * 80);
    for (MediaModel *media in self.mediaArray) {
        if (i == (mediaCount / self.lineCount + (mediaCount % self.lineCount > 0?1:0)) * currentLine) {
            x = 0;
            y += 80;
            ++currentLine;
        }
        
        EGOImageView *photo = [[EGOImageView alloc] initWithFrame:CGRectMake(x, y, 
                                                                           80, 80)];
        photo.tag = i;
        
        CGRect frame = photo.frame;
        frame.origin.x -= self.mscrollView.contentOffset.x;
        if (CGRectIntersectsRect(self.mscrollView.frame, frame)) {
            photo.imageURL = [NSURL URLWithString:media.thumbnailUrl];
        }
        
        if (media.mediaType == 1) {//视频
            UIImageView *img = [[UIImageView alloc] initWithImage: [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"VideoCameraPreview" ofType:@"png"]]];
            img.frame = CGRectMake(5,
                                   photo.frame.size.height - img.frame.size.height - 5,
                                   img.frame.size.width,
                                   img.frame.size.height);
            
            [photo addSubview:img];
            [img release];
        }
        
        //边框
        photo.layer.borderWidth = 0.5f;
        photo.layer.borderColor = [[UIColor whiteColor] CGColor];
        
        //点击事件
        photo.userInteractionEnabled = YES;
        UITapGestureRecognizer *singleTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(mediaDidSelected:)];
        [photo addGestureRecognizer:singleTap];
        [singleTap release];
        
        [self.mscrollView addSubview:photo];
        [photo release];
        
        if (contentWidth < (x + 80)) {
            contentWidth = x + 80;
        }
        
        x += 80;
        
        ++i;
    }
    
    self.mscrollView.contentSize = CGSizeMake(contentWidth, self.lineCount * 80);
}

//照片点击事件
-(void)mediaDidSelected:(UIGestureRecognizer *)gesture{
    UIView *view = gesture.view;

    PhotoListViewController *_photoListViewController = [[PhotoListViewController alloc] init];
    MediaModel *media = [self.mediaArray objectAtIndex:view.tag];
    _photoListViewController.circleId = media.circleId;
    _photoListViewController.mediaId = media.mid;
    
    AppDelegate *mainDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    UINavigationController *currentController = (UINavigationController *)mainDelegate.tabBarController.selectedViewController;
    [currentController pushViewController:_photoListViewController animated:YES];
    [_photoListViewController release];
    
}

-(void)setMediaArray:(NSArray *)array{
    [_mediaArray release];
    _mediaArray = nil;
    
    _mediaArray = [array retain];
    
    //计算行数
    NSInteger count = [self.mediaArray count];
    if (count <= 7) {
        self.lineCount = 1;
    }else if (count <= 11){
        self.lineCount = 2;
    }else {
        self.lineCount = 3;
    }
    
    //重置frame
    self.frame = CGRectMake(0, 0, self.frame.size.width, self.lineCount * 80);
    self.mscrollView.frame = CGRectMake(0, 0, self.frame.size.width, self.lineCount * 80);
    
    [self initScrollView];
}


-(void)dealloc{
    self.mscrollView = nil;
    self.mediaArray = nil;
    
    [super dealloc];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    for(UIView *view in [self.mscrollView subviews]){
        if ([view isMemberOfClass:[EGOImageView class]]) {
            EGOImageView *photo = (EGOImageView *)view;
            
            CGRect frame = photo.frame;
            frame.origin.x -= self.mscrollView.contentOffset.x;
            
            if (CGRectIntersectsRect(self.mscrollView.frame, frame)) {//相交，显示图片
                if (photo.image == nil) {
                    MediaModel *media = [self.mediaArray objectAtIndex:photo.tag];
                    photo.imageURL = [NSURL URLWithString:media.thumbnailUrl];
                }
            }else{//销毁图片
                [photo cancelImageLoad];
                photo.image = nil;
                photo.imageURL = nil;
            }
        }
    }
}


@end
