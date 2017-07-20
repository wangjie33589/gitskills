//
//  PicViewController.h
//  KYSYCloud
//
//  Created by sciyonSoft on 16/3/8.
//  Copyright © 2016年 sciyonSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PicViewController : UIViewController
-(id)initWithArray:(NSArray*)aArr withDic:(NSDictionary*)aDic withTitleStr:(NSString *)title;
- (IBAction)deleBtn:(UIButton *)sender;
@property (strong, nonatomic) IBOutlet UILabel *label;
- (IBAction)compelteBtn:(UIButton *)sender;
@property (strong, nonatomic) IBOutlet UIButton *button;
@property (strong, nonatomic) IBOutlet UIButton *deleBtn;
@property(assign,nonatomic)int type;

@end
