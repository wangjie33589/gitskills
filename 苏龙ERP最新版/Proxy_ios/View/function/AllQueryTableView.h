//
//  AllQueryTableView.h
//  Proxy_ios
//
//  Created by 刘康.Mac on 15/12/8.
//  Copyright © 2015年 keyuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AllQueryTableView : UIView <UITableViewDelegate,UITableViewDataSource>
{
    NSDictionary* requestDict;
    UITableView* contenTableView;
    NSMutableArray* showArray;
    NSString* titleStr;
    NSMutableArray* showTitleArray;
}
- (id)initWithModel:(NSDictionary *)dict title:(NSString *)aStr;

@end
