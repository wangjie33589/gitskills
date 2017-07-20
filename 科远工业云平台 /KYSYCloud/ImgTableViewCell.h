//
//  ImgTableViewCell.h
//  KYSYCloud
//
//  Created by sciyonSoft on 16/3/3.
//  Copyright © 2016年 sciyonSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>


@interface ImgTableViewCell : UITableViewCell
- (IBAction)playBtn:(UIButton *)sender;
- (IBAction)recoadBtn:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *play;
@property (strong, nonatomic) IBOutlet UIButton *recoad;

//录音存储路径
@property (nonatomic, strong)NSURL *tmpFile;
//录音
@property (nonatomic, strong)AVAudioRecorder *recorder;
//播放
@property (nonatomic, strong)AVAudioPlayer *player;
//录音状态(是否录音)
@property (nonatomic, assign)BOOL isRecoding;




@end
