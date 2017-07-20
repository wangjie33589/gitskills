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
#import "XMLDictionary.h"
#import "NSString+Extension_NSString.h"
#import "UIImageView+WebCache.h"




#define kUseBlockAPIToTrackPlayerStatus     1

@interface DemoViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,UISearchBarDelegate>
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
    UISearchBar *_searbar;
    NSString *searStr;
    
    NSArray *_ShowArray;
    UIView *playerView ;
    NSDictionary *_picUrlDic;
    UIImageView *logoImageView;
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
    
//
//    [self moveDatabaseFileIntoDocumentsIfNeeded];
//    [self moveDatabaseFileIntoDocumentsIfNeeded1];
//    
    
    
    //listArray =[self getFilenamelistOfType:@"mp3" fromDirPath:[self filePathWithName:@""]];
//    UIImageView *bgImag =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bg1136.png"]];
//    bgImag.frame=CGRectMake(0, 0, LWidth, LHeight);
//    [self.view addSubview:bgImag];
    _searbar =[[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, LWidth, 40)];
    _searbar.placeholder=@"歌手名/歌曲名";
    _searbar.delegate=self;
    _searbar.returnKeyType=UIReturnKeyDone;
    [self.view addSubview:_searbar];
    mytable =[[UITableView alloc]initWithFrame:CGRectMake(0, 40, LWidth, LHeight) style:UITableViewStylePlain];
    mytable.backgroundColor=[UIColor whiteColor];
    mytable.dataSource=self;
    mytable.delegate=self;
    mytable.separatorColor=[UIColor clearColor];
   // [mytable registerNib:[UINib nibWithNibName:@"MyTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
   // [mytable registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
//    [mytable registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell1"];
    mytable.rowHeight=60;
    mytable.contentInset=UIEdgeInsetsMake(0, 0, 200, 0);
    [self.view addSubview:mytable];
    [self initListTableView];
    _musicNameLab =[[UILabel alloc]initWithFrame:CGRectMake(0, LHeight-190, LWidth, 30)];
    _musicNameLab.textAlignment=NSTextAlignmentCenter;
    [self.view addSubview:_musicNameLab];
    
    playerView =[[UIView alloc]init];
    playerView.backgroundColor=[UIColor whiteColor];
    playerView.hidden=YES;
    playerView.frame=CGRectMake(0, LHeight-165, LWidth, LHeight);
    [self.view addSubview:playerView];
  logoImageView =[[UIImageView alloc]init];
    logoImageView.frame=CGRectMake(5, 5, 80, 80);
    //logoImageView.layer.cornerRadius=40;
    //logoImageView.layer.masksToBounds=YES;
    [playerView addSubview:logoImageView];
   
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, logoImageView.frame.origin.y-200, CGRectGetWidth([self.view bounds]), 30.0)];
    [_titleLabel setFont:[UIFont systemFontOfSize:20.0]];
    [_titleLabel setTextColor:[UIColor blackColor]];
    [_titleLabel setTextAlignment:NSTextAlignmentCenter];
    [_titleLabel setLineBreakMode:NSLineBreakByTruncatingTail];
    [playerView addSubview:_titleLabel];
    
    _statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, CGRectGetMaxY([_titleLabel frame]) + 10.0, CGRectGetWidth([self.view bounds]), 30.0)];
    [_statusLabel setFont:[UIFont systemFontOfSize:16.0]];
    [_statusLabel setTextColor:[UIColor colorWithWhite:0.4 alpha:1.0]];
    [_statusLabel setTextAlignment:NSTextAlignmentCenter];
    [_statusLabel setLineBreakMode:NSLineBreakByTruncatingTail];
    [playerView addSubview:_statusLabel];
    
    _fastBackWardBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _fastBackWardBtn.frame =CGRectMake(100, 30, 50.0, 50);
    //[_fastForwardBtn setTitle:@"" forState:UIControlStateNormal];
    [_fastBackWardBtn setImage:[UIImage imageNamed:@"上一首.png"] forState:0];
    [_fastBackWardBtn addTarget:self action:@selector(_backBtnClick) forControlEvents:UIControlEventTouchDown];
    [playerView addSubview:_fastBackWardBtn];
    
    
    _buttonPlayPause = [UIButton buttonWithType:UIButtonTypeCustom];
    [_buttonPlayPause setFrame:CGRectMake(_fastBackWardBtn.frame.origin.x+55, _fastBackWardBtn.frame.origin.y, 60, 60)];
    //[_buttonPlayPause setTitle:@"播放" forState:UIControlStateNormal];
    [_buttonPlayPause setImage:[UIImage imageNamed:@"播放.png"] forState:0];
    
    [_buttonPlayPause addTarget:self action:@selector(_actionPlayPause:) forControlEvents:UIControlEventTouchDown];
    [playerView addSubview:_buttonPlayPause];
    
    
    
    _fastForwardBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    [_fastForwardBtn setFrame:CGRectMake(_buttonPlayPause.frame.origin.x+65,30, 50, 50)];
    //[_fastForwardBtn setTitle:@"" forState:UIControlStateNormal];
    [_fastForwardBtn setImage:[UIImage imageNamed:@"下一首.png"] forState:0];
    [_fastForwardBtn addTarget:self action:@selector(_forwardBtnClick) forControlEvents:UIControlEventTouchDown];
    [playerView addSubview:_fastForwardBtn];
    
    

    
    //    _buttonNext = [UIButton buttonWithType:UIButtonTypeCustom];
    //    [_buttonNext setFrame:CGRectMake(_fastForwardBtn.frame.origin.x+80, _fastForwardBtn.frame.origin.y, 50, 50)];
    //    //[_buttonNext setTitle:@"下一首" forState:UIControlStateNormal];
    //    [_buttonNext setImage:[UIImage imageNamed:@"music_player_next.png"] forState:0];
    //    [_buttonNext addTarget:self action:@selector(_actionNext:) forControlEvents:UIControlEventTouchDown];
    //    [self.view addSubview:_buttonNext];
    
    _progressSlider = [[UISlider alloc] initWithFrame:CGRectMake(100, 0, LWidth-115, 40.0)];
    _progressSlider.continuous = NO;
    [_progressSlider addTarget:self action:@selector(_actionSliderProgress:) forControlEvents:UIControlEventValueChanged];
    _progressSlider.thumbTintColor=[CommonTool  colorWithHexString:@"#47cbfc"];
    //_progressSlider.tintColorDidChange=[UIColor yellowColor];
    _progressSlider.maximumTrackTintColor=[CommonTool  colorWithHexString:@"#dcdcdc"];
    _progressSlider.minimumTrackTintColor=[CommonTool  colorWithHexString:@"#47cbfc"];
    //_progressSlider.minimumTrackTintColor=[UIColor whiteColor];
   // _progressSlider.backgroundColor=[UIColor blueColor];
    
    [playerView addSubview:_progressSlider];
    [[NSNotificationCenter defaultCenter]
     
     addObserver:self selector:@selector(endPlay) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    
    //9.切换播放源
    
    // [_player replaceCurrentItemWithPlayerItem:nil];
    
    
    
    
    //_tracks = [Track remoteTracks];
    
    //[self _resetStreamer];


}
#pragma mark ------------------ UISearchBarDelegate
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:YES];
    
    for(id cc in [searchBar.subviews[0] subviews])
    {
        if([cc isKindOfClass:[UIButton class]])
        {
            UIButton *btn = (UIButton *)cc;
            [btn setTitle:@"取消"  forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(cancel) forControlEvents: UIControlEventTouchUpInside];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
    }
}
-(void)cancel{
    
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [searchBar setShowsCancelButton:NO];
    self.navigationItem.rightBarButtonItem = nil;
    [self.view endEditing:YES];
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    
    searStr=@"";
    searStr=searchBar.text;
    [self requestShowData];
    [self.view endEditing:YES];
}


- (void)requestShowData{
    NSString *muUrl =[NSString stringWithFormat:@"http://search.kuwo.cn/r.s?all=%@&ft=music&itemset=web_2013&client=kt&pn=0&rformat=json&encoding=utf8",searStr];
    NSLog(@"MYURL====%@",muUrl);
    NSString *urlstring= [muUrl  stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"MYURL====%@",urlstring);


      MyRequest *manager = [MyRequest requestWithURL:urlstring];
    manager.backSuccess = ^void(NSDictionary *dictt)
    {
          NSLog(@"showArray=====%@",dictt);
        _ShowArray=dictt[@"abslist"];
        
        NSLog(@"showArray=====%@",_ShowArray);
        [mytable reloadData];
        
        
    };
}

#pragma mark=====tableViewDelegte
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView==_listTableView) {
        return self.DeviceNameArr.count;
    }else{
        
        return _ShowArray.count;
    
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
         UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (!cell) {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
        }
        
         cell.backgroundColor=[UIColor clearColor];
        //cell.textLabel.textColor=[UIColor yellowColor];
       
        //cell.iView.image=[UIImage imageNamed:@"music_pic1"];
        //cell.textLabel.text=listArray[indexPath.row];
        cell.textLabel.text=_ShowArray[indexPath.row][@"SONGNAME"];
      
        
        cell.detailTextLabel.text=[NSString stringWithFormat:@"%@--%@",_ShowArray[indexPath.row][@"ARTIST"],_ShowArray[indexPath.row][@"ALBUM"]];
        
        
        //ShowArray[indexPath.row][@"%@ -- %@"];
        //NSArray *Arr =[[NSArray alloc]initWithObjects:@"林俊杰",@"郑智化", nil];
        //cell.selectedImagView.hidden=YES;
        //cell.secondLab.text=
       // cell.secondLab.text=_ShowArray[indexPath.row][@"ARTIST"];
        
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
        
        playerView.hidden=NO;
        _currRow=indexPath.row;
         [self requesrForUrl:_ShowArray[indexPath.row]];
        
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
       [self requesrForUrl:_ShowArray[_currRow]];;
        
    }else{
        _currRow=0;
        
       [self requesrForUrl:_ShowArray[_currRow]];
        
    }
    
    

}
-(void)_forwardBtnClick{

    ++_currRow;
    if (_currRow<listArray.count) {
 [self requesrForUrl:_ShowArray[_currRow]];
        
    }else{
        _currRow=0;
        
    [self requesrForUrl:_ShowArray[_currRow]];
        
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
    
    
    [self requesrForUrl:_ShowArray[_currRow+1]];
}

-(void)requesrForUrl:(NSDictionary*)myDic{
    
    NSString *muUrl =[NSString stringWithFormat:@"http://antiserver.kuwo.cn/anti.s?type=convert_url&rid=%@&format=aac",myDic[@"MUSICRID"]];
    NSLog(@"MYURL====%@",muUrl);
//    NSString *urlstring= [muUrl  stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    NSLog(@"MYURL====%@",urlstring);
//
    [self requesrForPic:myDic];
   
    
    MyRequest *manager = [MyRequest requestBackurlString:muUrl];
    manager.backSuccessUrl = ^void(NSString*urlString)
    {
        
        [self _resetStreamerWithRow:urlString withaDIC:myDic];
        
    };

}
-(void)requesrForPic:(NSDictionary*)myDic{
    
    NSString *muUrl =[NSString stringWithFormat:@"http://player.kuwo.cn/webmusic/st/getNewMuiseByRid?rid=%@",myDic[@"MUSICRID"]];
    NSLog(@"MYURL====%@",muUrl);
    //    NSString *urlstring= [muUrl  stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //    NSLog(@"MYURL====%@",urlstring);
    //
    
    
    MyRequest *manager = [MyRequest requestBackurlString:muUrl];
    manager.backSuccessUrl = ^void(NSString*urlString)
    {
        
        NSLog(@"sahdffgdbgjkfdgjkfg=====%@",urlString);
        NSString *resultString=[urlString subStringFrom:@"<artist_pic>" to:@"</artist_pic>" ];
        NSLog(@"resultString=====%@",resultString);
        [logoImageView sd_setImageWithURL:[NSURL URLWithString:resultString] placeholderImage:[UIImage imageNamed:@"musicHead.png"] options:nil];

        
    };



}
- (void)_resetStreamerWithRow:(NSString*)urlstring withaDIC:(NSDictionary*)aDic;
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
    NSString *path =urlstring;
    _musicNameLab.text=aDic[@"SONGNAME"];
    
    
//    MyRequest *manger =[MyRequest requestWithURL:[NSString stringWithFormat:@"http://%@/httpapi.asp?command=setPlayerCmd:playlist:%@:%@",self.ipArray[0],path,@"%3c0%3e"]];
//        NSLog(@"%@",[NSString stringWithFormat:@"http://%@/httpapi.asp?command=setPlayerCmd:playlist:%@:%@",self.ipArray[0],path,@"%3c0%3e"]);
//    manger.backSuccess=^void(NSDictionary *dictt){
//        
//        
//        
//        
//        
//    };
   
    
        _audioPlayer = [CCAudioPlayer audioPlayerWithContentsOfURL:[NSURL URLWithString:path]];
    
    
    
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
       [self requesrForUrl:_ShowArray[_currRow]];

    }else{
        _currRow=0;
    
       [self requesrForUrl:_ShowArray[_currRow]];
    
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

@end
