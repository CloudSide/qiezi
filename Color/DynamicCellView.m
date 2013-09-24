//
//  DynamicCellView.m
//  Color
//
//  Created by chao han on 12-5-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "DynamicCellView.h"
#import <QuartzCore/QuartzCore.h>
#import "MediaModel.h"
#import "UserModel.h"
#import "EGOImageView.h"
#import "NSDate+DynamicDateString.h"

@implementation DynamicCellView

@synthesize imageGroup = _imageGroup , numberLabel = _numberLabel ,
    peopleLabel = _peopleLabel , dateTime = _dateTime , iconView = _iconView,
    dynamicDict = _dynamicDict ;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    if (selected) {
        if ([self.imageGroup viewWithTag:100] == nil) {
            UIView *coverView = [[UIView alloc] init];
            coverView.frame = CGRectMake(0, 0, self.imageGroup.frame.size.width, self.imageGroup.frame.size.height);
            coverView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.35];
            coverView.tag = 100;
            [self.imageGroup addSubview:coverView];
            [coverView release];
        }
    }else{
        [[self.imageGroup viewWithTag:100] removeFromSuperview];
    }
}

-(void)setDynamicDict:(NSDictionary *)dict{
    [_dynamicDict release];
    _dynamicDict = nil;
    _dynamicDict = [dict retain];
    
    for (UIView *view in [self.imageGroup subviews]) {
        [view removeFromSuperview];
    }
    
    //显示最后一张照片的时间
    NSDate *lastTime = [self.dynamicDict objectForKey:@"date"];//最后一张照片的时间    
    self.dateTime.text = [lastTime getDynamicDateStringFromNow];

    //显示最后4张照片
    NSArray *picArray = [self.dynamicDict objectForKey:@"picArray"];//照片数组
    NSInteger mediaCount = [picArray count] > 4 ? 4 : [picArray count];
    
    for (NSInteger i = 0 ; i < mediaCount ; ++i) {
        MediaModel *media = [picArray objectAtIndex:i];
        
        EGOImageView *img = [[EGOImageView alloc]  init];
        [img setContentMode:UIViewContentModeScaleAspectFill];
        img.clipsToBounds = YES;
        
        if (mediaCount < 4) {
            if (i == 0) {
                img.frame = CGRectMake(0, 0, 80 * (4 - mediaCount + 1) + (4 - mediaCount)*1, 80);
                if (media.mediaType == 1) {
                    img.imageURL = [NSURL URLWithString:media.thumbnailUrl];
                }else{
                    img.imageURL = [NSURL URLWithString:media.originalUrl];
                }
            }else{
                EGOImageView * imgView = (EGOImageView *)[[self.imageGroup subviews] lastObject];
                img.frame = CGRectMake(imgView.frame.origin.x + imgView.frame.size.width + 1, 0, 80, 80);
                img.imageURL = [NSURL URLWithString:media.thumbnailUrl];
            }
        }else{
            img.frame = CGRectMake(i * 80 + i * 1, 0, 80, 80);
            img.imageURL = [NSURL URLWithString:media.thumbnailUrl];
        }
        
        if (media.mediaType == 1) {//视频
            UIImageView *icon = [[UIImageView alloc] initWithImage: [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"VideoCameraPreview" ofType:@"png"]]];
            icon.frame = CGRectMake(5,
                                   img.frame.size.height - icon.frame.size.height - 5,
                                   icon.frame.size.width,
                                   icon.frame.size.height);
            
            [img addSubview:icon];
            [icon release];
        }
        
        [self.imageGroup addSubview:img];
        [img release];
    }
    
    NSArray *userNames = [self.dynamicDict objectForKey:@"userNames"];//圈子成员名称数组
    NSMutableString *peopleNameStr = [NSMutableString stringWithString:@""];
    
    NSInteger userNamesCount = userNames.count;
    for (NSInteger i = 0 ; i < userNamesCount ; ++i) {
        NSString *name = [userNames objectAtIndex:i];
        if (i < userNamesCount -2) {
            [peopleNameStr appendString:[NSString stringWithFormat:@"%@, ",name]];
        }else{
            [peopleNameStr appendString:[NSString stringWithFormat:@"%@ & ",name]];
        }
    }
    
    self.peopleLabel.text = [peopleNameStr substringToIndex:peopleNameStr.length - 2];
    self.numberLabel.text = [[self.dynamicDict objectForKey:@"num"] stringValue];
}

-(void)dealloc {
    self.imageGroup = nil;
    self.numberLabel = nil;
    self.peopleLabel = nil;
    self.dateTime = nil;
    self.iconView = nil;
    self.dynamicDict = nil;
    
    [super dealloc];
}

@end
