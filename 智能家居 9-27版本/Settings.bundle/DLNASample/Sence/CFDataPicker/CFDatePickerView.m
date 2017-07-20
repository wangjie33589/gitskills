//
//  CFDatePickerView.m
//  CFDatePickerDemo
//
//  Created by TheMoon on 16/3/22.
//  Copyright © 2016年 CFJ. All rights reserved.
//

#import "CFDatePickerView.h"
#import "UIViewExt.h"
@interface CFDatePickerView ()

@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end



@implementation CFDatePickerView

+ (instancetype)datePickerViewWithFrame:(CGRect)frame cornorType:(CornorType) cornorType{
    CFDatePickerView *datePickerView = [[NSBundle mainBundle] loadNibNamed:@"CFDatePickerView" owner:self options:nil].lastObject;
    
    datePickerView.frame = frame;

    if (cornorType == CornorType_Circle) {
        [datePickerView setupCornorWithFrame:frame];
    }
    
    [datePickerView createDatePickerWithFrame:frame ];
    
    return datePickerView;
}

#pragma mark - 设置时间选择器
- (void)createDatePickerWithFrame:(CGRect)frame {
   
    UIDatePicker *picker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 40, CGRectGetWidth(frame), CGRectGetHeight(frame) - 40)];
    picker.locale = [NSLocale localeWithLocaleIdentifier:@"Chinese"];

    picker.datePickerMode = UIDatePickerModeDateAndTime;
    
    picker.backgroundColor = [UIColor clearColor];
    
    [picker setValue:[UIColor whiteColor] forKey:@"textColor"];
    
    self.datePicker = picker;
    
    [self addSubview:self.datePicker];
}

#pragma mark - 设置圆角
- (void)setupCornorWithFrame:(CGRect)frame{
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, frame.size.width, frame.size.height) byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(15, 15)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    maskLayer.path = maskPath.CGPath;
    self.bgView.layer.mask = maskLayer;
}


- (IBAction)cancleAction:(id)sender {
    NSLog(@"cancle");
    [self hideFromView];
    
}
- (IBAction)sureAction:(id)sender {
    
    NSLog(@"sure");
    NSLog(@"%@", self.datePicker.date);
    
    NSString *str =[CommonTool weekdayStringFromDate:self.datePicker.date];
    
    NSLog(@"str====%@",str);
    
    if (self.myDatePickerBlock) {
        self.myDatePickerBlock([self getDateStrFromDate: self.datePicker.date],str);
        
        
        
        
    }
    

    [self hideFromView];
    
}

- (NSString *)getDateStrFromDate:(NSDate *)date{
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    format.dateFormat = @"HH:mm:ss";
    NSString *dataStr = [format stringFromDate:date];
    return dataStr;
}


- (void)showInView{

   [UIView animateWithDuration:0.5 animations:^{
       self.top = LHeight- 300;
       self.hidden = NO;
   }];
}

- (void)hideFromView{
    
    [UIView animateWithDuration:0.5 animations:^{
        self.top  = LHeight ;
    } completion:^(BOOL finished) {
        if (finished ) {
            self.hidden = YES;
        }
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self hideFromView];
}

@end
