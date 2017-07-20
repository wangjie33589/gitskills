//
//  ADD_VC.h
//  KYSYCloud
//
//  Created by sciyonSoft on 16/3/16.
//  Copyright © 2016年 sciyonSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>



@interface ADD_VC : UIViewController<AVAudioPlayerDelegate>{
  


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




@property (strong, nonatomic) IBOutlet UITableView *myTable;
- (IBAction)downBtn:(UIButton *)sender;
@property (strong, nonatomic) IBOutlet UIButton *downBtn;
@property(copy,nonatomic)NSString *Mcode;

@property(assign ,nonatomic)int type;
@property(assign,nonatomic)int tag;










-(id)initWithADic:(NSDictionary *)aDic withTitle:(NSString*)title;




@end
