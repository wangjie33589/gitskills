//
//  ContensView.h
//  Proxy_ios
//
//  Created by 刘康.Mac on 15/11/22.
//  Copyright © 2015年 keyuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewsModel.h"

@protocol ContensViewDelegate <NSObject>

-(void)pushNewsViewController:(NSString *)aGuid;

@end

@interface ContensView : UIView <UITableViewDataSource,UITableViewDelegate>
{
    UITableView* contenTableView;
    NSUInteger startIndex;;
}

@property (nonatomic, unsafe_unretained) id<ContensViewDelegate> delegate;
@property (nonatomic, strong) NewsModel* model;
@property (nonatomic, strong) NSMutableArray* dataArray;

- (id)initWithModel:(NewsModel *)aModel;

@end
