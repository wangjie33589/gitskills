//
//  STPickerEndDate.h
//  科远签到
//
//  Created by sciyonSoft on 16/5/12.
//  Copyright © 2016年 lf. All rights reserved.
//

#import "STPickerView.h"


@class STPickerEndDate;
@protocol  STPickerEndDateDelegate<NSObject>
- (void)pickerEndDate:(STPickerEndDate *)pickerEndDate years:(NSInteger)years months:(NSInteger)months days:(NSInteger)days;

@end

@interface STPickerEndDate : STPickerView
/** 1.最小的年份，default is 1900 */
@property (nonatomic, assign)NSInteger yearLeast;
/** 2.显示年份数量，default is 200 */
@property (nonatomic, assign)NSInteger yearSum;
/** 3.中间选择框的高度，default is 28*/
@property (nonatomic, assign)CGFloat heightPickerComponent;

@property(nonatomic, weak)id <STPickerEndDateDelegate>delegate ;

@end
