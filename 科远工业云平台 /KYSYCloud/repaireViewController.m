//
//  repaireViewController.m
//  KYSYCloud
//
//  Created by sciyonSoft on 16/2/19.
//  Copyright © 2016年 sciyonSoft. All rights reserved.
//

#import "repaireViewController.h"

@interface repaireViewController (){
    NSDictionary *_fromDic;
    NSString* _titlestr;


}

@end

@implementation repaireViewController
-(id)initWithADic:(NSDictionary *)aDic withTitle:(NSString *)title
{
    self=[super init];
    if (self) {
        _fromDic=aDic;
        _titlestr=title;
    }
    
    return self;
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=_titlestr;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
