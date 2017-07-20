//
//  equipCheckDetilVC.h
//  KYSYCloud
//
//  Created by sciyonSoft on 16/2/29.
//  Copyright © 2016年 sciyonSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface equipCheckDetilVC : UIViewController
-(id)initWithDic:(NSDictionary*)dic withTitle:(NSString*)title;
@property (strong, nonatomic) IBOutlet UITableView *myTable;

@property(assign,nonatomic)int type;
@property(nonatomic,copy)NSString *Mcode;


@end
