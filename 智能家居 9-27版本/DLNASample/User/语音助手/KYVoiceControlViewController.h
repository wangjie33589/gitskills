//
//  KYVoiceControlViewController.h
//  SyncSmartHome
//
//  Created by sciyonSoft on 16/5/10.
//  Copyright © 2016年 sciyonSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

#import "WTRecorderWave.h"

@interface KYVoiceControlViewController : UIViewController
<
AVAudioPlayerDelegate
>
{
    NSTimer *RecordingTimer;
    NSTimeInterval intervalTime;
    
    UIScrollView *scrollview;
    WTRecorderWave *waveView;
    
    UILabel *timeLabel;
    
    UIView *actionView;
    UIButton *playButton;
    UIButton *recordButton;
    
    
    float sampleWidth;
}

@property (nonatomic, readonly, assign) BOOL isAllowUseMIC;
@property (nonatomic, readonly, assign) BOOL isRecording;
@property (nonatomic, readonly, assign) BOOL isRecordedWave;

@property (nonatomic, readonly, copy) NSString *audioPath;

@property (nonatomic, readonly, strong) AVAudioRecorder *audioRecorder;
@property (nonatomic, readonly, strong) AVAudioPlayer *audioPlayer;

- (BOOL)checkRecord;
- (void)startRecord;
- (void)stopRecord;

@end

