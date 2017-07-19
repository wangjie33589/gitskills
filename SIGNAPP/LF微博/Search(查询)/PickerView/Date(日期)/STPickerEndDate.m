//
//  STPickerEndDate.m
//  科远签到
//
//  Created by sciyonSoft on 16/5/12.
//  Copyright © 2016年 lf. All rights reserved.
//

#import "STPickerEndDate.h"
#import "NSCalendar+ST.h"
@interface STPickerEndDate()<UIPickerViewDataSource, UIPickerViewDelegate>
/** 1.年 */
@property (nonatomic, assign)NSInteger years;
/** 2.月 */
@property (nonatomic, assign)NSInteger months;
/** 3.日 */
@property (nonatomic, assign)NSInteger days;

@end

@implementation STPickerEndDate

#pragma mark - --- init 视图初始化 ---

- (void)setupUI {
    
    self.title = @"请选择日期";
    
    _yearLeast = 1900;
    _yearSum   = 200;
    _heightPickerComponent = 28;
    
    _years  = [NSCalendar currentYear];
    _months = [NSCalendar currentMonth];
    _days   = [NSCalendar currentDay];
    
    [self.pickerView setDelegate:self];
    [self.pickerView setDataSource:self];
    
    [self.pickerView selectRow:(_years - _yearLeast) inComponent:0 animated:NO];
    [self.pickerView selectRow:(_months - 1) inComponent:1 animated:NO];
    [self.pickerView selectRow:(_days - 1) inComponent:2 animated:NO];
    
}

#pragma mark - --- delegate 视图委托 ---


//
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0) {
        return self.yearSum;
    }else if(component == 1) {
        return 12;
    }else {
        NSInteger yearSelected = [pickerView selectedRowInComponent:0] + self.yearLeast;
        NSInteger monthSelected = [pickerView selectedRowInComponent:1] + 1;
        return  [NSCalendar getDaysWithYear:yearSelected month:monthSelected];
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return self.heightPickerComponent;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    switch (component) {
        case 0:
            [pickerView reloadComponent:1];
            [pickerView reloadComponent:2];
            break;
        case 1:
            [pickerView reloadComponent:2];
        default:
            break;
    }
    
    [self reloadData];
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view
{
    
    NSString *text;
    if (component == 0) {
        text =  [NSString stringWithFormat:@"%ld", row + 1900];
    }else if (component == 1){
        text =  [NSString stringWithFormat:@"%ld", row + 1];
    }else{
        text = [NSString stringWithFormat:@"%ld", row + 1];
    }
    
    UILabel *label = [[UILabel alloc]init];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setFont:[UIFont systemFontOfSize:17]];
    [label setText:text];
    return label;
}
#pragma mark - --- event response 事件相应 ---

- (void)selectedOk
{
    if ([self.delegate respondsToSelector:@selector(pickerEndDate:years:months:days:)]) {
        [self.delegate pickerEndDate:self years:self.years months:self.months days:self.days];
    }
    
    [super selectedOk];
}

#pragma mark - --- private methods 私有方法 ---

- (void)reloadData
{
    self.years  = [self.pickerView selectedRowInComponent:0] + self.yearLeast;
    self.months = [self.pickerView selectedRowInComponent:1] + 1;
    self.days   = [self.pickerView selectedRowInComponent:2] + 1;
}

#pragma mark - --- setters 属性 ---

- (void)setYearLeast:(NSInteger)yearLeast
{
    _yearLeast = yearLeast;
}

- (void)setYearSum:(NSInteger)yearSum
{
    _yearSum = yearSum;
}
#pragma mark - --- getters 属性 ---


@end