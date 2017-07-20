//
//  MyFooterView.m
//  SmartHome
//
//  Created by sciyonSoft on 16/8/8.
//
//

#import "MyFooterView.h"

@implementation MyFooterView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _titleLab1 = [[UILabel alloc]init];
        _titleLab1.frame =CGRectMake(17,0, self.frame.size.width,self.frame.size.height);
        _titleLab1.textAlignment =NSTextAlignmentLeft;
        //        _titleLab.backgroundColor = [UIColor redColor];
        [self addSubview:_titleLab1];
    }
    return self;
}

@end
