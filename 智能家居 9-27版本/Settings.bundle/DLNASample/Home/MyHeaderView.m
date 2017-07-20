//
//  MyHeaderView.m
//  SmartHome
//
//  Created by sciyonSoft on 16/8/4.
//
//

#import "MyHeaderView.h"

@implementation MyHeaderView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _titleLab = [[UILabel alloc]init];
        _titleLab.frame =CGRectMake(13,0, self.frame.size.width,self.frame.size.height);
        _titleLab.textAlignment =NSTextAlignmentLeft;
        //        _titleLab.backgroundColor = [UIColor redColor];
        [self addSubview:_titleLab];
        
        
        _viewColor= [[UIView alloc]init];
        _viewColor.frame = CGRectMake( 0, self.frame.size.height/4, 10, self.frame.size.height/2);
        _viewColor.backgroundColor = [UIColor orangeColor];
        [self addSubview:_viewColor];
        
    }
    return self;
}
@end
