//
//  regist_Two_ViewController.h
//  KYSYCloud
//
//  Created by sciyonSoft on 16/2/19.
//  Copyright © 2016年 sciyonSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>


@interface regist_Two_ViewController : UIViewController<AVAudioPlayerDelegate>{
    NSMutableDictionary *_recodeSeting;
    
}

//录音存储路径
@property (nonatomic, strong)NSURL *tmpFile;
//录音
@property (nonatomic, strong)AVAudioRecorder *recorder;
//播放
@property (nonatomic, strong)AVAudioPlayer *player;
//录音状态(是否录音)
@property (nonatomic, assign)BOOL isRecoding;

@property(nonatomic,strong)NSURL *downloadtmpfile;



@property(assign,nonatomic)int type;

@property (strong, nonatomic) IBOutlet UITableView *mytable;

-(id)initWithADic:(NSDictionary *)aDic withTitle:(NSString*)title;
@property (strong, nonatomic) IBOutlet UIButton *downFirstBtn;

@property (strong, nonatomic) IBOutlet UIButton *DownSecondBtn;

@property (strong, nonatomic) IBOutlet UIButton *downThirldBtn;


@end
