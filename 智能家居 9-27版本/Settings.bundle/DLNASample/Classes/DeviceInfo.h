/*******************************************************************************
 CopyRight:			Copyright 2009 hikvision. All rights reserved.
 FileName:			DeviceInfo.h
 Description:		device information headfile
 Author:			
 Data:				2009/08/25
 Modification History:
 *******************************************************************************/

#import <Foundation/Foundation.h>

@interface DeviceInfo : NSObject
{
	int			nDeviceID;			// device ID
	NSString	*chDeviceName;		// device name
	NSString	*chDeviceAddr;		// device address
	int			nDevicePort;		// device port
	NSString	*chLoginName;		// username
	NSString	*chPassWord;		// password
	int			nChannelNum;		// channel num

	bool		bLogined;
	long		lUserID;
	
	bool        bHaveIPChannel;     // have ip channel
	bool        bDeleted;           // device has been deleted
}

@property int nDeviceID;
@property int nDevicePort;
@property int nChannelNum;

@property bool bLogined;
@property long lUserID;
@property (nonatomic, retain) NSString *chDeviceName;
@property (nonatomic, retain) NSString *chDeviceAddr;
@property (nonatomic, retain) NSString *chLoginName;
@property (nonatomic, retain) NSString *chPassWord;

@property bool bHaveIPChannel;
@property bool bDeleted;
@end
