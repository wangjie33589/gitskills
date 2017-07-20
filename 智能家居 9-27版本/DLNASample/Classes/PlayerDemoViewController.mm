//
//  PlayerDemoViewController.m
//  PlayerDemo
//
//  Created by apple on 11-4-2.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//
#import "PlayerDemoViewController.h"
#import "CollectionViewCell.h"
#import "hcnetsdk.h"

#import "HikDec.h"
#import "OtherTest.h"
#import "VoiceTalk.h"
#import "Preview.h"
#import <Foundation/Foundation.h>
#include <stdio.h>
#include <ifaddrs.h>
#include <sys/socket.h>
#include <sys/poll.h>
#include <net/if.h>
#include <map>
#import <QuartzCore/QuartzCore.h>
#import "MyHeaderView.h"

@implementation PlayerDemoViewController

@synthesize	m_deviceIpField;
@synthesize	m_devicePortField;
@synthesize	m_uerNameField;
@synthesize	m_passwordField;
@synthesize m_playView;

@synthesize m_playButton;
@synthesize m_playbackButton;
@synthesize m_loginButton;
@synthesize m_getcfgButton;
@synthesize m_captureButton;
@synthesize m_recordButton;
@synthesize m_talkButton;
@synthesize m_ptzButton;
@synthesize m_otherButton;

@synthesize m_nPreviewPort;
@synthesize m_nPlaybackPort;
@synthesize m_fp;
@synthesize m_playThreadID;
@synthesize m_bThreadRun;
@synthesize m_lUserID;
@synthesize m_lRealPlayID;
@synthesize m_lPlaybackID;
@synthesize m_bPreview;
@synthesize m_bRecord;
@synthesize m_bPTZL;
@synthesize m_bVoiceTalk;
static NSString *headerIdentifier = @"HeaderView";
//static NSString *footerIdentifier = @"FooterView";

PlayerDemoViewController *g_pController = NULL;

int g_iStartChan = 0;
int g_iPreviewChanNum = 0;
bool g_bDecode = true;

-(instancetype)initWithAdic:(NSDictionary*)dic{
    
    self =[super init];
    if (self) {
        _fromDic=dic;
        
    }
    return self;
    
    
}

//playback callback function
void fPlayDataCallBack_V40(LONG lPlayHandle, DWORD dwDataType, BYTE *pBuffer,DWORD dwBufSize,void *pUser)
{
      PlayerDemoViewController *pDemo = (PlayerDemoViewController*)pUser;
	int i = 0;
    switch (dwDataType)
    {
        case NET_DVR_SYSHEAD:            
            if (dwBufSize > 0 && pDemo->m_nPlaybackPort == -1)
            {
                if(PlayM4_GetPort(&pDemo->m_nPlaybackPort) != 1)
                {
                    NSLog(@"PlayM4_GetPort failed:%d",  NET_DVR_GetLastError());
                    break;
                }
                if (!PlayM4_SetStreamOpenMode(pDemo->m_nPlaybackPort, STREAME_FILE))
                {
                    break;
                }
                if (!PlayM4_OpenStream(pDemo->m_nPlaybackPort, pBuffer , dwBufSize, 2*1024*1024))
                {
                    break;
                }
                pDemo->m_bPreview = 0;
                [pDemo startPlayer];
            }
            break;
        default:
            if (dwBufSize > 0 && pDemo->m_nPlaybackPort != -1)
            {
                for(i = 0; i < 4000; i++)
                {
                    if(PlayM4_InputData(pDemo->m_nPlaybackPort, pBuffer, dwBufSize))
                    {
                        break;
                    }  
                    usleep(10*1000);
                }
            }
            break;
    }	
}
void g_fExceptionCallBack(DWORD dwType, LONG lUserID, LONG lHandle, void *pUser)
{
    NSLog(@"g_fExceptionCallBack Type[0x%x], UserID[%d], Handle[%d]", dwType, lUserID, lHandle);
}
//other function button click up
-(IBAction)otherBtnClicked:(id)sender
{
    NSLog(@"otherBtnClicked");
    
//    TEST_Manage(m_lUserID, g_iStartChan);
//    TEST_PTZ(m_lRealPlayID, m_lUserID, g_iStartChan);
//    TEST_Config(m_lRealPlayID, m_lUserID, g_iStartChan);
//    TEST_Other(m_lRealPlayID, m_lUserID, g_iStartChan);
//    TEST_Alarm(m_lUserID);
    
   }
//ptz button click up
-(IBAction)ptzBtnClickedUp:(id)sender
{
    NSLog(@"ptzBtnClickedUp");
    if (m_bPTZL == true) {
        if(!NET_DVR_PTZControl_Other(m_lUserID, g_iStartChan, PAN_LEFT, 1))
        {
            NSLog(@"stop PAN_LEFT failed with[%d]", NET_DVR_GetLastError());
        }
        else
        {
            NSLog(@"stop PAN_LEFT succ");
        }
        [m_ptzButton setTitle:@"PTZ(R)" forState:UIControlStateNormal];
    }
    else
    {
        if(!NET_DVR_PTZControl_Other(m_lUserID, g_iStartChan, PAN_RIGHT, 1))
        {
            NSLog(@"stop PAN_RIGHT failed with[%d]", NET_DVR_GetLastError());
        }
        else
        {
            NSLog(@"stop PAN_RIGHT succ");
        }
        [m_ptzButton setTitle:@"PTZ(L)" forState:UIControlStateNormal];
    }
}
//ptz button click
-(IBAction)ptzBtnClicked:(id)sender
{    
    NSLog(@"ptzBtnClicked");
    if (m_lUserID < 0) {
        NSLog(@"Please logon a device first!");
        return;
    }
    if (m_bPTZL == false)
    {
        if(!NET_DVR_PTZControl_Other(m_lUserID, g_iStartChan, PAN_LEFT, 0))
        {
            NSLog(@"start PAN_LEFT failed with[%d]", NET_DVR_GetLastError());
        }
        else
        {
            NSLog(@"start PAN_LEFT succ");
        }
        m_bPTZL = true;
    }
    else
    {
        if(!NET_DVR_PTZControl_Other(m_lUserID, g_iStartChan, PAN_RIGHT, 0))
        {
            NSLog(@"start PAN_RIGHT failed with[%d]", NET_DVR_GetLastError());
        }
        else
        {
            NSLog(@"start PAN_RIGHT succ");
        }
        m_bPTZL = false;
    }
}

//开始对讲
//talk button click
-(IBAction)talkBtnClicked:(id)sender
{
    NSLog(@"talkBtnClicked");    
#if !TARGET_IPHONE_SIMULATOR
    if(!m_bVoiceTalk)
    {
        if(startVoiceTalk(m_lUserID) >= 0)
        {
            m_bVoiceTalk = true;
        }
    }
    else
    {
        stopVoiceTalk();
        m_bVoiceTalk = false;
    }
#endif
}
//开始录屏
// record button click while realplay
-(IBAction)recordBtnClicked:(id)sender
{
    NSLog(@"recordBtnClicked");
    if (m_bRecord == false)
    {
        if (m_lRealPlayID < 0) {
            NSLog(@"Please start realplay first!");
            return;
        }
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        char szFileName[256] = {0};
        NSString* date;
        NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"YYYY-MM-dd-hh-mm-ss"];
        date = [formatter stringFromDate:[NSDate date]];        
        sprintf(szFileName, "%s/%s.mp4", (char*)documentsDirectory.UTF8String, (char*)date.UTF8String);
        if (!NET_DVR_SaveRealData(m_lRealPlayID, szFileName)) {
            NSLog(@"NET_DVR_SaveRealData failed with[%d]", NET_DVR_GetLastError());
            return;
        }
        NSLog(@"NET_DVR_SaveRealData succ [%s]", szFileName);
        
        m_bRecord = true;
        [m_recordButton setTitle:@"Stop Record" forState:UIControlStateNormal];
    }
    else
    {
        NET_DVR_StopSaveRealData(m_lRealPlayID);
        m_bRecord = false;
        [m_recordButton setTitle:@"Start Record" forState:UIControlStateNormal];
    }
}
//截图按钮
// capture button click
-(IBAction)captureBtnClicked:(id)sender
{
    
    
    NSLog(@"captureBtnClicked");
    if (m_lRealPlayID < 0) {
        NSLog(@"Please start realplay first!");
        return;
    }
    int nHeight = 0;
    int nWidth = 0;
    if (!PlayM4_GetPictureSize(m_nPreviewPort, &nWidth, &nHeight)){
        NSLog(@"PlayM4_GetPictureSize fialed with[%d]", PlayM4_GetLastError(m_nPreviewPort));
        return;
    }
    //2cif -> 4cif
    if (nWidth == 704 && (nHeight == 288 || nHeight == 240)) {
        nHeight <<= 1;
    }
    
    int nSize = 5 * nWidth * nHeight;
    char *pBuf1 = new char[nSize];
    memset(pBuf1, 0, nSize);
    unsigned int  dwRet = 0;
    if (!PlayM4_GetBMP(m_nPreviewPort, (unsigned char*)pBuf1, nSize, &dwRet))
    {
        delete []pBuf1;
        pBuf1 = NULL;
        NSLog(@"PlayM4_GetBMP failed with[%d]", PlayM4_GetLastError(m_nPreviewPort));
        return;
    }
   
    
    // NSLog(@"PBF======%@",pBuf1);
    
    
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    char szFileName[256] = {0};
    NSString* date;
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"YYYY-MM-dd hh:mm:ss"];
    date = [formatter stringFromDate:[NSDate date]];
  
    sprintf(szFileName, "%s/%s.bmp", (char*)documentsDirectory.UTF8String, (char*)date.UTF8String);
    
    FILE *pFile = NULL;
    pFile = fopen(szFileName, "wb");
    fwrite(pBuf1, dwRet, 1, pFile);
    fclose(pFile);
    
    delete []pBuf1;
    pBuf1 = NULL;
    
    NSLog(@"capture bmp succ[%s]", szFileName);
    [self savePhoto];
    return;
}
// 保存图片到相册功能，ALAssetsLibraryiOS9.0 以后用photoliabary 替代，
-(void)savePhoto
{
    
    //UIImage * image = [self captureImageFromView:self.view];
    
    //ALAssetsLibrary * library = [ALAssetsLibrary new];
    
    UIImageView *imageView;
    UIGraphicsBeginImageContext(imageView.bounds.size);
    [imageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *temp=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIImageWriteToSavedPhotosAlbum(temp, nil, nil, nil);
    
    
}
//截图功能
-(UIImage *)captureImageFromView:(UIView *)view
{
    
    CGRect screenRect = [view bounds];
    
    UIGraphicsBeginImageContext(screenRect.size);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    [view.layer renderInContext:ctx];
    
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
    
}
//开始播放按钮



// preview button Click
-(IBAction) playerBtnClicked:(id)sender
{
	NSLog(@"liveStreamBtnClicked");

    [m_playButton setBackgroundImage:[UIImage imageNamed:@"vedioplay"] forState:0];
    if(g_iPreviewChanNum > 1)
    {
        if(!m_bPreview)
        {
            int iPreviewID[MAX_VIEW_NUM] = {0};
            for(int i = 0; i < MAX_VIEW_NUM; i++)
            {
                iPreviewID[i] = startPreview(m_lUserID, g_iStartChan, m_multiView[i], i);
            }
            m_lRealPlayID = iPreviewID[0];
            m_bPreview = true;
            [m_playButton setTitle:@"Stop Preview" forState:UIControlStateNormal];
        }
        else
        {
            for(int i = 0; i < MAX_VIEW_NUM; i++)
            {
                stopPreview(i);
            }
            m_bPreview = false;
            [m_playButton setTitle:@"Start Preview" forState:UIControlStateNormal];
        }
    }
    else
    {
        if(!m_bPreview)
        {
            m_lRealPlayID = startPreview(m_lUserID, g_iStartChan, m_playView, 0);
            m_bPreview = true;
            [m_playButton setTitle:@"Stop Preview" forState:UIControlStateNormal];
        }
        else
        {
            stopPreview(0);
            m_bPreview = false;
            [m_playButton setTitle:@"Start Preview" forState:UIControlStateNormal];
        }
    }
}

//config button click
-(IBAction) getcfgBtnClicked:(id)sender
{
	NSLog(@"getcfgBtnClicked");
    
    if(m_lUserID == -1)
    {
        NSLog(@"Please logon a device first!");
        return;
    }       
	
    NET_DVR_COMPRESSIONCFG_V30 struCompress = {0};
    DWORD dwRet = 0;
    if (!NET_DVR_GetDVRConfig(m_lUserID, NET_DVR_GET_COMPRESSCFG_V30, g_iStartChan, &struCompress, sizeof(struCompress), &dwRet))
    {
        NSLog(@"NET_DVR_GET_COMPRESSCFG_V30 failed with[%d]", NET_DVR_GetLastError());
    }
    else
    {
        NSLog(@"NET_DVR_GET_COMPRESSCFG_V30 succ");
    }
    //set substream resolution to cif
    struCompress.struNetPara.byResolution = 1;
    if (!NET_DVR_SetDVRConfig(m_lUserID, NET_DVR_SET_COMPRESSCFG_V30, g_iStartChan, &struCompress, sizeof(struCompress)))
    {
        NSLog(@"NET_DVR_SET_COMPRESSCFG_V30 failed with[%d]", NET_DVR_GetLastError());
    }
    else
    {
        NSLog(@"NET_DVR_SET_COMPRESSCFG_V30 succ");
    }
}

//init player for preview
//- (void) startPlay
//{
//       if(PlayM4_GetPort(&m_nPreviewPort) != 1)
//       {
//           NSLog(@"PlayM4_GetPort failed:%d",  NET_DVR_GetLastError());
//       }
//	return;
//}

//start player
- (void) startPlayer
{
	[self performSelectorOnMainThread:@selector(playerPlay) 
						   withObject:nil
						waitUntilDone:NO];
}

//play,the function PlayM4_Play must be called in main thread
- (void) playerPlay
{
    int nRet = 0;
    if(m_bPreview)
    {
        nRet = PlayM4_Play(m_nPreviewPort, m_playView);
        PlayM4_PlaySound(m_nPreviewPort);
    }
    else
    {
        nRet = PlayM4_Play(m_nPlaybackPort, m_playView);
        PlayM4_PlaySound(m_nPlaybackPort);
    }       
	if (nRet != 1)
	{
		NSLog(@"PlayM4_Play fail");
		[self stopPlay];
		return;
	}
}
- (void)previewPlay:(int*)iPlayPort playView:(UIView*)playView
{
    m_nPreviewPort = *iPlayPort;
    int iRet = PlayM4_Play(*iPlayPort, playView);
    PlayM4_PlaySound(*iPlayPort);
    if (iRet != 1)
    {
        NSLog(@"PlayM4_Play fail");
        [self stopPreviewPlay];
        return;
    }
}
- (void)stopPreviewPlay:(int*)iPlayPort
{
    PlayM4_StopSound();
    if (!PlayM4_Stop(*iPlayPort))
    {
        NSLog(@"PlayM4_Stop failed");
    }
    if(!PlayM4_CloseStream(*iPlayPort))
    {
        NSLog(@"PlayM4_CloseStream failed");
    }
    if (!PlayM4_FreePort(*iPlayPort))
    {
        NSLog(@"PlayM4_FreePort failed");
    }
    *iPlayPort = -1;
}

// playback button click (bytime)
-(IBAction) playbackBtnClicked:(id)sender
{
	NSLog(@"playbackBtnClicked");
       if (m_lPlaybackID == -1)
       {
           if(m_lUserID == -1)
           {
               NSLog(@"Please login on the device first!");
               return;
           }           
           
           NET_DVR_TIME struStartTime = {0};
           NET_DVR_TIME struEndTime = {0};
           struStartTime.dwYear = 2015;
           struStartTime.dwMonth = 12;
           struStartTime.dwDay = 24;
           
           struEndTime.dwYear = 2015;
           struEndTime.dwMonth = 12;
           struEndTime.dwDay = 25;
           
           m_lPlaybackID = NET_DVR_PlayBackByTime(m_lUserID, g_iStartChan, &struStartTime, &struEndTime, NULL);
           if (m_lPlaybackID == -1) 
           {
               NSLog(@"NET_DVR_PlayBackByTime failed:%d",  NET_DVR_GetLastError());
               UIAlertView *alert = [[UIAlertView alloc] 
                                     initWithTitle:kWarningTitle
                                     message:kRealPlayFailMsg
                                     delegate:nil 
                                     cancelButtonTitle:kWarningConfirmButton
                                     otherButtonTitles:nil];	
               [alert show];
               [alert release];               
        
               [self stopPlayback];
               return;
           }
           
           if (!NET_DVR_SetPlayDataCallBack_V40(m_lPlaybackID, fPlayDataCallBack_V40 , self))
           {
               NSLog(@"NET_DVR_SetPlayDataCallBack_V40 failed:%d",  NET_DVR_GetLastError());
               [self stopPlayback];
               return;
           }
           
           if (!NET_DVR_PlayBackControl_V40(m_lPlaybackID, NET_DVR_PLAYSTART, NULL, 0, NULL, NULL))
           {
               NSLog(@"NET_DVR_PlayBackControl_V40 failed:%d",  NET_DVR_GetLastError());
               [self stopPlayback];
               return;
           }
           [m_playbackButton setTitle:@"Stop Playback" forState:UIControlStateNormal];
       }
       else
       {
            [self stopPlayback];
            [m_playbackButton setTitle:@"Start Playback" forState:UIControlStateNormal];
       }
}
/*
 // playback button click (by Name)
-(IBAction) playbackBtnClicked:(id)sender
{
    NSLog(@"playbackBtnClicked");
    if (m_lPlaybackID == -1)
    {
        if(m_lUserID == -1)
        {
            NSLog(@"Please login on the device first!");
            return;
        }
        
        m_lPlaybackID = NET_DVR_PlayBackByName(m_lUserID, "ch01_08000000000000000", NULL);
        if (m_lPlaybackID == -1)
        {
            NSLog(@"NET_DVR_PlayBackByName failed:%d",  NET_DVR_GetLastError());
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:kWarningTitle
                                  message:kRealPlayFailMsg
                                  delegate:nil
                                  cancelButtonTitle:kWarningConfirmButton
                                  otherButtonTitles:nil];
            [alert show];
            [alert release];
            
            [self stopPlayback];
            return;
        }
        
        if (!NET_DVR_SetPlayDataCallBack_V40(m_lPlaybackID, fPlayDataCallBack_V40 , self))
        {
            NSLog(@"NET_DVR_SetPlayDataCallBack_V40 failed:%d",  NET_DVR_GetLastError());
            [self stopPlayback];
            return;
        }
        
        if (!NET_DVR_PlayBackControl_V40(m_lPlaybackID, NET_DVR_PLAYSTART, NULL, 0, NULL, NULL))
        {
            NSLog(@"NET_DVR_PlayBackControl_V40 failed:%d",  NET_DVR_GetLastError());
            [self stopPlayback];
            return;
        }
        [m_playbackButton setTitle:@"Stop Playback" forState:UIControlStateNormal];
    }
    else
    {
        [self stopPlayback];
        [m_playbackButton setTitle:@"Start Playback" forState:UIControlStateNormal];
    }
}
*/

// login button clickƒ

-(IBAction) loginBtnClicked:(id)sender
{
    NSLog(@"loginBtnClicked");
    // init
    BOOL bRet = NET_DVR_Init();
    if (!bRet)
    {
        NSLog(@"NET_DVR_Init failed");
    }
    NET_DVR_SetExceptionCallBack_V30(0, NULL, g_fExceptionCallBack, NULL);
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    const char* pDir = [documentPath UTF8String];
    NET_DVR_SetLogToFile(3, (char*)pDir, true);
    if (m_lUserID == -1)
    {                  
        //  Get value
//        NSString * iP = m_deviceIpField.text;
//        NSString * port = m_devicePortField.text;
//        NSString * usrName = m_uerNameField.text;
//        NSString * password = m_passwordField.text;
        
        
        NSString * iP =IP;
        NSString * port = Port;
        NSString * usrName = User;
        NSString * password = Psd;

        
        DeviceInfo *deviceInfo = [[DeviceInfo alloc] init];
        deviceInfo.chDeviceAddr = iP;
        deviceInfo.nDevicePort = [port integerValue];
        deviceInfo.chLoginName = usrName;
        deviceInfo.chPassWord = password;
        
        // check valid
        if (![self validateValue:deviceInfo])
        {
            return;
        }
        
        // device login
        NET_DVR_DEVICEINFO_V30 logindeviceInfo = {0};
        
        // encode type
        NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        m_lUserID = NET_DVR_Login_V30((char*)[deviceInfo.chDeviceAddr UTF8String], 
                                      deviceInfo.nDevicePort, 
                                      (char*)[deviceInfo.chLoginName cStringUsingEncoding:enc], 
                                      (char*)[deviceInfo.chPassWord UTF8String], 
                                      &logindeviceInfo);
        
        printf("iP:%s\n", (char*)[deviceInfo.chDeviceAddr UTF8String]);
        printf("Port:%d\n", deviceInfo.nDevicePort);
        printf("UsrName:%s\n", (char*)[deviceInfo.chLoginName cStringUsingEncoding:enc]);
        printf("Password:%s\n", (char*)[deviceInfo.chPassWord UTF8String]);
        
        // login on failed
        if (m_lUserID == -1)
        {
            UIAlertView *alert = [[UIAlertView alloc] 
                                  initWithTitle:kWarningTitle
                                  message:kLoginDeviceFailMsg
                                  delegate:nil 
                                  cancelButtonTitle:kWarningConfirmButton
                                  otherButtonTitles:nil];	
            [alert show];
            [alert release];		
            return;
        }
        
        if(logindeviceInfo.byChanNum > 0)
        {
            g_iStartChan = logindeviceInfo.byStartChan;
            g_iPreviewChanNum = logindeviceInfo.byChanNum;
        }
        else if(logindeviceInfo.byIPChanNum > 0)
        {
            g_iStartChan = logindeviceInfo.byStartDChan;
            g_iPreviewChanNum = logindeviceInfo.byIPChanNum + logindeviceInfo.byHighDChanNum * 256;
        }
        
        [m_loginButton setTitle:@"Logout" forState:UIControlStateNormal];
    }
    else 
    {
        NET_DVR_Logout(m_lUserID);
        NET_DVR_Cleanup();
        m_lUserID = -1;
        [m_loginButton setTitle:@"Login" forState:UIControlStateNormal];
    }	
}
-(void)loginSucess{
    NSLog(@"loginBtnClicked");
    // init
    BOOL bRet = NET_DVR_Init();
    if (!bRet)
    {
        NSLog(@"NET_DVR_Init failed");
    }
    NET_DVR_SetExceptionCallBack_V30(0, NULL, g_fExceptionCallBack, NULL);
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    const char* pDir = [documentPath UTF8String];
    NET_DVR_SetLogToFile(3, (char*)pDir, true);
    if (m_lUserID == -1)
    {
        //  Get value
        //        NSString * iP = m_deviceIpField.text;
        //        NSString * port = m_devicePortField.text;
        //        NSString * usrName = m_uerNameField.text;
        //        NSString * password = m_passwordField.text;
        
        
        NSString * iP =_fromDic[@"videoip"];
        NSString * port = _fromDic[@"port"];
        NSString * usrName = _fromDic[@"loginname"];
        NSString * password = _fromDic[@"loginpwd"];
        NSLog(@"ip====%@ port=====%@ username===%@ password===%@",iP,port,usrName,password);
        
        
        
        DeviceInfo *deviceInfo = [[DeviceInfo alloc] init];
        deviceInfo.chDeviceAddr = iP;
        deviceInfo.nDevicePort = [port integerValue];
        deviceInfo.chLoginName = usrName;
        deviceInfo.chPassWord = password;
        
        // check valid
        if (![self validateValue:deviceInfo])
        {
            [SVProgressHUD dismiss];
            return;
        }
        
        // device login
        NET_DVR_DEVICEINFO_V30 logindeviceInfo = {0};
        
        // encode type
        NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        m_lUserID = NET_DVR_Login_V30((char*)[deviceInfo.chDeviceAddr UTF8String],
                                      deviceInfo.nDevicePort,
                                      (char*)[deviceInfo.chLoginName cStringUsingEncoding:enc],
                                      (char*)[deviceInfo.chPassWord UTF8String],
                                      &logindeviceInfo);
        
        printf("iP:%s\n", (char*)[deviceInfo.chDeviceAddr UTF8String]);
        printf("Port:%d\n", deviceInfo.nDevicePort);
        printf("UsrName:%s\n", (char*)[deviceInfo.chLoginName cStringUsingEncoding:enc]);
        printf("Password:%s\n", (char*)[deviceInfo.chPassWord UTF8String]);
        
        // login on failed
        if (m_lUserID == -1)
        {
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:kWarningTitle
                                  message:kLoginDeviceFailMsg
                                  delegate:nil
                                  cancelButtonTitle:kWarningConfirmButton
                                  otherButtonTitles:nil];
            [alert show];
            [alert release];
            return;
        }
        
        if(logindeviceInfo.byChanNum > 0)
        {
            g_iStartChan = logindeviceInfo.byStartChan;
            g_iPreviewChanNum = logindeviceInfo.byChanNum;
        }
        else if(logindeviceInfo.byIPChanNum > 0)
        {
            g_iStartChan = logindeviceInfo.byStartDChan;
            g_iPreviewChanNum = logindeviceInfo.byIPChanNum + logindeviceInfo.byHighDChanNum * 256;
        }
        
        [m_loginButton setTitle:@"Logout" forState:UIControlStateNormal];
    }
    else
    {
        NET_DVR_Logout(m_lUserID);
        NET_DVR_Cleanup();
        m_lUserID = -1;
        [m_loginButton setTitle:@"Login" forState:UIControlStateNormal];
    }	
    [SVProgressHUD  dismiss];
   
}

//stop preview
-(void) stopPlay
{
	if (m_lRealPlayID != -1)
	{
		NET_DVR_StopRealPlay(m_lRealPlayID);
		m_lRealPlayID = -1;		
	}
	
       if(m_nPreviewPort >= 0)
       {
           if(!PlayM4_StopSound())
           {
               NSLog(@"PlayM4_StopSound failed");
           }
           if (!PlayM4_Stop(m_nPreviewPort))
           {
               NSLog(@"PlayM4_Stop failed");
           }
           if(!PlayM4_CloseStream(m_nPreviewPort))
           {
               NSLog(@"PlayM4_CloseStream failed");
           }
           if (!PlayM4_FreePort(m_nPreviewPort))
           {
               NSLog(@"PlayM4_FreePort failed");
           }
             m_nPreviewPort = -1;
       }
}

//stop playback
- (void) stopPlayback
{
    if (m_lPlaybackID != -1)
    {
            NET_DVR_StopPlayBack(m_lPlaybackID);
            m_lPlaybackID = -1;
    }
    
    if(m_nPlaybackPort >= 0)
    {
        if (!PlayM4_Stop(m_nPlaybackPort)) 
        {
            NSLog(@"PlayM4_Stop failed");
        }
        if(!PlayM4_CloseStream(m_nPlaybackPort))
        {
            NSLog(@"PlayM4_CloseStream failed");
        }
        if (!PlayM4_FreePort(m_nPlaybackPort))
        {
            NSLog(@"PlayM4_FreePort failed");
        }
        m_nPlaybackPort = -1;
    }    
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad 
{
    self.title=@"监控详情";
    playBtnflag=0;
    [SVProgressHUD showWithStatus:@"努力加载中..."];
    
    [self requestForShowData];
    
    
    m_lUserID = -1;
	m_lRealPlayID = -1;
    m_lPlaybackID = -1;
    m_nPreviewPort = -1;
    m_nPlaybackPort = -1;
    m_bRecord = false;
    m_bPTZL = false;
	//[self starPlay];
	
    int nWidth = m_playView.frame.size.width / 2;
    int nHeight = m_playView.frame.size.height / 2;
    for(int i = 0; i < MAX_VIEW_NUM; i++)
    {
        m_multiView[i] = [[UIView alloc] initWithFrame:CGRectMake((i%(MAX_VIEW_NUM/2)) * nWidth, (i/(MAX_VIEW_NUM/2)) * nHeight, nWidth - 1, nHeight - 1)];
        m_multiView[i].backgroundColor = [UIColor clearColor];
        [m_playView addSubview:m_multiView[i]];
    }
    
    
	// hide keybord
	[[NSNotificationCenter defaultCenter] addObserver:self                                                          
											 selector:@selector(keyboardWillHide:)                                                                  
												 name:UIKeyboardWillHideNotification
											   object:nil];
    g_pController = self;
    
    [self loginSucess];
    [self initCollectView];
	[super viewDidLoad];
    
    
}
-(void)requestForShowData{
    
    NSString *muUrl =[NSString stringWithFormat:@"http://%@",HTTPIP];
    
    NSString *urlstring=[NSString stringWithFormat:@"{\"funcode\":\"10801\",\"videotypeid\":\"%@\",\"serverid\":\"%@\",\"actuserid\":\"%@\"}",@"10086",@"2001",USER_ID];
    NSDictionary *dict =[NSDictionary dictionaryWithObjectsAndKeys:urlstring,@"jsonrequest", nil];
    
    // NSLog(@"sadfsdfhbgh===%@",newurlString);
    MyRequest *manager = [MyRequest requestWithURL:muUrl withParameter:dict];
    manager.backSuccess = ^void(NSDictionary *dictt)
    {
        if (  [[dictt objectForKey:@"SS"] integerValue]==200) {
            // NSLog(@"dict:==%@",dictt[@"DATA"]);
            self.showArray=dictt[@"DATA"];
            //            [self requestForType];
            [collectView reloadData];
            NSLog(@"_AreaArray====%@",_showArray);
        }else{
            
            [SVProgressHUD showErrorWithStatus:[dictt objectForKey:@"MSG"]];
            
        }
    };
    
    
    
    
    
    
    
    
    
    
    
}


-(void)initCollectView{
    
    
    UICollectionViewFlowLayout *layout =[[UICollectionViewFlowLayout alloc]init];
    layout.itemSize=CGSizeMake(LWidth/2-5,LWidth/2-5);
    //上左下右
    layout.sectionInset=UIEdgeInsetsMake(10,0, 200,0);
    [layout setHeaderReferenceSize:CGSizeMake(collectView.frame.size.width,44)];
 
    layout.minimumLineSpacing=10;
    collectView =[[UICollectionView alloc]initWithFrame:CGRectMake(0, self.myView.frame.origin.y+50, LWidth, LHeight) collectionViewLayout:layout];
    collectView.backgroundColor=[UIColor clearColor];
    collectView.delegate=self;
    collectView.dataSource=self;
 
    [collectView registerNib:[UINib nibWithNibName:@"CollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];
    [collectView registerClass:[MyHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerIdentifier];
    [self.view addSubview:collectView];
    
   
    
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    
    
    return self.showArray.count;
    
    
    
}
-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CollectionViewCell *cell =[[collectionView  dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath]autorelease];
    cell.backgroundColor=[UIColor whiteColor];
    cell.label.text=self.showArray[indexPath.row][@"videoname"];
    //    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@%@%@",HTTPIP,IMAGE_URL,_showArray[indexPath.row][@"areaimg"]]]
    cell.imageView.image =[UIImage imageNamed:@"video2"];
    return cell;
    
    
    
    
    
    
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
//    //    TypeDetilViewController *vc =[[TypeDetilViewController alloc]init];
//    //    [self.navigationController pushViewController:vc animated:YES];
//    PlayerDemoViewController *vc =[[PlayerDemoViewController alloc]init];
//    [self.navigationController pushViewController:vc  animated:YES];
//    //
//    
    
    
}
//设置头尾部内容
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableView =nil;
    
    if (kind ==UICollectionElementKindSectionHeader) {
        //定制头部视图的内容
        MyHeaderView *headerV = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:headerIdentifier forIndexPath:indexPath];
        if (indexPath.section == 0) {
            headerV.titleLab.text = @"查看其它监控";
        }
        if (indexPath.section ==1 ) {
            headerV.titleLab.text = @"场景:";
        }
        
        reusableView = headerV;
    }
//    if (kind ==UICollectionElementKindSectionFooter) {
//        MyFooterView *footerV = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:footerIdentifier forIndexPath:indexPath];
//        if (indexPath.section==1) {
//            footerV.titleLab1.text = @"";
//        }
//        reusableView = footerV;
//    }

    return reusableView;
}

-(void) loginMultiThread
{
    NET_DVR_DEVICEINFO_V30 devInfo = {0};
    int lLoginID = NET_DVR_Login_V30("10.17.133.35", 8000, "admin", "12345", &devInfo);
    if(lLoginID >= 0)
    {
        NSLog(@"NET_DVR_Login_V30 succ[%d]", lLoginID);
    }
    else
    {
        NSLog(@"NET_DVR_Login_V30 failed[%d]", NET_DVR_GetLastError());
    }
    NET_DVR_Logout(lLoginID);
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning 
{
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload 
{

	if (m_lRealPlayID != -1)
	{
		NET_DVR_StopRealPlay(m_lRealPlayID);
		m_lRealPlayID = -1;
	}
    
       if(m_lPlaybackID != -1)
       {
           NET_DVR_StopPlayBack(m_lPlaybackID);
           m_lPlaybackID = -1;
       }
    
       if(m_lUserID != -1)
       {
           NET_DVR_Logout(m_lUserID);
           NET_DVR_Cleanup();
           m_lUserID = -1;
       }
}

/*******************************************************************************
 Function:			validateValue
 Description:		check valid
 Input:				deviceInfo － device info
 Output:			
 Return:			true-valid;false-invalid
 *******************************************************************************/
- (bool) validateValue:(DeviceInfo *)deviceInfo
{
	// check device address
	if ([deviceInfo.chDeviceAddr compare:@""] == NSOrderedSame)
	{
		UIAlertView *alert = [[UIAlertView alloc] 
							  initWithTitle:kWarningTitle
							  message:kDeviceAddrEmptyMsg
							  delegate:nil 
							  cancelButtonTitle:kWarningConfirmButton
							  otherButtonTitles:nil];
		[alert show];
		[alert release];
		
		return false;
	}
	
	// check length of device address
	if ([deviceInfo.chDeviceAddr lengthOfBytesUsingEncoding:NSUTF8StringEncoding] > 32)
	{
		UIAlertView *alert = [[UIAlertView alloc] 
							  initWithTitle:kWarningTitle
							  message:kDeviceAddrTooLongerMsg
							  delegate:nil 
							  cancelButtonTitle:kWarningConfirmButton
							  otherButtonTitles:nil];	
		[alert show];
		[alert release];
		
		return false;
	}
	
	// whether valid ip
	if (![self isValidIP:deviceInfo.chDeviceAddr])
	{
		UIAlertView *alert = [[UIAlertView alloc] 
							  initWithTitle:kWarningTitle
							  message:kDeviceAddrInvalidMsg
							  delegate:nil 
							  cancelButtonTitle:kWarningConfirmButton
							  otherButtonTitles:nil];	
		[alert show];
		[alert release];
		
		return false;
	}
	
	// check port
	if (deviceInfo.nDevicePort == 0)
	{
		UIAlertView *alert = [[UIAlertView alloc] 
							  initWithTitle:kWarningTitle
							  message:kDevicePortEmptyMsg
							  delegate:nil 
							  cancelButtonTitle:kWarningConfirmButton
							  otherButtonTitles:nil];	
		[alert show];
		[alert release];
		
		return false;
	}
	
	// check username
	if ([deviceInfo.chLoginName compare:@""] == NSOrderedSame)
	{
		UIAlertView *alert = [[UIAlertView alloc] 
							  initWithTitle:kWarningTitle
							  message:kDeviceUserNameEmptyMsg
							  delegate:nil 
							  cancelButtonTitle:kWarningConfirmButton
							  otherButtonTitles:nil];	
		[alert show];
		[alert release];
	
		return false;
	}
	
	// check username length
	if ([deviceInfo.chLoginName lengthOfBytesUsingEncoding:NSUTF8StringEncoding] > 64)
	{
		UIAlertView *alert = [[UIAlertView alloc] 
							  initWithTitle:kWarningTitle
							  message:kDeviceUserNameTooLongerMsg
							  delegate:nil 
							  cancelButtonTitle:kWarningConfirmButton
							  otherButtonTitles:nil];	
		[alert show];
		[alert release];
		
		return false;
	}
	
	// check password length
	if ([deviceInfo.chPassWord lengthOfBytesUsingEncoding:NSUTF8StringEncoding] > 16)
	{
		UIAlertView *alert = [[UIAlertView alloc] 
							  initWithTitle:kWarningTitle
							  message:kDevicePasswordTooLongerMsg
							  delegate:nil 
							  cancelButtonTitle:kWarningConfirmButton
							  otherButtonTitles:nil];	
		[alert show];
		[alert release];
		
		return false;
	}
	
	return true;
}

#pragma mark -
#pragma mark textField UITextField Delegate methods

/*******************************************************************************
 Function:			textFieldEditingDidBegin
 Description:		enter edit box,hide picture,controller up
 Input:				sender － button down
 Output:			
 Return:			
 *******************************************************************************/
- (IBAction) textFieldEditingDidBegin:(id)sender
{
	[UIView beginAnimations:@"login.animation" context:nil];
	
	[UIView commitAnimations];	
}

/*******************************************************************************
 Function:			textFieldEditingDidEndOnExit
 Description:		exit edit box,hide picture,controller focus change
 Input:				sender － button down
 Output:			
 Return:			
 *******************************************************************************/
- (IBAction) textFieldEditingDidEndOnExit:(id)sender
{
	// foucs on username edit box,click done,focus on password edit box
	if (sender == m_deviceIpField)
	{
		[m_devicePortField becomeFirstResponder];
	}
	
	else if (sender == m_devicePortField)
	{
		[m_uerNameField becomeFirstResponder];
	}
	
	else if (sender == m_uerNameField)
	{
		[m_passwordField becomeFirstResponder];
	}
	
	// if focus on password edit box,click done,revert GUI
	else if (sender == m_passwordField)
	{
		[UIView beginAnimations:@"login.animation" context:nil];
	}
	else 
	{
		// do nothing
	}
}

/*******************************************************************************
 Function:			isValidIP
 Description:		check ip
 Input:				ipStr － IP address
 Output:			
 Return:			true-valid,false-invalid
 *******************************************************************************/
- (bool)isValidIP:(NSString *)ipStr
{
	const char* ip = [ipStr cStringUsingEncoding:NSUTF8StringEncoding];
	
	// check invalid char
	int temp = 0;
	for (int i = 0; i < strlen(ip); i++)
	{
		// <1 or > 9,invalid char
		temp = (int)ip[i];
		if ((temp >= 48 && temp <= 57) || temp == 46)
		{
			continue;
		}
		else
		{
			return false;
		}
	}
	
	int n;
    unsigned int a, b, c, d;
    if(strlen(ip) <= 15 && 
       sscanf(ip, "%3u.%3u.%3u.%3u%n", &a, &b, &c, &d, &n) >= 4 
       && n == static_cast<int>(strlen(ip))) 
    {
		return (a > 0 && a <= 255 && b <= 255 && c <= 255 && d <= 255 && d > 0) || (a == 0 && b== 0 && c == 0 && d == 0);
    }
    return false;
}

/*******************************************************************************
 Function:			keyboardWillHide
 Description:		exit edit box,hide picture,controller focus change
 Input:				note － keyboard hide
 Output:			
 Return:			
 *******************************************************************************/
- (IBAction)keyboardWillHide:(NSNotification *)note
{
	[UIView beginAnimations:@"login.animation" context:nil];
	[UIView commitAnimations];
}

// hide copy and paste button
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
	[UIMenuController sharedMenuController].menuVisible = NO;
	
	return YES;
}

- (void)dealloc 
{
	if (m_playView != nil)
	{
		[m_playView release];
		m_playView = nil;
	}
	
	if (m_playThreadID != nil)
	{
		[m_playThreadID release];
		m_playThreadID = nil;
	}
	
    [super dealloc];
}

@end