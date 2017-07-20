/*
 *  HikDec.h
 *  PlayerDemo
 *
 *  Created by apple on 11-8-9.
 *  Copyright 2011 __MyCompanyName__. All rights reserved.
 *
 */

/////////////////////////
// 10. warning
/////////////////////////
#define kWarningTitle							NSLocalizedString(@"Warning", @"Alert Warning Title") 
#define kWarningConfirmButton					NSLocalizedString(@"Confirm", @"Alert Confrim Button") 

// device manage
#define kDeviceNameEmptyMsg						NSLocalizedString(@"Device name cannot be null", @"Alert Msg Device Name Empty Fail")
#define kDeviceNameTooLongerMsg					NSLocalizedString(@"Length of device name cannot exceed 32 characters", @"Alert Msg Device name too longer")
#define kDeviceAddrEmptyMsg						NSLocalizedString(@"Device address cannot be null", @"Alert Msg Device Address Empty Fail")
#define kDeviceAddrTooLongerMsg					NSLocalizedString(@"Length of device address cannot exceed 128 characters", @"Alert Msg Device address too longer")
#define kDevicePortEmptyMsg						NSLocalizedString(@"Device port cannot be null", @"Alert Msg Device Port Empty Fail")
#define kDeviceUserNameEmptyMsg					NSLocalizedString(@"Device user name cannot be null", @"Alert Msg Device User Name Empty Fail")
#define kDeviceUserNameTooLongerMsg				NSLocalizedString(@"Length of device user name cannot exceed 32 characters", @"Alert Msg Device user name too longer")
#define kDevicePasswordEmptyMsg					NSLocalizedString(@"Device password cannot be null", @"Alert Msg Device Password Empty Fail")
#define kDevicePasswordTooLongerMsg				NSLocalizedString(@"Length of device password cannot exceed 16 characters", @"Alert Msg Device password too longer")
#define kDeviceChannNoEmptyMsg					NSLocalizedString(@"Device channel No. cannot be null", @"Alert Msg Device Channel No. Empty Fail")
#define kDeviceAddrInvalidMsg					NSLocalizedString(@"Device address is invalid", @"Alert Msg Invalid IP Fail")

// sdk error message
#define kNetDvrInitFailMsg						NSLocalizedString(@"Init Net SDK failed", @"NET SDK Init Fail")
#define kLoginDeviceFailMsg						NSLocalizedString(@"Device login failed", @"Alert Msg Login Fail")
#define kGetIPCfgFailMsg						NSLocalizedString(@"Get Ip Channel Info failed", @"Alert Msg Get Ip Channel Info Fail")
#define kGetDeviceCompressFailMsg				NSLocalizedString(@"Get remote config parameters failed", @"Alert Msg Get Remote Config Info Fail")
#define kSetDeviceCompressFailMsg				NSLocalizedString(@"Set remote config parameters failed", @"Alert Msg Set Remote Config Info Fail")
#define kRealPlayFailMsg						NSLocalizedString(@"Realplay Fail", @"Alert Msg Realplay Fail")

#define kNetDvrErrorNoError						NSLocalizedString(@"No error", @"Alert Msg Net Dvr Error:DVR_No_Error")
#define kNetDvrErrorUserPwdError				NSLocalizedString(@"User name or password error", @"Alert Msg Net Dvr Error:DVR_USERPASSWORD_ERROR")
#define kNetDvrErrorNoEnoughPri					NSLocalizedString(@"No enough permission", @"Alert Msg Net Dvr Error:DVR_NOENOUGHPRI")
#define kNetDvrErrorNoInit						NSLocalizedString(@"Not init", @"Alert Msg Net Dvr Error:DVR_NOINIT")
#define kNetDvrErrorChannelError				NSLocalizedString(@"Channel No. error", @"Alert Msg Net Dvr Error:DVR_CHANNEL_ERROR")
#define kNetDvrErrorOverMaxLink					NSLocalizedString(@"DVR over max link", @"Alert Msg Net Dvr Error:DVR_OVER_MAXLINK")
#define kNetDvrErrorVersionNoMatch				NSLocalizedString(@"DVR version not match", @"Alert Msg Net Dvr Error:DVR_VERSIONNOMATCH")
#define kNetDvrErrorNetworkConnectFail			NSLocalizedString(@"DVR network connect failed", @"Alert Msg Net Dvr Error:DVR_NETWORK_FAIL_CONNECT")
#define kNetDvrErrorNetworkSendError			NSLocalizedString(@"DVR network send failed", @"Alert Msg Net Dvr Error:DVR_NETWORK_SEND_ERROR")
#define kNetDvrErrorNetworkRecError				NSLocalizedString(@"DVR network receive failed", @"Alert Msg Net Dvr Error:DVR_NETWORK_RECV_ERROR")
#define kNetDvrErrorNetworkTimeOutError			NSLocalizedString(@"DVR network receive timeout", @"Alert Msg Net Dvr Error:DVR_NETWORK_RECV_TIMEOUT")
#define kNetDvrErrorNetworkDataError			NSLocalizedString(@"DVR network send data error", @"Alert Msg Net Dvr Error:DVR_NETWORK_ERRORDATA")
#define kNetDvrErrorOrderError					NSLocalizedString(@"DVR order error", @"Alert Msg Net Dvr Error:DVR_ORDER_ERROR")
#define kNetDvrErrorOperNoPermit				NSLocalizedString(@"DVR Operation no permission", @"Alert Msg Net Dvr Error:DVR_OPERNOPERMIT")
#define kNetDvrErrorCommandTimeOut				NSLocalizedString(@"DVR command timeout", @"Alert Msg Net Dvr Error:DVR_COMMANDTIMEOUT")
#define kNetDvrErrorNoSupport                   NSLocalizedString(@"DVR not support", @"Alert Msg Net Dvr Error:NET_DVR_NOSUPPORT")
