//
//  ChangeViewController.h
//  Proxy_ios
//
//  Created by 刘康.Mac on 15/11/30.
//  Copyright © 2015年 keyuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChangeViewController : UIViewController
{
    NSString* xmlStr;
    NSDictionary* data;
    NSMutableArray* typeArray;
}

- (id)initWithXmlStr:(NSString *)xml data:(NSDictionary *)aData type:(NSArray *)aType title:(NSString *)aTitle;

@end
