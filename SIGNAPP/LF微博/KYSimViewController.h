//
//  KYSimViewController.h
//  科远签到
//
//  Created by sciyonSoft on 16/5/20.
//  Copyright © 2016年 lf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SFHFKeychainUtils.h"
@interface KYSimViewController : UIViewController
{
    UITextField * m_tfPw;   //手机序列号
    UITextField * m_tfemail;   //输入工号
    UITextField * m_server; //再次输入工号
    SFHFKeychainUtils * m_keychain;
    UILabel * showPswd ;  //显示密码
}
@property (nonatomic, retain) NSMutableArray *Data;
@property (nonatomic, retain) NSMutableArray *SaveData;
@end
