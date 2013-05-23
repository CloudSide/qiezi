//
//  UILabel+VerticalAlign.m
//  ZReader_HD
//
//  Created by  on 12-3-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "UILabel+VerticalAlign.h"

@implementation UILabel (VerticalAlign)
- (void)alignTop {
    CGSize fontSize = [self.text sizeWithFont:self.font];
    double finalHeight = fontSize.height * self.numberOfLines;
    double finalWidth = self.frame.size.width;    //expected width of label
    CGSize theStringSize = [self.text sizeWithFont:self.font constrainedToSize:CGSizeMake(finalWidth, finalHeight) lineBreakMode:self.lineBreakMode];
    int newLinesToPad = (finalHeight  - theStringSize.height) / fontSize.height;
    for(int i=0; i<newLinesToPad; i++)
        self.text = [self.text stringByAppendingString:@"\n "];
}

- (void)alignBottom {
    CGSize fontSize = [self.text sizeWithFont:self.font];
    double finalHeight = fontSize.height * self.numberOfLines;
    double finalWidth = self.frame.size.width;    //expected width of label
    CGSize theStringSize = [self.text sizeWithFont:self.font constrainedToSize:CGSizeMake(finalWidth, finalHeight) lineBreakMode:self.lineBreakMode];
    int newLinesToPad = (finalHeight  - theStringSize.height) / fontSize.height;
    for(int i=0; i<newLinesToPad; i++)
        self.text = [NSString stringWithFormat:@" \n%@",self.text];
}

-(void)autoWidth {
    CGSize fontSize = [self.text sizeWithFont:self.font];
    CGRect frame = self.frame;
    frame.size = fontSize;
    frame.size.width += 20;
    frame.origin.x = self.frame.origin.x - (fontSize.width - self.frame.size.width) - 20;
    
    self.frame = frame;
    
}

-(void)autoWidthBaseLeft {
    CGSize fontSize = [self.text sizeWithFont:self.font];
    CGRect frame = self.frame;
    frame.size = fontSize;
    frame.size.width += 20;
    
    self.frame = frame;
    
}
@end
