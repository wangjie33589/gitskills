/*
 *  CCAudioPlayer - Objective-C Audio player support remote and local files, Sitting on top of AVPlayer:
 *
 *      https://github.com/yechunjun/CCAudioPlayer
 *
 *  This code is distributed under the terms and conditions of the MIT license.
 *
 *  Author:
 *      Chun Ye <chunforios@gmail.com>
 *
 */

#import "DemoViewController.h"
#import "CCAudioPlayer.h"
#import "Track.h"
@import AVFoundation;
@import MediaPlayer;// @import只能引入系统框架
#import "MyTableViewCell.h"
#import "AppDelegate.h"



#define kUseBlockAPIToTrackPlayerStatus     1

@interface DemoViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>
{
@private
    UILabel *_titleLabel;
    UILabel *_statusLabel;
    
    UIButton *_buttonPlayPause;
    UIButton *_buttonNext;

    UISlider *_progressSlider;

    CCAudioPlayer *_audioPlayer;
    
    NSArray *_tracks;
    NSUInteger _currentTrackIndex;
    
    
    UIButton *_fastForwardBtn;
    UIButton *_fastBackWardBtn;
    NSArray *_listTableArray;
    UITableView *_listTableView;
    NSArray *listArray;
    NSInteger _currRow;
    UILabel *_musicNameLab;
    UIView * _Comments;
    BOOL  hiden;
    UITableView *mytable;
    NSTimer *_timer;
}

@end

@implementation DemoViewController
// 将播放页面视图做成单例 对操作状态进行保存
static DemoViewController *s_defaultManager = nil;
+ (DemoViewController *)defaultManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        s_defaultManager = [[DemoViewController alloc]init];
    });
       return s_defaultManager;
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    _timer=nil;
    [_timer invalidate];
//    AppDelegate* app = [[UIApplication sharedApplication] delegate];
//    self.renderer = app.avRenderer;
//    
    
    
    
//    self.renderer.delegate = self;
//

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    hiden=0;
    CGUpnpAvController* avCtrl = [[CGUpnpAvController alloc] init];
    avCtrl.delegate = self;
    [avCtrl search];
    self.avController = avCtrl;
    
    self.ipArray =[NSMutableArray array];
    self.DeviceNameArr=[NSMutableArray array];
     _timer =[NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(timer) userInfo:nil repeats:YES];
   
    [self initView];
}
-(void)timer{

    [_listTableView reloadData];

}
//
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    //NSSet * 类似于数组  touches 屏幕中点的集合
    
    UITouch *touch  = [touches anyObject];
    //locationInView获取所在屏幕中点的位置
    CGPoint point = [touch locationInView:self.view];
    
    //CGPoint point1 = [touch locationInView:];
    if (!CGRectContainsPoint(_listTableView.frame, point))
    {
        [_Comments removeFromSuperview];
        hiden=0;
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:.2];
        _listTableView.frame=CGRectMake(LWidth, 0, 0,0);
        [UIView  commitAnimations];

        
        
        
    }
    
    
    
}

//初始化下来框
-(void)initListTableView{
  
    
    
    _Comments = [[UIView alloc] init];
        _Comments.frame = CGRectMake(0, 0, LWidth, LHeight);
        _Comments.backgroundColor = [UIColor colorWithRed:0.157 green:0.169 blue:0.208 alpha:0.3];
    

    //_listTableArray =[[NSArray alloc]initWithObjects:@"手机", nil];
    //self.DeviceNameArr=[NSMutableArray array];
    [self.DeviceNameArr addObject:@"手机"];

    _listTableView=[[UITableView alloc]initWithFrame:CGRectMake(LWidth, 0, 0, 0) style:UITableViewStylePlain];
    [_Comments addSubview:_listTableView];
    _listTableView.dataSource=self;
    _listTableView.delegate=self;
    _listTableView.backgroundColor =[CommonTool  colorWithHexString:@"1E90FF"];
    [_listTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"sycell"];
    UIBarButtonItem *addBarBtn =[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"icon_5_n"] style:UIBarButtonItemStylePlain target:self action:@selector(addbarBtnClick)];
        self.navigationItem.rightBarButtonItem=addBarBtn;
    
    
}

-(void)addbarBtnClick{
    [self.view addSubview:_Comments];
    [self.view bringSubviewToFront:_Comments];
    hiden=!hiden;
    if (hiden==1) {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:.2];
        _listTableView.frame=CGRectMake(LWidth-100, 0, 95, self.DeviceNameArr.count*44+10);
        [UIView  commitAnimations];}
    else{
        [_Comments removeFromSuperview];
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:.2];
        _listTableView.frame=CGRectMake(LWidth, 0, 0,0);
        [UIView  commitAnimations];
    }
    
    
    
    
}

-(void)initView{
    

    [self moveDatabaseFileIntoDocumentsIfNeeded];
    [self moveDatabaseFileIntoDocumentsIfNeeded1];
    
    
    
    listArray =[self getFilenamelistOfType:@"mp3" fromDirPath:[self filePathWithName:@""]];
//    UIImageView *bgImag =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bg1136.png"]];
//    bgImag.frame=CGRectMake(0, 0, LWidth, LHeight);
//    [self.view addSubview:bgImag];
    mytable =[[UITableView alloc]initWithFrame:CGRectMake(0, 0, LWidth, LHeight-190) style:UITableViewStylePlain];
    mytable.backgroundColor=[UIColor whiteColor];
    mytable.dataSource=self;
    mytable.delegate=self;
    mytable.separatorColor=[UIColor clearColor];
    [mytable registerNib:[UINib nibWithNibName:@"MyTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
//    [mytable registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell1"];
    mytable.rowHeight=60;
    [self.view addSubview:mytable];
    [self initListTableView];
    _musicNameLab =[[UILabel alloc]initWithFrame:CGRectMake(0, LHeight-190, LWidth, 30)];
    _musicNameLab.textAlignment=NSTextAlignmentCenter;
    [self.view addSubview:_musicNameLab];
    
    
    UIImageView *logoImageView =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"musicHead.png"]];
    logoImageView.frame=CGRectMake(5, LHeight-160, 80, 80);
    //logoImageView.layer.cornerRadius=40;
    //logoImageView.layer.masksToBounds=YES;
    [self.view addSubview:logoImageView];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, logoImageView.frame.origin.y-200, CGRectGetWidth([self.view bounds]), 30.0)];
    [_titleLabel setFont:[UIFont systemFontOfSize:20.0]];
    [_titleLabel setTextColor:[UIColor blackColor]];
    [_titleLabel setTextAlignment:NSTextAlignmentCenter];
    [_titleLabel setLineBreakMode:NSLineBreakByTruncatingTail];
    [self.view addSubview:_titleLabel];
    
    _statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, CGRectGetMaxY([_titleLabel frame]) + 10.0, CGRectGetWidth([self.view bounds]), 30.0)];
    [_statusLabel setFont:[UIFont systemFontOfSize:16.0]];
    [_statusLabel setTextColor:[UIColor colorWithWhite:0.4 alpha:1.0]];
    [_statusLabel setTextAlignment:NSTextAlignmentCenter];
    [_statusLabel setLineBreakMode:NSLineBreakByTruncatingTail];
    [self.view addSubview:_statusLabel];
    
    _fastBackWardBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _fastBackWardBtn.frame =CGRectMake(100, LHeight-130, 50.0, 50);
    //[_fastForwardBtn setTitle:@"" forState:UIControlStateNormal];
    [_fastBackWardBtn setImage:[UIImage imageNamed:@"上一首.png"] forState:0];
    [_fastBackWardBtn addTarget:self action:@selector(_backBtnClick) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:_fastBackWardBtn];
    
    
    _buttonPlayPause = [UIButton buttonWithType:UIButtonTypeCustom];
    [_buttonPlayPause setFrame:CGRectMake(_fastBackWardBtn.frame.origin.x+55, _fastBackWardBtn.frame.origin.y, 60, 60)];
    //[_buttonPlayPause setTitle:@"播放" forState:UIControlStateNormal];
    [_buttonPlayPause setImage:[UIImage imageNamed:@"播放.png"] forState:0];
    
    [_buttonPlayPause addTarget:self action:@selector(_actionPlayPause:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:_buttonPlayPause];
    
    
    
    _fastForwardBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    [_fastForwardBtn setFrame:CGRectMake(_buttonPlayPause.frame.origin.x+65, LHeight-130, 50, 50)];
    //[_fastForwardBtn setTitle:@"" forState:UIControlStateNormal];
    [_fastForwardBtn setImage:[UIImage imageNamed:@"下一首.png"] forState:0];
    [_fastForwardBtn addTarget:self action:@selector(_forwardBtnClick) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:_fastForwardBtn];
    
    

    
    //    _buttonNext = [UIButton buttonWithType:UIButtonTypeCustom];
    //    [_buttonNext setFrame:CGRectMake(_fastForwardBtn.frame.origin.x+80, _fastForwardBtn.frame.origin.y, 50, 50)];
    //    //[_buttonNext setTitle:@"下一首" forState:UIControlStateNormal];
    //    [_buttonNext setImage:[UIImage imageNamed:@"music_player_next.png"] forState:0];
    //    [_buttonNext addTarget:self action:@selector(_actionNext:) forControlEvents:UIControlEventTouchDown];
    //    [self.view addSubview:_buttonNext];
    
    _progressSlider = [[UISlider alloc] initWithFrame:CGRectMake(100, LHeight-165, LWidth-115, 40.0)];
    _progressSlider.continuous = NO;
    [_progressSlider addTarget:self action:@selector(_actionSliderProgress:) forControlEvents:UIControlEventValueChanged];
    _progressSlider.thumbTintColor=[CommonTool  colorWithHexString:@"#47cbfc"];
    //_progressSlider.tintColorDidChange=[UIColor yellowColor];
    _progressSlider.maximumTrackTintColor=[CommonTool  colorWithHexString:@"#dcdcdc"];
    _progressSlider.minimumTrackTintColor=[CommonTool  colorWithHexString:@"#47cbfc"];
    //_progressSlider.minimumTrackTintColor=[UIColor whiteColor];
   // _progressSlider.backgroundColor=[UIColor blueColor];
    
    [self.view addSubview:_progressSlider];
    [[NSNotificationCenter defaultCenter]
     
     addObserver:self selector:@selector(endPlay) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    
    //9.切换播放源
    
    // [_player replaceCurrentItemWithPlayerItem:nil];
    
    
    
    
    //_tracks = [Track remoteTracks];
    
    //[self _resetStreamer];


}
#pragma mark=====tableViewDelegte
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView==_listTableView) {
        return self.DeviceNameArr.count;
    }else{
        
        return listArray.count;
    
    }


}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    static NSString *cellider =@"cell";
//    UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:cellider];
   
       if (tableView==_listTableView) {
           UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"sycell"];
             cell.textLabel.text=self.DeviceNameArr[indexPath.row];
           cell.selectionStyle=  UITableViewCellSelectionStyleNone;
          cell.textLabel.font=[UIFont systemFontOfSize:12];
         cell.backgroundColor=[CommonTool  colorWithHexString:@"1E90FF"];
           return cell;
    }else{
         MyTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"cell"];
         cell.backgroundColor=[UIColor clearColor];
        //cell.textLabel.textColor=[UIColor yellowColor];
       
        cell.iView.image=[UIImage imageNamed:@"music_pic1"];
        //cell.textLabel.text=listArray[indexPath.row];
        cell.firstLab.text=listArray[indexPath.row];
        NSArray *Arr =[[NSArray alloc]initWithObjects:@"林俊杰",@"郑智化", nil];
        cell.selectedImagView.hidden=YES;
        //cell.secondLab.text=
        cell.secondLab.text=Arr[indexPath.row];
        
        return cell;
       

        
    
    }
    

    //return cell;
    



}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_Comments removeFromSuperview];

    hiden=0;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:.2];
    _listTableView.frame=CGRectMake(LWidth, 0, 0,0);
    [UIView  commitAnimations];
   
    
    if (tableView==_listTableView) {
        [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:@"成功连接 %@",self.DeviceNameArr[indexPath.row]]];
       // _listTableView.hidden=YES;
        
    }else{
        _currRow=indexPath.row;
        [self _resetStreamerWithRow:indexPath.row];
        
        //[_audioPlayer play];
        [_buttonPlayPause setImage:[UIImage imageNamed:@"暂停.png"] forState:0];

    }
  

}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    hiden=0;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:.2];
    _listTableView.frame=CGRectMake(LWidth, 0, 0,0);
    [UIView  commitAnimations];




}
-(void)_backBtnClick{
    --_currRow;
    if (_currRow<listArray.count&&_currRow>0) {
        [self _resetStreamerWithRow:_currRow];
        
    }else{
        _currRow=0;
        
        [self _resetStreamerWithRow:_currRow];
        
    }
    
    

}
-(void)_forwardBtnClick{

    ++_currRow;
    if (_currRow<listArray.count) {
        [self _resetStreamerWithRow:_currRow];
        
    }else{
        _currRow=0;
        
        [self _resetStreamerWithRow:_currRow];
        
    }
    


}
#pragma mark - Private
-(void)viewWillDisappear:(BOOL)animated{
//    if (_audioPlayer) {
//        [_audioPlayer dispose];
//        if (!kUseBlockAPIToTrackPlayerStatus) {
//            [_audioPlayer removeObserver:self forKeyPath:@"progress"];
//            [_audioPlayer removeObserver:self forKeyPath:@"playerState"];
//        }
//        _audioPlayer = nil;
//    }
//    


}

- (void)updateProgressView
{
    [_progressSlider setValue:_audioPlayer.progress / _audioPlayer.duration animated:YES];
}

- (void)updateStatusViews
{
    
    
    switch (_audioPlayer.playerState) {
        case CCAudioPlayerStatePlaying:
        {
            //_statusLabel.text = @"Playing";
            [_buttonPlayPause setTitle:@"暂停" forState:UIControlStateNormal];
            [_buttonPlayPause setBackgroundImage:[UIImage imageNamed:@""] forState:0];

        }
            break;
        case CCAudioPlayerStateBuffering:
        {
            //_statusLabel.text = @"Buffering";
        }
            break;
            
        case CCAudioPlayerStatePaused:
        {
            //_statusLabel.text = @"Paused";
            [_buttonPlayPause setTitle:@"播放" forState:UIControlStateNormal];
            [_buttonPlayPause setBackgroundImage:[UIImage imageNamed:@""] forState:0];
        }
            break;
            
        case CCAudioPlayerStateStopped:
        {
            //_statusLabel.text = @"Play to End";
            
            [self _actionNext:nil];
        }
            break;
        default:
            break;
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"progress"]) {
        [self updateProgressView];
    } else {
        [self updateStatusViews];
    }
}

- (void)_actionSliderProgress:(id)sender
{
    [_audioPlayer seekToTime:_audioPlayer.duration * _progressSlider.value];
}

- (void)_actionPlayPause:(id)sender
{

    if (_audioPlayer.isPlaying) {
        [_buttonPlayPause setImage:[UIImage imageNamed:@"播放.png"] forState:0];
        [_audioPlayer pause];
    } else {
        [_buttonPlayPause setImage:[UIImage imageNamed:@"暂停.png"] forState:0];
        [_audioPlayer play];
        
    }
}

- (void)_actionNext:(id)sender
{
    if (++_currRow>= [listArray count]) {
        _currRow = 0;
    }
    
    
    [self _resetStreamerWithRow:_currRow+1];
}

- (void)_resetStreamerWithRow:(NSInteger)indexRow
{
    if (_audioPlayer) {
        [_audioPlayer dispose];
        if (!kUseBlockAPIToTrackPlayerStatus) {
            [_audioPlayer removeObserver:self forKeyPath:@"progress"];
            [_audioPlayer removeObserver:self forKeyPath:@"playerState"];
        }
        _audioPlayer = nil;
    }
    
    [_progressSlider setValue:0.0 animated:NO];
    
    //if (_tracks.count != 0) {
        //Track *track = [_tracks objectAtIndex:_currentTrackIndex];
       // NSString *title = [NSString stringWithFormat:@"%@ - %@", track.artist, track.title];
        //[_titleLabel setText:title];
    NSString *path =[self filePathWithName:listArray[indexRow]];
    _musicNameLab.text=listArray[indexRow];
    
    
//    MyRequest *manger =[MyRequest requestWithURL:[NSString stringWithFormat:@"http://%@/httpapi.asp?command=setPlayerCmd:playlist:%@:%@",self.ipArray[0],path,@"%3c0%3e"]];
//        NSLog(@"%@",[NSString stringWithFormat:@"http://%@/httpapi.asp?command=setPlayerCmd:playlist:%@:%@",self.ipArray[0],path,@"%3c0%3e"]);
//    manger.backSuccess=^void(NSDictionary *dictt){
//        
//        
//        
//        
//        
//    };
    if ( [self.renderer setAVTransportURI:path]) {
        
    }
   ;

    [self.renderer play];
    
        _audioPlayer = [CCAudioPlayer audioPlayerWithContentsOfURL:[NSURL fileURLWithPath:path]];
    
    
    
        if (kUseBlockAPIToTrackPlayerStatus) {
            typeof(self) __weak weakSelf = self;
            [_audioPlayer trackPlayerProgress:^(NSTimeInterval progress) {
                DemoViewController *strongSelf = weakSelf;
                [strongSelf updateProgressView];
            } playerState:^(CCAudioPlayerState playerState) {
                DemoViewController *strongSelf = weakSelf;
                [strongSelf updateStatusViews];
            }];
        } else {
            [_audioPlayer addObserver:self forKeyPath:@"progress" options:NSKeyValueObservingOptionNew context:NULL];
            [_audioPlayer addObserver:self forKeyPath:@"playerState" options:NSKeyValueObservingOptionNew context:NULL];
        }
        [_audioPlayer play];
    //} else {
        NSLog(@"No tracks available");
   // }
}

#pragma mark - 消息中心

- (void)endPlay{
    
    
    NSLog(@"结束播放");
    
    //self.sliderProgress.value = 0;
//    _currRow++;
//    
//    if (_currRow>= [listArray count]-1) {
//        _currRow =-1;
//    }
    ++_currRow;
    if (_currRow<listArray.count) {
        [self _resetStreamerWithRow:_currRow];

    }else{
        _currRow=0;
    
        [self _resetStreamerWithRow:_currRow];
    
    }
    
  
    
    //NSString *path =[self filePathWithName:listArray[0]];
    
    
//    AVPlayerItem *item = [[AVPlayerItem alloc]
//                          
//                          initWithURL:[NSURL fileURLWithPath:path]];
//    
    
    //1.切换到下一首歌曲
    
   // [_player replaceCurrentItemWithPlayerItem:item];
    
    //切换后要手动播放
    
    //[_player play];
    
    
}
-(void)moveDatabaseFileIntoDocumentsIfNeeded{
    NSString *DocumentsFilePath = [self filePathWithName:@"一千年以后.mp3"];
    
    NSFileManager *manager = [NSFileManager defaultManager];
    
    if (![manager fileExistsAtPath:DocumentsFilePath]) {
        NSString *sourcePath = [[NSBundle mainBundle] pathForResource:@"一千年以后" ofType:@"mp3"];
        // NSString *sourcePath1 = [[NSBundle mainBundle] pathForResource:@"水手" ofType:@"mp3"];
        [manager copyItemAtPath:sourcePath toPath:[self filePathWithName:@"一千年以后.mp3"] error:nil];
        
        //         [manager copyItemAtPath:sourcePath1 toPath:[self filePathWithName:@"水手.mp3"] error:nil];
    }
}
-(void)moveDatabaseFileIntoDocumentsIfNeeded1{
    NSString *DocumentsFilePath = [self filePathWithName:@"水手.mp3"];
    
    NSFileManager *manager = [NSFileManager defaultManager];
    
    if (![manager fileExistsAtPath:DocumentsFilePath]) {
        NSString *sourcePath = [[NSBundle mainBundle] pathForResource:@"水手" ofType:@"mp3"];
        // NSString *sourcePath1 = [[NSBundle mainBundle] pathForResource:@"水手" ofType:@"mp3"];
        [manager copyItemAtPath:sourcePath toPath:[self filePathWithName:@"水手.mp3"] error:nil];
        
        //         [manager copyItemAtPath:sourcePath1 toPath:[self filePathWithName:@"水手.mp3"] error:nil];
    }
}


-(NSString*)filePathWithName:(NSString*)name{
    return [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@",name]];
    
    
    
}
-(NSArray*) findArtistList {
    NSMutableArray *artistList = [[NSMutableArray alloc]init];
    MPMediaQuery *listQuery = [MPMediaQuery playlistsQuery];//播放列表
    NSArray *playlist = [listQuery collections];//播放列表数组
    
    
    NSLog(@"playlist====%@",playlist);
    for (MPMediaPlaylist * list in playlist) {
        NSLog(@"playlist====%@",playlist);
        NSArray *songs = [list items];//歌曲数组
        NSLog(@"song====%@",songs);
        for (MPMediaItem *song in songs) {
            NSString *title =[song valueForProperty:MPMediaItemPropertyTitle];//歌曲名
            //歌手名
            NSString *artist =[[song valueForProperty:MPMediaItemPropertyArtist] uppercaseString];
            if(artist!=nil&&![artistList containsObject:artist]){
                // [artistList addObject:artist];
                [artistList addObject:title];
            }
        }
    }
    return artistList;
}
-(NSArray *)getFilenamelistOfType:(NSString *)type fromDirPath:(NSString *)dirPath
{
    NSMutableArray *filenamelist = [NSMutableArray arrayWithCapacity:10];
    NSArray *tmplist = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:dirPath error:nil];
    
    for (NSString *filename in tmplist) {
        NSString *fullpath = [dirPath stringByAppendingPathComponent:filename];
        if ([self isFileExistAtPath:fullpath]) {
            if ([[filename pathExtension] isEqualToString:type]) {
                [filenamelist  addObject:filename];
            }
        }
    }
    
    return filenamelist;
}
-(BOOL)isFileExistAtPath:(NSString*)fileFullPath {
    BOOL isExist = NO;
    isExist = [[NSFileManager defaultManager] fileExistsAtPath:fileFullPath];
    return isExist;
}
#pragma mark CGUpnpControlPointDelegate
-  (void) controlPoint: (CGUpnpControlPoint *) controlPoint deviceAdded: (NSString *) deviceUdn;{
    
    
}
- (void)controlPoint:(CGUpnpControlPoint *)controlPoint deviceUpdated:(NSString *)deviceUdn {
    NSLog(@"%@", deviceUdn);
    //[SVProgressHUD showWithStatus:@"正在搜索设备，请稍后..."];
    self.avController = (CGUpnpAvController*)controlPoint;
    
    //self.dataSource = [controlPoint devices];
    
    // self.renderers =  [((CGUpnpAvController*)controlPoint) servers];
    //self.renderers=[self.avController servers];
    //    NSArray* renderers = [((CGUpnpAvController*)controlPoint) renderers];
    //    if ([renderers count] > 0) {
    //        for (CGUpnpAvRenderer* renderer in renderers) {
    //            NSLog(@"avRendererUDN:%@", [renderer udn]);
    //        }
    //    }
    //[SVProgressHUD showWithStatus:@"正在搜索设备，请稍后..."];
    [self.DeviceNameArr removeAllObjects];
    [self.DeviceNameArr addObject:@"手机"];
    
    self.dataSource=[self.avController renderers];
    for (int row=0; row < [self.dataSource count]; row++) {
        CGUpnpDevice *device = [self.dataSource objectAtIndex:row];
        
        [self.ipArray addObject:device.ipaddress];
        
        NSLog(@"device.ipAddress====%@",device.ipaddress);
        self.renderer  =[[CGUpnpAvRenderer alloc]initWithCObject:(__bridge CgUpnpDevice *)(device)];
        
        
        
        [self.DeviceNameArr addObject:device.friendlyName];
    }
    
//    if (self.ipArray.count>0) {
//        //[SVProgressHUD dismiss];
//        [self requestForPlayStstus];
//    }
    //[SVProgressHUD dismiss];
    
    //self.dataSource = [((CGUpnpAvController*)controlPoint) renderers];
    
    
    
    //    NSLog(@"selfDatta========%@",self.dataSource);
    //    NSLog(@"shdhfhjdf=====%@",self.renderers);
    //int dmsNum = 0;
    //    for (CGUpnpDevice *dev in [controlPoint devices]) {
    //        //NSLog(@"%@:%@", [dev friendlyName], [dev ipaddress]);
    //        if ([dev isDeviceType:@"urn:schemas-upnp-org:device:MediaServer:1"]) {
    ////			PrintDmsInfo(dev, ++dmsNum);
    //            //NSLog(@"#Server:%@", [dev deviceType]);
    //
    //        }
    //        else if([dev isDeviceType:@"urn:schemas-upnp-org:device:MediaRenderer:1"]) {
    //            NSLog(@"#Renderer%@", [dev deviceType]);
    //        }
    //    }
     [_listTableView reloadData];
}



- (void)controlPoint:(CGUpnpControlPoint *)controlPoint deviceRemoved:(NSString *)deviceUdn
{
    //    NSLog(@"device removed udn %@", deviceUdn);
    //    self.dataSource = [controlPoint devices];
    //    [self.tableView reloa
}


@end
