//
//  NotificationCellView.m
//  Color
//
//  Created by chao han on 12-5-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "NotificationCellView.h"

@implementation NotificationCellView
@synthesize avatarImageView = _avatarImageView , thumbnailImageView = _thumbnailImageView
, contentLabel = _contentLabel;

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
}

@end
