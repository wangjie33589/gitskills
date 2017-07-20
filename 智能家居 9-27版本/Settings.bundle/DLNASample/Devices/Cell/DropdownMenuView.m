//
//  DropdownMenuView.m
//  PopoVerMenu
//
//  Created by chairman on 16/3/27.
//  Copyright © 2016年 LaiYoung. All rights reserved.
//

#import "DropdownMenuView.h"
@interface DropdownMenuView()
<
UITableViewDataSource
>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, strong) NSArray *images;
@end
@implementation DropdownMenuView
- (NSArray *)titles {
    if (!_titles) {
        _titles = [self.dataDic allKeys];
    }
    return _titles;
}
- (NSArray *)images {
    if (!_images) {
        _images = [self.dataDic allValues];
    }
    return _images;
}
+ (instancetype)dropdown {
    return [[[NSBundle mainBundle]loadNibNamed:@"DropdownMenuView" owner:nil options:nil] firstObject];
}
- (void)awakeFromNib {
    self.tableView.tableFooterView = [UIView new];
    //不需要跟随父控件的尺寸变化而伸缩
    self.autoresizingMask = UIViewAutoresizingNone;
}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titles.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *Cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MenuCell"];
    Cell.textLabel.text = self.titles[indexPath.row];
    Cell.imageView.image = self.images[indexPath.row];
    return Cell;
}

@end
