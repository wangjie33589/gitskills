//
//  SelfBubbleCell.h
//  YiChat
//
//  Created by 孙 化育 on 14-11-7.
//  Copyright (c) 2014年 孙 化育. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelfBubbleCell : UITableViewCell

@property (retain, nonatomic) IBOutlet UIImageView *headImageView;

@property (retain, nonatomic) IBOutlet UIImageView *bubbleImageView;


@property (retain, nonatomic) IBOutlet UILabel *messageLabel;

@property (strong, nonatomic) IBOutlet UILabel *timeLab;




@end
