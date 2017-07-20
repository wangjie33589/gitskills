//
//  SelfBubbleCell.m
//  YiChat
//
//  Created by 孙 化育 on 14-11-7.
//  Copyright (c) 2014年 孙 化育. All rights reserved.
//

#import "SelfBubbleCell.h"

@implementation SelfBubbleCell

- (void)awakeFromNib {
    self.headImageView.layer.cornerRadius = 30;
    self.headImageView.layer.masksToBounds = YES;
        //stretchableImageWithLeftCapWidth设置边帽拉伸，拉伸时，延长部位只按照指定像素点的颜色填充。
    self.bubbleImageView.image = [[UIImage imageNamed:@"bubbleSelf.png"] stretchableImageWithLeftCapWidth:25 topCapHeight:21];
    
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    [_headImageView release];
    [_bubbleImageView release];
    [_messageLabel release];
    [super dealloc];
}
@end
