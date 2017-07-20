//
//  DropdownMenuController.m
//  PopoVerMenu
//
//  Created by chairman on 16/3/27.
//  Copyright © 2016年 LaiYoung. All rights reserved.
//

#import "DropdownMenuController.h"
#import "DropdownMenuView.h"
@interface DropdownMenuController ()
<
UITableViewDelegate
>
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation DropdownMenuController

- (void)viewDidLoad {
    [super viewDidLoad];
    DropdownMenuView *menu = [DropdownMenuView dropdown];
    menu.dataDic = self.dataDic;
    [self.view addSubview:menu];
    // 设置控制器view在popover中的尺寸
    self.preferredContentSize = menu.bounds.size;
    //查找menu 视图下的所有子视图
    NSInteger index = 0;
    while ([menu subviews].count) {
        if (index == [menu subviews].count) {
            return;
        } else {
            BOOL isY = [[menu subviews][index] isKindOfClass:[UITableView class]];
            if (isY) {
                self.tableView = [menu subviews][index];
                self.tableView.delegate = self;
                return;
            } else {
                index++;
            }
        }
    }


}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([self.delegate respondsToSelector:@selector(DropdownMenuController:withIndexPath:)]) {
        [self.delegate DropdownMenuController:self withIndexPath:indexPath];
        [self dismissViewControllerAnimated:YES completion:nil];//Animated 有延迟 所以不应该有动画效果
    }
}
@end
