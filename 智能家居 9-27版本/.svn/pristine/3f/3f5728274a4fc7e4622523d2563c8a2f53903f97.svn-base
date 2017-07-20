//
//  CFDatePickerView.h
//  CFDatePickerDemo
//
//  Created by TheMoon on 16/3/22.
//  Copyright © 2016年 CFJ. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  view样式
 */
typedef NS_ENUM(NSInteger, CornorType) {
    /**
     *  正常
     */
    CornorType_Normal,
    /**
     *  切圆角
     */
    CornorType_Circle
};

/**
 *  时间选择后，事件处理
 *
 *  @param dateStr 传出选择的时间
 */
typedef void (^DatePickerBlock) (NSString *dateStr,NSString *weekStr);

@interface CFDatePickerView : UIView

@property (nonatomic, strong)UIDatePicker *datePicker;
@property (nonatomic, copy) DatePickerBlock myDatePickerBlock;
+ (instancetype)datePickerViewWithFrame:(CGRect)frame cornorType:(CornorType) cornorType;
- (void)showInView;
- (void)hideFromView;
@end
