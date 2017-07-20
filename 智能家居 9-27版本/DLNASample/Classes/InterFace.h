#ifndef __INTER_FACE_H__
#define __INTER_FACE_H__

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#include"HikDefine.h"

#ifndef CALLBACK
#define CALLBACK
#endif
typedef void(CALLBACK* fVideoCallBackFunc)(HK_DWORD dwType,  HK_DWORD dwWidth , HK_DWORD dwHeight, HK_PBYTE pData, void *pUser);

// Create player Handle
HK_HANDLE		HK_IPHONE_CreateHandle();    

// Destroy player Handle
HK_VOID			HK_IPHONE_DestroyHandle(HK_HANDLE hPlayHandle);   

// Set PlayView to handle
HK_HRESULT		HK_IPHONE_SetDisplay(HK_HANDLE hPlayHandle , UIView* playView);  

// play
HK_HRESULT		HK_IPHONE_Play(HK_HANDLE hPlayHandle);  

// pause
//HK_HRESULT		HK_IPHONE_Pause(HK_HANDLE hPlayHandle); 

// stop
HK_HRESULT		HK_IPHONE_Stop(HK_HANDLE hPlayHandle); 

// Input Stream Data
HK_HRESULT		HK_IPHONE_InputData(HK_HANDLE hPlayHandle, HK_PBYTE pStreamData, HK_DWORD dwSize, HK_DWORD dwType); 

// Set Frame Rate
/*HK_HRESULT		HK_IPHONE_SetFRate(HK_HANDLE hPlayHandle, HK_FLOAT fFrate); 

// Play Local file
HK_HRESULT		HK_IPHONE_PlayLocalFile(HK_HANDLE hPlayHandle, HK_CHAR* filePath , UIView* playView); 

// Get Total Frame
HK_HRESULT		HK_IPHONE_GetTotalFrame(HK_HANDLE hPlayHandle);         

// Play one Frame
HK_HRESULT		HK_IPHONE_PlayOneFrame(HK_HANDLE hPlayHandle, HK_DWORD dwFrameNum);   */                 

// Capture
HK_HRESULT		HK_IPHONE_Capture(HK_HANDLE hPlayHandle);                          

// Set Callback Function
/*HK_HRESULT		HK_IPHONE_SetVideoCallBack(HK_HANDLE hPlayHandle, fVideoCallBackFunc fVideoCallBack, void* pUser);

// Set Secret key
HK_HRESULT		HK_IPHONE_SetSecretKey(HK_HANDLE hPlayHandle, HK_LONG lKeyType, char* pSecretKey, HK_LONG lKeyLen);

// Set Show Video
HK_HRESULT		HK_IPHONE_ShowVideo(HK_HANDLE hPlayHandle, HK_BOOL bShow);*/

#endif