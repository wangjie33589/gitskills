//
//  OtherBubbleCell.m
//  YiChat
//
//  Created by 孙 化育 on 14-11-7.
//  Copyright (c) 2014年 孙 化育. All rights reserved.
//

#import "OtherBubbleCell.h"

@implementation OtherBubbleCell

- (void)awakeFromNib {
    self.headImageView.layer.cornerRadius = 30;
    self.headImageView.layer.masksToBounds = YES;
    self.bubbleImageView.image = [[UIImage imageNamed:@"bubble.png"] stretchableImageWithLeftCapWidth:25 topCapHeight:21];
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
