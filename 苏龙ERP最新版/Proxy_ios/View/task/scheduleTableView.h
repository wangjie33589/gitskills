//
//  scheduleTableView.h
//  Proxy_ios
//
//  Created by E-Bans on 15/11/26.
//  Copyright © 2015年 keyuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol scheduleTableViewDelegate <NSObject>

-(void)RowViewController:(NSString *)xmlStr data:(NSDictionary *)aData rowData:(NSArray *)rowArray isType:(NSString *)type;

@end

@interface scheduleTableView : UIView <UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
{
    NSDictionary* dataDict;
    NSMutableArray* showArray;
    NSString* guid;
    NSString* title;
    UITableView* contenTableView;
    UIView* alert_View;
    NSMutableArray* isShowArray;
    UIView* btnView;
    NSInteger indexDel;
}

@property (nonatomic, unsafe_unretained) id<scheduleTableViewDelegate> delegate;

- (id)initWithModel:(NSDictionary *)data  guid:(NSString *)guidStr;

@end
