//
//  KYVoiceControlViewController.m
//  SyncSmartHome
//
//  Created by sciyonSoft on 16/5/10.
//  Copyright © 2016年 sciyonSoft. All rights reserved.
//

#import "KYVoiceControlViewController.h"

#import "math.h"
@interface KYVoiceControlViewController ()


@end

@implementation KYVoiceControlViewController
@synthesize audioRecorder;
@synthesize audioPlayer;
@synthesize audioPath;

@synthesize isAllowUseMIC;
@synthesize isRecording;
@synthesize isRecordedWave;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    self.title = @"语音助手";
    self.tabBarController.tabBar.hidden=YES;
    self.view.backgroundColor = [UIColor grayColor];
    [self setup];
    [self checkRecord];
    [self performSelector:@selector(setupView)
               withObject:nil afterDelay:0];
  
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void)back{
    
    [self.navigationController dismissViewControllerAnimated:NO completion:^{
        
    }];
}

- (void)setupView{
    
    recordButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [recordButton setFrame:CGRectMake((self.view.frame.size.width-100)/2,(self.view.frame.size.height-100)/2, 100, 100)];
    [recordButton setHighlighted:NO];
    [recordButton setImage:[UIImage imageNamed:@"iconRecorderStart"] forState:UIControlStateNormal];
    [recordButton setImage:[UIImage imageNamed:@"iconRecorderStop"] forState:UIControlStateSelected];
    [recordButton addTarget:self action:@selector(clickedRecorderButton:) forControlEvents:UIControlEventTouchUpInside];
    
   timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(((self.view.frame.size.width-100)/2)+3, recordButton.frame.origin.y - 70,100, 20)];
    
    [timeLabel setBackgroundColor:[UIColor clearColor]];
    [timeLabel setTextColor:[UIColor whiteColor]];
    [timeLabel setTextAlignment:NSTextAlignmentCenter];
    [timeLabel setFont:[UIFont systemFontOfSize:16.0f]];
    [timeLabel setText:@""];
    [self.view addSubview:timeLabel];

 
    
    
    playButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [playButton setFrame:CGRectMake((self.view.frame.size.width-100)/2, recordButton.frame.origin.y + 150, 100, 70)];
    [playButton setTitle:@"播 放" forState:UIControlStateNormal];
    [playButton setTitle:@"停 止" forState:UIControlStateSelected];
    [playButton addTarget:self action:@selector(clickedVoicePlay:) forControlEvents:UIControlEventTouchUpInside];
    
    //    [playButton setImage:[UIImage imageNamed:@"iconRecorderStart"] forState:UIControlStateNormal];
    //    [playButton setImage:[UIImage imageNamed:@"iconRecorderStop"] forState:UIControlStateSelected];
    
    [self.view addSubview:playButton];
    [self.view addSubview:recordButton];
    
}

//- (instancetype)initWithFrame:(CGRect)frame{
//    self = [super initWithFrame:frame];
//    if (self) [self setup];
//    return self;
//}

- (void)setup {
    intervalTime = 0.025;
    sampleWidth = 0.5;
}

- (void)restRecord{
    [waveView.samples removeAllObjects];
    [waveView setNeedsDisplay];
    
    [timeLabel setText:@""];
}

- (BOOL)checkRecord{
    if ([self canRecord]) {
        isAllowUseMIC = YES;
    }else{
        isAllowUseMIC = NO;
    }
    return isAllowUseMIC;
}

- (void)startRecord
{
    if (isRecording){
        return;
    }
    if (isRecordedWave) {
        [self restRecord];
    }
    
    if (isAllowUseMIC) {
        isRecording = YES;
        NSLog(@"startRecord");
        audioRecorder = nil;
        isRecordedWave = YES;
        
        // Init audio with record capability
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
        
        NSDictionary *recordSettings=[NSDictionary dictionaryWithObjectsAndKeys:
                                      [NSNumber numberWithFloat:8000],AVSampleRateKey,
                                      [NSNumber numberWithInt:kAudioFormatLinearPCM],AVFormatIDKey,
                                      [NSNumber numberWithInt:1],AVNumberOfChannelsKey,
                                      [NSNumber numberWithInt:16],AVLinearPCMBitDepthKey,
                                      [NSNumber numberWithBool:NO],AVLinearPCMIsBigEndianKey,
                                      [NSNumber numberWithBool:NO],AVLinearPCMIsFloatKey,
                                      nil];
        
        audioPath = [self FilePathInLibraryWithName:@"Caches/UserRecordTemp.wav"];
        NSURL *url = [NSURL fileURLWithPath:audioPath];
        
        NSError *error = nil;
        audioRecorder = [[ AVAudioRecorder alloc] initWithURL:url settings:recordSettings error:&error];
        [audioRecorder setMeteringEnabled:YES];
        if ([audioRecorder prepareToRecord] == YES){
            [audioRecorder record];
        }else {
            int errorCode = CFSwapInt32HostToBig ((int)[error code]);
            NSLog(@"Error: %@ [%4.4s])" , [error localizedDescription], (char*)&errorCode);
        }
        if (audioRecorder.isRecording) {
            NSLog(@"recording");
            [self initTimer];
        }
    }
}

-(void)stopRecord
{
    NSLog(@"stopRecord");
    [audioRecorder stop];
    audioRecorder=nil;
    
    isRecording = NO;
    
    [RecordingTimer invalidate];
    RecordingTimer = nil;
}

-(void)initTimer
{
    [RecordingTimer invalidate];
    RecordingTimer = nil;
    //定时器
    RecordingTimer = [NSTimer scheduledTimerWithTimeInterval:intervalTime
                                                      target:self
                                                    selector:@selector(handleMaxRecordingTimer:)
                                                    userInfo:nil
                                                     repeats:YES];
    [RecordingTimer fire];
}

//刷新界面
-(void)handleMaxRecordingTimer:(NSTimer *)theTimer
{
    if (audioRecorder && audioRecorder.isRecording) {
        [audioRecorder updateMeters];
        float peakPowerForChannel = [audioRecorder peakPowerForChannel:0];
        float peakPower = pow(10, (0.05 * peakPowerForChannel));
        NSLog(@"peakPower   :%lf   from :%lf",peakPower,peakPowerForChannel);
        
        [waveView  addSamples:[NSNumber numberWithFloat:peakPowerForChannel]];
        
        if (floor(waveView.samples.count*sampleWidth) >= ceil(waveView.bounds.size.width)){
            CGRect rectWave = waveView.frame;
            rectWave.size.width = (waveView.samples.count + 1)*sampleWidth;
            waveView.frame = rectWave;
            
            [scrollview setContentSize:rectWave.size];
            [scrollview scrollRectToVisible:CGRectMake((waveView.samples.count - 1)*sampleWidth, 0, sampleWidth, rectWave.size.height) animated:NO];
        }
        float time = audioRecorder.currentTime;
        NSInteger time2 = time * 100;
        NSInteger timeMin = time2 / 6000;
        NSInteger timeSe = time2 % 6000;
        
        NSString *timeString;
        if (timeMin == 0) {
            timeString = [NSString stringWithFormat:@"%0.2f\"",(timeSe / 100.00)];
        }else{
            timeString = [NSString stringWithFormat:@"%ld' %0.1f\"",timeMin,(timeSe / 100.00)];
        }
        [timeLabel setText:timeString];
    }
}

- (void)drawRect:(CGRect)rect{
    [[UIColor blackColor] set];
    UIRectFill(self.view.bounds);
}


- (BOOL)canRecord
{
    __block BOOL bCanRecord = YES;
    if ([[UIDevice currentDevice].systemVersion doubleValue] > 6.9)
    {
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        if ([audioSession respondsToSelector:@selector(requestRecordPermission:)]) {
            [audioSession performSelector:@selector(requestRecordPermission:) withObject:^(BOOL granted) {
                if (granted) {
                    bCanRecord = YES;
                } else {
                    bCanRecord = NO;
                }
            }];
        }
    }
    return bCanRecord;
}


- (IBAction)clickedRecorderButton:(id)sender {
    UIButton *bt = (UIButton *)sender;
    [self stopPlaying];
    if (self.isAllowUseMIC) {
        if (bt.isSelected) {
            [bt setSelected:NO];
            [self stopRecord];
        }else{
            [bt setSelected:YES];
            [self startRecord];
        }
    }
}

#pragma mark 播放

- (IBAction)clickedVoicePlay:(id)sender {
    if (audioPlayer != nil && audioPlayer.isPlaying) {
        [playButton setSelected:NO];
        [self stopPlaying];
    }else{
        if (self.isRecordedWave && !self.isRecording) {
            [playButton setSelected:YES];
            [self playRecordingWithPath:self.audioPath];
        }
    }
}


-(void) playRecordingWithPath:(NSString *)RecordPath{
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
    
    NSURL *url;
    url = [NSURL fileURLWithPath:RecordPath];
    NSError *error;
    audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    
    if (error != nil){
        [self stopPlaying];
    }else{
        audioPlayer.numberOfLoops = 0;
        audioPlayer.delegate = self;
        [audioPlayer play];
        NSLog(@"playing");
    }
}

-(void) stopPlaying
{
    NSLog(@"stopPlaying");
    [audioPlayer stop];
    audioPlayer = nil;
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    [playButton setSelected:NO];
    audioPlayer = nil;
}

- (NSString *)FilePathInLibraryWithName:(NSString *)name{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *LibraryDirectory = [paths objectAtIndex:0];
    return [LibraryDirectory stringByAppendingPathComponent:name];
}
@end

