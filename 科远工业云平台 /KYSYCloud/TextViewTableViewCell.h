//
//  TextViewTableViewCell.h
//  KYSYCloud
//
//  Created by sciyonSoft on 16/3/3.
//  Copyright © 2016年 sciyonSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TextViewTableViewCell : UITableViewCell<UITextViewDelegate>
@property (strong, nonatomic) IBOutlet UITextView *txtView;

@end
